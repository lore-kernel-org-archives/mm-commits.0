From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-memorylow-proportional-distribution.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:37:40 -0700
Message-ID: <20200403203740.za-oTeSwn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUho (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm: memcontrol: fix memory.low proportional distribution
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-memorylow-proportional-distribution.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix memory.low proportional distribution

Patch series "mm: memcontrol: recursive memory.low protection", v3.

The current memory.low (and memory.min) semantics require protection to be
assigned to a cgroup in an untinterrupted chain from the top-level cgroup
all the way to the leaf.

In practice, we want to protect entire cgroup subtrees from each other
(system management software vs.  workload), but we would like the VM to
balance memory optimally *within* each subtree, without having to make
explicit weight allocations among individual components.  The current
semantics make that impossible.

They also introduce unmanageable complexity into more advanced resource
trees.  For example:

          host root
          `- system.slice
             `- rpm upgrades
             `- logging
          `- workload.slice
             `- a container
                `- system.slice
                `- workload.slice
                   `- job A
                      `- component 1
                      `- component 2
                   `- job B

At a host-level perspective, we would like to protect the outer
workload.slice subtree as a whole from rpm upgrades, logging etc.  But for
that to be effective, right now we'd have to propagate it down through the
container, the inner workload.slice, into the job cgroup and ultimately
the component cgroups where memory is actually, physically allocated.=20
This may cross several tree delegation points and namespace boundaries,
which make such a setup near impossible.

CPU and IO on the other hand are already distributed recursively.  The
user would simply configure allowances at the host level, and they would
apply to the entire subtree without any downward propagation.

To enable the above-mentioned usecases and bring memory in line with other
resource controllers, this patch series extends memory.low/min such that
settings apply recursively to the entire subtree.  Users can still assign
explicit shares in subgroups, but if they don't, any ancestral protection
will be distributed such that children compete freely amongst each other -
as if no memory control were enabled inside the subtree - but enjoy
protection from neighboring trees.

In the above example, the user would then be able to configure shares of
CPU, IO and memory at the host level to comprehensively protect and
isolate the workload.slice as a whole from system.slice activity.

Patch #1 fixes an existing bug that can give a cgroup tree more protection
than it should receive as per ancestor configuration.

Patch #2 simplifies and documents the existing code to make it easier to
reason about the changes in the next patch.

Patch #3 finally implements recursive memory protection semantics.

Because of a risk of regressing legacy setups, the new semantics are
hidden behind a cgroup2 mount option, 'memory_recursiveprot'.

More details in patch #3.


This patch (of 3):

When memory.low is overcommitted - i.e.  the children claim more
protection than their shared ancestor grants them - the allowance is
distributed in proportion to how much each sibling uses their own declared
protection:

	low_usage =3D min(memory.low, memory.current)
	elow =3D parent_elow * (low_usage / siblings_low_usage)

However, siblings_low_usage is not the sum of all low_usages. It sums
up the usages of *only those cgroups that are within their memory.low*
That means that low_usage can be *bigger* than siblings_low_usage, and
consequently the total protection afforded to the children can be
bigger than what the ancestor grants the subtree.

Consider three groups where two are in excess of their protection:

  A/memory.low =3D 10G
  A/A1/memory.low =3D 10G, memory.current =3D 20G
  A/A2/memory.low =3D 10G, memory.current =3D 20G
  A/A3/memory.low =3D 10G, memory.current =3D  8G
  siblings_low_usage =3D 8G (only A3 contributes)

  A1/elow =3D parent_elow(10G) * low_usage(10G) / siblings_low_usage(8G) =
=3D 12.5G -> 10G
  A2/elow =3D parent_elow(10G) * low_usage(10G) / siblings_low_usage(8G) =
=3D 12.5G -> 10G
  A3/elow =3D parent_elow(10G) * low_usage(8G) / siblings_low_usage(8G) =3D =
10.0G

  (the 12.5G are capped to the explicit memory.low setting of 10G)

With that, the sum of all awarded protection below A is 30G, when A
only grants 10G for the entire subtree.

What does this mean in practice? A1 and A2 would still be in excess of
their 10G allowance and would be reclaimed, whereas A3 would not. As
they eventually drop below their protection setting, they would be
counted in siblings_low_usage again and the error would right itself.

When reclaim was applied in a binary fashion (cgroup is reclaimed when
it's above its protection, otherwise it's skipped) this would actually
work out just fine. However, since 1bc63fb1272b ("mm, memcg: make scan
aggression always exclude protection"), reclaim pressure is scaled to
how much a cgroup is above its protection. As a result this
calculation error unduly skews pressure away from A1 and A2 toward the
rest of the system.

But why did we do it like this in the first place?

The reasoning behind exempting groups in excess from
siblings_low_usage was to go after them first during reclaim in an
overcommitted subtree:

  A/memory.low =3D 2G, memory.current =3D 4G
  A/A1/memory.low =3D 3G, memory.current =3D 2G
  A/A2/memory.low =3D 1G, memory.current =3D 2G

  siblings_low_usage =3D 2G (only A1 contributes)
  A1/elow =3D parent_elow(2G) * low_usage(2G) / siblings_low_usage(2G) =3D =
2G
  A2/elow =3D parent_elow(2G) * low_usage(1G) / siblings_low_usage(2G) =3D =
1G

While the children combined are overcomitting A and are technically
both at fault, A2 is actively declaring unprotected memory and we
would like to reclaim that first.

However, while this sounds like a noble goal on the face of it, it
doesn't make much difference in actual memory distribution: Because A
is overcommitted, reclaim will not stop once A2 gets pushed back to
within its allowance; we'll have to reclaim A1 either way. The end
result is still that protection is distributed proportionally, with A1
getting 3/4 (1.5G) and A2 getting 1/4 (0.5G) of A's allowance.

[ If A weren't overcommitted, it wouldn't make a difference since each
  cgroup would just get the protection it declares:

  A/memory.low =3D 2G, memory.current =3D 3G
  A/A1/memory.low =3D 1G, memory.current =3D 1G
  A/A2/memory.low =3D 1G, memory.current =3D 2G

  With the current calculation:

  siblings_low_usage =3D 1G (only A1 contributes)
  A1/elow =3D parent_elow(2G) * low_usage(1G) / siblings_low_usage(1G) =3D =
2G -> 1G
  A2/elow =3D parent_elow(2G) * low_usage(1G) / siblings_low_usage(1G) =3D =
2G -> 1G

  Including excess groups in siblings_low_usage:

  siblings_low_usage =3D 2G
  A1/elow =3D parent_elow(2G) * low_usage(1G) / siblings_low_usage(2G) =3D =
1G -> 1G
  A2/elow =3D parent_elow(2G) * low_usage(1G) / siblings_low_usage(2G) =3D =
1G -> 1G ]

Simplify the calculation and fix the proportional reclaim bug by
including excess cgroups in siblings_low_usage.

After this patch, the effective memory.low distribution from the
example above would be as follows:

  A/memory.low =3D 10G
  A/A1/memory.low =3D 10G, memory.current =3D 20G
  A/A2/memory.low =3D 10G, memory.current =3D 20G
  A/A3/memory.low =3D 10G, memory.current =3D  8G
  siblings_low_usage =3D 28G

  A1/elow =3D parent_elow(10G) * low_usage(10G) / siblings_low_usage(28G) =
=3D 3.5G
  A2/elow =3D parent_elow(10G) * low_usage(10G) / siblings_low_usage(28G) =
=3D 3.5G
  A3/elow =3D parent_elow(10G) * low_usage(8G) / siblings_low_usage(28G) =
=3D 2.8G

Link: http://lkml.kernel.org/r/20200227195606.46212-2-hannes@cmpxchg.org
Fixes: 1bc63fb1272b ("mm, memcg: make scan aggression always exclude protec=
tion")
Fixes: 230671533d64 ("mm: memory.low hierarchical behavior")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c   |    4 +---
 mm/page_counter.c |   12 ++----------
 2 files changed, 3 insertions(+), 13 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-memorylow-proportional-distribution
+++ a/mm/memcontrol.c
@@ -6266,9 +6266,7 @@ struct cgroup_subsys memory_cgrp_subsys
  * elow =3D min( memory.low, parent->elow * ------------------ ),
  *                                        siblings_low_usage
  *
- *             | memory.current, if memory.current < memory.low
- * low_usage =3D |
- *	       | 0, otherwise.
+ * low_usage =3D min(memory.low, memory.current)
  *
  *
  * Such definition of the effective memory.low provides the expected
--- a/mm/page_counter.c~mm-memcontrol-fix-memorylow-proportional-distributi=
on
+++ a/mm/page_counter.c
@@ -23,11 +23,7 @@ static void propagate_protected_usage(st
 		return;
=20
 	if (c->min || atomic_long_read(&c->min_usage)) {
-		if (usage <=3D c->min)
-			protected =3D usage;
-		else
-			protected =3D 0;
-
+		protected =3D min(usage, c->min);
 		old_protected =3D atomic_long_xchg(&c->min_usage, protected);
 		delta =3D protected - old_protected;
 		if (delta)
@@ -35,11 +31,7 @@ static void propagate_protected_usage(st
 	}
=20
 	if (c->low || atomic_long_read(&c->low_usage)) {
-		if (usage <=3D c->low)
-			protected =3D usage;
-		else
-			protected =3D 0;

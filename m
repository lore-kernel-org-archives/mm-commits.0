From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-recursive-memorylow-protection.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:37:45 -0700
Message-ID: <20200403203745.HfvV-5eJ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgDCUhr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm: memcontrol: recursive memory.low protection
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-recursive-memorylow-protection.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: recursive memory.low protection

Right now, the effective protection of any given cgroup is capped by its
own explicit memory.low setting, regardless of what the parent says.  The
reasons for this are mostly historical and ease of implementation: to make
delegation of memory.low safe, effective protection is the min() of all
memory.low up the tree.

Unfortunately, this limitation makes it impossible to protect an entire
subtree from another without forcing the user to make explicit protection
allocations all the way to the leaf cgroups - something that is highly
undesirable in real life scenarios.

Consider memory in a data center host.  At the cgroup top level, we have a
distinction between system management software and the actual workload the
system is executing.  Both branches are further subdivided into individual
services, job components etc.

We want to protect the workload as a whole from the system management
software, but that doesn't mean we want to protect and prioritize
individual workload wrt each other.  Their memory demand can vary over
time, and we'd want the VM to simply cache the hottest data within the
workload subtree.  Yet, the current memory.low limitations force us to
allocate a fixed amount of protection to each workload component in order
to get protection from system management software in general.  This
results in very inefficient resource distribution.

Another concern with mandating downward allocation is that, as the
complexity of the cgroup tree grows, it gets harder for the lower levels
to be informed about decisions made at the host-level.  Consider a
container inside a namespace that in turn creates its own nested tree of
cgroups to run multiple workloads.  It'd be extremely difficult to
configure memory.low parameters in those leaf cgroups that on one hand
balance pressure among siblings as the container desires, while also
reflecting the host-level protection from e.g.  rpm upgrades, that lie
beyond one or more delegation and namespacing points in the tree.

It's highly unusual from a cgroup interface POV that nested levels have to
be aware of and reflect decisions made at higher levels for them to be
effective.

To enable such use cases and scale configurability for complex trees, this
patch implements a resource inheritance model for memory that is similar
to how the CPU and the IO controller implement work-conserving resource
allocations: a share of a resource allocated to a subree always applies to
the entire subtree recursively, while allowing, but not mandating,
children to further specify distribution rules.

That means that if protection is explicitly allocated among siblings,
those configured shares are being followed during page reclaim just like
they are now.  However, if the memory.low set at a higher level is not
fully claimed by the children in that subtree, the "floating" remainder is
applied to each cgroup in the tree in proportion to its size.  Since
reclaim pressure is applied in proportion to size as well, each child in
that tree gets the same boost, and the effect is neutral among siblings -
with respect to each other, they behave as if no memory control was
enabled at all, and the VM simply balances the memory demands optimally
within the subtree.  But collectively those cgroups enjoy a boost over the
cgroups in neighboring trees.

E.g.  a leaf cgroup with a memory.low setting of 0 no longer means that
it's not getting a share of the hierarchically assigned resource, just
that it doesn't claim a fixed amount of it to protect from its siblings.

This allows us to recursively protect one subtree (workload) from another
(system management), while letting subgroups compete freely among each
other - without having to assign fixed shares to each leaf, and without
nested groups having to echo higher-level settings.

The floating protection composes naturally with fixed protection.=20
Consider the following example tree:

		A            A: low =3D 2G
               / \          A1: low =3D 1G
              A1 A2         A2: low =3D 0G

As outside pressure is applied to this tree, A1 will enjoy a fixed
protection from A2 of 1G, but the remaining, unclaimed 1G from A is split
evenly among A1 and A2, coming out to 1.5G and 0.5G.

There is a slight risk of regressing theoretical setups where the
top-level cgroups don't know about the true budgeting and set bogusly high
"bypass" values that are meaningfully allocated down the tree.  Such
setups would rely on unclaimed protection to be discarded, and
distributing it would change the intended behavior.  Be safe and hide the
new behavior behind a mount option, 'memory_recursiveprot'.

Link: http://lkml.kernel.org/r/20200227195606.46212-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   11 ++++
 include/linux/cgroup-defs.h             |    5 ++
 kernel/cgroup/cgroup.c                  |   17 ++++++-
 mm/memcontrol.c                         |   51 ++++++++++++++++++++--
 4 files changed, 79 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-recursive-memor=
ylow-protection
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -188,6 +188,17 @@ cgroup v2 currently supports the followi
         modified through remount from the init namespace. The mount
         option is ignored on non-init namespace mounts.
=20
+  memory_recursiveprot
+
+        Recursively apply memory.min and memory.low protection to
+        entire subtrees, without requiring explicit downward
+        propagation into leaf cgroups.  This allows protecting entire
+        subtrees from one another, while retaining free competition
+        within those subtrees.  This should have been the default
+        behavior but is a mount-option to avoid regressing setups
+        relying on the original semantics (e.g. specifying bogusly
+        high 'bypass' protection values at higher tree levels).
+
=20
 Organizing Processes and Threads
 --------------------------------
--- a/include/linux/cgroup-defs.h~mm-memcontrol-recursive-memorylow-protect=
ion
+++ a/include/linux/cgroup-defs.h
@@ -94,6 +94,11 @@ enum {
 	 * Enable legacy local memory.events.
 	 */
 	CGRP_ROOT_MEMORY_LOCAL_EVENTS =3D (1 << 5),
+
+	/*
+	 * Enable recursive subtree protection
+	 */
+	CGRP_ROOT_MEMORY_RECURSIVE_PROT =3D (1 << 6),
 };
=20
 /* cftype->flags */
--- a/kernel/cgroup/cgroup.c~mm-memcontrol-recursive-memorylow-protection
+++ a/kernel/cgroup/cgroup.c
@@ -1813,12 +1813,14 @@ int cgroup_show_path(struct seq_file *sf
 enum cgroup2_param {
 	Opt_nsdelegate,
 	Opt_memory_localevents,
+	Opt_memory_recursiveprot,
 	nr__cgroup2_params
 };
=20
 static const struct fs_parameter_spec cgroup2_fs_parameters[] =3D {
 	fsparam_flag("nsdelegate",		Opt_nsdelegate),
 	fsparam_flag("memory_localevents",	Opt_memory_localevents),
+	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
 	{}
 };
=20
@@ -1839,6 +1841,9 @@ static int cgroup2_parse_param(struct fs
 	case Opt_memory_localevents:
 		ctx->flags |=3D CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 		return 0;
+	case Opt_memory_recursiveprot:
+		ctx->flags |=3D CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -1855,6 +1860,11 @@ static void apply_cgroup_root_flags(unsi
 			cgrp_dfl_root.flags |=3D CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 		else
 			cgrp_dfl_root.flags &=3D ~CGRP_ROOT_MEMORY_LOCAL_EVENTS;
+
+		if (root_flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT)
+			cgrp_dfl_root.flags |=3D CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+		else
+			cgrp_dfl_root.flags &=3D ~CGRP_ROOT_MEMORY_RECURSIVE_PROT;
 	}
 }
=20
@@ -1864,6 +1874,8 @@ static int cgroup_show_options(struct se
 		seq_puts(seq, ",nsdelegate");
 	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
 		seq_puts(seq, ",memory_localevents");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT)
+		seq_puts(seq, ",memory_recursiveprot");
 	return 0;
 }
=20
@@ -6412,7 +6424,10 @@ static struct kobj_attribute cgroup_dele
 static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *=
attr,
 			     char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "nsdelegate\nmemory_localevents\n");
+	return snprintf(buf, PAGE_SIZE,
+			"nsdelegate\n"
+			"memory_localevents\n"
+			"memory_recursiveprot\n");
 }
 static struct kobj_attribute cgroup_features_attr =3D __ATTR_RO(features);
=20
--- a/mm/memcontrol.c~mm-memcontrol-recursive-memorylow-protection
+++ a/mm/memcontrol.c
@@ -6264,13 +6264,27 @@ struct cgroup_subsys memory_cgrp_subsys
  *    budget is NOT proportional. A cgroup's protection from a sibling
  *    is capped to its own memory.min/low setting.
  *
+ * 5. However, to allow protecting recursive subtrees from each other
+ *    without having to declare each individual cgroup's fixed share
+ *    of the ancestor's claim to protection, any unutilized -
+ *    "floating" - protection from up the tree is distributed in
+ *    proportion to each cgroup's *usage*. This makes the protection
+ *    neutral wrt sibling cgroups and lets them compete freely over
+ *    the shared parental protection budget, but it protects the
+ *    subtree as a whole from neighboring subtrees.
+ *
+ * Note that 4. and 5. are not in conflict: 4. is about protecting
+ * against immediate siblings whereas 5. is about protecting against
+ * neighboring subtrees.
  */
 static unsigned long effective_protection(unsigned long usage,
+					  unsigned long parent_usage,
 					  unsigned long setting,
 					  unsigned long parent_effective,
 					  unsigned long siblings_protected)
 {
 	unsigned long protected;
+	unsigned long ep;
=20
 	protected =3D min(usage, setting);
 	/*
@@ -6301,7 +6315,34 @@ static unsigned long effective_protectio
 	 * protection is always dependent on how memory is actually
 	 * consumed among the siblings anyway.
 	 */
-	return protected;
+	ep =3D protected;
+
+	/*
+	 * If the children aren't claiming (all of) the protection
+	 * afforded to them by the parent, distribute the remainder in
+	 * proportion to the (unprotected) memory of each cgroup. That
+	 * way, cgroups that aren't explicitly prioritized wrt each
+	 * other compete freely over the allowance, but they are
+	 * collectively protected from neighboring trees.
+	 *
+	 * We're using unprotected memory for the weight so that if
+	 * some cgroups DO claim explicit protection, we don't protect
+	 * the same bytes twice.
+	 */
+	if (!(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT))
+		return ep;
+
+	if (parent_effective > siblings_protected && usage > protected) {
+		unsigned long unclaimed;
+
+		unclaimed =3D parent_effective - siblings_protected;
+		unclaimed *=3D usage - protected;
+		unclaimed /=3D parent_usage - siblings_protected;
+
+		ep +=3D unclaimed;
+	}
+
+	return ep;
 }
=20
 /**
@@ -6321,8 +6362,8 @@ static unsigned long effective_protectio
 enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 						struct mem_cgroup *memcg)
 {
+	unsigned long usage, parent_usage;
 	struct mem_cgroup *parent;
-	unsigned long usage;
=20
 	if (mem_cgroup_disabled())
 		return MEMCG_PROT_NONE;
@@ -6347,11 +6388,13 @@ enum mem_cgroup_protection mem_cgroup_pr
 		goto out;
 	}
=20
-	memcg->memory.emin =3D effective_protection(usage,
+	parent_usage =3D page_counter_read(&parent->memory);
+
+	memcg->memory.emin =3D effective_protection(usage, parent_usage,
 			memcg->memory.min, READ_ONCE(parent->memory.emin),
 			atomic_long_read(&parent->memory.children_min_usage));
=20
-	memcg->memory.elow =3D effective_protection(usage,
+	memcg->memory.elow =3D effective_protection(usage, parent_usage,
 			memcg->memory.low, READ_ONCE(parent->memory.elow),
 			atomic_long_read(&parent->memory.children_low_usage));
=20
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 070/155] mm: memcontrol: clean up and document
 effective low/min calculations
Date: Wed, 01 Apr 2020 21:07:03 -0700
Message-ID: <20200402040703.7W1N7eLnV%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEHL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:11 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org

=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clean up and document effective low/min calculatio=
ns

The effective protection of any given cgroup is a somewhat complicated
construct that depends on the ancestor's configuration, siblings'
configurations, as well as current memory utilization in all these groups.
It's done this way to satisfy hierarchical delegation requirements while
also making the configuration semantics flexible and expressive in complex
real life scenarios.

Unfortunately, all the rules and requirements are sparsely documented, and
the code is a little too clever in merging different scenarios into a
single min() expression.  This makes it hard to reason about the
implementation and avoid breaking semantics when making changes to it.

This patch documents each semantic rule individually and splits out the
handling of the overcommit case from the regular case.

Michal Koutn=C3=BD also points out that the points of equilibrium as descri=
bed
in the existing example scenarios aren't actually accurate.  Delete these
examples for now to avoid confusion.

Link: http://lkml.kernel.org/r/20200227195606.46212-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  177 +++++++++++++++++++++-------------------------
 1 file changed, 84 insertions(+), 93 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-clean-up-and-document-effective-low-min=
-calculations
+++ a/mm/memcontrol.c
@@ -6234,6 +6234,76 @@ struct cgroup_subsys memory_cgrp_subsys
 	.early_init =3D 0,
 };
=20
+/*
+ * This function calculates an individual cgroup's effective
+ * protection which is derived from its own memory.min/low, its
+ * parent's and siblings' settings, as well as the actual memory
+ * distribution in the tree.
+ *
+ * The following rules apply to the effective protection values:
+ *
+ * 1. At the first level of reclaim, effective protection is equal to
+ *    the declared protection in memory.min and memory.low.
+ *
+ * 2. To enable safe delegation of the protection configuration, at
+ *    subsequent levels the effective protection is capped to the
+ *    parent's effective protection.
+ *
+ * 3. To make complex and dynamic subtrees easier to configure, the
+ *    user is allowed to overcommit the declared protection at a given
+ *    level. If that is the case, the parent's effective protection is
+ *    distributed to the children in proportion to how much protection
+ *    they have declared and how much of it they are utilizing.
+ *
+ *    This makes distribution proportional, but also work-conserving:
+ *    if one cgroup claims much more protection than it uses memory,
+ *    the unused remainder is available to its siblings.
+ *
+ * 4. Conversely, when the declared protection is undercommitted at a
+ *    given level, the distribution of the larger parental protection
+ *    budget is NOT proportional. A cgroup's protection from a sibling
+ *    is capped to its own memory.min/low setting.
+ *
+ */
+static unsigned long effective_protection(unsigned long usage,
+					  unsigned long setting,
+					  unsigned long parent_effective,
+					  unsigned long siblings_protected)
+{
+	unsigned long protected;
+
+	protected =3D min(usage, setting);
+	/*
+	 * If all cgroups at this level combined claim and use more
+	 * protection then what the parent affords them, distribute
+	 * shares in proportion to utilization.
+	 *
+	 * We are using actual utilization rather than the statically
+	 * claimed protection in order to be work-conserving: claimed
+	 * but unused protection is available to siblings that would
+	 * otherwise get a smaller chunk than what they claimed.
+	 */
+	if (siblings_protected > parent_effective)
+		return protected * parent_effective / siblings_protected;
+
+	/*
+	 * Ok, utilized protection of all children is within what the
+	 * parent affords them, so we know whatever this child claims
+	 * and utilizes is effectively protected.
+	 *
+	 * If there is unprotected usage beyond this value, reclaim
+	 * will apply pressure in proportion to that amount.
+	 *
+	 * If there is unutilized protection, the cgroup will be fully
+	 * shielded from reclaim, but we do return a smaller value for
+	 * protection than what the group could enjoy in theory. This
+	 * is okay. With the overcommit distribution above, effective
+	 * protection is always dependent on how memory is actually
+	 * consumed among the siblings anyway.
+	 */
+	return protected;
+}
+
 /**
  * mem_cgroup_protected - check if memory consumption is in the normal ran=
ge
  * @root: the top ancestor of the sub-tree being checked
@@ -6247,67 +6317,11 @@ struct cgroup_subsys memory_cgrp_subsys
  *   MEMCG_PROT_LOW: cgroup memory is protected as long there is
  *     an unprotected supply of reclaimable memory from other cgroups.
  *   MEMCG_PROT_MIN: cgroup memory is protected
- *
- * @root is exclusive; it is never protected when looked at directly
- *
- * To provide a proper hierarchical behavior, effective memory.min/low val=
ues
- * are used. Below is the description of how effective memory.low is calcu=
lated.
- * Effective memory.min values is calculated in the same way.
- *
- * Effective memory.low is always equal or less than the original memory.l=
ow.
- * If there is no memory.low overcommittment (which is always true for
- * top-level memory cgroups), these two values are equal.
- * Otherwise, it's a part of parent's effective memory.low,
- * calculated as a cgroup's memory.low usage divided by sum of sibling's
- * memory.low usages, where memory.low usage is the size of actually
- * protected memory.
- *
- *                                             low_usage
- * elow =3D min( memory.low, parent->elow * ------------------ ),
- *                                        siblings_low_usage
- *
- * low_usage =3D min(memory.low, memory.current)
- *
- *
- * Such definition of the effective memory.low provides the expected
- * hierarchical behavior: parent's memory.low value is limiting
- * children, unprotected memory is reclaimed first and cgroups,
- * which are not using their guarantee do not affect actual memory
- * distribution.
- *
- * For example, if there are memcgs A, A/B, A/C, A/D and A/E:
- *
- *     A      A/memory.low =3D 2G, A/memory.current =3D 6G
- *    //\\
- *   BC  DE   B/memory.low =3D 3G  B/memory.current =3D 2G
- *            C/memory.low =3D 1G  C/memory.current =3D 2G
- *            D/memory.low =3D 0   D/memory.current =3D 2G
- *            E/memory.low =3D 10G E/memory.current =3D 0
- *
- * and the memory pressure is applied, the following memory distribution
- * is expected (approximately):
- *
- *     A/memory.current =3D 2G
- *
- *     B/memory.current =3D 1.3G
- *     C/memory.current =3D 0.6G
- *     D/memory.current =3D 0
- *     E/memory.current =3D 0
- *
- * These calculations require constant tracking of the actual low usages
- * (see propagate_protected_usage()), as well as recursive calculation of
- * effective memory.low values. But as we do call mem_cgroup_protected()
- * path for each memory cgroup top-down from the reclaim,
- * it's possible to optimize this part, and save calculated elow
- * for next usage. This part is intentionally racy, but it's ok,
- * as memory.low is a best-effort mechanism.
  */
 enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 						struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent;
-	unsigned long emin, parent_emin;
-	unsigned long elow, parent_elow;
 	unsigned long usage;
=20
 	if (mem_cgroup_disabled())
@@ -6322,52 +6336,29 @@ enum mem_cgroup_protection mem_cgroup_pr
 	if (!usage)
 		return MEMCG_PROT_NONE;
=20
-	emin =3D memcg->memory.min;
-	elow =3D memcg->memory.low;
-
 	parent =3D parent_mem_cgroup(memcg);
 	/* No parent means a non-hierarchical mode on v1 memcg */
 	if (!parent)
 		return MEMCG_PROT_NONE;
=20
-	if (parent =3D=3D root)
-		goto exit;
-
-	parent_emin =3D READ_ONCE(parent->memory.emin);
-	emin =3D min(emin, parent_emin);
-	if (emin && parent_emin) {
-		unsigned long min_usage, siblings_min_usage;
-
-		min_usage =3D min(usage, memcg->memory.min);
-		siblings_min_usage =3D atomic_long_read(
-			&parent->memory.children_min_usage);
-
-		if (min_usage && siblings_min_usage)
-			emin =3D min(emin, parent_emin * min_usage /
-				   siblings_min_usage);
-	}
-
-	parent_elow =3D READ_ONCE(parent->memory.elow);
-	elow =3D min(elow, parent_elow);
-	if (elow && parent_elow) {
-		unsigned long low_usage, siblings_low_usage;
-
-		low_usage =3D min(usage, memcg->memory.low);
-		siblings_low_usage =3D atomic_long_read(
-			&parent->memory.children_low_usage);
-
-		if (low_usage && siblings_low_usage)
-			elow =3D min(elow, parent_elow * low_usage /
-				   siblings_low_usage);
+	if (parent =3D=3D root) {
+		memcg->memory.emin =3D memcg->memory.min;
+		memcg->memory.elow =3D memcg->memory.low;
+		goto out;
 	}
=20
-exit:
-	memcg->memory.emin =3D emin;
-	memcg->memory.elow =3D elow;
+	memcg->memory.emin =3D effective_protection(usage,
+			memcg->memory.min, READ_ONCE(parent->memory.emin),
+			atomic_long_read(&parent->memory.children_min_usage));
+
+	memcg->memory.elow =3D effective_protection(usage,
+			memcg->memory.low, READ_ONCE(parent->memory.elow),
+			atomic_long_read(&parent->memory.children_low_usage));
=20
-	if (usage <=3D emin)
+out:
+	if (usage <=3D memcg->memory.emin)
 		return MEMCG_PROT_MIN;
-	else if (usage <=3D elow)
+	else if (usage <=3D memcg->memory.elow)
 		return MEMCG_PROT_LOW;
 	else
 		return MEMCG_PROT_NONE;
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A086C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699E5613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHWmN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWmN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CA8E6141D;
        Sat,  8 May 2021 22:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513670;
        bh=+Zqvn5fwSnEBqBJvFGsjecUA3Jjg1y8G/OwDEQknim8=;
        h=Date:From:To:Subject:From;
        b=KjyswXjDGrD3BdKasyzNb+x1PaU8izFg7hKq+q19+ETKRbDaojWO2xStGjZcyEdmC
         RbJ+iqFfxW7biS8m0Pry4IIv1o2Wbgw1LoQttiDxF0SrVDvmD7Crt8wbrKQ7D3y8xY
         rVSN9WjX5r3Wr73Am0iF7QQa8o/Mjzbh1FOKE3jo=
Date:   Sat, 08 May 2021 15:41:10 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  [merged]
 cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
 removed from -mm tree
Message-ID: <20210508224110.otcZeWJF7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: rstat: punt root-level optimization to individual con=
trollers
has been removed from the -mm tree.  Its filename was
     cgroup-rstat-punt-root-level-optimization-to-individual-controllers.pa=
tch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: cgroup: rstat: punt root-level optimization to individual controll=
ers

Current users of the rstat code can source root-level statistics from the
native counters of their respective subsystem, allowing them to forego
aggregation at the root level.  This optimization is currently implemented
inside the generic rstat code, which doesn't track the root cgroup and
doesn't invoke the subsystem flush callbacks on it.

However, the memory controller cannot do this optimization, because
cgroup1 breaks out memory specifically for the local level, including at
the root level.  In preparation for the memory controller switching to
rstat, move the optimization from rstat core to the controllers.

Afterwards, rstat will always track the root cgroup for changes and invoke
the subsystem callbacks on it; and it's up to the subsystem to
special-case and skip aggregation of the root cgroup if it can source this
information through other, cheaper means.

This is the case for the io controller and the cgroup base stats.  In
their respective flush callbacks, check whether the parent is the root
cgroup, and if so, skip the unnecessary upward propagation.

The extra cost of tracking the root cgroup is negligible: on stat changes,
we actually remove a branch that checks for the root.  The queueing for a
flush touches only per-cpu data, and only the first stat change since a
flush requires a (per-cpu) lock.

Link: https://lkml.kernel.org/r/20210209163304.77088-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-cgroup.c    |   17 +++++++----
 kernel/cgroup/rstat.c |   59 +++++++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 30 deletions(-)

--- a/block/blk-cgroup.c~cgroup-rstat-punt-root-level-optimization-to-indiv=
idual-controllers
+++ a/block/blk-cgroup.c
@@ -764,6 +764,10 @@ static void blkcg_rstat_flush(struct cgr
 	struct blkcg *blkcg =3D css_to_blkcg(css);
 	struct blkcg_gq *blkg;
=20
+	/* Root-level stats are sourced from system-wide IO stats */
+	if (!cgroup_parent(css->cgroup))
+		return;
+
 	rcu_read_lock();
=20
 	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
@@ -786,8 +790,8 @@ static void blkcg_rstat_flush(struct cgr
 		blkg_iostat_add(&bisc->last, &delta);
 		u64_stats_update_end(&blkg->iostat.sync);
=20
-		/* propagate global delta to parent */
-		if (parent) {
+		/* propagate global delta to parent (unless that's root) */
+		if (parent && parent->parent) {
 			u64_stats_update_begin(&parent->iostat.sync);
 			blkg_iostat_set(&delta, &blkg->iostat.cur);
 			blkg_iostat_sub(&delta, &blkg->iostat.last);
@@ -801,10 +805,11 @@ static void blkcg_rstat_flush(struct cgr
 }
=20
 /*
- * The rstat algorithms intentionally don't handle the root cgroup to avoid
- * incurring overhead when no cgroups are defined. For that reason,
- * cgroup_rstat_flush in blkcg_print_stat does not actually fill out the
- * iostat in the root cgroup's blkcg_gq.
+ * We source root cgroup stats from the system-wide stats to avoid
+ * tracking the same information twice and incurring overhead when no
+ * cgroups are defined. For that reason, cgroup_rstat_flush in
+ * blkcg_print_stat does not actually fill out the iostat in the root
+ * cgroup's blkcg_gq.
  *
  * However, we would like to re-use the printing code between the root and
  * non-root cgroups to the extent possible. For that reason, we simulate
--- a/kernel/cgroup/rstat.c~cgroup-rstat-punt-root-level-optimization-to-in=
dividual-controllers
+++ a/kernel/cgroup/rstat.c
@@ -25,13 +25,8 @@ static struct cgroup_rstat_cpu *cgroup_r
 void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 {
 	raw_spinlock_t *cpu_lock =3D per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
-	struct cgroup *parent;
 	unsigned long flags;
=20
-	/* nothing to do for root */
-	if (!cgroup_parent(cgrp))
-		return;
-
 	/*
 	 * Speculative already-on-list test. This may race leading to
 	 * temporary inaccuracies, which is fine.
@@ -46,10 +41,10 @@ void cgroup_rstat_updated(struct cgroup
 	raw_spin_lock_irqsave(cpu_lock, flags);
=20
 	/* put @cgrp and all ancestors on the corresponding updated lists */
-	for (parent =3D cgroup_parent(cgrp); parent;
-	     cgrp =3D parent, parent =3D cgroup_parent(cgrp)) {
+	while (true) {
 		struct cgroup_rstat_cpu *rstatc =3D cgroup_rstat_cpu(cgrp, cpu);
-		struct cgroup_rstat_cpu *prstatc =3D cgroup_rstat_cpu(parent, cpu);
+		struct cgroup *parent =3D cgroup_parent(cgrp);
+		struct cgroup_rstat_cpu *prstatc;
=20
 		/*
 		 * Both additions and removals are bottom-up.  If a cgroup
@@ -58,8 +53,17 @@ void cgroup_rstat_updated(struct cgroup
 		if (rstatc->updated_next)
 			break;
=20
+		/* Root has no parent to link it to, but mark it busy */
+		if (!parent) {
+			rstatc->updated_next =3D cgrp;
+			break;
+		}
+
+		prstatc =3D cgroup_rstat_cpu(parent, cpu);
 		rstatc->updated_next =3D prstatc->updated_children;
 		prstatc->updated_children =3D cgrp;
+
+		cgrp =3D parent;
 	}
=20
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
@@ -113,23 +117,26 @@ static struct cgroup *cgroup_rstat_cpu_p
 	 */
 	if (rstatc->updated_next) {
 		struct cgroup *parent =3D cgroup_parent(pos);
-		struct cgroup_rstat_cpu *prstatc =3D cgroup_rstat_cpu(parent, cpu);
-		struct cgroup_rstat_cpu *nrstatc;
-		struct cgroup **nextp;
-
-		nextp =3D &prstatc->updated_children;
-		while (true) {
-			nrstatc =3D cgroup_rstat_cpu(*nextp, cpu);
-			if (*nextp =3D=3D pos)
-				break;
=20
-			WARN_ON_ONCE(*nextp =3D=3D parent);
-			nextp =3D &nrstatc->updated_next;
+		if (parent) {
+			struct cgroup_rstat_cpu *prstatc;
+			struct cgroup **nextp;
+
+			prstatc =3D cgroup_rstat_cpu(parent, cpu);
+			nextp =3D &prstatc->updated_children;
+			while (true) {
+				struct cgroup_rstat_cpu *nrstatc;
+
+				nrstatc =3D cgroup_rstat_cpu(*nextp, cpu);
+				if (*nextp =3D=3D pos)
+					break;
+				WARN_ON_ONCE(*nextp =3D=3D parent);
+				nextp =3D &nrstatc->updated_next;
+			}
+			*nextp =3D rstatc->updated_next;
 		}
=20
-		*nextp =3D rstatc->updated_next;
 		rstatc->updated_next =3D NULL;
-
 		return pos;
 	}
=20
@@ -309,11 +316,15 @@ static void cgroup_base_stat_sub(struct
=20
 static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 {
-	struct cgroup *parent =3D cgroup_parent(cgrp);
 	struct cgroup_rstat_cpu *rstatc =3D cgroup_rstat_cpu(cgrp, cpu);
+	struct cgroup *parent =3D cgroup_parent(cgrp);
 	struct cgroup_base_stat cur, delta;
 	unsigned seq;
=20
+	/* Root-level stats are sourced from system-wide CPU stats */
+	if (!parent)
+		return;
+
 	/* fetch the current per-cpu values */
 	do {
 		seq =3D __u64_stats_fetch_begin(&rstatc->bsync);
@@ -326,8 +337,8 @@ static void cgroup_base_stat_flush(struc
 	cgroup_base_stat_add(&cgrp->bstat, &delta);
 	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
=20
-	/* propagate global delta to parent */
-	if (parent) {
+	/* propagate global delta to parent (unless that's root) */
+	if (cgroup_parent(parent)) {
 		delta =3D cgrp->bstat;
 		cgroup_base_stat_sub(&delta, &cgrp->last_bstat);
 		cgroup_base_stat_add(&parent->bstat, &delta);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



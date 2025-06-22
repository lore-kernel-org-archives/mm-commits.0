Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044243C26
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750632772; cv=none; b=r1C/AvUJoHVswUEJq3L6fChSYm7kN3OO01WG5jiMC6n3zd8XFV+YloNOuzJ/uqhBBpiOu4F4k4xkY08Vk4SOUXB9+Gz+KZQJFMc+P4PCfT3C/E1YEaWS67Ea7RxECoKeej5AdLrxkLQorGOW8KshtlNmWtJ/ZEl+1Npw5nikVV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750632772; c=relaxed/simple;
	bh=pYSnAuvUokKUnde87ti5aNrX1QfAFFHsGLOWVSlVoRs=;
	h=Date:To:From:Subject:Message-Id; b=tFEGmDTtAsl/btgb2KamaWpB9THsFvTSPIntLNkFtJ4tl6B7ZA3UgDOhFFLDqvywkuj6OI7YRplMNTnVx358q2qjorlOu9sMWkbIzK66D4zZG3tEyg7LbpwrQBPav3GM4A2DhKOzWTz5gZaVfBv6e8r23Y3ozn325/4sfh8EQgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijew4K7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijew4K7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA04C4CEE3;
	Sun, 22 Jun 2025 22:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750632771;
	bh=pYSnAuvUokKUnde87ti5aNrX1QfAFFHsGLOWVSlVoRs=;
	h=Date:To:From:Subject:From;
	b=ijew4K7eGuheXXU+2dUUJBb5TDWxEz5yZdUuoBym358Fdx/Firx1yDOH7sB+5kvgE
	 ncdd95CSn/IbQtCH7E++H985CAHfiRqWWbpkt1xEfYAzqEH8/RfMBbqqNQIPIDOgxR
	 WYgHrRIlftEsDQpothYq0HhJK6Zn+k46izjOKdhE=
Date: Sun, 22 Jun 2025 15:52:50 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch added to mm-new branch
Message-Id: <20250622225251.6AA04C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_quota_goal_metric
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: decouple from damos_quota_goal_metric
Date: Sun, 22 Jun 2025 14:37:55 -0700

Patch series "mm/damon: decouple sysfs from core".

DAMON sysfs interface is coupled with core layer.  It maintains some of
its keywords arrays be synchronized with matching DAMON core API enums. 
It is unnecessary coupling that makes separated changes for different
layers difficult.  Decouple the layers by introducing new data structure
for the mappings on DAMON sysfs interface.


This patch (of 5):

Decouple DAMOS sysfs interface from damos_quota_goal_metric.  For this,
define and use new sysfs-schemes internal data structure that maps the
user-space keywords and damos_quota_goal_metric, instead of having the
implicit and unflexible array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250622213759.50930-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   55 +++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 14 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric
+++ a/mm/damon/sysfs-schemes.c
@@ -941,27 +941,51 @@ struct damos_sysfs_quota_goal {
 	int nid;
 };
 
-/* This should match with enum damos_quota_goal_metric */
-static const char * const damos_sysfs_quota_goal_metric_strs[] = {
-	"user_input",
-	"some_mem_psi_us",
-	"node_mem_used_bp",
-	"node_mem_free_bp",
-};
-
 static struct damos_sysfs_quota_goal *damos_sysfs_quota_goal_alloc(void)
 {
 	return kzalloc(sizeof(struct damos_sysfs_quota_goal), GFP_KERNEL);
 }
 
+struct damos_sysfs_qgoal_metric_name {
+	enum damos_quota_goal_metric metric;
+	char *name;
+};
+
+static
+struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
+	{
+		.metric = DAMOS_QUOTA_USER_INPUT,
+		.name = "user_input",
+	},
+	{
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.name = "some_mem_psi_us",
+	},
+	{
+		.metric = DAMOS_QUOTA_NODE_MEM_USED_BP,
+		.name = "node_mem_used_bp",
+	},
+	{
+		.metric = DAMOS_QUOTA_NODE_MEM_FREE_BP,
+		.name = "node_mem_free_bp",
+	},
+};
+
 static ssize_t target_metric_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_metric_names); i++) {
+		struct damos_sysfs_qgoal_metric_name *metric_name;
 
-	return sysfs_emit(buf, "%s\n",
-			damos_sysfs_quota_goal_metric_strs[goal->metric]);
+		metric_name = &damos_sysfs_qgoal_metric_names[i];
+		if (metric_name->metric == goal->metric)
+			return sysfs_emit(buf, "%s\n", metric_name->name);
+	}
+	return -EINVAL;
 }
 
 static ssize_t target_metric_store(struct kobject *kobj,
@@ -969,11 +993,14 @@ static ssize_t target_metric_store(struc
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
-	enum damos_quota_goal_metric m;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_metric_names); i++) {
+		struct damos_sysfs_qgoal_metric_name *metric_name;
 
-	for (m = 0; m < NR_DAMOS_QUOTA_GOAL_METRICS; m++) {
-		if (sysfs_streq(buf, damos_sysfs_quota_goal_metric_strs[m])) {
-			goal->metric = m;
+		metric_name = &damos_sysfs_qgoal_metric_names[i];
+		if (sysfs_streq(buf, metric_name->name)) {
+			goal->metric = metric_name->metric;
 			return count;
 		}
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch


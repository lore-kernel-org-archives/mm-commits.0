Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DAC2868A6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126367; cv=none; b=ZHO1OTXxf2MtgfKk0m9BVv0cabEZ9gmOsY78OrbLW7961dDSksxlxZxfsHdUZzFPv/QQganHt0QaQ0uPOCYh+V6XHnj8borcKgv34mUruG9VZAWFZZUjwZBuFC5d+1rK0VXUGj2pdkFyO9NLndoIK5zI5wVo7muns62wHoTeByo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126367; c=relaxed/simple;
	bh=DoTo5Cir8tW2HR5nxs0do+3vZXtqShWEeikOLLzcH9s=;
	h=Date:To:From:Subject:Message-Id; b=SJ0waxk04eftTDAQbjMsPlnME0mxNeqqLXYz0EXyP2FXK0JMK4Z3Htq+oReX1JFoY3DaBB5/keZaGx3TjdwK7b5EzFOaFEdp2HAiMaOlOEXNTrpiN+CelzHMGknt4QDxb9oO0QZnoEd3aqSXziMrF6O+HYjZBEZGlwn2oMuNbOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T6zRl2LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T6zRl2LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE73C4CEF5;
	Thu, 10 Jul 2025 05:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126366;
	bh=DoTo5Cir8tW2HR5nxs0do+3vZXtqShWEeikOLLzcH9s=;
	h=Date:To:From:Subject:From;
	b=T6zRl2LPSJMLYebALx1fCq7EsiWw7o3RulYxrXWKYYCFUILf5uG8IYU14FlPZQUUU
	 fm3+Dj0TR/whb1ye617pWwqQ0FqadOkVy2i0XeERImj+FXIt2JLUYYX5EQQNqWGS2E
	 6Q02I68tR9QWIyuwu+M1kxNGFfWcRrVxMqbnO6FU=
Date: Wed, 09 Jul 2025 22:46:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch removed from -mm tree
Message-Id: <20250710054606.CBE73C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_quota_goal_metric
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch


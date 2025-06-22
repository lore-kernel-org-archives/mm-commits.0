Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870643C26
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750632775; cv=none; b=kpPpCy5kfedugb0eR4hZffBJxZi15gS477+HADAg/5ZVis2403RjPza2BdN537EXmC9Sos+CWjy6FZikL5s3Li30RrNqWv4FGWp/Xlnih/WL2YgtUTp2WW88bXBS7Lr1VSGVskFdTUae5UAPGweUo14VeRMiBmM97WBjV8yaHa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750632775; c=relaxed/simple;
	bh=ov1k4T5zAAIp4Qp26yhT2gUNZWM2b4lWA4YwI0HB1J0=;
	h=Date:To:From:Subject:Message-Id; b=rRR/ePnaQBmvJDuauzVC306DxzWjQM17Ge+2unH+Wgm7elcC7VdotQyRZ9kJpdLhmharZYfGafCYFamf3gVSQ4Y13RTcYbPwYVv5rsb6azy35kpsQabL5MGaJ60vzaJl56hjstHXxT1hSj+ROkNR/IdAxnP/WRF43fFCmvKF4VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXgsAfDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXgsAfDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AA3C4CEE3;
	Sun, 22 Jun 2025 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750632775;
	bh=ov1k4T5zAAIp4Qp26yhT2gUNZWM2b4lWA4YwI0HB1J0=;
	h=Date:To:From:Subject:From;
	b=XXgsAfDOGZYTsVbzzGdqDuTo7pQ5IiPcDcc5oFbKct/MJ4iiq9i0/KzRCTW5+eU9Q
	 broJ2VsRxeDc7Z95A0oZZIre1k/NZhsPxc+7GYK1t9WSo/nMgd0E/Emht8KRFGbsba
	 1d79zVyJtcqGjVd8H/RH/Y7etzgjzSG1EFUHsbJc=
Date: Sun, 22 Jun 2025 15:52:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch added to mm-new branch
Message-Id: <20250622225255.51AA3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_wmark_metric
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch

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
Subject: mm/damon/sysfs-schemes: decouple from damos_wmark_metric
Date: Sun, 22 Jun 2025 14:37:57 -0700

Decouple DAMOS sysfs interface from damos_wmark_metric.  For this, define
and use new sysfs-schemes internal data structure that maps the user-space
keywords and damos_wmark_metric, instead of having the implicit and
unflexible array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   41 +++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric
+++ a/mm/damon/sysfs-schemes.c
@@ -785,10 +785,21 @@ static struct damon_sysfs_watermarks *da
 	return watermarks;
 }
 
-/* Should match with enum damos_wmark_metric */
-static const char * const damon_sysfs_wmark_metric_strs[] = {
-	"none",
-	"free_mem_rate",
+struct damos_sysfs_wmark_metric_name {
+	enum damos_wmark_metric metric;
+	char *name;
+};
+
+static const struct damos_sysfs_wmark_metric_name
+damos_sysfs_wmark_metric_names[] = {
+	{
+		.metric = DAMOS_WMARK_NONE,
+		.name = "none",
+	},
+	{
+		.metric = DAMOS_WMARK_FREE_MEM_RATE,
+		.name = "free_mem_rate",
+	},
 };
 
 static ssize_t metric_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -796,9 +807,16 @@ static ssize_t metric_show(struct kobjec
 {
 	struct damon_sysfs_watermarks *watermarks = container_of(kobj,
 			struct damon_sysfs_watermarks, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_wmark_metric_names); i++) {
+		const struct damos_sysfs_wmark_metric_name *metric_name;
 
-	return sysfs_emit(buf, "%s\n",
-			damon_sysfs_wmark_metric_strs[watermarks->metric]);
+		metric_name = &damos_sysfs_wmark_metric_names[i];
+		if (metric_name->metric == watermarks->metric)
+			return sysfs_emit(buf, "%s\n", metric_name->name);
+	}
+	return -EINVAL;
 }
 
 static ssize_t metric_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -806,11 +824,14 @@ static ssize_t metric_store(struct kobje
 {
 	struct damon_sysfs_watermarks *watermarks = container_of(kobj,
 			struct damon_sysfs_watermarks, kobj);
-	enum damos_wmark_metric metric;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_wmark_metric_names); i++) {
+		const struct damos_sysfs_wmark_metric_name *metric_name;
 
-	for (metric = 0; metric < NR_DAMOS_WMARK_METRICS; metric++) {
-		if (sysfs_streq(buf, damon_sysfs_wmark_metric_strs[metric])) {
-			watermarks->metric = metric;
+		metric_name = &damos_sysfs_wmark_metric_names[i];
+		if (sysfs_streq(buf, metric_name->name)) {
+			watermarks->metric = metric_name->metric;
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


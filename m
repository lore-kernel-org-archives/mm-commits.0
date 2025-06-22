Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46D23C26
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750632773; cv=none; b=ZkDu7CD8HxqTeKiEC5Us5wXmCFgHVzjet3gWuzg9uF/ngK3768VHEmBE246RCMrafj+nU6vbUQvFrIoPk9oieMLhZhsFWhO2LmQRbyHzLJlgBN/5CZPrZBz1nHxovCirqBOdc9YtECx1pgcHML1CQpvjNLja1rGwLF6X50nIPTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750632773; c=relaxed/simple;
	bh=gu3u+0QpgU4fWZNZXA492Jtv+0OHf3O0byNRthQcf48=;
	h=Date:To:From:Subject:Message-Id; b=KmmLYRR8RARqJKZITaW7Z9xnQZzWRpC3ez9gfV7tJxWDv4wenGGjHQRoU3rBf5mpAMXRPIRzB16/UzHZOFHiwoXj4diS2u7+cE1+DEQZMcrk99XZkNMgIPvW7E5JazrTLBbrXuwD+T/yHte3igthGh+JgF3CIzs12BJXEcQb8KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W0NgLtmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W0NgLtmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AC1C4CEE3;
	Sun, 22 Jun 2025 22:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750632773;
	bh=gu3u+0QpgU4fWZNZXA492Jtv+0OHf3O0byNRthQcf48=;
	h=Date:To:From:Subject:From;
	b=W0NgLtmcgS7a1VnveSYnI06iO9QZam0hk31/+9WO4MDztPSvhlWAtG+Gn1NEIxFrS
	 0o/2HY2I2aOJc5KjfZ08+iinpS1HcD0UVeLywrwov9mi72FRDJW0E0ot3YHRGxBVfM
	 f5LPXzEx4dPgF3Ha6bELMo8vBN6mWkzRA1IL6CF8=
Date: Sun, 22 Jun 2025 15:52:52 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-decouple-from-damos_action.patch added to mm-new branch
Message-Id: <20250622225253.62AC1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_action
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-decouple-from-damos_action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-decouple-from-damos_action.patch

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
Subject: mm/damon/sysfs-schemes: decouple from damos_action
Date: Sun, 22 Jun 2025 14:37:56 -0700

Decouple DAMOS sysfs interface from damos_action.  For this, define and
use new sysfs-schemes internal data structure that maps the user-space
keywords and damos_action, instead of having the implicit and unflexible
array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   80 ++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 18 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_action
+++ a/mm/damon/sysfs-schemes.c
@@ -1614,18 +1614,52 @@ struct damon_sysfs_scheme {
 	int target_nid;
 };
 
-/* This should match with enum damos_action */
-static const char * const damon_sysfs_damos_action_strs[] = {
-	"willneed",
-	"cold",
-	"pageout",
-	"hugepage",
-	"nohugepage",
-	"lru_prio",
-	"lru_deprio",
-	"migrate_hot",
-	"migrate_cold",
-	"stat",
+struct damos_sysfs_action_name {
+	enum damos_action action;
+	char *name;
+};
+
+struct damos_sysfs_action_name damos_sysfs_action_names[] = {
+	{
+		.action = DAMOS_WILLNEED,
+		.name = "willneed",
+	},
+	{
+		.action = DAMOS_COLD,
+		.name = "cold",
+	},
+	{
+		.action = DAMOS_PAGEOUT,
+		.name = "pageout",
+	},
+	{
+		.action = DAMOS_HUGEPAGE,
+		.name = "hugepage",
+	},
+	{
+		.action = DAMOS_NOHUGEPAGE,
+		.name = "nohugepage",
+	},
+	{
+		.action = DAMOS_LRU_PRIO,
+		.name = "lru_prio",
+	},
+	{
+		.action = DAMOS_LRU_DEPRIO,
+		.name = "lru_deprio",
+	},
+	{
+		.action = DAMOS_MIGRATE_HOT,
+		.name = "migrate_hot",
+	},
+	{
+		.action = DAMOS_MIGRATE_COLD,
+		.name = "migrate_cold",
+	},
+	{
+		.action = DAMOS_STAT,
+		.name = "stat",
+	},
 };
 
 static struct damon_sysfs_scheme *damon_sysfs_scheme_alloc(
@@ -1862,9 +1896,16 @@ static ssize_t action_show(struct kobjec
 {
 	struct damon_sysfs_scheme *scheme = container_of(kobj,
 			struct damon_sysfs_scheme, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_action_names); i++) {
+		struct damos_sysfs_action_name *action_name;
 
-	return sysfs_emit(buf, "%s\n",
-			damon_sysfs_damos_action_strs[scheme->action]);
+		action_name = &damos_sysfs_action_names[i];
+		if (action_name->action == scheme->action)
+			return sysfs_emit(buf, "%s\n", action_name->name);
+	}
+	return -EINVAL;
 }
 
 static ssize_t action_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1872,11 +1913,14 @@ static ssize_t action_store(struct kobje
 {
 	struct damon_sysfs_scheme *scheme = container_of(kobj,
 			struct damon_sysfs_scheme, kobj);
-	enum damos_action action;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_action_names); i++) {
+		struct damos_sysfs_action_name *action_name;
 
-	for (action = 0; action < NR_DAMOS_ACTIONS; action++) {
-		if (sysfs_streq(buf, damon_sysfs_damos_action_strs[action])) {
-			scheme->action = action;
+		action_name = &damos_sysfs_action_names[i];
+		if (sysfs_streq(buf, action_name->name)) {
+			scheme->action = action_name->action;
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


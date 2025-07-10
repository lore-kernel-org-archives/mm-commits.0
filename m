Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119A2286883
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126368; cv=none; b=Ec4zPOwvlta+3vWxJG1Rm+RfPdjOYVIMVNOCHGkmglzE64b7elRCwyWFtPG4t80i85MvK8GBcQpRDDinc2qFD2CzfCBZDOHejYomDGv+3O747cB1bo4DtHzc5pTIiAXHwMVTZ2fUxOM0ADp6tXgufN8VkJTJI3LEZY0CFNJlOmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126368; c=relaxed/simple;
	bh=DSsbVoEt4sYbpG6Si+iYMbG5Ym9/yL3xzFW+e1K2EZk=;
	h=Date:To:From:Subject:Message-Id; b=mWFT6wcaVbnXuFbkc1VUSo0bSb0gqWrxnyW6iW0c4Q8hAUH7DF1tNSkdWRsyUgtgSUSwX2UusbXPJE1Ib0a12001UzfwZvx9LGeX/MKrYOHSZje8KRZD+dO476TqSJK2X5JePT61JUmCA6J2KaPoVmIbAgaaCgFq01vn0PdTHDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xQoLIVpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xQoLIVpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6ACC4CEE3;
	Thu, 10 Jul 2025 05:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126367;
	bh=DSsbVoEt4sYbpG6Si+iYMbG5Ym9/yL3xzFW+e1K2EZk=;
	h=Date:To:From:Subject:From;
	b=xQoLIVpy19vzcv8gEoAdde7REfHgKFPb5wbZqQpJxNYLm71yFawxxV8Ss+EuWz+PZ
	 /TotM+9RSNIFe2h7wAk/GxnFyqn27Kx5OUTJKD9Za6uATrDpqeeSY4Y5QPBEaFYhfw
	 0tUb8eK/WrTAkNKtdxrMKZaPKG8VRVXu0sTM4x2g=
Date: Wed, 09 Jul 2025 22:46:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-decouple-from-damos_action.patch removed from -mm tree
Message-Id: <20250710054607.DA6ACC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_action
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-decouple-from-damos_action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: decouple from damos_action
Date: Sun, 22 Jun 2025 14:37:56 -0700

Decouple DAMOS sysfs interface from damos_action.  For this, define and
use new sysfs-schemes internal data structure that maps the user-space
keywords and damos_action, instead of having the implicit and unflexible
array index rule.

[akpm@linux-foundation.org: make damos_sysfs_action_names static]
  Closes: https://lore.kernel.org/oe-kbuild-all/202506271655.b8yfEZIT-lkp@intel.com/
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
+static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
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


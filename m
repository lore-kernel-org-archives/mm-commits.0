Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48BE286435
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126372; cv=none; b=g4Nrt//grGoafxoPjd6iL7pNiiSXGFhxsI8/0sRgoWcp15kHRA57gAGx/sxGdE62PJjEM53WWpO+NvZv/tbFWYlzSu8OrbM8dho9yn0DhXsPS0YD9qMKxnaWWofL3aEsN2kKU00SDBM2jkLSlsTWGcxUoIagPAq9k5Tk9WuvcxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126372; c=relaxed/simple;
	bh=qEJYDGlxo5wHx67Mq6oADk+D4xEvXKBXvDOooRdzQGI=;
	h=Date:To:From:Subject:Message-Id; b=Pv4sx0p2CqcH3Qoc0mnrT7yArHkx5t/DTBBmUbhsAoiPvbwACDk2lwCXUkxTEegeIW/XpGmrcFCJrwsrSy856R1WKUPWYi5p2g1EBrKNQyQ0X9AXhGHgtN0Zm6nrWPbATXJmqhUT5nVYGH9mAguQ14VFXghr3gLuvorTVrFHZEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecO9G2HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecO9G2HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA082C4CEE3;
	Thu, 10 Jul 2025 05:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126371;
	bh=qEJYDGlxo5wHx67Mq6oADk+D4xEvXKBXvDOooRdzQGI=;
	h=Date:To:From:Subject:From;
	b=ecO9G2HNWTO/Yw7JRrK5uuaqrzHVD7sRORym9NSGG8n2Y0OnHlGsxxuGnM+Gom74+
	 YHOtdi3/Jaey+mJby7HfI8NAQ/9Kbdqb0iWDC1HesA96nBSsRVZsBdiQOJ1KnuVKDJ
	 hyC5UdPfDYendhc5UZ565omQY3tD6N2U9IGjzNRw=
Date: Wed, 09 Jul 2025 22:46:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch removed from -mm tree
Message-Id: <20250710054611.BA082C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_filter_type
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: decouple from damos_filter_type
Date: Sun, 22 Jun 2025 14:37:58 -0700

Decouple DAMOS sysfs interface from damos_filter_type.  For this, define
and use new sysfs-schemes internal data structure that maps the user-space
keywords and damos_filter_type, instead of having the implicit and
unflexible array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   75 ++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 18 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_filter_type
+++ a/mm/damon/sysfs-schemes.c
@@ -341,16 +341,45 @@ static struct damon_sysfs_scheme_filter
 	return filter;
 }
 
-/* Should match with enum damos_filter_type */
-static const char * const damon_sysfs_scheme_filter_type_strs[] = {
-	"anon",
-	"active",
-	"memcg",
-	"young",
-	"hugepage_size",
-	"unmapped",
-	"addr",
-	"target",
+struct damos_sysfs_filter_type_name {
+	enum damos_filter_type type;
+	char *name;
+};
+
+static const struct damos_sysfs_filter_type_name
+damos_sysfs_filter_type_names[] = {
+	{
+		.type = DAMOS_FILTER_TYPE_ANON,
+		.name = "anon",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_ACTIVE,
+		.name = "active",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_MEMCG,
+		.name = "memcg",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_YOUNG,
+		.name = "young",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+		.name = "hugepage_size",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_UNMAPPED,
+		.name = "unmapped",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_ADDR,
+		.name = "addr",
+	},
+	{
+		.type = DAMOS_FILTER_TYPE_TARGET,
+		.name = "target",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -358,9 +387,16 @@ static ssize_t type_show(struct kobject
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_filter_type_names); i++) {
+		const struct damos_sysfs_filter_type_name *type_name;
 
-	return sysfs_emit(buf, "%s\n",
-			damon_sysfs_scheme_filter_type_strs[filter->type]);
+		type_name = &damos_sysfs_filter_type_names[i];
+		if (type_name->type == filter->type)
+			return sysfs_emit(buf, "%s\n", type_name->name);
+	}
+	return -EINVAL;
 }
 
 static bool damos_sysfs_scheme_filter_valid_type(
@@ -385,16 +421,19 @@ static ssize_t type_store(struct kobject
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	enum damos_filter_type type;
 	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_filter_type_names); i++) {
+		const struct damos_sysfs_filter_type_name *type_name;
 
-	for (type = 0; type < NR_DAMOS_FILTER_TYPES; type++) {
-		if (sysfs_streq(buf, damon_sysfs_scheme_filter_type_strs[
-					type])) {
+		type_name = &damos_sysfs_filter_type_names[i];
+		if (sysfs_streq(buf, type_name->name)) {
 			if (!damos_sysfs_scheme_filter_valid_type(
-						filter->handle_layer, type))
+						filter->handle_layer,
+						type_name->type))
 				break;
-			filter->type = type;
+			filter->type = type_name->type;
 			ret = count;
 			break;
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


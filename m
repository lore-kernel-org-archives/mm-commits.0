Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5998828640C
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126373; cv=none; b=enMlRrSQhKJXX7CEay9nmTH3nug7o80ljuB1Yo0e4zC6+QJFQX1/98l4V8PTHQSASd3s6aEZs252+kImVbXcpoTKNQX6TviRHo2iUNGpbu2nRugRRSiDQmbCo8BkCLOD/czTvKETldcsom6Um8bz0aJjFD7hfDf9CdX8vwrwesQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126373; c=relaxed/simple;
	bh=nKZETh1L98CYWJKwtR/0AOMEIPKyM3YL5/A5amToX70=;
	h=Date:To:From:Subject:Message-Id; b=I3D0lEsR+1Kq08yljmuN+hlLfIn2MkDto3/zymfvVIYjlqTYUdydPM7lurHSOuRBBQBGP3oycD/OSgf91VXkq0Zukd7YXSFugDH8F4PdT8kkDag7KV+hC8nGD1tHKMcgIi1fuMW0sf9fuXLzCN7lYMkJHx7NDJ7mtoN9ayLKjRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wT9tvJED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wT9tvJED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C535FC4CEE3;
	Thu, 10 Jul 2025 05:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126372;
	bh=nKZETh1L98CYWJKwtR/0AOMEIPKyM3YL5/A5amToX70=;
	h=Date:To:From:Subject:From;
	b=wT9tvJEDdb9bfNQ1AZ+buh63GZgSt0O7z/N2JTpIr5kF3GO7wZxieFWdpIQE9WeTB
	 o+9NS38Z5NhdPT6o6Z2LkTJIlg1YF8cRCWxuvTDHCjV2HL1v0dzxYt34prw0ASP/8+
	 Zm3yw+VimmaIiNtNhObCZChfbVPJCSwT1kEYJlto=
Date: Wed, 09 Jul 2025 22:46:12 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-decouple-from-damon_ops_id.patch removed from -mm tree
Message-Id: <20250710054612.C535FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: decouple from damon_ops_id
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-decouple-from-damon_ops_id.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: decouple from damon_ops_id
Date: Sun, 22 Jun 2025 14:37:59 -0700

Decouple DAMON sysfs interface from damon_ops_id.  For this, define and
use new mm/damon/sysfs.c internal data structure that maps the user-space
keywords and damon_ops_id, instead of having the implicit and unflexible
array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   56 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 15 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-decouple-from-damon_ops_id
+++ a/mm/damon/sysfs.c
@@ -811,11 +811,24 @@ static const struct kobj_type damon_sysf
  * context directory
  */
 
-/* This should match with enum damon_ops_id */
-static const char * const damon_sysfs_ops_strs[] = {
-	"vaddr",
-	"fvaddr",
-	"paddr",
+struct damon_sysfs_ops_name {
+	enum damon_ops_id ops_id;
+	char *name;
+};
+
+static const struct damon_sysfs_ops_name damon_sysfs_ops_names[] = {
+	{
+		.ops_id = DAMON_OPS_VADDR,
+		.name = "vaddr",
+	},
+	{
+		.ops_id = DAMON_OPS_FVADDR,
+		.name = "fvaddr",
+	},
+	{
+		.ops_id = DAMON_OPS_PADDR,
+		.name = "paddr",
+	},
 };
 
 struct damon_sysfs_context {
@@ -934,14 +947,16 @@ static void damon_sysfs_context_rm_dirs(
 static ssize_t avail_operations_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-	enum damon_ops_id id;
 	int len = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_ops_names); i++) {
+		const struct damon_sysfs_ops_name *ops_name;
 
-	for (id = 0; id < NR_DAMON_OPS; id++) {
-		if (!damon_is_registered_ops(id))
+		ops_name = &damon_sysfs_ops_names[i];
+		if (!damon_is_registered_ops(ops_name->ops_id))
 			continue;
-		len += sysfs_emit_at(buf, len, "%s\n",
-				damon_sysfs_ops_strs[id]);
+		len += sysfs_emit_at(buf, len, "%s\n", ops_name->name);
 	}
 	return len;
 }
@@ -951,8 +966,16 @@ static ssize_t operations_show(struct ko
 {
 	struct damon_sysfs_context *context = container_of(kobj,
 			struct damon_sysfs_context, kobj);
+	int i;
 
-	return sysfs_emit(buf, "%s\n", damon_sysfs_ops_strs[context->ops_id]);
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_ops_names); i++) {
+		const struct damon_sysfs_ops_name *ops_name;
+
+		ops_name = &damon_sysfs_ops_names[i];
+		if (ops_name->ops_id == context->ops_id)
+			return sysfs_emit(buf, "%s\n", ops_name->name);
+	}
+	return -EINVAL;
 }
 
 static ssize_t operations_store(struct kobject *kobj,
@@ -960,11 +983,14 @@ static ssize_t operations_store(struct k
 {
 	struct damon_sysfs_context *context = container_of(kobj,
 			struct damon_sysfs_context, kobj);
-	enum damon_ops_id id;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_ops_names); i++) {
+		const struct damon_sysfs_ops_name *ops_name;
 
-	for (id = 0; id < NR_DAMON_OPS; id++) {
-		if (sysfs_streq(buf, damon_sysfs_ops_strs[id])) {
-			context->ops_id = id;
+		ops_name = &damon_sysfs_ops_names[i];
+		if (sysfs_streq(buf, ops_name->name)) {
+			context->ops_id = ops_name->ops_id;
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


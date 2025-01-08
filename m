Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A2A19CC0C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308500; cv=none; b=gb7Ez4QV1Gav1DtCOOdJYEvXyuJw9Wc6P3fSSafeYwpnpGfef9xpHJKSaUuM1WPdgxQwmKJ3Vg/dGsr18s+Bv+4IrVSDIKtXqzpfT826CWEwLDJLMCb+QpiwuvHmVukE74zxBFBd9n8QdbTyCts4GvbKwKqc3OJL8Em+CpwYrmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308500; c=relaxed/simple;
	bh=+4NfAdgoxGv4XwTlDsCIU45+yhRav+SKhDvWuAaFWHw=;
	h=Date:To:From:Subject:Message-Id; b=SkU/lx6RwySTFL5pePKk5koy1A1EznFWr8OB+rWootItK7UoJBcEtoukKQbNHu/600IZ5Ynyth3GvDvoIy7SulOgaKtqzn6wUweOdZlOvlyplUd0MQ+DHSKkFn0oaXpCHZLNQWeL0VvFelbOhYmOk0dcJmYencCV7L7z5nvI8+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hGqXlqPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hGqXlqPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D055C4CED0;
	Wed,  8 Jan 2025 03:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308500;
	bh=+4NfAdgoxGv4XwTlDsCIU45+yhRav+SKhDvWuAaFWHw=;
	h=Date:To:From:Subject:From;
	b=hGqXlqPYVcDqXlptSacwZ9Yf8ubDtNTl8RHMLW039lzIZyqaFiQOBgWmos3Hs2Pg+
	 OP9wKAsJ67vYUFLnPUmjE7S1cqZ5G9guqsfupdhGAC7rCWCqhe5nL9OwOv/FJtraFs
	 RKU/rTQJS4mI/uTTZefzY4uam+9WqXiiEKD/aYoM=
Date: Tue, 07 Jan 2025 19:54:59 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-pass.patch added to mm-unstable branch
Message-Id: <20250108035500.0D055C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: add a file for setting damos_filter->pass
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-pass.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-pass.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/sysfs-schemes: add a file for setting damos_filter->pass
Date: Tue, 7 Jan 2025 12:17:35 -0800

Only kernel-space DAMON API users can use inclusive DAMOS filters.  Add a
sysfs file named 'pass' under DAMOS filter directory of DAMON sysfs
interface, to let the user-space users use inclusive DAMOS filters.

Link: https://lkml.kernel.org/r/20250107201739.79484-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-pass
+++ a/mm/damon/sysfs-schemes.c
@@ -313,6 +313,7 @@ struct damon_sysfs_scheme_filter {
 	struct kobject kobj;
 	enum damos_filter_type type;
 	bool matching;
+	bool pass;
 	char *memcg_path;
 	struct damon_addr_range addr_range;
 	int target_idx;
@@ -385,6 +386,30 @@ static ssize_t matching_store(struct kob
 	return count;
 }
 
+static ssize_t pass_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->pass ? 'Y' : 'N');
+}
+
+static ssize_t pass_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	bool pass;
+	int err = kstrtobool(buf, &pass);
+
+	if (err)
+		return err;
+
+	filter->pass = pass;
+	return count;
+}
+
 static ssize_t memcg_path_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -482,6 +507,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_scheme_filter_matching_attr =
 		__ATTR_RW_MODE(matching, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_filter_pass_attr =
+		__ATTR_RW_MODE(pass, 0600);
+
 static struct kobj_attribute damon_sysfs_scheme_filter_memcg_path_attr =
 		__ATTR_RW_MODE(memcg_path, 0600);
 
@@ -497,6 +525,7 @@ static struct kobj_attribute damon_sysfs
 static struct attribute *damon_sysfs_scheme_filter_attrs[] = {
 	&damon_sysfs_scheme_filter_type_attr.attr,
 	&damon_sysfs_scheme_filter_matching_attr.attr,
+	&damon_sysfs_scheme_filter_pass_attr.attr,
 	&damon_sysfs_scheme_filter_memcg_path_attr.attr,
 	&damon_sysfs_scheme_filter_addr_start_attr.attr,
 	&damon_sysfs_scheme_filter_addr_end_attr.attr,
@@ -1901,7 +1930,8 @@ static int damon_sysfs_add_scheme_filter
 			sysfs_filters->filters_arr[i];
 		struct damos_filter *filter =
 			damos_new_filter(sysfs_filter->type,
-					sysfs_filter->matching, false);
+					sysfs_filter->matching,
+					sysfs_filter->pass);
 		int err;
 
 		if (!filter)
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch
docs-translations-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-fixup-damos_filter-kernel-doc.patch
mm-damon-core-add-damos_filter-pass-field.patch
mm-damon-core-support-damos_filter-pass.patch
mm-damon-paddr-support-damos_filter-pass.patch
mm-damon-add-pass-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-pass.patch
docs-mm-damon-design-document-pass-block-filters-behaviors.patch
docs-abi-damon-document-damos-filter-pass-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-pass-sysfs-file.patch


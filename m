Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75FBC139
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215478; cv=none; b=ej07ge2TzH1HLoeq5JtMhL4xijc4D8QHIsJfoEIYqFJJagWEULWkzQHbSY154avUNB0jaDvr0/dXxzIEgAz7o13r5ir6oWK/bGTAqKSBUWgzvTJf32DCCcyUqKjuXQbIyaNp/gJJK9aiQFsyqCR7n+qib7oI0XBf4wo+UztLP9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215478; c=relaxed/simple;
	bh=qsBJHDzQxnTd7mIugbrgTlw8OLbJaiDrxECnlqz0Axo=;
	h=Date:To:From:Subject:Message-Id; b=aUSbQs1n737u6urcd6UWuPBOzDyji9+ccmQXxkTkcLrDnwdvTskXqRJS/xGGJxWSTYis0k8JSB68H+Tc56iyLo8fO20lak2bYye79hNhYB+VTEcywIQP7U+3KI94U4nklp/9+7vwi1xvF9yJBb9QDykVjXZDwidfr3ZpjnsgP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aefN4dL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aefN4dL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E207EC4CED2;
	Tue,  7 Jan 2025 02:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215476;
	bh=qsBJHDzQxnTd7mIugbrgTlw8OLbJaiDrxECnlqz0Axo=;
	h=Date:To:From:Subject:From;
	b=aefN4dL0nchpI+oDN01ShLNCdWq1JFUPDmAzRAy3MKMGmOm2rhl3YddISqgl0CbXK
	 B/iouZIHV6a4qjgtzIDhLr56YKNkMco3nJh1d8fnt43gf6GJ9DBqGw4B0KSKc7z00R
	 P3Yd5cILOgIg5775yyK0P4PRRzrS83YKUKUjX/6k=
Date: Mon, 06 Jan 2025 18:04:35 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch added to mm-unstable branch
Message-Id: <20250107020435.E207EC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/syfs-schemes: implement per-scheme filter-passed bytes stat
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch

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
Subject: mm/damon/syfs-schemes: implement per-scheme filter-passed bytes stat
Date: Mon, 6 Jan 2025 11:33:53 -0800

Add a new DAMON sysfs interface file under scheme stat directory, namely
'sz_ops_filter_passed'.  It represents total bytes that passed
region-internal DAMOS filters of the scheme that handled by the DAMON
operations set layer.

Link: https://lkml.kernel.org/r/20250106193401.109161-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat
+++ a/mm/damon/sysfs-schemes.c
@@ -188,6 +188,7 @@ struct damon_sysfs_stats {
 	unsigned long sz_tried;
 	unsigned long nr_applied;
 	unsigned long sz_applied;
+	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 };
 
@@ -232,6 +233,15 @@ static ssize_t sz_applied_show(struct ko
 	return sysfs_emit(buf, "%lu\n", stats->sz_applied);
 }
 
+static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
+}
+
 static ssize_t qt_exceeds_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -258,6 +268,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_stats_sz_applied_attr =
 		__ATTR_RO_MODE(sz_applied, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
+		__ATTR_RO_MODE(sz_ops_filter_passed, 0400);
+
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
@@ -266,6 +279,7 @@ static struct attribute *damon_sysfs_sta
 	&damon_sysfs_stats_sz_tried_attr.attr,
 	&damon_sysfs_stats_nr_applied_attr.attr,
 	&damon_sysfs_stats_sz_applied_attr.attr,
+	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	NULL,
 };
@@ -2077,6 +2091,8 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_tried = scheme->stat.sz_tried;
 		sysfs_stats->nr_applied = scheme->stat.nr_applied;
 		sysfs_stats->sz_applied = scheme->stat.sz_applied;
+		sysfs_stats->sz_ops_filter_passed =
+			scheme->stat.sz_ops_filter_passed;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 	}
 }
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
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


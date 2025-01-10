Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3FA21A43A
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 22:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549779; cv=none; b=styxDoceNT+wzD3wwZOEsznsGPDWUwAN3YAPeyFBi090qzSfnxefU61UEP/qxrXqg4E9B6QGrGwxp/i6OKxYqo5mpR0/jAZZBriY+oyXP8jxt5hs7QBPEfP6WO+SOwna+wmD+dVu8342QDGy5AdjX0xo59HrQfQnjKL3AXieCtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549779; c=relaxed/simple;
	bh=YS6UYmkHgPYeMUaj2k1lCVf9BRcznBvCnAKMSQIQCQQ=;
	h=Date:To:From:Subject:Message-Id; b=HC5kuyL0Q1KXWR597eeHzM26Gfdj0ec35yzx9UhkXlaamlZYl6jUeVvb4pChbS6TyxHlYBvauxyZPxQOGxRTT9stmWEXcsfhsvVHCOihm6cF7Hn3yi1vlFw0CawNEzn1CzAX3k8IxewGU0lr3Cu39XOa01LyXbTlfV98SKKfffk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ztPbJK15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ztPbJK15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE18C4CED6;
	Fri, 10 Jan 2025 22:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736549778;
	bh=YS6UYmkHgPYeMUaj2k1lCVf9BRcznBvCnAKMSQIQCQQ=;
	h=Date:To:From:Subject:From;
	b=ztPbJK15YfErp90j4aMJF/uus+GezWEK43gT1MaXrL01vVZmZpkrhY63z84WvbtpS
	 8CF9bro365Lu5eXNDb14zfy5HSh1TYwcVdP11MyGNByHoelKTI1TMeSp5RISClVG4U
	 hgOpxzqx0XV+EZj1kTHbQgXofDNYZxPCn6vnvFFE=
Date: Fri, 10 Jan 2025 14:56:17 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-explain-effective-quota-on-kernel-doc-comment.patch added to mm-unstable branch
Message-Id: <20250110225618.3EE18C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: explain "effective quota" on kernel-doc comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

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
Subject: mm/damon: explain "effective quota" on kernel-doc comment
Date: Fri, 10 Jan 2025 10:52:32 -0800

The kernel-doc comment for 'struct damos_quota' describes how "effective
quota" is calculated, but does not explain what it is.  Actually there was
an input[1] about it.  Add the explanation on the comment.

Also, fix a trivial typo on the comment block: s/empt/empty/

[1] https://github.com/damonitor/damo/issues/17#issuecomment-2497525043

Link: https://lkml.kernel.org/r/20250110185232.54907-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-explain-effective-quota-on-kernel-doc-comment
+++ a/include/linux/damon.h
@@ -193,11 +193,16 @@ struct damos_quota_goal {
  * size quota is set, DAMON tries to apply the action only up to &sz bytes
  * within &reset_interval.
  *
- * Internally, the time quota is transformed to a size quota using estimated
- * throughput of the scheme's action.  DAMON then compares it against &sz and
- * uses smaller one as the effective quota.
+ * To convince the different types of quotas and goals, DAMON internally
+ * converts those into one single size quota called "effective quota".  DAMON
+ * internally uses it as the only one real quota.  The conversion is made as
+ * follows.
  *
- * If @goals is not empt, DAMON calculates yet another size quota based on the
+ * The time quota is transformed to a size quota using estimated throughput of
+ * the scheme's action.  DAMON then compares it against &sz and uses smaller
+ * one as the effective quota.
+ *
+ * If @goals is not empty, DAMON calculates yet another size quota based on the
  * goals using its internal feedback loop algorithm, for every @reset_interval.
  * Then, if the new size quota is smaller than the effective quota, it uses the
  * new size quota as the effective quota.
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
mm-damon-core-add-damos_filter-allow-field.patch
mm-damon-core-support-damos_filter-allow.patch
mm-damon-paddr-support-damos_filter-allow.patch
mm-damon-add-allow-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch
docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch
docs-abi-damon-document-damos-filter-allow-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch
docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch


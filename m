Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991E02E40E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308507; cv=none; b=HqC6kNOcyRTpIBdRen2DL/5+vlpurGcG6SoR4YlBCF+Zua43DQiZGGX2YEh+EbaI7qGan1gUGIPzOOCf/PsQxj4wabyi8WWehbrua2j1wXvxRRyShZdro4poy7G9GVQCCXs4yLbZB7OC5b5A8fr+Tm9OSOlzso47mziBa3OAFcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308507; c=relaxed/simple;
	bh=FLgXsdnItKEbFbwKwDtbmHd3UWtbERuxi80Ia8HtJec=;
	h=Date:To:From:Subject:Message-Id; b=JvRieMwFIzhOwqk94JKGl6YPOCPG4ikj10ftkSo+5GVfUodlX/3rHWmb/0xQMA7l/SqohQ4uM7jczuxMiMiTscFsJiTbyT05Z5keCaJZHN1mRcKaKBkhVZrrLm480ozlGmjOwg+Jk7OaOWWXRxOpsKx1BZSDToV3OYzIUMG7tgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LCJIatyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LCJIatyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681C5C4CED0;
	Wed,  8 Jan 2025 03:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308507;
	bh=FLgXsdnItKEbFbwKwDtbmHd3UWtbERuxi80Ia8HtJec=;
	h=Date:To:From:Subject:From;
	b=LCJIatyYrX1oO+Ttme6/iZw/TQ7xrnjoB/c0FebmOh00R3/s+Wb4IIJworhtbV1UI
	 ZjhZK+toNrI84b3IyCnq0ATFs1T6Ul1RcNCtN+G6c8lyGVD5d8KH8Yj/FEK147VXo/
	 lVEAWtZYh6I9Vvj2rLeqKqZsogI6JC52TEHYm1Os=
Date: Tue, 07 Jan 2025 19:55:06 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-damos-filter-pass-sysfs-file.patch added to mm-unstable branch
Message-Id: <20250108035507.681C5C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document DAMOS filter 'pass' sysfs file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-damos-filter-pass-sysfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-damos-filter-pass-sysfs-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document DAMOS filter 'pass' sysfs file
Date: Tue, 7 Jan 2025 12:17:39 -0800

Update DAMON usage document for the newly added 'pass' sysfs file for
DAMOS filters.

Link: https://lkml.kernel.org/r/20250107201739.79484-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   34 ++++++++++-------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-damos-filter-pass-sysfs-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
+    │ │ │ │ │ │ │ │ 0/type,matching,memcg_id,pass
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
@@ -406,13 +406,14 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each filter.  The filters are evaluated
 in the numeric order.
 
-Each filter directory contains six files, namely ``type``, ``matcing``,
-``memcg_path``, ``addr_start``, ``addr_end``, and ``target_idx``.  To ``type``
-file, you can write one of five special keywords: ``anon`` for anonymous pages,
-``memcg`` for specific memory cgroup, ``young`` for young pages, ``addr`` for
-specific address range (an open-ended interval), or ``target`` for specific
-DAMON monitoring target filtering.  Meaning of the types are same to the
-description on the :ref:`design doc <damon_design_damos_filters>`.
+Each filter directory contains seven files, namely ``type``, ``matcing``,
+``pass``, ``memcg_path``, ``addr_start``, ``addr_end``, and ``target_idx``.  To
+``type`` file, you can write one of five special keywords: ``anon`` for
+anonymous pages, ``memcg`` for specific memory cgroup, ``young`` for young
+pages, ``addr`` for specific address range (an open-ended interval), or
+``target`` for specific DAMON monitoring target filtering.  Meaning of the
+types are same to the description on the :ref:`design doc
+<damon_design_damos_filters>`.
 
 In case of the memory cgroup filtering, you can specify the memory cgroup of
 the interest by writing the path of the memory cgroup from the cgroups mount
@@ -422,25 +423,30 @@ specify the start and end address of the
 you can specify the index of the target between the list of the DAMON context's
 monitoring targets list to ``target_idx`` file.
 
-You can write ``Y`` or ``N`` to ``matching`` file to filter out pages that does
-or does not match to the type, respectively.  Then, the scheme's action will
-not be applied to the pages that specified to be filtered out.
+You can write ``Y`` or ``N`` to ``matching`` file to specify whether the filter
+is for memory that matches the ``type``.  You can write ``Y`` or ``N`` to
+``pass`` file to specify should this filter let the memory that satisfies the
+``type`` and ``matching`` pass though (allow) or be blocked by (reject) the
+filter.  Allowing means the scheme's action will be applied to the memory.
 
 For example, below restricts a DAMOS action to be applied to only non-anonymous
 pages of all memory cgroups except ``/having_care_already``.::
 
     # echo 2 > nr_filters
-    # # filter out anonymous pages
+    # # block anonymous pages
     echo anon > 0/type
     echo Y > 0/matching
+    echo N > 0/pass
     # # further filter out all cgroups except one at '/having_care_already'
     echo memcg > 1/type
     echo /having_care_already > 1/memcg_path
     echo Y > 1/matching
+    echo N > 1/pass
 
 Refer to the :ref:`DAMOS filters design documentation
-<damon_design_damos_filters>` for more details including when each of the
-filters are supported and differences on stats.
+<damon_design_damos_filters>` for more details including how multiple filters
+of different ``pass`` works, when each of the filters are supported, and
+differences on stats.
 
 .. _sysfs_schemes_stats:
 
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


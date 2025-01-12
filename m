Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B92D632
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736659660; cv=none; b=gz6T+ED22xEBWt0TUFzHUG3rOB7P5pcjj7KBDAhuxIhF+biIQ+pSsQV++5UOOmj3rx5a/Cv3wBIZn4ihgB+ABjhYQ7xsGeI6CHhtNTrGDyMvIEX1EMKie/w0SOImtLTbhMNiFaDaYtInLB1bGDdkEpky2Q/egBK5xkt+F9lBxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736659660; c=relaxed/simple;
	bh=P10/quZVLwKbhonIhdYPuJwkZz2OgQt0gvBsKj8Ypp8=;
	h=Date:To:From:Subject:Message-Id; b=TJYXk8XlUzIywDcBDLSk5O80Uql1Zb+2j2eDLKOtZBn8u68nHaPxaNIowbOREVrz8CY/UdnEv2lTerpXzhd1yOcJfnI6KpekKwuJ+DG427/BsSc/8sAoovuZYWznX9oiE6sAKbNYt5r0LGIz6N5Ab9i7b4MgPpTOnCpYW6X2/ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RUMjKVLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RUMjKVLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6502C4CEE0;
	Sun, 12 Jan 2025 05:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736659659;
	bh=P10/quZVLwKbhonIhdYPuJwkZz2OgQt0gvBsKj8Ypp8=;
	h=Date:To:From:Subject:From;
	b=RUMjKVLOHMjIvfDYBkl+BQseUx/0v5zDl38h0J7jM4KYpW2+VmSLlNMrwfWoKmBxa
	 fatV4RulByfYWp+WHGXzBCClqwdWgZ2ra/OLVzG7lbxbsRXZu/kgwBydg3xGUJR+Zs
	 GCRPtcv9UwS1IiFXGSHWf1Ldl6K2Seo749kOoFD8=
Date: Sat, 11 Jan 2025 21:27:39 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] replace-free-hugepage-folios-after-migration-fix-2.patch removed from -mm tree
Message-Id: <20250112052739.B6502C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: define replace_free_hugepage_folios() on CONFIG_HUGETLB_PAGE=n as static inline
has been removed from the -mm tree.  Its filename was
     replace-free-hugepage-folios-after-migration-fix-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/hugetlb: define replace_free_hugepage_folios() on CONFIG_HUGETLB_PAGE=n as static inline
Date: Thu, 19 Dec 2024 10:37:53 -0800

Commit fba5261e0039 ("mm: replace free hugepage folios after migration")
on mm-unstable that also available at
https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge1116@126.com
breaks build when CONFIG_HUGETLB_PAGE=n as below, since
replace_free_hugepage_folios() is defined on the header as non-inline. 
Fix it.

    ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests --build_dir ../kunit.out
    [...]
    ld: io_uring/rsrc.o: in function `replace_free_hugepage_folios':
    rsrc.c:(.text+0x160): multiple definition of `replace_free_hugepage_folios'; kernel/fork.o:fork.c:(.text+0xc30): first defined here
    [...]
    make: *** [Makefile:251: __sub-make] Error 2

Link: https://lkml.kernel.org/r/20241219183753.62922-1-sj@kernel.org
Fixes: fba5261e0039 ("mm: replace free hugepage folios after migration")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~replace-free-hugepage-folios-after-migration-fix-2
+++ a/include/linux/hugetlb.h
@@ -1060,7 +1060,8 @@ static inline int isolate_or_dissolve_hu
 	return -ENOMEM;
 }
 
-int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
+static inline int replace_free_hugepage_folios(unsigned long start_pfn,
+		unsigned long end_pfn)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
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


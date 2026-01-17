Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A787230CD8B
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768620359; cv=none; b=cLU4ZgBEaPsRl5Utrq20oWGlksnfDerMwz4INeeNVyMgk3VYqhApfPZLiueEcSdsrDhdSumZyIVucQPEXphY/bOPuXchJaWy67akv4rq8R0aFnTM8CJ8Cx43TDj5m5GicnAtGFgBHiyuTUWhJ1M+bUbI7O7eBAk5t7DboLO+9W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768620359; c=relaxed/simple;
	bh=EJ+JD56lBL73VCUhIkS/Zf4z1MTYyDEcu5GlM+y2aL0=;
	h=Date:To:From:Subject:Message-Id; b=OZyCDrkDVXf1Rz0o5pXZ5dnlQ9Ovk86c/wTOTSoTfkze7z8z1lwhMguBVW1CMikgZkuZfNduakpoh/clFweFt1m6as+9kJQS1JklJif9UvshRX5JZ7zjoe7KuEO+gN6k1vxCV1vw1COIf5M0+cX9MA3Q50pXDMpVwGTe5n1ED58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kpqBBPnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kpqBBPnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F234C4CEF7;
	Sat, 17 Jan 2026 03:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768620359;
	bh=EJ+JD56lBL73VCUhIkS/Zf4z1MTYyDEcu5GlM+y2aL0=;
	h=Date:To:From:Subject:From;
	b=kpqBBPnfiXTowEp4zlf/WllZvs8po5xtIAeusszHb6xEQP6fkmHSDFYBPxAHfw120
	 fTFNHwgbkh4SB1UlyvxNVlnEQtfXfeN0nHBoSA98v/GWtCd73/3et6ImR2wuMX+EIe
	 A9EsELeYD0WonrZ993Zw4WmbwT5blsbKcI+4fMIU=
Date: Fri, 16 Jan 2026 19:25:58 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-temporary-build-fix.patch added to mm-new branch
Message-Id: <20260117032559.4F234C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: temporary build fix
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-temporary-build-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-temporary-build-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/vma: temporary build fix
Date: Fri, 16 Jan 2026 17:01:27 -0800

Link: https://lkml.kernel.org/r/20260115182720.1691130-9-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20260117010707.202128-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   38 +++++++++++++++++++-------------------
 mm/vma_internal.h       |    1 +
 2 files changed, 20 insertions(+), 19 deletions(-)

--- a/include/linux/pgtable.h~mm-vma-temporary-build-fix
+++ a/include/linux/pgtable.h
@@ -23,25 +23,6 @@
 #endif
 
 /*
- * On almost all architectures and configurations, 0 can be used as the
- * upper ceiling to free_pgtables(): on many architectures it has the same
- * effect as using TASK_SIZE.  However, there is one configuration which
- * must impose a more careful limit, to avoid freeing kernel pgtables.
- */
-#ifndef USER_PGTABLES_CEILING
-#define USER_PGTABLES_CEILING	0UL
-#endif
-
-/*
- * This defines the first usable user address. Platforms
- * can override its value with custom FIRST_USER_ADDRESS
- * defined in their respective <asm/pgtable.h>.
- */
-#ifndef FIRST_USER_ADDRESS
-#define FIRST_USER_ADDRESS	0UL
-#endif
-
-/*
  * This defines the generic helper for accessing PMD page
  * table page. Although platforms can still override this
  * via their respective <asm/pgtable.h>.
@@ -1661,6 +1642,25 @@ void arch_sync_kernel_mappings(unsigned
 #endif /* CONFIG_MMU */
 
 /*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
+/*
+ * This defines the first usable user address. Platforms
+ * can override its value with custom FIRST_USER_ADDRESS
+ * defined in their respective <asm/pgtable.h>.
+ */
+#ifndef FIRST_USER_ADDRESS
+#define FIRST_USER_ADDRESS	0UL
+#endif
+
+/*
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
  */
--- a/mm/vma_internal.h~mm-vma-temporary-build-fix
+++ a/mm/vma_internal.h
@@ -46,6 +46,7 @@
 #include <linux/swap.h>
 #include <linux/uprobes.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/pgtable.h>
 
 #include <asm/current.h>
 #include <asm/tlb.h>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch


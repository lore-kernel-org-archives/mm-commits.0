Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CD42C15AE
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490006; cv=none; b=DuLXU8G+Cbpj0IJdqWEWH/W2RIKjx31IF2pbF7tusNVPPanr8wYGvo2HIEFF6mb8ZSD4gLjrIw9Sx1ghAqcWh8K8FTqy9nsmnKR/uLCgIwYlv2hwTQUwRHDpkCBpiuIQn9J2UP+HNlqFhRBBEVPadiVOabNZUfWjDoFiySyV9dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490006; c=relaxed/simple;
	bh=ZqYmXo2oSrZoc8oqYA0F3IzadtzxyR4X6YSBSlOUfj4=;
	h=Date:To:From:Subject:Message-Id; b=Ob+D0aHf91HgmloV3HEmZYkJemVm2/yWDYDiqkH4R7HUC0NdJUbPC60zfczYw48twJidEprZyfE5xAbI5hFh058pcjiRNZyhpJ7Lhl/N6CKLpHyL5zIWqh4cItLMiyLiegwhEEjf/4o68R8SeyvBruYntsqDGJ3zITQSFGoe6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qFb1Q2Gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qFb1Q2Gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D5DC4CEE7;
	Sun, 21 Sep 2025 21:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490005;
	bh=ZqYmXo2oSrZoc8oqYA0F3IzadtzxyR4X6YSBSlOUfj4=;
	h=Date:To:From:Subject:From;
	b=qFb1Q2GiYcn5r7rtNAqkJVstLALtsLnSj5bhUVMtFKZiwYzSU94sIRTMe1HqdFJk1
	 Zcuc5VcrKDHNvNMM6Ea0gqlpD2RE/tSJSTVEr5m9wBX4MGCP6NMFBrfj5OH4nxJ6YY
	 W0WUvTcMv1m5Nxu8ALzgogqDtE2LH7htT+0Ss9bY=
Date: Sun, 21 Sep 2025 14:26:45 -0700
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch removed from -mm tree
Message-Id: <20250921212645.B4D5DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
has been removed from the -mm tree.  Its filename was
     include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
Date: Sat Sep 13 05:03:39 PM PDT 2025

For all the usual reasons, plus a new one.  Calling

	(void)arch_enter_lazy_mmu_mode();

deservedly blows up.

Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines
+++ a/include/linux/pgtable.h
@@ -232,9 +232,9 @@ static inline int pmd_dirty(pmd_t pmd)
  * and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
+static inline void arch_enter_lazy_mmu_mode(void) {}
+static inline void arch_leave_lazy_mmu_mode(void) {}
+static inline void arch_flush_lazy_mmu_mode(void) {}
 #endif
 
 #ifndef pte_batch_hint
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch


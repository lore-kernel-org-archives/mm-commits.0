Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7981A6802
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 17:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773769595; cv=none; b=DqdPl4aBtAASVgK4VjquGicEFQ7m+qXNo+NOpLASzFJ126QTFtjM+00XbjaEx74DKpwPJ3ewuCcdJcq2PjtyLZSAYtDs3wbfmIxonlEFBvCDaTajnaR1CRaUzrKPLJTOMn8IDvg3S8CrO6sJdpeqhnU8BVXj20veqpQPMafWAdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773769595; c=relaxed/simple;
	bh=i8Ec/ZMiTHiTrqvO0JWlmnFyt4+iZRcZ0IWvbPL+sTg=;
	h=Date:To:From:Subject:Message-Id; b=WeI+7lskoSqTHhqT7WSvHjQw+JuF2Wob3d2Y+CrDYgun1oO2uOqiPDHYS0xnZDIXKLGd5vl686z2DXz3F7d3Db5FzczX1egf305YfwVq6i9UQHItjScsSmAWKqF4EJ1itgJ31oV7V42MEcuqu3xL5fgZnLCZ9eJk8ZBO+UTNnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CE5K94NT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CE5K94NT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD66C4CEF7;
	Tue, 17 Mar 2026 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773769594;
	bh=i8Ec/ZMiTHiTrqvO0JWlmnFyt4+iZRcZ0IWvbPL+sTg=;
	h=Date:To:From:Subject:From;
	b=CE5K94NTu9aB8MuI4Q3qXzlnfdII7cmJvAjxCzyRIf3qrRgXLb09bzzwbKqwkh3vA
	 6DJ+WQUb0ihwDQzi2IZfXIvEFLUJtDalXAaQFvXkV7+j6DGbKY5eY0Qz02mHsFBcbR
	 xGEboRTzjhjvg/yt7QL6SZWstxLv9flPpKxEnpME=
Date: Tue, 17 Mar 2026 10:46:34 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,epetron@amazon.de,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-make-kho_scratch_overlap-usable-outside-debugging.patch added to mm-new branch
Message-Id: <20260317174634.AAD66C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make kho_scratch_overlap usable outside debugging
has been added to the -mm mm-new branch.  Its filename is
     kho-make-kho_scratch_overlap-usable-outside-debugging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-make-kho_scratch_overlap-usable-outside-debugging.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Michal Clapinski <mclapinski@google.com>
Subject: kho: make kho_scratch_overlap usable outside debugging
Date: Tue, 17 Mar 2026 15:15:32 +0100

Patch series "kho: add support for deferred struct page init", v7.

When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is enabled,
struct page initialization is deferred to parallel kthreads that run later
in the boot process.

Currently, KHO is incompatible with DEFERRED.  This series fixes that
incompatibility.


This patch (of 3):

Also return false if kho_scratch is NULL.

Link: https://lkml.kernel.org/r/20260317141534.815634-1-mclapinski@google.com
Link: https://lkml.kernel.org/r/20260317141534.815634-2-mclapinski@google.com
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h              |    6 +++
 kernel/liveupdate/Makefile                  |    1 
 kernel/liveupdate/kexec_handover.c          |   28 +++++++++++++++---
 kernel/liveupdate/kexec_handover_debug.c    |   25 ----------------
 kernel/liveupdate/kexec_handover_internal.h |    7 +++-
 5 files changed, 35 insertions(+), 32 deletions(-)

--- a/include/linux/kexec_handover.h~kho-make-kho_scratch_overlap-usable-outside-debugging
+++ a/include/linux/kexec_handover.h
@@ -35,6 +35,7 @@ void *kho_restore_vmalloc(const struct k
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
 
 void kho_memory_init(void);
 
@@ -109,6 +110,11 @@ static inline int kho_retrieve_subtree(c
 	return -EOPNOTSUPP;
 }
 
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+
 static inline void kho_memory_init(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
--- a/kernel/liveupdate/kexec_handover.c~kho-make-kho_scratch_overlap-usable-outside-debugging
+++ a/kernel/liveupdate/kexec_handover.c
@@ -820,7 +820,8 @@ int kho_preserve_folio(struct folio *fol
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+	if (WARN_ON(kho_scratch_overlap_debug(pfn << PAGE_SHIFT,
+					      PAGE_SIZE << order)))
 		return -EINVAL;
 
 	return kho_radix_add_page(tree, pfn, order);
@@ -864,10 +865,9 @@ int kho_preserve_pages(struct page *page
 	unsigned long failed_pfn = 0;
 	int err = 0;
 
-	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
-					nr_pages << PAGE_SHIFT))) {
+	if (WARN_ON(kho_scratch_overlap_debug(start_pfn << PAGE_SHIFT,
+					      nr_pages << PAGE_SHIFT)))
 		return -EINVAL;
-	}
 
 	while (pfn < end_pfn) {
 		unsigned int order =
@@ -1327,6 +1327,26 @@ int kho_retrieve_subtree(const char *nam
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	phys_addr_t scratch_start, scratch_end;
+	unsigned int i;
+
+	if (!kho_scratch)
+		return false;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (phys < scratch_end && (phys + size) > scratch_start)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(kho_scratch_overlap);
+
 static int __init kho_mem_retrieve(const void *fdt)
 {
 	struct kho_radix_tree tree;
diff --git a/kernel/liveupdate/kexec_handover_debug.c a/kernel/liveupdate/kexec_handover_debug.c
deleted file mode 100644
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * kexec_handover_debug.c - kexec handover optional debug functionality
- * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
- */
-
-#define pr_fmt(fmt) "KHO: " fmt
-
-#include "kexec_handover_internal.h"
-
-bool kho_scratch_overlap(phys_addr_t phys, size_t size)
-{
-	phys_addr_t scratch_start, scratch_end;
-	unsigned int i;
-
-	for (i = 0; i < kho_scratch_cnt; i++) {
-		scratch_start = kho_scratch[i].addr;
-		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
-
-		if (phys < scratch_end && (phys + size) > scratch_start)
-			return true;
-	}
-
-	return false;
-}
--- a/kernel/liveupdate/kexec_handover_internal.h~kho-make-kho_scratch_overlap-usable-outside-debugging
+++ a/kernel/liveupdate/kexec_handover_internal.h
@@ -41,9 +41,12 @@ static inline void kho_debugfs_fdt_remov
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
-bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+static inline bool kho_scratch_overlap_debug(phys_addr_t phys, size_t size)
+{
+	return kho_scratch_overlap(phys, size);
+}
 #else
-static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+static inline bool kho_scratch_overlap_debug(phys_addr_t phys, size_t size)
 {
 	return false;
 }
--- a/kernel/liveupdate/Makefile~kho-make-kho_scratch_overlap-usable-outside-debugging
+++ a/kernel/liveupdate/Makefile
@@ -7,7 +7,6 @@ luo-y :=								\
 		luo_session.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
_

Patches currently in -mm which might be from mclapinski@google.com are

kho-make-kho_scratch_overlap-usable-outside-debugging.patch
kho-fix-deferred-init-of-kho-scratch.patch


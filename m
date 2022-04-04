Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7C2C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241939AbiDDXIr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiDDXIR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:08:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4C454FBB
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 15:36:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D614EB81A55
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 22:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C2BC2BBE4;
        Mon,  4 Apr 2022 22:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649111803;
        bh=9qdg0wd30caYI+zOhjkoDLNqLXYHbw5VOqmUitp/sp0=;
        h=Date:To:From:Subject:From;
        b=K7WV+ajPHVFfbTQ/kmwtQudq9O71/52pm/gQkx5D5o7AVB+jnMk8rwptNgBXGd+wY
         Tl2QYrttw1KCN26aGdHD8WsN1svrEkMeZrT7/Vsk7lc+5xPpx6UBOauVmxHE0iLMKy
         ZTr233XrbkctZQRzZ6C7g6z6FhNuBamry1VZuZcA=
Date:   Mon, 04 Apr 2022 15:36:42 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, peterx@redhat.com,
        npiggin@gmail.com, luto@kernel.org, dave.hansen@linux.intel.com,
        andrew.cooper3@citrix.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-unnecessary-flush-on-change_huge_pmd.patch added to -mm tree
Message-Id: <20220404223643.66C2BC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid unnecessary flush on change_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-avoid-unnecessary-flush-on-change_huge_pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-unnecessary-flush-on-change_huge_pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-unnecessary-flush-on-change_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm: avoid unnecessary flush on change_huge_pmd()

Calls to change_protection_range() on THP can trigger, at least on x86,
two TLB flushes for one page: one immediately, when pmdp_invalidate() is
called by change_huge_pmd(), and then another one later (that can be
batched) when change_protection_range() finishes.

The first TLB flush is only necessary to prevent the dirty bit (and with a
lesser importance the access bit) from changing while the PTE is modified.
However, this is not necessary as the x86 CPUs set the dirty-bit
atomically with an additional check that the PTE is (still) present.  One
caveat is Intel's Knights Landing that has a bug and does not do so.

Leverage this behavior to eliminate the unnecessary TLB flush in
change_huge_pmd().  Introduce a new arch specific pmdp_invalidate_ad()
that only invalidates the access and dirty bit from further changes.

Link: https://lkml.kernel.org/r/20220401180821.1986781-4-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    5 +++++
 arch/x86/mm/pgtable.c          |   10 ++++++++++
 include/linux/pgtable.h        |   20 ++++++++++++++++++++
 mm/huge_memory.c               |    4 ++--
 mm/pgtable-generic.c           |    8 ++++++++
 5 files changed, 45 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-avoid-unnecessary-flush-on-change_huge_pmd
+++ a/arch/x86/include/asm/pgtable.h
@@ -1173,6 +1173,11 @@ static inline pmd_t pmdp_establish(struc
 	}
 }
 #endif
+
+#define __HAVE_ARCH_PMDP_INVALIDATE_AD
+extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
+				unsigned long address, pmd_t *pmdp);
+
 /*
  * Page table pages are page-aligned.  The lower half of the top
  * level is used for userspace and the top half for the kernel.
--- a/arch/x86/mm/pgtable.c~mm-avoid-unnecessary-flush-on-change_huge_pmd
+++ a/arch/x86/mm/pgtable.c
@@ -608,6 +608,16 @@ int pmdp_clear_flush_young(struct vm_are
 
 	return young;
 }
+
+pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
+			 pmd_t *pmdp)
+{
+	/*
+	 * No flush is necessary. Once an invalid PTE is established, the PTE's
+	 * access and dirty bits cannot be updated.
+	 */
+	return pmdp_establish(vma, address, pmdp, pmd_mkinvalid(*pmdp));
+}
 #endif
 
 /**
--- a/include/linux/pgtable.h~mm-avoid-unnecessary-flush-on-change_huge_pmd
+++ a/include/linux/pgtable.h
@@ -570,6 +570,26 @@ extern pmd_t pmdp_invalidate(struct vm_a
 			    pmd_t *pmdp);
 #endif
 
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE_AD
+
+/*
+ * pmdp_invalidate_ad() invalidates the PMD while changing a transparent
+ * hugepage mapping in the page tables. This function is similar to
+ * pmdp_invalidate(), but should only be used if the access and dirty bits would
+ * not be cleared by the software in the new PMD value. The function ensures
+ * that hardware changes of the access and dirty bits updates would not be lost.
+ *
+ * Doing so can allow in certain architectures to avoid a TLB flush in most
+ * cases. Yet, another TLB flush might be necessary later if the PMD update
+ * itself requires such flush (e.g., if protection was set to be stricter). Yet,
+ * even when a TLB flush is needed because of the update, the caller may be able
+ * to batch these TLB flushing operations, so fewer TLB flush operations are
+ * needed.
+ */
+extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
+				unsigned long address, pmd_t *pmdp);
+#endif
+
 #ifndef __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
 {
--- a/mm/huge_memory.c~mm-avoid-unnecessary-flush-on-change_huge_pmd
+++ a/mm/huge_memory.c
@@ -1801,10 +1801,10 @@ int change_huge_pmd(struct mmu_gather *t
 	 * The race makes MADV_DONTNEED miss the huge pmd and don't clear it
 	 * which may break userspace.
 	 *
-	 * pmdp_invalidate() is required to make sure we don't miss
+	 * pmdp_invalidate_ad() is required to make sure we don't miss
 	 * dirty/young flags set by hardware.
 	 */
-	oldpmd = pmdp_invalidate(vma, addr, pmd);
+	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
 
 	entry = pmd_modify(oldpmd, newprot);
 	if (preserve_write)
--- a/mm/pgtable-generic.c~mm-avoid-unnecessary-flush-on-change_huge_pmd
+++ a/mm/pgtable-generic.c
@@ -201,6 +201,14 @@ pmd_t pmdp_invalidate(struct vm_area_str
 }
 #endif
 
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE_AD
+pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
+			 pmd_t *pmdp)
+{
+	return pmdp_invalidate(vma, address, pmdp);
+}
+#endif
+
 #ifndef pmdp_collapse_flush
 pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
 			  pmd_t *pmdp)
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch
mm-mprotect-use-mmu_gather.patch
mm-mprotect-do-not-flush-when-not-required-architecturally.patch
mm-avoid-unnecessary-flush-on-change_huge_pmd.patch


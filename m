Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D04BC04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbjHKXNe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbjHKXNF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB793C16
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 101D767ADC
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EC7C433C8;
        Fri, 11 Aug 2023 23:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794976;
        bh=V132bKo9qrT5SBvTSTlVZHyRIaJf6Ll9dee08VXuJ6U=;
        h=Date:To:From:Subject:From;
        b=x9zfwciGOK2IIY/PVpEmNKizogtRtW3e043yM2XsSIxR/6xsJ6ThYPZ61QQ+Nd7Lj
         Li7L3xOyU+RDwXvank7OWEWTdhCODkOU/04BuvKa0F2RSU3Vc4PBaoQalhzOS+DowQ
         powMD6qpwc7oDOVP5zOl/ewY4aJ9fTKXorI8j+0Q=
Date:   Fri, 11 Aug 2023 16:02:55 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-config_per_vma_lock-ifdefs.patch removed from -mm tree
Message-Id: <20230811230256.65EC7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove CONFIG_PER_VMA_LOCK ifdefs
has been removed from the -mm tree.  Its filename was
     mm-remove-config_per_vma_lock-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove CONFIG_PER_VMA_LOCK ifdefs
Date: Mon, 24 Jul 2023 19:54:01 +0100

Patch series "Handle most file-backed faults under the VMA lock", v3.

This patchset adds the ability to handle page faults on parts of files
which are already in the page cache without taking the mmap lock.


This patch (of 10):

Provide lock_vma_under_rcu() when CONFIG_PER_VMA_LOCK is not defined to
eliminate ifdefs in the users.

Link: https://lkml.kernel.org/r/20230724185410.1124082-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230724185410.1124082-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c   |    2 --
 arch/powerpc/mm/fault.c |    4 ----
 arch/riscv/mm/fault.c   |    4 ----
 arch/s390/mm/fault.c    |    2 --
 arch/x86/mm/fault.c     |    4 ----
 include/linux/mm.h      |    6 ++++++
 6 files changed, 6 insertions(+), 16 deletions(-)

--- a/arch/arm64/mm/fault.c~mm-remove-config_per_vma_lock-ifdefs
+++ a/arch/arm64/mm/fault.c
@@ -587,7 +587,6 @@ static int __kprobes do_page_fault(unsig
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
-#ifdef CONFIG_PER_VMA_LOCK
 	if (!(mm_flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
@@ -615,7 +614,6 @@ static int __kprobes do_page_fault(unsig
 		return 0;
 	}
 lock_mmap:
-#endif /* CONFIG_PER_VMA_LOCK */
 
 retry:
 	vma = lock_mm_and_find_vma(mm, addr, regs);
--- a/arch/powerpc/mm/fault.c~mm-remove-config_per_vma_lock-ifdefs
+++ a/arch/powerpc/mm/fault.c
@@ -469,7 +469,6 @@ static int ___do_page_fault(struct pt_re
 	if (is_exec)
 		flags |= FAULT_FLAG_INSTRUCTION;
 
-#ifdef CONFIG_PER_VMA_LOCK
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
@@ -501,7 +500,6 @@ static int ___do_page_fault(struct pt_re
 		return user_mode(regs) ? 0 : SIGBUS;
 
 lock_mmap:
-#endif /* CONFIG_PER_VMA_LOCK */
 
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
@@ -551,9 +549,7 @@ retry:
 
 	mmap_read_unlock(current->mm);
 
-#ifdef CONFIG_PER_VMA_LOCK
 done:
-#endif
 	if (unlikely(fault & VM_FAULT_ERROR))
 		return mm_fault_error(regs, address, fault);
 
--- a/arch/riscv/mm/fault.c~mm-remove-config_per_vma_lock-ifdefs
+++ a/arch/riscv/mm/fault.c
@@ -283,7 +283,6 @@ void handle_page_fault(struct pt_regs *r
 		flags |= FAULT_FLAG_WRITE;
 	else if (cause == EXC_INST_PAGE_FAULT)
 		flags |= FAULT_FLAG_INSTRUCTION;
-#ifdef CONFIG_PER_VMA_LOCK
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
@@ -311,7 +310,6 @@ void handle_page_fault(struct pt_regs *r
 		return;
 	}
 lock_mmap:
-#endif /* CONFIG_PER_VMA_LOCK */
 
 retry:
 	vma = lock_mm_and_find_vma(mm, addr, regs);
@@ -368,9 +366,7 @@ retry:
 
 	mmap_read_unlock(mm);
 
-#ifdef CONFIG_PER_VMA_LOCK
 done:
-#endif
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		tsk->thread.bad_cause = cause;
 		mm_fault_error(regs, addr, fault);
--- a/arch/s390/mm/fault.c~mm-remove-config_per_vma_lock-ifdefs
+++ a/arch/s390/mm/fault.c
@@ -407,7 +407,6 @@ static inline vm_fault_t do_exception(st
 		access = VM_WRITE;
 	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
-#ifdef CONFIG_PER_VMA_LOCK
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 	vma = lock_vma_under_rcu(mm, address);
@@ -432,7 +431,6 @@ static inline vm_fault_t do_exception(st
 		goto out;
 	}
 lock_mmap:
-#endif /* CONFIG_PER_VMA_LOCK */
 	mmap_read_lock(mm);
 
 	gmap = NULL;
--- a/arch/x86/mm/fault.c~mm-remove-config_per_vma_lock-ifdefs
+++ a/arch/x86/mm/fault.c
@@ -1328,7 +1328,6 @@ void do_user_addr_fault(struct pt_regs *
 	}
 #endif
 
-#ifdef CONFIG_PER_VMA_LOCK
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
@@ -1358,7 +1357,6 @@ void do_user_addr_fault(struct pt_regs *
 		return;
 	}
 lock_mmap:
-#endif /* CONFIG_PER_VMA_LOCK */
 
 retry:
 	vma = lock_mm_and_find_vma(mm, address, regs);
@@ -1418,9 +1416,7 @@ retry:
 	}
 
 	mmap_read_unlock(mm);
-#ifdef CONFIG_PER_VMA_LOCK
 done:
-#endif
 	if (likely(!(fault & VM_FAULT_ERROR)))
 		return;
 
--- a/include/linux/mm.h~mm-remove-config_per_vma_lock-ifdefs
+++ a/include/linux/mm.h
@@ -742,6 +742,12 @@ static inline void vma_assert_write_lock
 static inline void vma_mark_detached(struct vm_area_struct *vma,
 				     bool detached) {}
 
+static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
+		unsigned long address)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_PER_VMA_LOCK */
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch


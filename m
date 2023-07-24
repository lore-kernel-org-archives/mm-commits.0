Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F938C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjGXTFq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjGXTFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54D10E3
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498F061004
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E8FC433C7;
        Mon, 24 Jul 2023 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225543;
        bh=pLuSXWXJgOWMPIz9k/IzcsTMOM1vHpoDKY+Hw8CFIrk=;
        h=Date:To:From:Subject:From;
        b=nkvGPNkagx5pmWoZvvyBjrvj+dXPwWuhd30hjrD8nJwT+1TJSwc+zS0c37OzaJ9YI
         fwrHvoqauoZfdcuc6u5836OKqbdoeJRzhD/VaOyjV3XGK4IvAxRUaketY//Hs5xiYk
         ANkUJt5XqaUtbQW/uS01jT8lmGArmtR8WyOsJOlA=
Date:   Mon, 24 Jul 2023 12:05:42 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-config_per_vma_lock-ifdefs.patch added to mm-unstable branch
Message-Id: <20230724190543.87E8FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove CONFIG_PER_VMA_LOCK ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-config_per_vma_lock-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-config_per_vma_lock-ifdefs.patch

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
 
@@ -616,7 +615,6 @@ static int __kprobes do_page_fault(unsig
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
 
@@ -502,7 +501,6 @@ static int ___do_page_fault(struct pt_re
 		return user_mode(regs) ? 0 : SIGBUS;
 
 lock_mmap:
-#endif /* CONFIG_PER_VMA_LOCK */
 
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
@@ -552,9 +550,7 @@ retry:
 
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
@@ -431,7 +430,6 @@ static inline vm_fault_t do_exception(st
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
 
@@ -1359,7 +1358,6 @@ void do_user_addr_fault(struct pt_regs *
 		return;
 	}
 lock_mmap:
-#endif /* CONFIG_PER_VMA_LOCK */
 
 retry:
 	vma = lock_mm_and_find_vma(mm, address, regs);
@@ -1419,9 +1417,7 @@ retry:
 	}
 
 	mmap_read_unlock(mm);
-#ifdef CONFIG_PER_VMA_LOCK
 done:
-#endif
 	if (likely(!(fault & VM_FAULT_ERROR)))
 		return;
 
--- a/include/linux/mm.h~mm-remove-config_per_vma_lock-ifdefs
+++ a/include/linux/mm.h
@@ -775,6 +775,12 @@ static inline void assert_fault_locked(s
 	mmap_assert_locked(vmf->vma->vm_mm);
 }
 
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

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch


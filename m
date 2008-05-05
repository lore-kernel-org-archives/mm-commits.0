From: akpm@linux-foundation.org
Subject: + arch-um-kernel-memc-remove-arch_validate.patch added to -mm tree
Date: Mon, 05 May 2008 13:25:02 -0700
Message-ID: <200805052025.m45KP3lS003293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761278AbYEEUZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 16:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org


The patch titled
     arch/um/kernel/mem.c: remove arch_validate()
has been added to the -mm tree.  Its filename is
     arch-um-kernel-memc-remove-arch_validate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/kernel/mem.c: remove arch_validate()
From: WANG Cong <xiyou.wangcong@gmail.com>

- Remove arch_validate(), because no one uses it.

- Remove useless macro HAVE_ARCH_VALIDATE.

- Make the variable 'empty_bad_page' static.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ksyms.c |    1 -
 arch/um/kernel/mem.c   |   33 +--------------------------------
 include/asm-um/page.h  |    3 ---
 3 files changed, 1 insertion(+), 36 deletions(-)

diff -puN arch/um/kernel/ksyms.c~arch-um-kernel-memc-remove-arch_validate arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~arch-um-kernel-memc-remove-arch_validate
+++ a/arch/um/kernel/ksyms.c
@@ -18,7 +18,6 @@ EXPORT_SYMBOL(get_signals);
 EXPORT_SYMBOL(kernel_thread);
 EXPORT_SYMBOL(sys_waitpid);
 EXPORT_SYMBOL(flush_tlb_range);
-EXPORT_SYMBOL(arch_validate);
 
 EXPORT_SYMBOL(high_physmem);
 EXPORT_SYMBOL(empty_zero_page);
diff -puN arch/um/kernel/mem.c~arch-um-kernel-memc-remove-arch_validate arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~arch-um-kernel-memc-remove-arch_validate
+++ a/arch/um/kernel/mem.c
@@ -21,7 +21,7 @@
 /* allocated in paging_init, zeroed in mem_init, and unchanged thereafter */
 unsigned long *empty_zero_page = NULL;
 /* allocated in paging_init and unchanged thereafter */
-unsigned long *empty_bad_page = NULL;
+static unsigned long *empty_bad_page = NULL;
 
 /*
  * Initialized during boot, and readonly for initializing page tables
@@ -240,37 +240,6 @@ void __init paging_init(void)
 #endif
 }
 
-struct page *arch_validate(struct page *page, gfp_t mask, int order)
-{
-	unsigned long addr, zero = 0;
-	int i;
-
- again:
-	if (page == NULL)
-		return page;
-	if (PageHighMem(page))
-		return page;
-
-	addr = (unsigned long) page_address(page);
-	for (i = 0; i < (1 << order); i++) {
-		current->thread.fault_addr = (void *) addr;
-		if (__do_copy_to_user((void __user *) addr, &zero,
-				     sizeof(zero),
-				     &current->thread.fault_addr,
-				     &current->thread.fault_catcher)) {
-			if (!(mask & __GFP_WAIT))
-				return NULL;
-			else break;
-		}
-		addr += PAGE_SIZE;
-	}
-
-	if (i == (1 << order))
-		return page;
-	page = alloc_pages(mask, order);
-	goto again;
-}
-
 /*
  * This can't do anything because nothing in the kernel image can be freed
  * since it's not in kernel physical memory.
diff -puN include/asm-um/page.h~arch-um-kernel-memc-remove-arch_validate include/asm-um/page.h
--- a/include/asm-um/page.h~arch-um-kernel-memc-remove-arch_validate
+++ a/include/asm-um/page.h
@@ -114,9 +114,6 @@ extern unsigned long uml_physmem;
 #define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(v) pfn_valid(phys_to_pfn(__pa(v)))
 
-extern struct page *arch_validate(struct page *page, gfp_t mask, int order);
-#define HAVE_ARCH_VALIDATE

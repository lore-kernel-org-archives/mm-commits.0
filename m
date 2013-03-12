From: akpm@linux-foundation.org
Subject: + mm-ppc-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:48 -0700
Message-ID: <20130312212248.D8E2031C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:54339 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:50 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so38545qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, agust@denx.de, benh@kernel.crashing.org, jiang.liu@huawei.com, paulus@samba.org


The patch titled
     Subject: mm/ppc: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-ppc-use-common-help-functions-to-free-reserved-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/ppc: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/crash_dump.c             |    5 --
 arch/powerpc/kernel/fadump.c                 |    5 --
 arch/powerpc/kernel/kvm.c                    |    7 ----
 arch/powerpc/mm/mem.c                        |   29 +----------------
 arch/powerpc/platforms/512x/mpc512x_shared.c |    5 --
 5 files changed, 6 insertions(+), 45 deletions(-)

diff -puN arch/powerpc/kernel/crash_dump.c~mm-ppc-use-common-help-functions-to-free-reserved-pages arch/powerpc/kernel/crash_dump.c
--- a/arch/powerpc/kernel/crash_dump.c~mm-ppc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/powerpc/kernel/crash_dump.c
@@ -150,10 +150,7 @@ void crash_free_reserved_phys_range(unsi
 		if (addr <= rtas_end && ((addr + PAGE_SIZE) > rtas_start))
 			continue;
 
-		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
-		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
-		free_page((unsigned long)__va(addr));
-		totalram_pages++;
+		free_reserved_page(pfn_to_page(addr >> PAGE_SHIFT));
 	}
 }
 #endif
diff -puN arch/powerpc/kernel/fadump.c~mm-ppc-use-common-help-functions-to-free-reserved-pages arch/powerpc/kernel/fadump.c
--- a/arch/powerpc/kernel/fadump.c~mm-ppc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/powerpc/kernel/fadump.c
@@ -1045,10 +1045,7 @@ static void fadump_release_memory(unsign
 		if (addr <= ra_end && ((addr + PAGE_SIZE) > ra_start))
 			continue;
 
-		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
-		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
-		free_page((unsigned long)__va(addr));
-		totalram_pages++;
+		free_reserved_page(pfn_to_page(addr >> PAGE_SHIFT));
 	}
 }
 
diff -puN arch/powerpc/kernel/kvm.c~mm-ppc-use-common-help-functions-to-free-reserved-pages arch/powerpc/kernel/kvm.c
--- a/arch/powerpc/kernel/kvm.c~mm-ppc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/powerpc/kernel/kvm.c
@@ -756,12 +756,7 @@ static __init void kvm_free_tmp(void)
 	end = (ulong)&kvm_tmp[ARRAY_SIZE(kvm_tmp)] & PAGE_MASK;
 
 	/* Free the tmp space we don't need */
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-	}
+	free_reserved_area(start, end, 0, NULL);
 }
 
 static int __init kvm_guest_init(void)
diff -puN arch/powerpc/mm/mem.c~mm-ppc-use-common-help-functions-to-free-reserved-pages arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-ppc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/powerpc/mm/mem.c
@@ -405,39 +405,14 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	unsigned long addr;
-
 	ppc_md.progress = ppc_printk_progress;
-
-	addr = (unsigned long)__init_begin;
-	for (; addr < (unsigned long)__init_end; addr += PAGE_SIZE) {
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	pr_info("Freeing unused kernel memory: %luk freed\n",
-		((unsigned long)__init_end -
-		(unsigned long)__init_begin) >> 10);
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (start >= end)
-		return;
-
-	start = _ALIGN_DOWN(start, PAGE_SIZE);
-	end = _ALIGN_UP(end, PAGE_SIZE);
-	pr_info("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-	}
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
diff -puN arch/powerpc/platforms/512x/mpc512x_shared.c~mm-ppc-use-common-help-functions-to-free-reserved-pages arch/powerpc/platforms/512x/mpc512x_shared.c
--- a/arch/powerpc/platforms/512x/mpc512x_shared.c~mm-ppc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/powerpc/platforms/512x/mpc512x_shared.c
@@ -172,12 +172,9 @@ static struct fsl_diu_shared_fb __attrib
 
 static inline void mpc512x_free_bootmem(struct page *page)
 {
-	__ClearPageReserved(page);
 	BUG_ON(PageTail(page));
 	BUG_ON(atomic_read(&page->_count) > 1);
-	atomic_set(&page->_count, 1);
-	__free_page(page);
-	totalram_pages++;
+	free_reserved_page(page);
 }
 
 void mpc512x_release_bootmem(void)
_

Patches currently in -mm which might be from liuj97@gmail.com are

mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-alpha-use-common-help-functions-to-free-reserved-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-avr32-use-common-help-functions-to-free-reserved-pages.patch
mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch
mm-c6x-use-common-help-functions-to-free-reserved-pages.patch
mm-cris-use-common-help-functions-to-free-reserved-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-h8300-use-common-help-functions-to-free-reserved-pages.patch
mm-ia64-use-common-help-functions-to-free-reserved-pages.patch
mm-m32r-use-common-help-functions-to-free-reserved-pages.patch
mm-m68k-use-common-help-functions-to-free-reserved-pages.patch
mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch
mm-mips-use-common-help-functions-to-free-reserved-pages.patch
mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch
mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch
mm-parisc-use-common-help-functions-to-free-reserved-pages.patch
mm-ppc-use-common-help-functions-to-free-reserved-pages.patch
mm-s390-use-common-help-functions-to-free-reserved-pages.patch
mm-score-use-common-help-functions-to-free-reserved-pages.patch
mm-sh-use-common-help-functions-to-free-reserved-pages.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch
mm-um-use-common-help-functions-to-free-reserved-pages.patch
mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch
mm-x86-use-common-help-functions-to-free-reserved-pages.patch
mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mmkexec-use-common-help-functions-to-free-reserved-pages.patch


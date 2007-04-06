From: akpm@linux-foundation.org
Subject: - agp-adjustments.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:08:58 -0700
Message-ID: <200704062008.l36K8wGr017886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32811 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798AbXDFUJE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     agp adjustments
has been removed from the -mm tree.  Its filename was
     agp-adjustments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: agp adjustments
From: "Jan Beulich" <jbeulich@novell.com>

In generic code, remove an arch-dependent hunk in favor of #define-ing the
respective bits in asm-<arch>/agp.h (allowing easier overriding in
para-virtualized environments).

In intel-agp, fix a call to __free_page where __free_pages(, 2) was meant,
and do proper error path handling.  Also remove a redundant conditional.

In ali-agp, add missing calls to global_flush_tlb().

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/ali-agp.c   |    2 ++
 drivers/char/agp/generic.c   |   22 ----------------------
 drivers/char/agp/intel-agp.c |    8 +++-----
 include/asm-i386/agp.h       |    6 ++++--
 include/asm-x86_64/agp.h     |    6 ++++--
 5 files changed, 13 insertions(+), 31 deletions(-)

diff -puN drivers/char/agp/ali-agp.c~agp-adjustments drivers/char/agp/ali-agp.c
--- a/drivers/char/agp/ali-agp.c~agp-adjustments
+++ a/drivers/char/agp/ali-agp.c
@@ -145,6 +145,7 @@ static void *m1541_alloc_page(struct agp
 	void *addr = agp_generic_alloc_page(agp_bridge);
 	u32 temp;
 
+	global_flush_tlb();
 	if (!addr)
 		return NULL;
 
@@ -160,6 +161,7 @@ static void ali_destroy_page(void * addr
 	if (addr) {
 		global_cache_flush();	/* is this really needed?  --hch */
 		agp_generic_destroy_page(addr);
+		global_flush_tlb();
 	}
 }
 
diff -puN drivers/char/agp/generic.c~agp-adjustments drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~agp-adjustments
+++ a/drivers/char/agp/generic.c
@@ -51,28 +51,6 @@ int agp_memory_reserved;
  */
 EXPORT_SYMBOL_GPL(agp_memory_reserved);
 
-#if defined(CONFIG_X86)
-int map_page_into_agp(struct page *page)
-{
-	int i;
-	i = change_page_attr(page, 1, PAGE_KERNEL_NOCACHE);
-	/* Caller's responsibility to call global_flush_tlb() for
-	 * performance reasons */
-	return i;
-}
-EXPORT_SYMBOL_GPL(map_page_into_agp);
-
-int unmap_page_from_agp(struct page *page)
-{
-	int i;
-	i = change_page_attr(page, 1, PAGE_KERNEL);
-	/* Caller's responsibility to call global_flush_tlb() for
-	 * performance reasons */
-	return i;
-}
-EXPORT_SYMBOL_GPL(unmap_page_from_agp);
-#endif
-
 /*
  * Generic routines for handling agp_memory structures -
  * They use the basic page allocation routines to do the brunt of the work.
diff -puN drivers/char/agp/intel-agp.c~agp-adjustments drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~agp-adjustments
+++ a/drivers/char/agp/intel-agp.c
@@ -183,8 +183,9 @@ static void *i8xx_alloc_pages(void)
 		return NULL;
 
 	if (change_page_attr(page, 4, PAGE_KERNEL_NOCACHE) < 0) {
+		change_page_attr(page, 4, PAGE_KERNEL);
 		global_flush_tlb();
-		__free_page(page);
+		__free_pages(page, 2);
 		return NULL;
 	}
 	global_flush_tlb();
@@ -206,7 +207,7 @@ static void i8xx_destroy_pages(void *add
 	global_flush_tlb();
 	put_page(page);
 	unlock_page(page);
-	free_pages((unsigned long)addr, 2);
+	__free_pages(page, 2);
 	atomic_dec(&agp_bridge->current_memory_agp);
 }
 
@@ -312,9 +313,6 @@ static struct agp_memory *alloc_agpphysm
 	struct agp_memory *new;
 	void *addr;
 
-	if (pg_count != 1 && pg_count != 4)
-		return NULL;
-
 	switch (pg_count) {
 	case 1: addr = agp_bridge->driver->agp_alloc_page(agp_bridge);
 		global_flush_tlb();
diff -puN include/asm-i386/agp.h~agp-adjustments include/asm-i386/agp.h
--- a/include/asm-i386/agp.h~agp-adjustments
+++ a/include/asm-i386/agp.h
@@ -12,8 +12,10 @@
  * data corruption on some CPUs.
  */
 
-int map_page_into_agp(struct page *page);
-int unmap_page_from_agp(struct page *page);
+/* Caller's responsibility to call global_flush_tlb() for
+ * performance reasons */
+#define map_page_into_agp(page) change_page_attr(page, 1, PAGE_KERNEL_NOCACHE)
+#define unmap_page_from_agp(page) change_page_attr(page, 1, PAGE_KERNEL)
 #define flush_agp_mappings() global_flush_tlb()
 
 /* Could use CLFLUSH here if the cpu supports it. But then it would
diff -puN include/asm-x86_64/agp.h~agp-adjustments include/asm-x86_64/agp.h
--- a/include/asm-x86_64/agp.h~agp-adjustments
+++ a/include/asm-x86_64/agp.h
@@ -10,8 +10,10 @@
  * with different cachability attributes for the same page.
  */
 
-int map_page_into_agp(struct page *page);
-int unmap_page_from_agp(struct page *page);
+/* Caller's responsibility to call global_flush_tlb() for
+ * performance reasons */
+#define map_page_into_agp(page) change_page_attr(page, 1, PAGE_KERNEL_NOCACHE)
+#define unmap_page_from_agp(page) change_page_attr(page, 1, PAGE_KERNEL)
 #define flush_agp_mappings() global_flush_tlb()
 
 /* Could use CLFLUSH here if the cpu supports it. But then it would
_

Patches currently in -mm which might be from jbeulich@novell.com are

git-agpgart.patch
remove-pci_dac_dma_-apis.patch
use-stop_machine_run-in-the-intel-rng-driver.patch

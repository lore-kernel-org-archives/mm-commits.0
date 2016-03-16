From: akpm@linux-foundation.org
Subject: [merged] x86-query-dynamic-debug_pagealloc-setting.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:57:04 -0700
Message-ID: <56e9ba90.u+wb6/uRhP0f7bZE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPT5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     x86-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: x86: query dynamic DEBUG_PAGEALLOC setting

We can use debug_pagealloc_enabled() to check if we can map the identity
mapping with 2MB pages.  We can also add the state into the dump_stack
output.

The patch does not touch the code for the 1GB pages, which ignored
CONFIG_DEBUG_PAGEALLOC.  Do we need to fence this as well?

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/dumpstack.c |    5 ++---
 arch/x86/mm/init.c          |    7 ++++---
 arch/x86/mm/pageattr.c      |   14 ++++----------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff -puN arch/x86/kernel/dumpstack.c~x86-query-dynamic-debug_pagealloc-setting arch/x86/kernel/dumpstack.c
--- a/arch/x86/kernel/dumpstack.c~x86-query-dynamic-debug_pagealloc-setting
+++ a/arch/x86/kernel/dumpstack.c
@@ -265,9 +265,8 @@ int __die(const char *str, struct pt_reg
 #ifdef CONFIG_SMP
 	printk("SMP ");
 #endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC ");
-#endif
+	if (debug_pagealloc_enabled())
+		printk("DEBUG_PAGEALLOC ");
 #ifdef CONFIG_KASAN
 	printk("KASAN");
 #endif
diff -puN arch/x86/mm/init.c~x86-query-dynamic-debug_pagealloc-setting arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-query-dynamic-debug_pagealloc-setting
+++ a/arch/x86/mm/init.c
@@ -150,13 +150,14 @@ static int page_size_mask;
 
 static void __init probe_page_size_mask(void)
 {
-#if !defined(CONFIG_DEBUG_PAGEALLOC) && !defined(CONFIG_KMEMCHECK)
+#if !defined(CONFIG_KMEMCHECK)
 	/*
-	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * For CONFIG_KMEMCHECK or pagealloc debugging, identity mapping will
+	 * use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
 	 * large pages into small in interrupt context, etc.
 	 */
-	if (cpu_has_pse)
+	if (cpu_has_pse && !debug_pagealloc_enabled())
 		page_size_mask |= 1 << PG_LEVEL_2M;
 #endif
 
diff -puN arch/x86/mm/pageattr.c~x86-query-dynamic-debug_pagealloc-setting arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~x86-query-dynamic-debug_pagealloc-setting
+++ a/arch/x86/mm/pageattr.c
@@ -106,12 +106,6 @@ static inline unsigned long highmap_end_
 
 #endif
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-# define debug_pagealloc 1
-#else
-# define debug_pagealloc 0
-#endif
-
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -714,10 +708,10 @@ static int split_large_page(struct cpa_d
 {
 	struct page *base;
 
-	if (!debug_pagealloc)
+	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
 	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
-	if (!debug_pagealloc)
+	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
 	if (!base)
 		return -ENOMEM;
@@ -1337,10 +1331,10 @@ static int __change_page_attr_set_clr(st
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		if (!debug_pagealloc)
+		if (!debug_pagealloc_enabled())
 			spin_lock(&cpa_lock);
 		ret = __change_page_attr(cpa, checkalias);
-		if (!debug_pagealloc)
+		if (!debug_pagealloc_enabled())
 			spin_unlock(&cpa_lock);
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are



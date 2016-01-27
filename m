From: akpm@linux-foundation.org
Subject: + x86-query-dynamic-debug_pagealloc-setting.patch added to -mm
 tree
Date: Wed, 27 Jan 2016 11:52:22 -0800
Message-ID: <56a91ff6.Pt1pVMq3VRZox/r6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935199AbcA0TwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: query dynamic DEBUG_PAGEALLOC setting
has been added to the -mm tree.  Its filename is
     x86-query-dynamic-debug_pagealloc-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-query-dynamic-debug_pagealloc-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-query-dynamic-debug_pagealloc-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -708,10 +702,10 @@ static int split_large_page(struct cpa_d
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
@@ -1331,10 +1325,10 @@ static int __change_page_attr_set_clr(st
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

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch
mm-provide-debug_pagealloc_enabled-without-config_debug_pagealloc.patch
x86-query-dynamic-debug_pagealloc-setting.patch
s390-query-dynamic-debug_pagealloc-setting.patch


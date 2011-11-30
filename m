From: akpm@linux-foundation.org
Subject: + mmx86-remove-debug_pagealloc_enabled.patch added to -mm tree
Date: Wed, 30 Nov 2011 15:09:23 -0800
Message-ID: <201111302309.pAUN9Nn5003888@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:54523 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1K3XJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 18:09:28 -0500
Received: by faaq16 with SMTP id q16so42991faa.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 15:09:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, hpa@zytor.com, mgorman@suse.de, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm,x86: remove debug_pagealloc_enabled
has been added to the -mm tree.  Its filename is
     mmx86-remove-debug_pagealloc_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: mm,x86: remove debug_pagealloc_enabled

When (no)bootmem finishes its operation, it passes pages to the buddy
allocator.  Since debug_pagealloc_enabled is not set, we will not protect
these pages, which is not what we want with CONFIG_DEBUG_PAGEALLOC=y.

To fix this, remove debug_pagealloc_enabled.  That variable was introduced
by commit 12d6f21e ("x86: do not PSE on CONFIG_DEBUG_PAGEALLOC=y") to get
more CPA (change page attribude) code testing.  But currently we have
CONFIG_CPA_DEBUG, which tests CPA.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr.c |    6 ------
 include/linux/mm.h     |   10 ----------
 init/main.c            |    5 -----
 mm/debug-pagealloc.c   |    3 ---
 4 files changed, 24 deletions(-)

diff -puN arch/x86/mm/pageattr.c~mmx86-remove-debug_pagealloc_enabled arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~mmx86-remove-debug_pagealloc_enabled
+++ a/arch/x86/mm/pageattr.c
@@ -1334,12 +1334,6 @@ void kernel_map_pages(struct page *page,
 	}
 
 	/*
-	 * If page allocator is not up yet then do not call c_p_a():
-	 */
-	if (!debug_pagealloc_enabled)
-		return;
-
-	/*
 	 * The return value is ignored as the calls cannot fail.
 	 * Large pages for identity mappings are not used at boot time
 	 * and hence no memory allocations during large page split.
diff -puN include/linux/mm.h~mmx86-remove-debug_pagealloc_enabled include/linux/mm.h
--- a/include/linux/mm.h~mmx86-remove-debug_pagealloc_enabled
+++ a/include/linux/mm.h
@@ -1538,23 +1538,13 @@ static inline void vm_stat_account(struc
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern int debug_pagealloc_enabled;
-
 extern void kernel_map_pages(struct page *page, int numpages, int enable);
-
-static inline void enable_debug_pagealloc(void)
-{
-	debug_pagealloc_enabled = 1;
-}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
 #else
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
-static inline void enable_debug_pagealloc(void)
-{
-}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif /* CONFIG_HIBERNATION */
diff -puN init/main.c~mmx86-remove-debug_pagealloc_enabled init/main.c
--- a/init/main.c~mmx86-remove-debug_pagealloc_enabled
+++ a/init/main.c
@@ -282,10 +282,6 @@ static int __init unknown_bootoption(cha
 	return 0;
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-int __read_mostly debug_pagealloc_enabled = 0;
-#endif
-
 static int __init init_setup(char *str)
 {
 	unsigned int i;
@@ -597,7 +593,6 @@ asmlinkage void __init start_kernel(void
 	}
 #endif
 	page_cgroup_init();
-	enable_debug_pagealloc();
 	debug_objects_mem_init();
 	kmemleak_init();
 	setup_per_cpu_pageset();
diff -puN mm/debug-pagealloc.c~mmx86-remove-debug_pagealloc_enabled mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mmx86-remove-debug_pagealloc_enabled
+++ a/mm/debug-pagealloc.c
@@ -95,9 +95,6 @@ static void unpoison_pages(struct page *
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!debug_pagealloc_enabled)
-		return;

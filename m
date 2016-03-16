From: akpm@linux-foundation.org
Subject: [merged]
 x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:08 -0700
Message-ID: <56e9ba94.8FrAbqotPM9/FoaB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499AbcCPT5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: also use debug_pagealloc_enabled() for free_init_pages
has been removed from the -mm tree.  Its filename was
     x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: x86: also use debug_pagealloc_enabled() for free_init_pages

we want to couple all debugging features with debug_pagealloc_enabled()
and not with the config option CONFIG_DEBUG_PAGEALLOC.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN arch/x86/mm/init.c~x86-also-use-debug_pagealloc_enabled-for-free_init_pages arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-also-use-debug_pagealloc_enabled-for-free_init_pages
+++ a/arch/x86/mm/init.c
@@ -667,21 +667,22 @@ void free_init_pages(char *what, unsigne
 	 * mark them not present - any buggy init-section access will
 	 * create a kernel page fault:
 	 */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk(KERN_INFO "debug: unmapping init [mem %#010lx-%#010lx]\n",
-		begin, end - 1);
-	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
-#else
-	/*
-	 * We just marked the kernel text read only above, now that
-	 * we are going to free part of that, we need to make that
-	 * writeable and non-executable first.
-	 */
-	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
-	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+	if (debug_pagealloc_enabled()) {
+		pr_info("debug: unmapping init [mem %#010lx-%#010lx]\n",
+			begin, end - 1);
+		set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
+	} else {
+		/*
+		 * We just marked the kernel text read only above, now that
+		 * we are going to free part of that, we need to make that
+		 * writeable and non-executable first.
+		 */
+		set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
+		set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
 
-	free_reserved_area((void *)begin, (void *)end, POISON_FREE_INITMEM, what);
-#endif
+		free_reserved_area((void *)begin, (void *)end,
+				   POISON_FREE_INITMEM, what);
+	}
 }
 
 void free_initmem(void)
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are



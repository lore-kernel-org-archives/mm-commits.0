From: akpm@linux-foundation.org
Subject: + x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch
 added to -mm tree
Date: Wed, 03 Feb 2016 15:09:34 -0800
Message-ID: <56b288ae.Gk5P5ZVap9gBi/7S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbcBCXJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 18:09:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, js1304@gmail.com, labbott@fedoraproject.org, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: also use debug_pagealloc_enabled() for free_init_pages
has been added to the -mm tree.  Its filename is
     x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch

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
Subject: x86: also use debug_pagealloc_enabled() for free_init_pages

we want to couple all debugging features with debug_pagealloc_enabled()
and not with the config option CONFIG_DEBUG_PAGEALLOC.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Suggested-by: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Joonsoo Kim <js1304@gmail.com>
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

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch
x86-query-dynamic-debug_pagealloc-setting.patch
s390-query-dynamic-debug_pagealloc-setting.patch
x86-also-use-debug_pagealloc_enabled-for-free_init_pages.patch


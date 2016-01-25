From: akpm@linux-foundation.org
Subject: +
 mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
 added to -mm tree
Date: Mon, 25 Jan 2016 13:50:30 -0800
Message-ID: <56a698a6.gqYiMEV9Sj+O3FNh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbcAYVub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 16:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, 569F5E29.3090107@de.ibm.com, 56A20F30.4050705@de.ibm.com, heiko.carstens@de.ibm.com, iamjoonsoo.kim@lge.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_pagealloc: Ask users for default setting of debug_pagealloc
has been added to the -mm tree.  Its filename is
     mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch

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
Subject: mm/debug_pagealloc: Ask users for default setting of debug_pagealloc

since commit 031bc5743f158 ("mm/debug-pagealloc: make debug-pagealloc
boottime configurable") CONFIG_DEBUG_PAGEALLOC is by default not adding
any page debugging.

This resulted in several unnoticed bugs, e.g.

https://lkml.kernel.org/g/<569F5E29.3090107@de.ibm.com>
or
https://lkml.kernel.org/g/<56A20F30.4050705@de.ibm.com>

as this behaviour change was not even documented in Kconfig.

Let's provide a new Kconfig symbol that allows to change the default back
to enabled, e.g.  for debug kernels.  This also makes the change obvious
to kernel packagers.

Let's also change the Kconfig description for CONFIG_DEBUG_PAGEALLOC,
to indicate that there are two stages of overhead.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   20 ++++++++++++++++++--
 mm/page_alloc.c  |    6 +++++-
 2 files changed, 23 insertions(+), 3 deletions(-)

diff -puN mm/Kconfig.debug~mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc
+++ a/mm/Kconfig.debug
@@ -16,8 +16,8 @@ config DEBUG_PAGEALLOC
 	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	---help---
 	  Unmap pages from the kernel linear mapping after free_pages().
-	  This results in a large slowdown, but helps to find certain types
-	  of memory corruption.
+	  Depending on runtime enablement, this results in a small or large
+	  slowdown, but helps to find certain types of memory corruption.
 
 	  For architectures which don't enable ARCH_SUPPORTS_DEBUG_PAGEALLOC,
 	  fill the pages with poison patterns after free_pages() and verify
@@ -26,5 +26,21 @@ config DEBUG_PAGEALLOC
 	  that would result in incorrect warnings of memory corruption after
 	  a resume because free pages are not saved to the suspend image.
 
+	  By default this option will have a small overhead, e.g. by not
+	  allowing the kernel mapping to be backed by large pages on some
+	  architectures. Even bigger overhead comes when the debugging is
+	  enabled by DEBUG_PAGEALLOC_ENABLE_DEFAULT or the debug_pagealloc
+	  command line parameter.
+
+config DEBUG_PAGEALLOC_ENABLE_DEFAULT
+	bool "Enable debug page memory allocations by default?"
+        default off
+        depends on DEBUG_PAGEALLOC
+        ---help---
+	  Enable debug page memory allocations by default? This value
+	  can be overridden by debug_pagealloc=off|on.
+
+	  If unsure say no.
+
 config PAGE_POISONING
 	bool
diff -puN mm/page_alloc.c~mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc
+++ a/mm/page_alloc.c
@@ -478,7 +478,8 @@ void prep_compound_page(struct page *pag
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
-bool _debug_pagealloc_enabled __read_mostly;
+bool _debug_pagealloc_enabled __read_mostly
+			= IS_ENABLED(CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT);
 bool _debug_guardpage_enabled __read_mostly;
 
 static int __init early_debug_pagealloc(char *buf)
@@ -489,6 +490,9 @@ static int __init early_debug_pagealloc(
 	if (strcmp(buf, "on") == 0)
 		_debug_pagealloc_enabled = true;
 
+	if (strcmp(buf, "off") == 0)
+		_debug_pagealloc_enabled = false;
+
 	return 0;
 }
 early_param("debug_pagealloc", early_debug_pagealloc);
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch


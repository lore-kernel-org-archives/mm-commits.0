From: akpm@linux-foundation.org
Subject: + generic-debug-pagealloc-cannot-depend-on-hibernation.patch added to -mm tree
Date: Tue, 10 Mar 2009 15:27:47 -0700
Message-ID: <200903102227.n2AMRl9F012569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbZCJW2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 18:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     debug-pagealloc: cannot depend on hibernation
has been added to the -mm tree.  Its filename is
     generic-debug-pagealloc-cannot-depend-on-hibernation.patch

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
Subject: debug-pagealloc: cannot depend on hibernation
From: Akinobu Mita <akinobu.mita@gmail.com>

The generic debug-pagealloc generates wrong messages for the page
corruption after hibernation.  Because the free pages are not saved to the
suspend image.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/Kconfig.debug~generic-debug-pagealloc-cannot-depend-on-hibernation mm/Kconfig.debug
--- a/mm/Kconfig.debug~generic-debug-pagealloc-cannot-depend-on-hibernation
+++ a/mm/Kconfig.debug
@@ -4,9 +4,14 @@ config WANT_PAGE_DEBUG_FLAGS
 config PAGE_POISONING
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on !HIBERNATION
 	select DEBUG_PAGEALLOC
 	select WANT_PAGE_DEBUG_FLAGS
 	help
 	   Fill the pages with poison patterns after free_pages() and verify
 	   the patterns before alloc_pages(). This results in a large slowdown,
 	   but helps to find certain types of memory corruptions.
+
+	   This option cannot enalbe with hibernation. Otherwise, it will get
+	   wrong messages for memory corruption because the free pages are not
+	   saved to the suspend image.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

generic-debug-pagealloc-v4.patch
generic-debug-pagealloc-depend-on-config_debug_kernel.patch
generic-debug-pagealloc-cannot-depend-on-hibernation.patch
loop-add-ioctl-to-resize-a-loop-device.patch


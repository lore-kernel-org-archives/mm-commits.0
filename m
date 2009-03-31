From: akpm@linux-foundation.org
Subject: [folded] generic-debug-pagealloc-cannot-depend-on-hibernation.patch removed from -mm tree
Date: Tue, 31 Mar 2009 14:57:10 -0700
Message-ID: <200903312157.n2VLvA8d014725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760460AbZCaV66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 17:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     debug-pagealloc: cannot depend on hibernation
has been removed from the -mm tree.  Its filename was
     generic-debug-pagealloc-cannot-depend-on-hibernation.patch

This patch was dropped because it was folded into generic-debug-pagealloc-v4.patch

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

origin.patch
generic-debug-pagealloc-v4.patch
generic-debug-pagealloc-cannot-depend-on-hibernation.patch
introduce-debug_kmap_atomic.patch
use-debug_kmap_atomic.patch
loop-add-ioctl-to-resize-a-loop-device.patch


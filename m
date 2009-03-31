From: akpm@linux-foundation.org
Subject: [folded] generic-debug-pagealloc-depend-on-config_debug_kernel.patch removed from -mm tree
Date: Tue, 31 Mar 2009 14:57:06 -0700
Message-ID: <200903312157.n2VLv65Z014722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437AbZCaV62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 17:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     debug-pagealloc: depend on CONFIG_DEBUG_KERNEL
has been removed from the -mm tree.  Its filename was
     generic-debug-pagealloc-depend-on-config_debug_kernel.patch

This patch was dropped because it was folded into generic-debug-pagealloc-v4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: debug-pagealloc: depend on CONFIG_DEBUG_KERNEL
From: Akinobu Mita <akinobu.mita@gmail.com>

The generic debug-pagealloc should depend on CONFIG_DEBUG_KERNEL as well
as the architecture specific one.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig.debug~generic-debug-pagealloc-depend-on-config_debug_kernel mm/Kconfig.debug
--- a/mm/Kconfig.debug~generic-debug-pagealloc-depend-on-config_debug_kernel
+++ a/mm/Kconfig.debug
@@ -3,7 +3,7 @@ config WANT_PAGE_DEBUG_FLAGS
 
 config PAGE_POISONING
 	bool "Debug page memory allocations"
-	depends on !ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select DEBUG_PAGEALLOC
 	select WANT_PAGE_DEBUG_FLAGS
 	help
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
generic-debug-pagealloc-v4.patch
generic-debug-pagealloc-depend-on-config_debug_kernel.patch
generic-debug-pagealloc-cannot-depend-on-hibernation.patch
introduce-debug_kmap_atomic.patch
use-debug_kmap_atomic.patch
loop-add-ioctl-to-resize-a-loop-device.patch


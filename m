From: akpm@linux-foundation.org
Subject: + generic-debug-pagealloc-depend-on-config_debug_kernel.patch added to -mm tree
Date: Tue, 10 Mar 2009 15:27:45 -0700
Message-ID: <200903102227.n2AMRkQd012566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbZCJW2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 18:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     debug-pagealloc: depend on CONFIG_DEBUG_KERNEL
has been added to the -mm tree.  Its filename is
     generic-debug-pagealloc-depend-on-config_debug_kernel.patch

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

generic-debug-pagealloc-v4.patch
generic-debug-pagealloc-depend-on-config_debug_kernel.patch
generic-debug-pagealloc-cannot-depend-on-hibernation.patch
loop-add-ioctl-to-resize-a-loop-device.patch


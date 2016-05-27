From: akpm@linux-foundation.org
Subject: [patch 19/19] mm: disable DEFERRED_STRUCT_PAGE_INIT on
 !NO_BOOTMEM
Date: Fri, 27 May 2016 14:27:49 -0700
Message-ID: <5748bbd5.d75NeCAH8c9RXYBp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbcE0V1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gwshan@linux.vnet.ibm.com, mgorman@suse.de

From: Gavin Shan <gwshan@linux.vnet.ibm.com>
Subject: mm: disable DEFERRED_STRUCT_PAGE_INIT on !NO_BOOTMEM

When we have !NO_BOOTMEM, the deferred page struct initialization doesn't
work well because the pages reserved in bootmem are released to the page
allocator uncoditionally.  It causes memory corruption and system crash
eventually.

As Mel suggested, the bootmem is retiring slowly.  We fix the issue by
simply hiding DEFERRED_STRUCT_PAGE_INIT when bootmem is enabled.

Link: http://lkml.kernel.org/r/1460602170-5821-1-git-send-email-gwshan@linux.vnet.ibm.com
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-disable-deferred_struct_page_init-on-no_bootmem mm/Kconfig
--- a/mm/Kconfig~mm-disable-deferred_struct_page_init-on-no_bootmem
+++ a/mm/Kconfig
@@ -648,7 +648,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 	bool "Defer initialisation of struct pages to kthreads"
 	default n
 	depends on ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
-	depends on MEMORY_HOTPLUG
+	depends on NO_BOOTMEM && MEMORY_HOTPLUG
 	depends on !FLATMEM
 	help
 	  Ordinarily all struct pages are initialised during early boot in a
_

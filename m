From: akpm@linux-foundation.org
Subject: + linux-typesh-always-use-unsigned-long-for-pgoff_t.patch added
 to -mm tree
Date: Mon, 12 Jan 2015 12:42:52 -0800
Message-ID: <54b431cc.+CIo9/mn2KjN+BdH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbALUmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 15:42:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, arnd@arndb.de, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/types.h: Always use unsigned long for pgoff_t
has been added to the -mm tree.  Its filename is
     linux-typesh-always-use-unsigned-long-for-pgoff_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-typesh-always-use-unsigned-long-for-pgoff_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-typesh-always-use-unsigned-long-for-pgoff_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux/types.h: Always use unsigned long for pgoff_t

Everybody uses unsigned long for pgoff_t, and no ever overrode the
definition of pgoff_t.  Keep it that way, and remove the option of
overriding it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/types.h~linux-typesh-always-use-unsigned-long-for-pgoff_t include/linux/types.h
--- a/include/linux/types.h~linux-typesh-always-use-unsigned-long-for-pgoff_t
+++ a/include/linux/types.h
@@ -135,12 +135,9 @@ typedef unsigned long blkcnt_t;
 #endif
 
 /*
- * The type of an index into the pagecache.  Use a #define so asm/types.h
- * can override it.
+ * The type of an index into the pagecache.
  */
-#ifndef pgoff_t
 #define pgoff_t unsigned long
-#endif
 
 /* A dma_addr_t can hold any valid DMA or bus address for the platform */
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-drop-_page_file-and-pte_file-related-helpers.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
linux-typesh-always-use-unsigned-long-for-pgoff_t.patch
fs-affs-fix-casting-in-printed-messages.patch
linux-next.patch


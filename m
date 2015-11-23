From: akpm@linux-foundation.org
Subject: + dma-mapping-use-offset_in_page-macro.patch added to -mm tree
Date: Mon, 23 Nov 2015 14:30:33 -0800
Message-ID: <56539389.TK5ari5EqFsZmFVV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbbKWWae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 17:30:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: use offset_in_page macro
has been added to the -mm tree.  Its filename is
     dma-mapping-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: dma-mapping: use offset_in_page macro

Use offset_in_page macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-use-offset_in_page-macro include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-use-offset_in_page-macro
+++ a/include/linux/dma-mapping.h
@@ -131,10 +131,10 @@ static inline dma_addr_t dma_map_single_
 	kmemcheck_mark_initialized(ptr, size);
 	BUG_ON(!valid_dma_direction(dir));
 	addr = ops->map_page(dev, virt_to_page(ptr),
-			     (unsigned long)ptr & ~PAGE_MASK, size,
+			     offset_in_page(ptr), size,
 			     dir, attrs);
 	debug_dma_map_page(dev, virt_to_page(ptr),
-			   (unsigned long)ptr & ~PAGE_MASK, size,
+			   offset_in_page(ptr), size,
 			   dir, addr, true);
 	return addr;
 }
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
dma-mapping-use-offset_in_page-macro.patch


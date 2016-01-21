From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-use-offset_in_page-macro.patch removed from
 -mm tree
Date: Thu, 21 Jan 2016 15:29:19 -0800
Message-ID: <56a169cf.np+eeI7uimeE5RPe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcAUX3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, borntraeger@de.ibm.com, jroedel@suse.de, sebott@linux.vnet.ibm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: use offset_in_page macro
has been removed from the -mm tree.  Its filename was
     dma-mapping-use-offset_in_page-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: dma-mapping: use offset_in_page macro

Use offset_in_page macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-use-offset_in_page-macro include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-use-offset_in_page-macro
+++ a/include/linux/dma-mapping.h
@@ -129,10 +129,10 @@ static inline dma_addr_t dma_map_single_
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



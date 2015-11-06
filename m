From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-make-memblock_remove_range-static.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:58 -0800
Message-ID: <563d089e.Dv5kOiVKxp8yl2+D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033520AbbKFUH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: make memblock_remove_range() static
has been removed from the -mm tree.  Its filename was
     mm-memblock-make-memblock_remove_range-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock: make memblock_remove_range() static

memblock_remove_range() is only used in the mm/memblock.c, so we can make
it static.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ----
 mm/memblock.c            |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-make-memblock_remove_range-static include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-make-memblock_remove_range-static
+++ a/include/linux/memblock.h
@@ -89,10 +89,6 @@ int memblock_add_range(struct memblock_t
 		       phys_addr_t base, phys_addr_t size,
 		       int nid, unsigned long flags);
 
-int memblock_remove_range(struct memblock_type *type,
-			  phys_addr_t base,
-			  phys_addr_t size);

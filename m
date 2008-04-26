From: akpm@linux-foundation.org
Subject: - block-fix-memory-hotplug-and-bouncing-in-block-layer.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:28 -0700
Message-ID: <200804261642.m3QGgS9Q031202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757888AbYDZQmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@suse.de, jens.axboe@oracle.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     block: fix memory hotplug and bouncing in block layer
has been removed from the -mm tree.  Its filename was
     block-fix-memory-hotplug-and-bouncing-in-block-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix memory hotplug and bouncing in block layer
From: Andi Kleen <andi@firstfloor.org>

Only noticed this while hacking something else, no test case.

blk_max_low_pfn is initialized once at bootup by the block layer from
max_low_pfn.  But max_low_pfn is not necessarily constant over the runtime of
the system when you consider memory hotplug.  What could happen if that
someone adds memory later the block layer wouldn't get updated and then start
bouncing memory unnecessarily.

Also on 64bit blk_max_low_pfn actually isn't needed because it just disables
bouncing essentially and there is no highmem.  And nobody can pass pfns >
max_low_pfn to the block layer, because those wouldn't have a struct page and
I suspect block layer wouldn't be very happy without that.

So set BLK_BOUNCE_HIGH to infinity (-1ULL) on 64bit.  That avoids the problem
of having to update it on memory hotadd.

On 32bit I kept the same behaviour because at least on i386
memory hotadd only adds HIGHMEM, never lowmem.

BLK_BOUNCE_ANY is always set to infinity on both 32 and 64bit.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/blkdev.h~block-fix-memory-hotplug-and-bouncing-in-block-layer include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-fix-memory-hotplug-and-bouncing-in-block-layer
+++ a/include/linux/blkdev.h
@@ -535,8 +535,13 @@ extern unsigned long blk_max_low_pfn, bl
  * BLK_BOUNCE_ANY	: don't bounce anything
  * BLK_BOUNCE_ISA	: bounce pages above ISA DMA boundary
  */
+
+#if BITS_PER_LONG == 32
 #define BLK_BOUNCE_HIGH		((u64)blk_max_low_pfn << PAGE_SHIFT)
-#define BLK_BOUNCE_ANY		((u64)blk_max_pfn << PAGE_SHIFT)
+#else
+#define BLK_BOUNCE_HIGH		-1ULL
+#endif
+#define BLK_BOUNCE_ANY		(-1ULL)
 #define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)
 
 /*
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch


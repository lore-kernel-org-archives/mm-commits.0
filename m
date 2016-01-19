From: akpm@linux-foundation.org
Subject: [merged]
 dax-increase-granularity-of-dax_clear_blocks-operations.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:13:07 -0800
Message-ID: <569e98d3.blAK1Ng7ZEx5kMHc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbcASUNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.com, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: increase granularity of dax_clear_blocks() operations
has been removed from the -mm tree.  Its filename was
     dax-increase-granularity-of-dax_clear_blocks-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: increase granularity of dax_clear_blocks() operations

dax_clear_blocks is currently performing a cond_resched() after every
PAGE_SIZE memset.  We need not check so frequently, for example md-raid
only calls cond_resched() at stripe granularity.  Also, in preparation for
introducing a dax_map_atomic() operation that temporarily pins a dax
mapping move the call to cond_resched() to the outer loop.

The worst case latency between calls to cond_resched() after this change
is 500us the average latency is 133us.  This is up from a 10us max and 4us
average.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN fs/dax.c~dax-increase-granularity-of-dax_clear_blocks-operations fs/dax.c
--- a/fs/dax.c~dax-increase-granularity-of-dax_clear_blocks-operations
+++ a/fs/dax.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/vmstat.h>
+#include <linux/sizes.h>
 
 /*
  * dax_clear_blocks() is called from within transaction context from XFS,
@@ -43,24 +44,17 @@ int dax_clear_blocks(struct inode *inode
 	do {
 		void __pmem *addr;
 		unsigned long pfn;
-		long count;
+		long count, sz;
 
 		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
 		if (count < 0)
 			return count;
-		BUG_ON(size < count);
-		while (count > 0) {
-			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
-			if (pgsz > count)
-				pgsz = count;
-			clear_pmem(addr, pgsz);
-			addr += pgsz;
-			size -= pgsz;
-			count -= pgsz;
-			BUG_ON(pgsz & 511);
-			sector += pgsz / 512;
-			cond_resched();
-		}
+		sz = min_t(long, count, SZ_128K);
+		clear_pmem(addr, sz);
+		size -= sz;
+		BUG_ON(sz & 511);
+		sector += sz / 512;
+		cond_resched();
 	} while (size);
 
 	wmb_pmem();
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch


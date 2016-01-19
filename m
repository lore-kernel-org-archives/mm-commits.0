From: akpm@linux-foundation.org
Subject: [merged]
 dax-guarantee-page-aligned-results-from-bdev_direct_access.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:13:09 -0800
Message-ID: <569e98d5.S95gD57CSIiD2QQw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbcASUNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: guarantee page aligned results from bdev_direct_access()
has been removed from the -mm tree.  Its filename was
     dax-guarantee-page-aligned-results-from-bdev_direct_access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: guarantee page aligned results from bdev_direct_access()

If a ->direct_access() implementation ever returns a map count less than
PAGE_SIZE, catch the error in bdev_direct_access().  This simplifies error
checking in upper layers.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 ++
 fs/dax.c       |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~dax-guarantee-page-aligned-results-from-bdev_direct_access fs/block_dev.c
--- a/fs/block_dev.c~dax-guarantee-page-aligned-results-from-bdev_direct_access
+++ a/fs/block_dev.c
@@ -494,6 +494,8 @@ long bdev_direct_access(struct block_dev
 	avail = ops->direct_access(bdev, sector, addr, pfn);
 	if (!avail)
 		return -ERANGE;
+	if (avail > 0 && avail & ~PAGE_MASK)
+		return -ENXIO;
 	return min(avail, size);
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
diff -puN fs/dax.c~dax-guarantee-page-aligned-results-from-bdev_direct_access fs/dax.c
--- a/fs/dax.c~dax-guarantee-page-aligned-results-from-bdev_direct_access
+++ a/fs/dax.c
@@ -52,7 +52,6 @@ int dax_clear_blocks(struct inode *inode
 		sz = min_t(long, count, SZ_128K);
 		clear_pmem(addr, sz);
 		size -= sz;
-		BUG_ON(sz & 511);
 		sector += sz / 512;
 		cond_resched();
 	} while (size);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch


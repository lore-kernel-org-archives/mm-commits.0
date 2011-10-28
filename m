From: akpm@linux-foundation.org
Subject: [merged] dio-use-a-slab-cache-for-struct-dio.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:10:33 -0700
Message-ID: <201110282210.p9SMAXde031239@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:33026 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1J1WKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio: use a slab cache for struct dio
has been removed from the -mm tree.  Its filename was
     dio-use-a-slab-cache-for-struct-dio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: dio: use a slab cache for struct dio

A direct slab call is slightly faster than kmalloc and can be better
cached per CPU.  It also avoids rounding to the next kmalloc slab.

In addition this enforces cache line alignment for struct dio to avoid any
false sharing.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/direct-io.c~dio-use-a-slab-cache-for-struct-dio fs/direct-io.c
--- a/fs/direct-io.c~dio-use-a-slab-cache-for-struct-dio
+++ a/fs/direct-io.c
@@ -140,7 +140,9 @@ struct dio {
 	 * wish that they not be zeroed.
 	 */
 	struct page *pages[DIO_PAGES];	/* page buffer */
-};
+} ____cacheline_aligned_in_smp;
+
+static struct kmem_cache *dio_cache __read_mostly;
 
 static void __inode_dio_wait(struct inode *inode)
 {
@@ -330,7 +332,7 @@ static void dio_bio_end_aio(struct bio *
 
 	if (remaining == 0) {
 		dio_complete(dio, dio->iocb->ki_pos, 0, true);
-		kfree(dio);
+		kmem_cache_free(dio_cache, dio);
 	}
 }
 
@@ -1174,7 +1176,7 @@ direct_io_worker(int rw, struct kiocb *i
 
 	if (ret2 == 0) {
 		ret = dio_complete(dio, offset, ret, false);
-		kfree(dio);
+		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
 
@@ -1250,7 +1252,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	if (rw == READ && end == offset)
 		return 0;
 
-	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
@@ -1274,7 +1276,7 @@ __blockdev_direct_IO(int rw, struct kioc
 							      end - 1);
 			if (retval) {
 				mutex_unlock(&inode->i_mutex);
-				kfree(dio);
+				kmem_cache_free(dio_cache, dio);
 				goto out;
 			}
 		}
@@ -1302,3 +1304,10 @@ out:
 	return retval;
 }
 EXPORT_SYMBOL(__blockdev_direct_IO);
+
+static __init int dio_init(void)
+{
+	dio_cache = KMEM_CACHE(dio, SLAB_PANIC);
+	return 0;
+}
+module_init(dio_init)
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
brlocks-lglocks-clean-up-code.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
hwpoison-convert-pr_debugs-to-pr_infos.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch


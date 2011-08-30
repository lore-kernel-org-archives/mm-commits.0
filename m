From: akpm@linux-foundation.org
Subject: + dio-use-a-slab-cache-for-struct-dio.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:47:53 -0700
Message-ID: <201108302347.p7UNlrYp026214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921Ab1H3Xsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: use a slab cache for struct dio
has been added to the -mm tree.  Its filename is
     dio-use-a-slab-cache-for-struct-dio.patch

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
Subject: dio: use a slab cache for struct dio
From: Andi Kleen <ak@linux.intel.com>

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
 
@@ -1178,7 +1180,7 @@ direct_io_worker(int rw, struct kiocb *i
 
 	if (ret2 == 0) {
 		ret = dio_complete(dio, offset, ret, false);
-		kfree(dio);
+		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
 
@@ -1254,7 +1256,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	if (rw == READ && end == offset)
 		return 0;
 
-	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
@@ -1278,7 +1280,7 @@ __blockdev_direct_IO(int rw, struct kioc
 							      end - 1);
 			if (retval) {
 				mutex_unlock(&inode->i_mutex);
-				kfree(dio);
+				kmem_cache_free(dio_cache, dio);
 				goto out;
 			}
 		}
@@ -1306,3 +1308,10 @@ out:
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

linux-next.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch


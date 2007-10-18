From: akpm@linux-foundation.org
Subject: - drivers-block-ccissc-fix-check-after-use.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:23 -0700
Message-ID: <200710180659.l9I6xNdd030979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbXJRG76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bunk@stusta.de, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/cciss.c: fix check-after-use
has been removed from the -mm tree.  Its filename was
     drivers-block-ccissc-fix-check-after-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/block/cciss.c: fix check-after-use
From: Adrian Bunk <bunk@kernel.org>

The Coverity checker spotted that we have already oops'ed if "disk"
was NULL.

Since "disk" being NULL seems impossible at this point this patch
removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   56 +++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-fix-check-after-use drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-fix-check-after-use
+++ a/drivers/block/cciss.c
@@ -1582,38 +1582,36 @@ static int deregister_disk(struct gendis
 	 * allows us to delete disk zero but keep the controller registered.
 	 */
 	if (h->gendisk[0] != disk) {
-		if (disk) {
-			struct request_queue *q = disk->queue;
-			if (disk->flags & GENHD_FL_UP)
-				del_gendisk(disk);
-			if (q) {
-				blk_cleanup_queue(q);
-				/* Set drv->queue to NULL so that we do not try
-				 * to call blk_start_queue on this queue in the
-				 * interrupt handler
-				 */
-				drv->queue = NULL;
-			}
-			/* If clear_all is set then we are deleting the logical
-			 * drive, not just refreshing its info.  For drives
-			 * other than disk 0 we will call put_disk.  We do not
-			 * do this for disk 0 as we need it to be able to
-			 * configure the controller.
+		struct request_queue *q = disk->queue;
+		if (disk->flags & GENHD_FL_UP)
+			del_gendisk(disk);
+		if (q) {
+			blk_cleanup_queue(q);
+			/* Set drv->queue to NULL so that we do not try
+			 * to call blk_start_queue on this queue in the
+			 * interrupt handler
+			 */
+			drv->queue = NULL;
+		}
+		/* If clear_all is set then we are deleting the logical
+		 * drive, not just refreshing its info.  For drives
+		 * other than disk 0 we will call put_disk.  We do not
+		 * do this for disk 0 as we need it to be able to
+		 * configure the controller.
+		*/
+		if (clear_all){
+			/* This isn't pretty, but we need to find the
+			 * disk in our array and NULL our the pointer.
+			 * This is so that we will call alloc_disk if
+			 * this index is used again later.
 			*/
-			if (clear_all){
-				/* This isn't pretty, but we need to find the
-				 * disk in our array and NULL our the pointer.
-				 * This is so that we will call alloc_disk if
-				 * this index is used again later.
-				*/
-				for (i=0; i < CISS_MAX_LUN; i++){
-					if(h->gendisk[i] == disk){
-						h->gendisk[i] = NULL;
-						break;
-					}
+			for (i=0; i < CISS_MAX_LUN; i++){
+				if(h->gendisk[i] == disk){
+					h->gendisk[i] = NULL;
+					break;
 				}
-				put_disk(disk);
 			}
+			put_disk(disk);
 		}
 	} else {
 		set_capacity(disk, 0);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch

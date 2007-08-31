From: akpm@linux-foundation.org
Subject: + drivers-block-ccissc-fix-check-after-use.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:06:32 -0700
Message-ID: <200708311806.l7VI6XDZ019959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965544AbXHaSHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bunk@stusta.de, mike.miller@hp.com


The patch titled
     drivers/block/cciss.c: fix check-after-use
has been added to the -mm tree.  Its filename is
     drivers-block-ccissc-fix-check-after-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 27 insertions(+), 29 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-fix-check-after-use drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-fix-check-after-use
+++ a/drivers/block/cciss.c
@@ -1583,38 +1583,36 @@ static int deregister_disk(struct gendis
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
drivers-block-ccissc-fix-check-after-use.patch
arm-extern-inline-static-inline.patch
ppc-remove-apus-support.patch
git-dvb.patch
ivtv-fbc-bugfix.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch

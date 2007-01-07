From: akpm@osdl.org
Subject: - swsusp-do-not-fail-if-resume-device-is-not-set.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:31 -0800
Message-ID: <200701070758.l077wVDx012960@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40789 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbXAGH64 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Do not fail if resume device is not set
has been removed from the -mm tree.  Its filename was
     swsusp-do-not-fail-if-resume-device-is-not-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Do not fail if resume device is not set
From: "Rafael J. Wysocki" <rjw@sisk.pl>

In the kernels later than 2.6.19 there is a regression that makes swsusp
fail if the resume device is not explicitly specified.

It can be fixed by adding an additional parameter to
mm/swapfile.c:swap_type_of() allowing us to pass the (struct block_device
*) corresponding to the first available swap back to the caller.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/swap.h |    2 +-
 kernel/power/swap.c  |    9 +++++----
 kernel/power/user.c  |    7 ++++---
 mm/swapfile.c        |    8 +++++++-
 4 files changed, 17 insertions(+), 9 deletions(-)

diff -puN include/linux/swap.h~swsusp-do-not-fail-if-resume-device-is-not-set include/linux/swap.h
--- a/include/linux/swap.h~swsusp-do-not-fail-if-resume-device-is-not-set
+++ a/include/linux/swap.h
@@ -245,7 +245,7 @@ extern int swap_duplicate(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern void swap_free(swp_entry_t);
 extern void free_swap_and_cache(swp_entry_t);
-extern int swap_type_of(dev_t, sector_t);
+extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
 extern sector_t swapdev_block(int, pgoff_t);
diff -puN kernel/power/swap.c~swsusp-do-not-fail-if-resume-device-is-not-set kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-do-not-fail-if-resume-device-is-not-set
+++ a/kernel/power/swap.c
@@ -165,14 +165,15 @@ static int swsusp_swap_check(void) /* Th
 {
 	int res;
 
-	res = swap_type_of(swsusp_resume_device, swsusp_resume_block);
+	res = swap_type_of(swsusp_resume_device, swsusp_resume_block,
+			&resume_bdev);
 	if (res < 0)
 		return res;
 
 	root_swap = res;
-	resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_WRITE);
-	if (IS_ERR(resume_bdev))
-		return PTR_ERR(resume_bdev);
+	res = blkdev_get(resume_bdev, FMODE_WRITE, O_RDWR);
+	if (res)
+		return res;
 
 	res = set_blocksize(resume_bdev, PAGE_SIZE);
 	if (res < 0)
diff -puN kernel/power/user.c~swsusp-do-not-fail-if-resume-device-is-not-set kernel/power/user.c
--- a/kernel/power/user.c~swsusp-do-not-fail-if-resume-device-is-not-set
+++ a/kernel/power/user.c
@@ -57,7 +57,7 @@ static int snapshot_open(struct inode *i
 	memset(&data->handle, 0, sizeof(struct snapshot_handle));
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY) {
 		data->swap = swsusp_resume_device ?
-				swap_type_of(swsusp_resume_device, 0) : -1;
+			swap_type_of(swsusp_resume_device, 0, NULL) : -1;
 		data->mode = O_RDONLY;
 	} else {
 		data->swap = -1;
@@ -268,7 +268,8 @@ static int snapshot_ioctl(struct inode *
 			 * so we need to recode them
 			 */
 			if (old_decode_dev(arg)) {
-				data->swap = swap_type_of(old_decode_dev(arg), 0);
+				data->swap = swap_type_of(old_decode_dev(arg),
+							0, NULL);
 				if (data->swap < 0)
 					error = -ENODEV;
 			} else {
@@ -365,7 +366,7 @@ static int snapshot_ioctl(struct inode *
 			swdev = old_decode_dev(swap_area.dev);
 			if (swdev) {
 				offset = swap_area.offset;
-				data->swap = swap_type_of(swdev, offset);
+				data->swap = swap_type_of(swdev, offset, NULL);
 				if (data->swap < 0)
 					error = -ENODEV;
 			} else {
diff -puN mm/swapfile.c~swsusp-do-not-fail-if-resume-device-is-not-set mm/swapfile.c
--- a/mm/swapfile.c~swsusp-do-not-fail-if-resume-device-is-not-set
+++ a/mm/swapfile.c
@@ -434,7 +434,7 @@ void free_swap_and_cache(swp_entry_t ent
  *
  * This is needed for the suspend to disk (aka swsusp).
  */
-int swap_type_of(dev_t device, sector_t offset)
+int swap_type_of(dev_t device, sector_t offset, struct block_device **bdev_p)
 {
 	struct block_device *bdev = NULL;
 	int i;
@@ -450,6 +450,9 @@ int swap_type_of(dev_t device, sector_t 
 			continue;
 
 		if (!bdev) {
+			if (bdev_p)
+				*bdev_p = sis->bdev;
+
 			spin_unlock(&swap_lock);
 			return i;
 		}
@@ -459,6 +462,9 @@ int swap_type_of(dev_t device, sector_t 
 			se = list_entry(sis->extent_list.next,
 					struct swap_extent, list);
 			if (se->start_block == offset) {
+				if (bdev_p)
+					*bdev_p = sis->bdev;
+
 				spin_unlock(&swap_lock);
 				bdput(bdev);
 				return i;
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch
shrink_slab-handle-bad-shrinkers.patch

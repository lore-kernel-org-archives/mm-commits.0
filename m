From: akpm@osdl.org
Subject: - swsusp-use-partition-device-and-offset-to-identify-swap-areas.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:02 -0800
Message-ID: <200612072259.kB7Mx2HM029450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163665AbWLGW7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: use partition device and offset to identify swap areas
has been removed from the -mm tree.  Its filename was
     swsusp-use-partition-device-and-offset-to-identify-swap-areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: use partition device and offset to identify swap areas
From: "Rafael J. Wysocki" <rjw@sisk.pl>

The Linux kernel handles swap files almost in the same way as it handles swap
partitions and there are only two differences between these two types of swap
areas:

(1) swap files need not be contiguous,

(2) the header of a swap file is not in the first block of the partition
    that holds it.  From the swsusp's point of view (1) is not a problem,
    because it is already taken care of by the swap-handling code, but (2) has
    to be taken into consideration.

In principle the location of a swap file's header may be determined with the
help of appropriate filesystem driver.  Unfortunately, however, it requires
the filesystem holding the swap file to be mounted, and if this filesystem is
journaled, it cannot be mounted during a resume from disk.  For this reason we
need some other means by which swap areas can be identified.

For example, to identify a swap area we can use the partition that holds the
area and the offset from the beginning of this partition at which the swap
header is located.

The following patch allows swsusp to identify swap areas this way.  It changes
swap_type_of() so that it takes an additional argument representing an offset
of the swap header within the partition represented by its first argument.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/swap.h |    2 +-
 kernel/power/swap.c  |    2 +-
 kernel/power/user.c  |    5 +++--
 mm/swapfile.c        |   38 ++++++++++++++++++++++++++------------
 4 files changed, 31 insertions(+), 16 deletions(-)

diff -puN include/linux/swap.h~swsusp-use-partition-device-and-offset-to-identify-swap-areas include/linux/swap.h
--- a/include/linux/swap.h~swsusp-use-partition-device-and-offset-to-identify-swap-areas
+++ a/include/linux/swap.h
@@ -247,7 +247,7 @@ extern int swap_duplicate(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern void swap_free(swp_entry_t);
 extern void free_swap_and_cache(swp_entry_t);
-extern int swap_type_of(dev_t);
+extern int swap_type_of(dev_t, sector_t);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
diff -puN kernel/power/swap.c~swsusp-use-partition-device-and-offset-to-identify-swap-areas kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-use-partition-device-and-offset-to-identify-swap-areas
+++ a/kernel/power/swap.c
@@ -74,7 +74,7 @@ static int mark_swapfiles(swp_entry_t st
 
 static int swsusp_swap_check(void) /* This is called before saving image */
 {
-	int res = swap_type_of(swsusp_resume_device);
+	int res = swap_type_of(swsusp_resume_device, 0);
 
 	if (res >= 0) {
 		root_swap = res;
diff -puN kernel/power/user.c~swsusp-use-partition-device-and-offset-to-identify-swap-areas kernel/power/user.c
--- a/kernel/power/user.c~swsusp-use-partition-device-and-offset-to-identify-swap-areas
+++ a/kernel/power/user.c
@@ -55,7 +55,8 @@ static int snapshot_open(struct inode *i
 	filp->private_data = data;
 	memset(&data->handle, 0, sizeof(struct snapshot_handle));
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY) {
-		data->swap = swsusp_resume_device ? swap_type_of(swsusp_resume_device) : -1;
+		data->swap = swsusp_resume_device ?
+				swap_type_of(swsusp_resume_device, 0) : -1;
 		data->mode = O_RDONLY;
 	} else {
 		data->swap = -1;
@@ -265,7 +266,7 @@ static int snapshot_ioctl(struct inode *
 			 * so we need to recode them
 			 */
 			if (old_decode_dev(arg)) {
-				data->swap = swap_type_of(old_decode_dev(arg));
+				data->swap = swap_type_of(old_decode_dev(arg), 0);
 				if (data->swap < 0)
 					error = -ENODEV;
 			} else {
diff -puN mm/swapfile.c~swsusp-use-partition-device-and-offset-to-identify-swap-areas mm/swapfile.c
--- a/mm/swapfile.c~swsusp-use-partition-device-and-offset-to-identify-swap-areas
+++ a/mm/swapfile.c
@@ -427,34 +427,48 @@ void free_swap_and_cache(swp_entry_t ent
 
 #ifdef CONFIG_SOFTWARE_SUSPEND
 /*
- * Find the swap type that corresponds to given device (if any)
+ * Find the swap type that corresponds to given device (if any).
  *
- * This is needed for software suspend and is done in such a way that inode
- * aliasing is allowed.
+ * @offset - number of the PAGE_SIZE-sized block of the device, starting
+ * from 0, in which the swap header is expected to be located.
+ *
+ * This is needed for the suspend to disk (aka swsusp).
  */
-int swap_type_of(dev_t device)
+int swap_type_of(dev_t device, sector_t offset)
 {
+	struct block_device *bdev = NULL;
 	int i;
 
+	if (device)
+		bdev = bdget(device);
+
 	spin_lock(&swap_lock);
 	for (i = 0; i < nr_swapfiles; i++) {
-		struct inode *inode;
+		struct swap_info_struct *sis = swap_info + i;
 
-		if (!(swap_info[i].flags & SWP_WRITEOK))
+		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 
-		if (!device) {
+		if (!bdev) {
 			spin_unlock(&swap_lock);
 			return i;
 		}
-		inode = swap_info[i].swap_file->f_dentry->d_inode;
-		if (S_ISBLK(inode->i_mode) &&
-		    device == MKDEV(imajor(inode), iminor(inode))) {
-			spin_unlock(&swap_lock);
-			return i;
+		if (bdev == sis->bdev) {
+			struct swap_extent *se;
+
+			se = list_entry(sis->extent_list.next,
+					struct swap_extent, list);
+			if (se->start_block == offset) {
+				spin_unlock(&swap_lock);
+				bdput(bdev);
+				return i;
+			}
 		}
 	}
 	spin_unlock(&swap_lock);
+	if (bdev)
+		bdput(bdev);
+
 	return -ENODEV;
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch


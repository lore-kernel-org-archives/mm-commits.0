From: akpm@linux-foundation.org
Subject: [merged] hiddev-fix-waitqueue-usage.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:10:15 -0700
Message-ID: <200903111810.n2BIAFsM020066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbZCKSMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, jkosina@suse.cz, oliver@neukum.name, mm-commits@vger.kernel.org


The patch titled
     hiddev: fix waitqueue usage
has been removed from the -mm tree.  Its filename was
     hiddev-fix-waitqueue-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hiddev: fix waitqueue usage
From: Johannes Weiner <hannes@cmpxchg.org>

DECLARE_WAITQUEUE doesn't initialize the wait descriptor's task_list
to 'empty' but to zero.

prepare_to_wait() will not enqueue the descriptor to the waitqueue and
finish_wait() will do list_del_init() on a list head that contains
NULL pointers, which oopses.

This was introduced by 079034073 "HID: hiddev cleanup -- handle all
error conditions properly".

The prior code used an unconditional add_to_waitqueue() which didn't
care about the wait descriptor's list head and enqueued the thing
unconditionally.

The new code uses prepare_to_wait() which DOES check the prior list
state, so use DEFINE_WAIT instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oliver Neukum <oliver@neukum.name>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hiddev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/usbhid/hiddev.c~hiddev-fix-waitqueue-usage drivers/hid/usbhid/hiddev.c
--- a/drivers/hid/usbhid/hiddev.c~hiddev-fix-waitqueue-usage
+++ a/drivers/hid/usbhid/hiddev.c
@@ -333,7 +333,7 @@ static ssize_t hiddev_write(struct file 
  */
 static ssize_t hiddev_read(struct file * file, char __user * buffer, size_t count, loff_t *ppos)
 {
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT(wait);
 	struct hiddev_list *list = file->private_data;
 	int event_size;
 	int retval;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
cifs-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch


From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:17 -0700
Message-ID: <200906162241.n5GMfHaB003224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763AbZFPWxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: limit the num of mem regions user can register per fd
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: limit the num of mem regions user can register per fd
From: Izik Eidus <ieidus@redhat.com>

Right now user can open /dev/ksm fd and register unlimited number of
regions, such behavior may allocate unlimited amount of kernel memory
and get the whole host into out of memory situation.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd
+++ a/mm/ksm.c
@@ -48,6 +48,9 @@ static int rmap_hash_size;
 module_param(rmap_hash_size, int, 0);
 MODULE_PARM_DESC(rmap_hash_size, "Hash table size for the reverse mapping");
 
+static int regions_per_fd;
+module_param(regions_per_fd, int, 0);
+
 /*
  * ksm_mem_slot - hold information for an userspace scanning range
  * (the scanning for this region will be from addr untill addr +
@@ -67,6 +70,7 @@ struct ksm_mem_slot {
  */
 struct ksm_sma {
 	struct list_head sma_slots;
+	int nregions;
 };
 
 /**
@@ -452,6 +456,11 @@ static int ksm_sma_ioctl_register_memory
 	struct ksm_mem_slot *slot;
 	int ret = -EPERM;
 
+	if ((ksm_sma->nregions + 1) > regions_per_fd) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	slot = kzalloc(sizeof(struct ksm_mem_slot), GFP_KERNEL);
 	if (!slot) {
 		ret = -ENOMEM;
@@ -472,6 +481,7 @@ static int ksm_sma_ioctl_register_memory
 
 	list_add_tail(&slot->link, &slots);
 	list_add_tail(&slot->sma_link, &ksm_sma->sma_slots);
+	ksm_sma->nregions++;
 
 	up_write(&slots_lock);
 	return 0;
@@ -510,6 +520,7 @@ static int ksm_sma_ioctl_remove_memory_r
 		mmput(slot->mm);
 		list_del(&slot->sma_link);
 		kfree(slot);
+		ksm_sma->nregions--;
 	}
 	up_write(&slots_lock);
 	return 0;
@@ -1387,6 +1398,7 @@ static int ksm_dev_ioctl_create_shared_m
 	}
 
 	INIT_LIST_HEAD(&ksm_sma->sma_slots);
+	ksm_sma->nregions = 0;
 
 	fd = anon_inode_getfd("ksm-sma", &ksm_sma_fops, ksm_sma, 0);
 	if (fd < 0)
@@ -1629,6 +1641,9 @@ static int __init ksm_init(void)
 	if (r)
 		goto out_free1;
 
+	if (!regions_per_fd)
+		regions_per_fd = 1024;
+
 	ksm_thread = kthread_run(ksm_scan_thread, NULL, "kksmd");
 	if (IS_ERR(ksm_thread)) {
 		printk(KERN_ERR "ksm: creating kthread failed\n");
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch


From: akpm@linux-foundation.org
Subject: + ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch added to -mm tree
Date: Tue, 05 May 2009 13:15:09 -0700
Message-ID: <200905052015.n45KF9o0004829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005AbZEEUUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     ksm: limit the num of mem regions user can register per fd
has been added to the -mm tree.  Its filename is
     ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch

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
Subject: ksm: limit the num of mem regions user can register per fd
From: Izik Eidus <ieidus@redhat.com>

Right now user can open /dev/ksm fd and register unlimited number of
regions, such behavior may allocate unlimited amount of kernel memory
and get the whole host into out of memory situation.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
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
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch


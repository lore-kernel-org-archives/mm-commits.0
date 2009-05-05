From: akpm@linux-foundation.org
Subject: + ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch added to -mm tree
Date: Tue, 05 May 2009 13:15:14 -0700
Message-ID: <200905052015.n45KFF9F004924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017AbZEEUUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
has been added to the -mm tree.  Its filename is
     ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch

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
Subject: ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
From: Izik Eidus <ieidus@redhat.com>

This patch change the KSM_REMOVE_MEMORY_REGION ioctl to be specific per
memory region (instead of flushing all the registred memory regions inside
the file descriptor like it happen now)

The previoes api was: user register memory regions using
KSM_REGISTER_MEMORY_REGION inside the fd, and then when he wanted to
remove just one memory region, he had to remove them all using
KSM_REMOVE_MEMORY_REGION.

This patch change this beahivor by chaning the KSM_REMOVE_MEMORY_REGION
ioctl to recive another paramter that it is the begining of the virtual
address that is wanted to be removed.

(user can still remove all the memory regions all at once, by just closing
the file descriptor)

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl
+++ a/mm/ksm.c
@@ -542,48 +542,55 @@ out:
 	return ret;
 }
 
-static void remove_mm_from_hash_and_tree(struct mm_struct *mm)
+static void remove_slot_from_hash_and_tree(struct ksm_mem_slot *slot)
 {
-	struct ksm_mem_slot *slot;
 	int pages_count;
 
-	list_for_each_entry(slot, &slots, link)
-		if (slot->mm == mm)
-			break;
-	BUG_ON(!slot);
-
 	root_unstable_tree = RB_ROOT;
 	for (pages_count = 0; pages_count < slot->npages; ++pages_count)
-		remove_page_from_tree(mm, slot->addr +
+		remove_page_from_tree(slot->mm, slot->addr +
 				      pages_count * PAGE_SIZE);
 	/* Called under slots_lock */
 	list_del(&slot->link);
 }
 
-static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma)
+static int ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma,
+					      unsigned long addr)
 {
+	int ret = -EFAULT;
 	struct ksm_mem_slot *slot, *node;
 
 	down_write(&slots_lock);
 	list_for_each_entry_safe(slot, node, &ksm_sma->sma_slots, sma_link) {
-		remove_mm_from_hash_and_tree(slot->mm);
-		mmput(slot->mm);
-		list_del(&slot->sma_link);
-		kfree(slot);
-		ksm_sma->nregions--;
+		if (addr == slot->addr) {
+			remove_slot_from_hash_and_tree(slot);
+			mmput(slot->mm);
+			list_del(&slot->sma_link);
+			kfree(slot);
+			ksm_sma->nregions--;
+			ret = 0;
+		}
 	}
 	up_write(&slots_lock);
-	return 0;
+	return ret;
 }
 
 static int ksm_sma_release(struct inode *inode, struct file *filp)
 {
+	struct ksm_mem_slot *slot, *node;
 	struct ksm_sma *ksm_sma = filp->private_data;
-	int r;
 
-	r = ksm_sma_ioctl_remove_memory_region(ksm_sma);
+	down_write(&slots_lock);
+	list_for_each_entry_safe(slot, node, &ksm_sma->sma_slots, sma_link) {
+		remove_slot_from_hash_and_tree(slot);
+		mmput(slot->mm);
+		list_del(&slot->sma_link);
+		kfree(slot);
+	}
+	up_write(&slots_lock);
+
 	kfree(ksm_sma);
-	return r;
+	return 0;
 }
 
 static long ksm_sma_ioctl(struct file *filp,
@@ -606,7 +613,7 @@ static long ksm_sma_ioctl(struct file *f
 		break;
 	}
 	case KSM_REMOVE_MEMORY_REGION:
-		r = ksm_sma_ioctl_remove_memory_region(sma);
+		r = ksm_sma_ioctl_remove_memory_region(sma, arg);
 		break;
 	}
 
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


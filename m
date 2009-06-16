From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:23 -0700
Message-ID: <200906162241.n5GMfNDq003355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762573AbZFPWl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch

This patch was dropped because an updated version will be merged

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
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch


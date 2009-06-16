From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:20 -0700
Message-ID: <200906162241.n5GMfKwq003351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710AbZFPWxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: don't allow overlap memory addresses registrations
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: don't allow overlap memory addresses registrations
From: Izik Eidus <ieidus@redhat.com>

subjects say it all.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 54 insertions(+), 4 deletions(-)

diff -puN mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations mm/ksm.c
--- a/mm/ksm.c~ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations
+++ a/mm/ksm.c
@@ -450,21 +450,71 @@ static void remove_page_from_tree(struct
 	remove_rmap_item_from_tree(rmap_item);
 }
 
+static inline int is_intersecting_address(unsigned long addr,
+					  unsigned long begin,
+					  unsigned long end)
+{
+	if (addr >= begin && addr < end)
+		return 1;
+	return 0;
+}
+
+/*
+ * is_overlap_mem - check if there is overlapping with memory that was already
+ * registred.
+ *
+ * note - this function must to be called under slots_lock
+ */
+static int is_overlap_mem(struct ksm_memory_region *mem)
+{
+	struct ksm_mem_slot *slot;
+
+	list_for_each_entry(slot, &slots, link) {
+		unsigned long mem_end;
+		unsigned long slot_end;
+
+		cond_resched();
+
+		if (current->mm != slot->mm)
+			continue;
+
+		mem_end = mem->addr + (unsigned long)mem->npages * PAGE_SIZE;
+		slot_end = slot->addr + (unsigned long)slot->npages * PAGE_SIZE;
+
+		if (is_intersecting_address(mem->addr, slot->addr, slot_end) ||
+		    is_intersecting_address(mem_end - 1, slot->addr, slot_end))
+			return 1;
+		if (is_intersecting_address(slot->addr, mem->addr, mem_end) ||
+		    is_intersecting_address(slot_end - 1, mem->addr, mem_end))
+			return 1;
+	}
+
+	return 0;
+}
+
 static int ksm_sma_ioctl_register_memory_region(struct ksm_sma *ksm_sma,
 						struct ksm_memory_region *mem)
 {
 	struct ksm_mem_slot *slot;
 	int ret = -EPERM;
 
+	if (!mem->npages)
+		goto out;
+
+	down_write(&slots_lock);
+
 	if ((ksm_sma->nregions + 1) > regions_per_fd) {
 		ret = -EBUSY;
-		goto out;
+		goto out_unlock;
 	}
 
+	if (is_overlap_mem(mem))
+		goto out_unlock;
+
 	slot = kzalloc(sizeof(struct ksm_mem_slot), GFP_KERNEL);
 	if (!slot) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -477,8 +527,6 @@ static int ksm_sma_ioctl_register_memory
 	slot->addr = mem->addr;
 	slot->npages = mem->npages;
 
-	down_write(&slots_lock);

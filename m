From: akpm@linux-foundation.org
Subject: [merged] mmksm-use-new-hashtable-implementation.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:50 -0800
Message-ID: <20130225204850.AB6205A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36293 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab3BYUsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:51 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so345749ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, hughd@google.com, khlebnikov@openvz.org, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: use new hashtable implementation
has been removed from the -mm tree.  Its filename was
     mmksm-use-new-hashtable-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: mm/ksm.c: use new hashtable implementation

Switch ksm to use the new hashtable implementation.  This reduces the
amount of generic unrelated code in the ksm module.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN mm/ksm.c~mmksm-use-new-hashtable-implementation mm/ksm.c
--- a/mm/ksm.c~mmksm-use-new-hashtable-implementation
+++ a/mm/ksm.c
@@ -33,7 +33,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
 #include <linux/ksm.h>
-#include <linux/hash.h>
+#include <linux/hashtable.h>
 #include <linux/freezer.h>
 #include <linux/oom.h>
 
@@ -156,9 +156,8 @@ struct rmap_item {
 static struct rb_root root_stable_tree = RB_ROOT;
 static struct rb_root root_unstable_tree = RB_ROOT;
 
-#define MM_SLOTS_HASH_SHIFT 10
-#define MM_SLOTS_HASH_HEADS (1 << MM_SLOTS_HASH_SHIFT)
-static struct hlist_head mm_slots_hash[MM_SLOTS_HASH_HEADS];
+#define MM_SLOTS_HASH_BITS 10
+static DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct mm_slot ksm_mm_head = {
 	.mm_list = LIST_HEAD_INIT(ksm_mm_head.mm_list),
@@ -275,26 +274,21 @@ static inline void free_mm_slot(struct m
 
 static struct mm_slot *get_mm_slot(struct mm_struct *mm)
 {
-	struct mm_slot *mm_slot;
-	struct hlist_head *bucket;
 	struct hlist_node *node;
+	struct mm_slot *slot;
+
+	hash_for_each_possible(mm_slots_hash, slot, node, link, (unsigned long)mm)
+		if (slot->mm == mm)
+			return slot;
 
-	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
-	hlist_for_each_entry(mm_slot, node, bucket, link) {
-		if (mm == mm_slot->mm)
-			return mm_slot;
-	}
 	return NULL;
 }
 
 static void insert_to_mm_slots_hash(struct mm_struct *mm,
 				    struct mm_slot *mm_slot)
 {
-	struct hlist_head *bucket;
-
-	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
 	mm_slot->mm = mm;
-	hlist_add_head(&mm_slot->link, bucket);
+	hash_add(mm_slots_hash, &mm_slot->link, (unsigned long)mm);
 }
 
 static inline int in_stable_tree(struct rmap_item *rmap_item)
@@ -647,7 +641,7 @@ static int unmerge_and_remove_all_rmap_i
 		ksm_scan.mm_slot = list_entry(mm_slot->mm_list.next,
 						struct mm_slot, mm_list);
 		if (ksm_test_exit(mm)) {
-			hlist_del(&mm_slot->link);
+			hash_del(&mm_slot->link);
 			list_del(&mm_slot->mm_list);
 			spin_unlock(&ksm_mmlist_lock);
 
@@ -1392,7 +1386,7 @@ next_mm:
 		 * or when all VM_MERGEABLE areas have been unmapped (and
 		 * mmap_sem then protects against race with MADV_MERGEABLE).
 		 */
-		hlist_del(&slot->link);
+		hash_del(&slot->link);
 		list_del(&slot->mm_list);
 		spin_unlock(&ksm_mmlist_lock);
 
@@ -1559,7 +1553,7 @@ void __ksm_exit(struct mm_struct *mm)
 	mm_slot = get_mm_slot(mm);
 	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
 		if (!mm_slot->rmap_list) {
-			hlist_del(&mm_slot->link);
+			hash_del(&mm_slot->link);
 			list_del(&mm_slot->mm_list);
 			easy_to_free = 1;
 		} else {
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch


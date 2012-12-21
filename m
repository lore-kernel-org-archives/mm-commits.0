From: akpm@linux-foundation.org
Subject: + mmksm-use-new-hashtable-implementation.patch added to -mm tree
Date: Fri, 21 Dec 2012 13:19:28 -0800
Message-ID: <20121221211929.3969C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35760 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2LUVTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 16:19:32 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so521893vcq.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 13:19:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, hughd@google.com, khlebnikov@openvz.org, mgorman@suse.de, mhocko@suse.cz


The patch titled
     Subject: mm/ksm.c: use new hashtable implementation
has been added to the -mm tree.  Its filename is
     mmksm-use-new-hashtable-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
mmksm-use-new-hashtable-implementation.patch


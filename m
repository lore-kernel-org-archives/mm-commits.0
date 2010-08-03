From: akpm@linux-foundation.org
Subject: + ksm-cleanup-for-mm_slots_hash.patch added to -mm tree
Date: Tue, 03 Aug 2010 16:47:13 -0700
Message-ID: <201008032347.o73NlDvC018272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798Ab0HCXry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 19:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, aarcange@redhat.com, avi@redhat.com, ieidus@redhat.com


The patch titled
     ksm: cleanup for mm_slots_hash
has been added to the -mm tree.  Its filename is
     ksm-cleanup-for-mm_slots_hash.patch

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
Subject: ksm: cleanup for mm_slots_hash
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Use compile-allocated memory instead of dynamic allocated memory for
mm_slots_hash.

Use hash_ptr() instead divisions for bucket calculation.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff -puN mm/ksm.c~ksm-cleanup-for-mm_slots_hash mm/ksm.c
--- a/mm/ksm.c~ksm-cleanup-for-mm_slots_hash
+++ a/mm/ksm.c
@@ -33,6 +33,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
 #include <linux/ksm.h>
+#include <linux/hash.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -153,8 +154,9 @@ struct rmap_item {
 static struct rb_root root_stable_tree = RB_ROOT;
 static struct rb_root root_unstable_tree = RB_ROOT;
 
-#define MM_SLOTS_HASH_HEADS 1024
-static struct hlist_head *mm_slots_hash;
+#define MM_SLOTS_HASH_SHIFT 10
+#define MM_SLOTS_HASH_HEADS (1 << MM_SLOTS_HASH_SHIFT)
+static struct hlist_head mm_slots_hash[MM_SLOTS_HASH_HEADS];
 
 static struct mm_slot ksm_mm_head = {
 	.mm_list = LIST_HEAD_INIT(ksm_mm_head.mm_list),
@@ -269,28 +271,13 @@ static inline void free_mm_slot(struct m
 	kmem_cache_free(mm_slot_cache, mm_slot);
 }
 
-static int __init mm_slots_hash_init(void)
-{
-	mm_slots_hash = kzalloc(MM_SLOTS_HASH_HEADS * sizeof(struct hlist_head),
-				GFP_KERNEL);
-	if (!mm_slots_hash)
-		return -ENOMEM;
-	return 0;
-}
-
-static void __init mm_slots_hash_free(void)
-{
-	kfree(mm_slots_hash);
-}
-
 static struct mm_slot *get_mm_slot(struct mm_struct *mm)
 {
 	struct mm_slot *mm_slot;
 	struct hlist_head *bucket;
 	struct hlist_node *node;
 
-	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
-				% MM_SLOTS_HASH_HEADS];
+	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
 	hlist_for_each_entry(mm_slot, node, bucket, link) {
 		if (mm == mm_slot->mm)
 			return mm_slot;
@@ -303,8 +290,7 @@ static void insert_to_mm_slots_hash(stru
 {
 	struct hlist_head *bucket;
 
-	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
-				% MM_SLOTS_HASH_HEADS];
+	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
 	mm_slot->mm = mm;
 	hlist_add_head(&mm_slot->link, bucket);
 }
@@ -1938,15 +1924,11 @@ static int __init ksm_init(void)
 	if (err)
 		goto out;
 
-	err = mm_slots_hash_init();
-	if (err)
-		goto out_free1;
-
 	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
 	if (IS_ERR(ksm_thread)) {
 		printk(KERN_ERR "ksm: creating kthread failed\n");
 		err = PTR_ERR(ksm_thread);
-		goto out_free2;
+		goto out_free;
 	}
 
 #ifdef CONFIG_SYSFS
@@ -1954,7 +1936,7 @@ static int __init ksm_init(void)
 	if (err) {
 		printk(KERN_ERR "ksm: register sysfs failed\n");
 		kthread_stop(ksm_thread);
-		goto out_free2;
+		goto out_free;
 	}
 #else
 	ksm_run = KSM_RUN_MERGE;	/* no way for user to start it */
@@ -1970,9 +1952,7 @@ static int __init ksm_init(void)
 #endif
 	return 0;
 
-out_free2:
-	mm_slots_hash_free();
-out_free1:
+out_free:
 	ksm_slab_free();
 out:
 	return err;
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
ksm-cleanup-for-mm_slots_hash.patch


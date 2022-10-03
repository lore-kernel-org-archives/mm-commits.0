Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70949C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJCVEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJCVEj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B189C7B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96FC4CE0E70
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A045C433D6;
        Mon,  3 Oct 2022 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831073;
        bh=X/8pYvL2uejTxkIncYF/WeYEkLgoF2mS5a0v+/23nro=;
        h=Date:To:From:Subject:From;
        b=MPHENSrP2ZqfxVYAGSVK3fUVGQzJk3StyVXqMej2mmGM4AwR+B/dLZyqKfmZ3v6JV
         F0ceDqhj3fzPHD0NrSHxThL4yFyLfkZbmR+DElYwQrI8+ztr/1NMiQgOk2qcEnjWXx
         NeeE+ra4JnlL91BvnufCfXF2uljGu0DicB4BqqYA=
Date:   Mon, 03 Oct 2022 14:04:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch removed from -mm tree
Message-Id: <20221003210433.5A045C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: convert ksm_mm_slot.mm_list to ksm_mm_slot.mm_node
has been removed from the -mm tree.  Its filename was
     ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: ksm: convert ksm_mm_slot.mm_list to ksm_mm_slot.mm_node
Date: Wed, 31 Aug 2022 11:19:49 +0800

In order to use common struct mm_slot, convert ksm_mm_slot.mm_list to
ksm_mm_slot.mm_node in advance, no functional change.

Link: https://lkml.kernel.org/r/20220831031951.43152-6-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/mm/ksm.c~ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node
+++ a/mm/ksm.c
@@ -114,13 +114,13 @@
 /**
  * struct ksm_mm_slot - ksm information per mm that is being scanned
  * @link: link to the mm_slots hash list
- * @mm_list: link into the mm_slots list, rooted in ksm_mm_head
+ * @mm_node: link into the mm_slots list, rooted in ksm_mm_head
  * @rmap_list: head for this mm_slot's singly-linked list of rmap_items
  * @mm: the mm that this information is valid for
  */
 struct ksm_mm_slot {
 	struct hlist_node link;
-	struct list_head mm_list;
+	struct list_head mm_node;
 	struct ksm_rmap_item *rmap_list;
 	struct mm_struct *mm;
 };
@@ -231,7 +231,7 @@ static LIST_HEAD(migrate_nodes);
 static DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct ksm_mm_slot ksm_mm_head = {
-	.mm_list = LIST_HEAD_INIT(ksm_mm_head.mm_list),
+	.mm_node = LIST_HEAD_INIT(ksm_mm_head.mm_node),
 };
 static struct ksm_scan ksm_scan = {
 	.mm_slot = &ksm_mm_head,
@@ -981,8 +981,8 @@ static int unmerge_and_remove_all_rmap_i
 	int err = 0;
 
 	spin_lock(&ksm_mmlist_lock);
-	ksm_scan.mm_slot = list_entry(ksm_mm_head.mm_list.next,
-						struct ksm_mm_slot, mm_list);
+	ksm_scan.mm_slot = list_entry(ksm_mm_head.mm_node.next,
+						struct ksm_mm_slot, mm_node);
 	spin_unlock(&ksm_mmlist_lock);
 
 	for (mm_slot = ksm_scan.mm_slot; mm_slot != &ksm_mm_head;
@@ -1006,11 +1006,11 @@ static int unmerge_and_remove_all_rmap_i
 		mmap_read_unlock(mm);
 
 		spin_lock(&ksm_mmlist_lock);
-		ksm_scan.mm_slot = list_entry(mm_slot->mm_list.next,
-						struct ksm_mm_slot, mm_list);
+		ksm_scan.mm_slot = list_entry(mm_slot->mm_node.next,
+						struct ksm_mm_slot, mm_node);
 		if (ksm_test_exit(mm)) {
 			hash_del(&mm_slot->link);
-			list_del(&mm_slot->mm_list);
+			list_del(&mm_slot->mm_node);
 			spin_unlock(&ksm_mmlist_lock);
 
 			free_mm_slot(mm_slot);
@@ -2253,7 +2253,7 @@ static struct ksm_rmap_item *scan_get_ne
 	struct vma_iterator vmi;
 	int nid;
 
-	if (list_empty(&ksm_mm_head.mm_list))
+	if (list_empty(&ksm_mm_head.mm_node))
 		return NULL;
 
 	slot = ksm_scan.mm_slot;
@@ -2294,7 +2294,7 @@ static struct ksm_rmap_item *scan_get_ne
 			root_unstable_tree[nid] = RB_ROOT;
 
 		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(slot->mm_list.next, struct ksm_mm_slot, mm_list);
+		slot = list_entry(slot->mm_node.next, struct ksm_mm_slot, mm_node);
 		ksm_scan.mm_slot = slot;
 		spin_unlock(&ksm_mmlist_lock);
 		/*
@@ -2367,8 +2367,8 @@ no_vmas:
 	remove_trailing_rmap_items(ksm_scan.rmap_list);
 
 	spin_lock(&ksm_mmlist_lock);
-	ksm_scan.mm_slot = list_entry(slot->mm_list.next,
-						struct ksm_mm_slot, mm_list);
+	ksm_scan.mm_slot = list_entry(slot->mm_node.next,
+						struct ksm_mm_slot, mm_node);
 	if (ksm_scan.address == 0) {
 		/*
 		 * We've completed a full scan of all vmas, holding mmap_lock
@@ -2380,7 +2380,7 @@ no_vmas:
 		 * mmap_lock then protects against race with MADV_MERGEABLE).
 		 */
 		hash_del(&slot->link);
-		list_del(&slot->mm_list);
+		list_del(&slot->mm_node);
 		spin_unlock(&ksm_mmlist_lock);
 
 		free_mm_slot(slot);
@@ -2429,7 +2429,7 @@ static void ksm_do_scan(unsigned int sca
 
 static int ksmd_should_run(void)
 {
-	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_list);
+	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_node);
 }
 
 static int ksm_scan_thread(void *nothing)
@@ -2526,7 +2526,7 @@ int __ksm_enter(struct mm_struct *mm)
 		return -ENOMEM;
 
 	/* Check ksm_run too?  Would need tighter locking */
-	needs_wakeup = list_empty(&ksm_mm_head.mm_list);
+	needs_wakeup = list_empty(&ksm_mm_head.mm_node);
 
 	spin_lock(&ksm_mmlist_lock);
 	insert_to_mm_slots_hash(mm, mm_slot);
@@ -2541,9 +2541,9 @@ int __ksm_enter(struct mm_struct *mm)
 	 * missed: then we might as well insert at the end of the list.
 	 */
 	if (ksm_run & KSM_RUN_UNMERGE)
-		list_add_tail(&mm_slot->mm_list, &ksm_mm_head.mm_list);
+		list_add_tail(&mm_slot->mm_node, &ksm_mm_head.mm_node);
 	else
-		list_add_tail(&mm_slot->mm_list, &ksm_scan.mm_slot->mm_list);
+		list_add_tail(&mm_slot->mm_node, &ksm_scan.mm_slot->mm_node);
 	spin_unlock(&ksm_mmlist_lock);
 
 	set_bit(MMF_VM_MERGEABLE, &mm->flags);
@@ -2574,11 +2574,11 @@ void __ksm_exit(struct mm_struct *mm)
 	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
 		if (!mm_slot->rmap_list) {
 			hash_del(&mm_slot->link);
-			list_del(&mm_slot->mm_list);
+			list_del(&mm_slot->mm_node);
 			easy_to_free = 1;
 		} else {
-			list_move(&mm_slot->mm_list,
-				  &ksm_scan.mm_slot->mm_list);
+			list_move(&mm_slot->mm_node,
+				  &ksm_scan.mm_slot->mm_node);
 		}
 	}
 	spin_unlock(&ksm_mmlist_lock);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-use-update_mmu_tlb-on-the-second-thread.patch
loongarch-update-local-tlb-if-pte-entry-exists.patch


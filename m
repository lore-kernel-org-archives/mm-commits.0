Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE9FECAAD5
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 23:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiHaXOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 19:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiHaXOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 19:14:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E92F997B
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 16:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 327E761C63
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 23:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85340C433C1;
        Wed, 31 Aug 2022 23:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661987672;
        bh=CSpkPgN05fmR+4XejonCPjiFIGPT+b4oJQZ5D0ACz7s=;
        h=Date:To:From:Subject:From;
        b=iXqkJefH+Se2D5buKGlhLEJ3mvdM48XEuCbWAddGHHJnlsKoRXNI3AQKWzhDS88mr
         g+s1dqn+dpYjZDWAb+nSCy1kvw3j7q5P2A3u7KpUtE0/RlXB/GaPhdam3Yx8hG+gy6
         5kwetmPravJaK3ifclzd8x3WTACRpDs8q+fEzdI4=
Date:   Wed, 31 Aug 2022 16:14:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch added to mm-unstable branch
Message-Id: <20220831231432.85340C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: convert ksm_mm_slot.mm_list to ksm_mm_slot.mm_node
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2252,7 +2252,7 @@ static struct ksm_rmap_item *scan_get_ne
 	struct vma_iterator vmi;
 	int nid;
 
-	if (list_empty(&ksm_mm_head.mm_list))
+	if (list_empty(&ksm_mm_head.mm_node))
 		return NULL;
 
 	slot = ksm_scan.mm_slot;
@@ -2293,7 +2293,7 @@ static struct ksm_rmap_item *scan_get_ne
 			root_unstable_tree[nid] = RB_ROOT;
 
 		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(slot->mm_list.next, struct ksm_mm_slot, mm_list);
+		slot = list_entry(slot->mm_node.next, struct ksm_mm_slot, mm_node);
 		ksm_scan.mm_slot = slot;
 		spin_unlock(&ksm_mmlist_lock);
 		/*
@@ -2366,8 +2366,8 @@ no_vmas:
 	remove_trailing_rmap_items(ksm_scan.rmap_list);
 
 	spin_lock(&ksm_mmlist_lock);
-	ksm_scan.mm_slot = list_entry(slot->mm_list.next,
-						struct ksm_mm_slot, mm_list);
+	ksm_scan.mm_slot = list_entry(slot->mm_node.next,
+						struct ksm_mm_slot, mm_node);
 	if (ksm_scan.address == 0) {
 		/*
 		 * We've completed a full scan of all vmas, holding mmap_lock
@@ -2379,7 +2379,7 @@ no_vmas:
 		 * mmap_lock then protects against race with MADV_MERGEABLE).
 		 */
 		hash_del(&slot->link);
-		list_del(&slot->mm_list);
+		list_del(&slot->mm_node);
 		spin_unlock(&ksm_mmlist_lock);
 
 		free_mm_slot(slot);
@@ -2428,7 +2428,7 @@ static void ksm_do_scan(unsigned int sca
 
 static int ksmd_should_run(void)
 {
-	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_list);
+	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_node);
 }
 
 static int ksm_scan_thread(void *nothing)
@@ -2525,7 +2525,7 @@ int __ksm_enter(struct mm_struct *mm)
 		return -ENOMEM;
 
 	/* Check ksm_run too?  Would need tighter locking */
-	needs_wakeup = list_empty(&ksm_mm_head.mm_list);
+	needs_wakeup = list_empty(&ksm_mm_head.mm_node);
 
 	spin_lock(&ksm_mmlist_lock);
 	insert_to_mm_slots_hash(mm, mm_slot);
@@ -2540,9 +2540,9 @@ int __ksm_enter(struct mm_struct *mm)
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
@@ -2573,11 +2573,11 @@ void __ksm_exit(struct mm_struct *mm)
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

mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch
mm-introduce-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot.patch
ksm-remove-redundant-declarations-in-ksmh.patch
ksm-add-the-ksm-prefix-to-the-names-of-the-ksm-private-structures.patch
ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch
ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch
ksm-convert-to-use-common-struct-mm_slot.patch


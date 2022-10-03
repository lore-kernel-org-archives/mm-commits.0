Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10740C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiJCVEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiJCVEj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B03AC74
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C17FCE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7EAC433D7;
        Mon,  3 Oct 2022 21:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831074;
        bh=Qnh5ULDOK/xY0nOpZwoCh89DoEk2YjDad4jfXTCGysc=;
        h=Date:To:From:Subject:From;
        b=SEB4c1B6wVEjLK5c8WK1UY640o9B/aE1IIkkWHQac/rA/XpsVaVAOIVzq2/68tI76
         8hr+OcdqmzKvt4DeZojWGNmVopiQ4zjmvmXTTkmGPjheQ3KdLUQYViaxtsMNNH46v4
         bJyEpoJJqtSzHDKFt/fUL5+lpyeiFscpNQeeHUBM=
Date:   Mon, 03 Oct 2022 14:04:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch removed from -mm tree
Message-Id: <20221003210434.8A7EAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: convert ksm_mm_slot.link to ksm_mm_slot.hash
has been removed from the -mm tree.  Its filename was
     ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: ksm: convert ksm_mm_slot.link to ksm_mm_slot.hash
Date: Wed, 31 Aug 2022 11:19:50 +0800

In order to use common struct mm_slot, convert ksm_mm_slot.link to
ksm_mm_slot.hash in advance, no functional change.

Link: https://lkml.kernel.org/r/20220831031951.43152-7-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/ksm.c~ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash
+++ a/mm/ksm.c
@@ -113,13 +113,13 @@
 
 /**
  * struct ksm_mm_slot - ksm information per mm that is being scanned
- * @link: link to the mm_slots hash list
+ * @hash: link to the mm_slots hash list
  * @mm_node: link into the mm_slots list, rooted in ksm_mm_head
  * @rmap_list: head for this mm_slot's singly-linked list of rmap_items
  * @mm: the mm that this information is valid for
  */
 struct ksm_mm_slot {
-	struct hlist_node link;
+	struct hlist_node hash;
 	struct list_head mm_node;
 	struct ksm_rmap_item *rmap_list;
 	struct mm_struct *mm;
@@ -425,7 +425,7 @@ static struct ksm_mm_slot *get_mm_slot(s
 {
 	struct ksm_mm_slot *slot;
 
-	hash_for_each_possible(mm_slots_hash, slot, link, (unsigned long)mm)
+	hash_for_each_possible(mm_slots_hash, slot, hash, (unsigned long)mm)
 		if (slot->mm == mm)
 			return slot;
 
@@ -436,7 +436,7 @@ static void insert_to_mm_slots_hash(stru
 				    struct ksm_mm_slot *mm_slot)
 {
 	mm_slot->mm = mm;
-	hash_add(mm_slots_hash, &mm_slot->link, (unsigned long)mm);
+	hash_add(mm_slots_hash, &mm_slot->hash, (unsigned long)mm);
 }
 
 /*
@@ -1009,7 +1009,7 @@ static int unmerge_and_remove_all_rmap_i
 		ksm_scan.mm_slot = list_entry(mm_slot->mm_node.next,
 						struct ksm_mm_slot, mm_node);
 		if (ksm_test_exit(mm)) {
-			hash_del(&mm_slot->link);
+			hash_del(&mm_slot->hash);
 			list_del(&mm_slot->mm_node);
 			spin_unlock(&ksm_mmlist_lock);
 
@@ -2379,7 +2379,7 @@ no_vmas:
 		 * or when all VM_MERGEABLE areas have been unmapped (and
 		 * mmap_lock then protects against race with MADV_MERGEABLE).
 		 */
-		hash_del(&slot->link);
+		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
 		spin_unlock(&ksm_mmlist_lock);
 
@@ -2573,7 +2573,7 @@ void __ksm_exit(struct mm_struct *mm)
 	mm_slot = get_mm_slot(mm);
 	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
 		if (!mm_slot->rmap_list) {
-			hash_del(&mm_slot->link);
+			hash_del(&mm_slot->hash);
 			list_del(&mm_slot->mm_node);
 			easy_to_free = 1;
 		} else {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-use-update_mmu_tlb-on-the-second-thread.patch
loongarch-update-local-tlb-if-pte-entry-exists.patch


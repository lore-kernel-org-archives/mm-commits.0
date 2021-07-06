Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E77C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAD1961C6C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhGFTNh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhGFTNh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E58661C74;
        Tue,  6 Jul 2021 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598658;
        bh=7EEEH+OtxMkv4OZnQlOceT34WUwrnvHdAVbHx4leqiI=;
        h=Date:From:To:Subject:From;
        b=uDHkNzueeXbCDgGGKCGjJ5tvHu/OButSbR9wmdXBaQXOKVfTaMwutXXZAqQsDvY+q
         IpM1vKmBbeE7A0MKUe2L63OAdLr6RRYyrNfwwUmn1TqQ/kuI8zBjf0nAwDvPOc1N7T
         8p7yxikEl1JBwVl9jJM4gU5KLBnbqk9bWw03iY1s=
Date:   Tue, 06 Jul 2021 12:10:58 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
 removed from -mm tree
Message-ID: <20210706191058.ROhBmKUyf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: move get_swap_page_of_type() under CONFIG_HIBERNATION
has been removed from the -mm tree.  Its filename was
     mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: move get_swap_page_of_type() under CONFIG_HIBERNATION

Patch series "Cleanups for swap", v2.

This series contains just cleanups to remove some unused variables, delete
meaningless forward declarations and so on.  More details can be found in
the respective changelogs.


This patch (of 4):

We should move get_swap_page_of_type() under CONFIG_HIBERNATION since the
only caller of this function is now suspend routine.

[linmiaohe@huawei.com: move scan_swap_map() under CONFIG_HIBERNATION]
  Link: https://lkml.kernel.org/r/20210521070855.2015094-1-linmiaohe@huawei.com
[linmiaohe@huawei.com: fold scan_swap_map() into the only caller get_swap_page_of_type()]
  Link: https://lkml.kernel.org/r/20210527120328.3935132-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210520134022.1370406-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210520134022.1370406-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   83 +++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 52 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-move-get_swap_page_of_type-under-config_hibernation
+++ a/mm/swapfile.c
@@ -453,10 +453,10 @@ static void swap_cluster_schedule_discar
 		unsigned int idx)
 {
 	/*
-	 * If scan_swap_map() can't find a free cluster, it will check
+	 * If scan_swap_map_slots() can't find a free cluster, it will check
 	 * si->swap_map directly. To make sure the discarding cluster isn't
-	 * taken by scan_swap_map(), mark the swap entries bad (occupied). It
-	 * will be cleared after discard
+	 * taken by scan_swap_map_slots(), mark the swap entries bad (occupied).
+	 * It will be cleared after discard
 	 */
 	memset(si->swap_map + idx * SWAPFILE_CLUSTER,
 			SWAP_MAP_BAD, SWAPFILE_CLUSTER);
@@ -589,7 +589,7 @@ static void dec_cluster_info_page(struct
 }
 
 /*
- * It's possible scan_swap_map() uses a free cluster in the middle of free
+ * It's possible scan_swap_map_slots() uses a free cluster in the middle of free
  * cluster list. Avoiding such abuse to avoid list corruption.
  */
 static bool
@@ -1037,21 +1037,6 @@ static void swap_free_cluster(struct swa
 	swap_range_free(si, offset, SWAPFILE_CLUSTER);
 }
 
-static unsigned long scan_swap_map(struct swap_info_struct *si,
-				   unsigned char usage)
-{
-	swp_entry_t entry;
-	int n_ret;
-
-	n_ret = scan_swap_map_slots(si, usage, 1, &entry);
-
-	if (n_ret)
-		return swp_offset(entry);
-	else
-		return 0;
-
-}
-
 int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
 {
 	unsigned long size = swap_entry_size(entry_size);
@@ -1114,14 +1099,14 @@ start_over:
 nextsi:
 		/*
 		 * if we got here, it's likely that si was almost full before,
-		 * and since scan_swap_map() can drop the si->lock, multiple
-		 * callers probably all tried to get a page from the same si
-		 * and it filled up before we could get one; or, the si filled
-		 * up between us dropping swap_avail_lock and taking si->lock.
-		 * Since we dropped the swap_avail_lock, the swap_avail_head
-		 * list may have been modified; so if next is still in the
-		 * swap_avail_head list then try it, otherwise start over
-		 * if we have not gotten any slots.
+		 * and since scan_swap_map_slots() can drop the si->lock,
+		 * multiple callers probably all tried to get a page from the
+		 * same si and it filled up before we could get one; or, the si
+		 * filled up between us dropping swap_avail_lock and taking
+		 * si->lock. Since we dropped the swap_avail_lock, the
+		 * swap_avail_head list may have been modified; so if next is
+		 * still in the swap_avail_head list then try it, otherwise
+		 * start over if we have not gotten any slots.
 		 */
 		if (plist_node_empty(&next->avail_lists[node]))
 			goto start_over;
@@ -1137,30 +1122,6 @@ noswap:
 	return n_ret;
 }
 
-/* The only caller of this function is now suspend routine */
-swp_entry_t get_swap_page_of_type(int type)
-{
-	struct swap_info_struct *si = swap_type_to_swap_info(type);
-	pgoff_t offset;
-
-	if (!si)
-		goto fail;
-
-	spin_lock(&si->lock);
-	if (si->flags & SWP_WRITEOK) {
-		/* This is called for allocating swap entry, not cache */
-		offset = scan_swap_map(si, 1);
-		if (offset) {
-			atomic_long_dec(&nr_swap_pages);
-			spin_unlock(&si->lock);
-			return swp_entry(type, offset);
-		}
-	}
-	spin_unlock(&si->lock);
-fail:
-	return (swp_entry_t) {0};
-}
-
 static struct swap_info_struct *__swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
@@ -1812,6 +1773,24 @@ int free_swap_and_cache(swp_entry_t entr
 }
 
 #ifdef CONFIG_HIBERNATION
+
+swp_entry_t get_swap_page_of_type(int type)
+{
+	struct swap_info_struct *si = swap_type_to_swap_info(type);
+	swp_entry_t entry = {0};
+
+	if (!si)
+		goto fail;
+
+	/* This is called for allocating swap entry, not cache */
+	spin_lock(&si->lock);
+	if ((si->flags & SWP_WRITEOK) && scan_swap_map_slots(si, 1, 1, &entry))
+		atomic_long_dec(&nr_swap_pages);
+	spin_unlock(&si->lock);
+fail:
+	return entry;
+}
+
 /*
  * Find the swap type that corresponds to given device (if any).
  *
@@ -2649,7 +2628,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_lock(&p->lock);
 	drain_mmlist();
 
-	/* wait for anyone still in scan_swap_map */
+	/* wait for anyone still in scan_swap_map_slots */
 	p->highest_bit = 0;		/* cuts scans short */
 	while (p->flags >= SWP_SCANNING) {
 		spin_unlock(&p->lock);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


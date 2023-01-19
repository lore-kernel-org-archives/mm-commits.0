Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE187C678D6
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjASBRm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjASBPl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C76468432
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B858AB81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600F2C433EF;
        Thu, 19 Jan 2023 01:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090889;
        bh=WG9pjIi7kqLAIsFYICho+KnZUK/wgcw7DG/f1WKr24w=;
        h=Date:To:From:Subject:From;
        b=m8T2Tzi1uinAcdxNgvnMmxx6RaJxRsRTIMSALp+TPqC6nFgjfuTrRp3L5nLrEqI++
         RUThhXt8mPDKf9Y8bthnNPi+eOwgL63GjT55BHUk7njawBmzll0mVW948Y4wR/1IyL
         kjeTBQLRvQEK4mIvnvrpRLt2KG8CZS4oW1faFBTQ=
Date:   Wed, 18 Jan 2023 17:14:48 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, linmiaohe@huawei.com, hughd@google.com,
        david@redhat.com, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch removed from -mm tree
Message-Id: <20230119011449.600F2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: avoid holding swap reference in swap_cache_get_folio
has been removed from the -mm tree.  Its filename was
     swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: swap: avoid holding swap reference in swap_cache_get_folio
Date: Tue, 20 Dec 2022 02:58:40 +0800

All its callers either already hold a reference to, or lock the swap
device while calling this function.  There is only one exception in
shmem_swapin_folio, just make this caller also hold a reference of the
swap device, so this helper can be simplified and saves a few cycles.

This also provides finer control of error handling in shmem_swapin_folio,
on race (with swap off), it can just try again.  For invalid swap entry,
it can fail with a proper error code.

Link: https://lkml.kernel.org/r/20221219185840.25441-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c      |   11 +++++++++++
 mm/swap_state.c |    8 ++------
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~swap-avoid-holding-swap-reference-in-swap_cache_get_folio
+++ a/mm/shmem.c
@@ -1739,6 +1739,7 @@ static int shmem_swapin_folio(struct ino
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
+	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
 	int error;
@@ -1750,6 +1751,14 @@ static int shmem_swapin_folio(struct ino
 	if (is_swapin_error_entry(swap))
 		return -EIO;
 
+	si = get_swap_device(swap);
+	if (!si) {
+		if (!shmem_confirm_swap(mapping, index, swap))
+			return -EEXIST;
+		else
+			return -EINVAL;
+	}
+
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
@@ -1810,6 +1819,7 @@ static int shmem_swapin_folio(struct ino
 	delete_from_swap_cache(folio);
 	folio_mark_dirty(folio);
 	swap_free(swap);
+	put_swap_device(si);
 
 	*foliop = folio;
 	return 0;
@@ -1823,6 +1833,7 @@ unlock:
 		folio_unlock(folio);
 		folio_put(folio);
 	}
+	put_swap_device(si);
 
 	return error;
 }
--- a/mm/swap_state.c~swap-avoid-holding-swap-reference-in-swap_cache_get_folio
+++ a/mm/swap_state.c
@@ -321,19 +321,15 @@ static inline bool swap_use_vma_readahea
  * unlocked and with its refcount incremented - we rely on the kernel
  * lock getting page table operations atomic even if we drop the folio
  * lock before returning.
+ *
+ * Caller must lock the swap device or hold a reference to keep it valid.
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct folio *folio;
-	struct swap_info_struct *si;
 
-	si = get_swap_device(entry);
-	if (!si)
-		return NULL;
 	folio = filemap_get_folio(swap_address_space(entry), swp_offset(entry));
-	put_swap_device(si);
-
 	if (folio) {
 		bool vma_ra = swap_use_vma_readahead();
 		bool readahead;
_

Patches currently in -mm which might be from kasong@tencent.com are



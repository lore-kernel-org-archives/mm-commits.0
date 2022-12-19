Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C06C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 20:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiLSUOf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 15:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLSUOd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 15:14:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D841BE36
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 12:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43496B8101D
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 20:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9E6C433D2;
        Mon, 19 Dec 2022 20:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671480870;
        bh=5+4z33IWMXzh68CtQqKrBdS3afPacN1NivXs5IaFjUQ=;
        h=Date:To:From:Subject:From;
        b=Vc4jKUg/jUZs3A86jFjDPTksdgOJ+mBu7SeNQv3QObwEUqFVUywkwOJuC5USvCWpW
         jjcaz44W2+CliWk+jgCvXnxc/KBi0I5tGctRc4StY79RVCVezZjZmrcMG8bCa3AaaD
         52Xp0NMNcmEg6lvPBFXVU9DuOtu4AXhTOeCPPR+U=
Date:   Mon, 19 Dec 2022 12:14:29 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, linmiaohe@huawei.com, hughd@google.com,
        david@redhat.com, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch added to mm-unstable branch
Message-Id: <20221219201429.DE9E6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: avoid holding swap reference in swap_cache_get_folio
has been added to the -mm mm-unstable branch.  Its filename is
     swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch

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
@@ -1741,6 +1741,7 @@ static int shmem_swapin_folio(struct ino
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
+	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
 	int error;
@@ -1752,6 +1753,14 @@ static int shmem_swapin_folio(struct ino
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
@@ -1812,6 +1821,7 @@ static int shmem_swapin_folio(struct ino
 	delete_from_swap_cache(folio);
 	folio_mark_dirty(folio);
 	swap_free(swap);
+	put_swap_device(si);
 
 	*foliop = folio;
 	return 0;
@@ -1825,6 +1835,7 @@ unlock:
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

swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch
swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch
swap-fold-swap_ra_clamp_pfn-into-swap_ra_info.patch
swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch


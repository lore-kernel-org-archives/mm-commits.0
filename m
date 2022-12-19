Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF642C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 20:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiLSUOa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 15:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLSUO2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 15:14:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A4210A2
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 12:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8053B80E18
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 20:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9376DC433D2;
        Mon, 19 Dec 2022 20:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671480863;
        bh=ADVUTPJ2r6gBn2i9c3ZyG8FCAoTx3qSoe6JSBqKVtTk=;
        h=Date:To:From:Subject:From;
        b=f6a/1Jp5zYz1srjHyGin4E6LoITyJT49evwa3xl6Hh6UCgXGN5hvWejm3yrgbEUsj
         Y4fmMdxEwaaPMi3+mWyngNrvzziGmEeh0mFyGM38L7oR+Q0gp+RwUlFjbTIqfIbRJP
         J4fWSW09m7u8hyRRy209AAXbKvffBJ+tRLnPPGR0=
Date:   Mon, 19 Dec 2022 12:14:22 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, linmiaohe@huawei.com, hughd@google.com,
        david@redhat.com, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch added to mm-unstable branch
Message-Id: <20221219201423.9376DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: get rid of volatile and avoid redundant read
has been added to the -mm mm-unstable branch.  Its filename is
     swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch

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
Subject: swapfile: get rid of volatile and avoid redundant read
Date: Tue, 20 Dec 2022 02:58:37 +0800

Patch series "Clean up and fixes for swap", v2.

This series cleans up some code paths, saves a few cycles and reduces the
object size by a bit.  It also fixes some rare race issue with statistics.


This patch (of 4):

Convert a volatile variable to more readable READ_ONCE.  And this actually
avoids the code from reading the variable twice redundantly when it races.

Link: https://lkml.kernel.org/r/20221219185840.25441-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20221219185840.25441-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~swapfile-get-rid-of-volatile-and-avoid-redundant-read
+++ a/mm/swapfile.c
@@ -1843,13 +1843,13 @@ static int unuse_pte_range(struct vm_are
 	pte_t *pte;
 	struct swap_info_struct *si;
 	int ret = 0;
-	volatile unsigned char *swap_map;
 
 	si = swap_info[type];
 	pte = pte_offset_map(pmd, addr);
 	do {
 		struct folio *folio;
 		unsigned long offset;
+		unsigned char swp_count;
 
 		if (!is_swap_pte(*pte))
 			continue;
@@ -1860,7 +1860,6 @@ static int unuse_pte_range(struct vm_are
 
 		offset = swp_offset(entry);
 		pte_unmap(pte);
-		swap_map = &si->swap_map[offset];
 		folio = swap_cache_get_folio(entry, vma, addr);
 		if (!folio) {
 			struct page *page;
@@ -1877,8 +1876,10 @@ static int unuse_pte_range(struct vm_are
 				folio = page_folio(page);
 		}
 		if (!folio) {
-			if (*swap_map == 0 || *swap_map == SWAP_MAP_BAD)
+			swp_count = READ_ONCE(si->swap_map[offset]);
+			if (swp_count == 0 || swp_count == SWAP_MAP_BAD)
 				goto try_next;
+
 			return -ENOMEM;
 		}
 
_

Patches currently in -mm which might be from kasong@tencent.com are

swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch
swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch
swap-fold-swap_ra_clamp_pfn-into-swap_ra_info.patch
swap-avoid-holding-swap-reference-in-swap_cache_get_folio.patch


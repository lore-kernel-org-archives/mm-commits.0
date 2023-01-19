Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF8EC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjASBRh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjASBPc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C3D68400
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 750C061B08
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D077BC433EF;
        Thu, 19 Jan 2023 01:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090884;
        bh=c+7M1jr8h018/8eysl9UzUaQOLokujiIZRknNhkisGU=;
        h=Date:To:From:Subject:From;
        b=e1Rz55VdP5NUDuwL0iisIw67tL4ZOMwbUeYTrC68SXTWmDIJBv0QKRI0jgkVqOC00
         byVxBnoVFR9AR85OwGb9N3ubqSF7IfButuhuEgyPld5t9b2jkc2/MSpB5GaidpR0bK
         qXenT/A8CdZJnY1xCB/NMnJoKawiwV6d5SStsVME=
Date:   Wed, 18 Jan 2023 17:14:44 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, linmiaohe@huawei.com, hughd@google.com,
        david@redhat.com, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch removed from -mm tree
Message-Id: <20230119011444.D077BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swapfile: get rid of volatile and avoid redundant read
has been removed from the -mm tree.  Its filename was
     swapfile-get-rid-of-volatile-and-avoid-redundant-read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1835,13 +1835,13 @@ static int unuse_pte_range(struct vm_are
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
@@ -1852,7 +1852,6 @@ static int unuse_pte_range(struct vm_are
 
 		offset = swp_offset(entry);
 		pte_unmap(pte);
-		swap_map = &si->swap_map[offset];
 		folio = swap_cache_get_folio(entry, vma, addr);
 		if (!folio) {
 			struct page *page;
@@ -1869,8 +1868,10 @@ static int unuse_pte_range(struct vm_are
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



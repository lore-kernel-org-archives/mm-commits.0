Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE18C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjASBRf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjASBPc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68429577EB
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 024A861B18
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC8CC433EF;
        Thu, 19 Jan 2023 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090886;
        bh=nb84coc7tf3E97MYmWrLyynikqUHf5fUOFXxjp8/vAM=;
        h=Date:To:From:Subject:From;
        b=WBbub48Tj5oIKrG2O5pHVlJh5tC/BY9asXG6J+XbzdaGUpvQETXq/Km46r0DN8Aq/
         Fgs7sj5SAv2zoVWdFTCdZpUX6J/Y0thJg32cfWu1AzObJwVTtFyykg4DmQbGVsmKdu
         3B5IMAm4cnm8u49ePfGDR4Xaz1MK6agg8Q4sqGCA=
Date:   Wed, 18 Jan 2023 17:14:45 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, linmiaohe@huawei.com, hughd@google.com,
        david@redhat.com, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch removed from -mm tree
Message-Id: <20230119011446.5BC8CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: avoid a redundant pte map if ra window is 1
has been removed from the -mm tree.  Its filename was
     swap-avoid-a-redundant-pte-map-if-ra-window-is-1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: swap: avoid a redundant pte map if ra window is 1
Date: Tue, 20 Dec 2022 02:58:38 +0800

Avoid a redundant pte map/unmap when swap readahead window is 1.

Link: https://lkml.kernel.org/r/20221219185840.25441-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/swap_state.c~swap-avoid-a-redundant-pte-map-if-ra-window-is-1
+++ a/mm/swap_state.c
@@ -727,8 +727,6 @@ static void swap_ra_info(struct vm_fault
 	}
 
 	faddr = vmf->address;
-	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
-
 	fpfn = PFN_DOWN(faddr);
 	ra_val = GET_SWAP_RA_VAL(vma);
 	pfn = PFN_DOWN(SWAP_RA_ADDR(ra_val));
@@ -739,12 +737,11 @@ static void swap_ra_info(struct vm_fault
 	atomic_long_set(&vma->swap_readahead_info,
 			SWAP_RA_VAL(faddr, win, 0));
 
-	if (win == 1) {
-		pte_unmap(orig_pte);
+	if (win == 1)
 		return;
-	}
 
 	/* Copy the PTEs because the page table may be unmapped */
+	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
 	if (fpfn == pfn + 1)
 		swap_ra_clamp_pfn(vma, faddr, fpfn, fpfn + win, &start, &end);
 	else if (pfn == fpfn + 1)
_

Patches currently in -mm which might be from kasong@tencent.com are



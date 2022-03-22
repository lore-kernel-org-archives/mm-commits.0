Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1754C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiCVVsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiCVVr7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B75B5F8F7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA13D6119A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E2AC340EC;
        Tue, 22 Mar 2022 21:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985572;
        bh=1ms0A4CRfbE+q+WFuovPaSOgayD/+vzxjQilvcPcAH4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jhKGz1weAcvN1OjR4QHCsvWBLJ56SZz2uJxcpHltSp0LprHZZDx4wHWEDkCHVTYMV
         vz+UqA0RbTzggObouoddRUjH4xCgGx+X0Rz9GB+nZ4AiPPwf1DZgzhf6vUhLOvRusy
         RlWy5BTRfV3+/e68FlE/ZhwC7CeA6zawpEI6qPq8=
Date:   Tue, 22 Mar 2022 14:46:11 -0700
To:     ziy@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 151/227] mm/thp: refix __split_huge_pmd_locked() for migration PMD
Message-Id: <20220322214612.09E2AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: refix __split_huge_pmd_locked() for migration PMD

Migration entries do not contribute to a page's reference count: move
__split_huge_pmd_locked()'s page_ref_add() into pmd_migration's else block
(along with the page_count() check - a page is quite likely to have
reference count frozen to 0 when a migration entry is found).

This will fix a very rare anonymous memory leak, after a split_huge_pmd()
raced with an anon split_huge_page() or an anon THP migrate_pages(): since
the wrongly raised refcount stopped the page (perhaps small, perhaps huge,
depending on when the race hit) from ever being freed.  At first I thought
there were worse risks, from prematurely unfreezing a frozen page: but now
think that would only affect page cache pages, which do not come this way
(except for anonymous pages in swap cache, perhaps).

Link: https://lkml.kernel.org/r/84792468-f512-e48f-378c-e34c3641e97@google.com
Fixes: ec0abae6dcdf ("mm/thp: fix __split_huge_pmd_locked() for migration PMD")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd
+++ a/mm/huge_memory.c
@@ -2055,9 +2055,9 @@ static void __split_huge_pmd_locked(stru
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
 		uffd_wp = pmd_uffd_wp(old_pmd);
+		VM_BUG_ON_PAGE(!page_count(page), page);
+		page_ref_add(page, HPAGE_PMD_NR - 1);
 	}
-	VM_BUG_ON_PAGE(!page_count(page), page);
-	page_ref_add(page, HPAGE_PMD_NR - 1);
 
 	/*
 	 * Withdraw the table only after we mark the pmd entry invalid.
_

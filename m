Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8244DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiANWFW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58282 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiANWFT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B72DB825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0404C36AE9;
        Fri, 14 Jan 2022 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197917;
        bh=gN5DsMeAdSGJoe2owBHk09Ta8KpskfveIu7mEDq0Ux4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LCU6z3cA68spkFXerZ5eXcSjJuTkOsHZAfKiwnq9t/SEyA6skrZ2kQjZiLKQo7U56
         fgGM4ydJB/pa0P5u8uUqiSyS8njJGqzTZDF6kBKpw74DRlE36ZYHVwPo4w/jdQ5OyE
         zovxCG71xZl7/WTSfIpHFY+QdpeWVu25QLI2fqoA=
Date:   Fri, 14 Jan 2022 14:05:16 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, lixinhai.lxh@gmail.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 044/146] mm/gup.c: stricter check on THP migration
 entry during follow_pmd_mask
Message-ID: <20220114220516.9_DFP1Inz%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/gup.c: stricter check on THP migration entry during follow_pmd_mask

When BUG_ON check for THP migration entry, the existing code only check
thp_migration_supported case, but not for !thp_migration_supported case. 
If !thp_migration_supported() and !pmd_present(), the original code may
dead loop in theory.  To make the BUG_ON check consistent, we need catch
both cases.

Move the BUG_ON check one step earlier, because if the bug happen we
should know it instead of depend on FOLL_MIGRATION been used by caller.

Because pmdval instead of *pmd is read by the is_pmd_migration_entry()
check, the existing code don't help to avoid useless locking within
pmd_migration_entry_wait(), so remove that check.

Link: https://lkml.kernel.org/r/20211217062559.737063-1-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask
+++ a/mm/gup.c
@@ -642,12 +642,17 @@ static struct page *follow_pmd_mask(stru
 	}
 retry:
 	if (!pmd_present(pmdval)) {
+		/*
+		 * Should never reach here, if thp migration is not supported;
+		 * Otherwise, it must be a thp migration entry.
+		 */
+		VM_BUG_ON(!thp_migration_supported() ||
+				  !is_pmd_migration_entry(pmdval));
+
 		if (likely(!(flags & FOLL_MIGRATION)))
 			return no_page_table(vma, flags);
-		VM_BUG_ON(thp_migration_supported() &&
-				  !is_pmd_migration_entry(pmdval));
-		if (is_pmd_migration_entry(pmdval))
-			pmd_migration_entry_wait(mm, pmd);
+
+		pmd_migration_entry_wait(mm, pmd);
 		pmdval = READ_ONCE(*pmd);
 		/*
 		 * MADV_DONTNEED may convert the pmd to null because
_

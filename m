Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8463C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbiATVYq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57102 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347632AbiATVYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A208B81E66
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB0AC340E0;
        Thu, 20 Jan 2022 21:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713883;
        bh=q2p/jA1KAORlc8SFZn//hrOwY/UAn+ygkH5RUFxHjv8=;
        h=Date:From:To:Subject:From;
        b=i2U9vAa7vnAYJruQHdzHKopu8qMYpq1oIcOX7XBV758HJ3FlWQ3q4I6NuAulI4CQe
         FMRXP2yTHOhy8FHEWfShoIyITP7mvmWKtyfpjMMzZlQoZ5lXCveKCOD27OMnjKk9tg
         iVBed1I+GWrgpgL4vwNKaOjEf2LRedZ41RcTyopU=
Date:   Thu, 20 Jan 2022 13:24:43 -0800
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask.patch
 removed from -mm tree
Message-ID: <20220120212443.2pce8mODP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: stricter check on THP migration entry during follow_pmd_mask
has been removed from the -mm tree.  Its filename was
     mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACABC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 22 Dec 2021 04:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhLVE2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 23:28:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44304 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbhLVE2t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 23:28:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3885617D4
        for <mm-commits@vger.kernel.org>; Wed, 22 Dec 2021 04:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04884C36AE5;
        Wed, 22 Dec 2021 04:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640147328;
        bh=rd6q4epqN8/5NtUWX2Ad/8RKL4FCnANYT5kuCAlB3pE=;
        h=Date:From:To:Subject:From;
        b=YHilUMqzkR3eCfnYhXsnRsLFFc8oGVLgOedxa1l3864bKHd4JEosohBt2/idQMgQS
         +Ga7dIfLaRFaf0Gws/Cc+t0Wjaj3Gi+E7NaCcumbXcWmXpdQV8KIa/dbnRjCPPhsx6
         xhQpLEZbyeiqAgJbP3TL3qRrd5vD0lOhbvyrMxok=
Date:   Tue, 21 Dec 2021 20:28:47 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        lixinhai.lxh@gmail.com
Subject:  +
 mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask.patch
 added to -mm tree
Message-ID: <20211222042847.ZPIWa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: stricter check on THP migration entry during follow_pmd_mask
has been added to the -mm tree.  Its filename is
     mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gupc-stricter-check-on-thp-migration-entry-during-follow_pmd_mask.patch


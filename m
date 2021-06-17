Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92406C48BE8
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 01:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60CC3613DD
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 01:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhFQBC6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 21:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231628AbhFQBC6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 21:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96905613D5;
        Thu, 17 Jun 2021 01:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623891650;
        bh=c0SIEMMoK9BAYvIXyubHrXQp1uXqiZxghmrL32qqQa0=;
        h=Date:From:To:Subject:From;
        b=Eb7OchwfsKWKr3XY0KSWfEvSLemZrWr6uqLm3MzARXXv129SOn7tgcwe9viE/SRXU
         MENrbX6r8N3ZaDlN+uItwqy8XvoxxY3LM5cXjAWB8oy/l9XU0S5uLYctGLNgvMowlg
         Dk2vxrrcfEK6YH9VwgK+5/q2YWLBF3WrKmyl4JPw=
Date:   Wed, 16 Jun 2021 18:00:50 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org
Subject:  +
 mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch added to -mm
 tree
Message-ID: <20210617010050.RhoHRs5uU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_vma_mapped_walk(): add a level of indentation fix
has been added to the -mm tree.  Its filename is
     mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page_vma_mapped_walk(): add a level of indentation fix

add a tab to the READ_ONCE line in the indentation patch.

Link: https://lkml.kernel.org/r/7f817555-3ce1-c785-e438-87d8efdcaf26@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped_walk-add-a-level-of-indentation-fix
+++ a/mm/page_vma_mapped.c
@@ -190,7 +190,7 @@ restart:
 		 * compiler and used as a stale value after we've observed a
 		 * subsequent update.
 		 */
-	pmde = READ_ONCE(*pvmw->pmd);
+		pmde = READ_ONCE(*pvmw->pmd);
 
 		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch
mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch
mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch
mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch
mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch
mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch


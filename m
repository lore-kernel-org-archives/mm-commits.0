Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF43C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E2960F41
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 20:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhHQULW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Aug 2021 16:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233763AbhHQULW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 17 Aug 2021 16:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9FEE61053;
        Tue, 17 Aug 2021 20:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629231048;
        bh=dO3KhDKgfXbfKroy0LEVV+RxaPWzXAuYTBFvPNYx/6Y=;
        h=Date:From:To:Subject:From;
        b=m6As5iestTpUwIKj0PeZaO4Y1mP1TQC0s3rK6XQ89CIoMqdgCn04mj6mxl4bVnchC
         3WQRGaJiBnlY6JBOplcYkS0c7+iuwQPqtk0HbGVU9TMwS11HCXSbisMBeed/f9Ns/v
         aLcw/kpIdxLP8Py5cViv01Ek5vz12ibaN9Vqw7TI=
Date:   Tue, 17 Aug 2021 13:10:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        mike.kravetz@oracle.com, mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, hughd@google.com
Subject:  +
 huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch added to -mm
 tree
Message-ID: <20210817201048.r2EhE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: remove shrinklist addition from shmem_setattr()
has been added to the -mm tree.  Its filename is
     huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch

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
Subject: huge tmpfs: remove shrinklist addition from shmem_setattr()

There's a block of code in shmem_setattr() to add the inode to
shmem_unused_huge_shrink()'s shrinklist when lowering i_size: it dates
from before 5.7 changed truncation to do split_huge_page() for itself, and
should have been removed at that time.

I am over-stating that: split_huge_page() can fail (notably if there's an
extra reference to the page at that time), so there might be value in
retrying.  But there were already retries as truncation worked through the
tails, and this addition risks repeating unsuccessful retries
indefinitely: I'd rather remove it now, and work on reducing the chance of
split_huge_page() failures separately, if we need to.

Link: https://lkml.kernel.org/r/b73b3492-8822-18f9-83e2-938528cdde94@google.com
Fixes: 71725ed10c40 ("mm: huge tmpfs: try to split_huge_page() when punching hole")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/mm/shmem.c~huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr
+++ a/mm/shmem.c
@@ -1058,7 +1058,6 @@ static int shmem_setattr(struct user_nam
 {
 	struct inode *inode = d_inode(dentry);
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	int error;
 
 	error = setattr_prepare(&init_user_ns, dentry, attr);
@@ -1094,24 +1093,6 @@ static int shmem_setattr(struct user_nam
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-
-			/*
-			 * Part of the huge page can be beyond i_size: subject
-			 * to shrink under memory pressure.
-			 */
-			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-				spin_lock(&sbinfo->shrinklist_lock);
-				/*
-				 * _careful to defend against unlocked access to
-				 * ->shrink_list in shmem_unused_huge_shrink()
-				 */
-				if (list_empty_careful(&info->shrinklist)) {
-					list_add_tail(&info->shrinklist,
-							&sbinfo->shrinklist);
-					sbinfo->shrinklist_len++;
-				}
-				spin_unlock(&sbinfo->shrinklist_lock);
-			}
 		}
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

fs-mm-fix-race-in-unlinking-swapfile.patch
huge-tmpfs-fix-fallocatevanilla-advance-over-huge-pages.patch
huge-tmpfs-fix-split_huge_page-after-falloc_fl_keep_size.patch
huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch
huge-tmpfs-revert-shmems-use-of-transhuge_vma_enabled.patch
huge-tmpfs-move-shmem_huge_enabled-upwards.patch
huge-tmpfs-sgp_noalloc-to-stop-collapse_file-on-race.patch
huge-tmpfs-shmem_is_hugevma-inode-index.patch
huge-tmpfs-decide-statst_blksize-by-shmem_is_huge.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch


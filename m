Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE519C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D6D610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350341AbhICU6A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350309AbhICU57 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A943660E9B;
        Fri,  3 Sep 2021 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702619;
        bh=m5/gIi1Zh7AP+iApmhnBtBcDdwRQzrHGVCQiJ3SZ5p4=;
        h=Date:From:To:Subject:From;
        b=UoWQvCbFQwyP+K5ZEjifDs6Vawewl00A/AE/nV/+WAN6aKIhikEFev4IUW2JDxddl
         wtkn5epMeaXBW9X/rWzGiQySkxrZZfURTGYKRpvcbvD6yIFzOH2W2qoGpjwcc0G0CQ
         nw1giwRg4qqXRhUoTlNcAywcLnLJFFOqD+Bp6JFQ=
Date:   Fri, 03 Sep 2021 13:56:58 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  [merged]
 huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch removed from
 -mm tree
Message-ID: <20210903205658.jst3a-CGS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: remove shrinklist addition from shmem_setattr()
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-remove-shrinklist-addition-from-shmem_setattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



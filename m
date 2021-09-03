Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB37C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37FC3610F9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350427AbhICU6R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350386AbhICU6L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF1760E9B;
        Fri,  3 Sep 2021 20:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702631;
        bh=Zs/+HYGrWWe5yL4ZEGcOv/30nJksbNJ0v/XM5otJ7c4=;
        h=Date:From:To:Subject:From;
        b=hDowQoqBbEvXkI0MgXcIYnYXjBfEBiCelrTbo+ACDy09IxO6D5N+T5lkU0ry16KAA
         1BPwybbKwVFYt4HxgNBxjY2ADv7yeTC+THbC8sGLWy1ngBM3VJ0AJB4JU7lZnEx+WA
         YqTCgkxClHZCg1u6jtLpZNCDI8qVOOilu5HzEEB4=
Date:   Fri, 03 Sep 2021 13:57:10 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  [merged]
 huge-tmpfs-decide-statst_blksize-by-shmem_is_huge.patch removed from -mm
 tree
Message-ID: <20210903205710.k_h0JRWSF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: decide stat.st_blksize by shmem_is_huge()
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-decide-statst_blksize-by-shmem_is_huge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: decide stat.st_blksize by shmem_is_huge()

4.18 commit 89fdcd262fd4 ("mm: shmem: make stat.st_blksize return huge
page size if THP is on") added is_huge_enabled() to decide st_blksize: if
hugeness is to be defined per file, that will need to be replaced by
shmem_is_huge().

This does give a different answer (No) for small files on a
"huge=within_size" mount: but that can be considered a minor bugfix.  And
a different answer (No) for default files on a "huge=advise" mount: I'm
reluctant to complicate it, just to reproduce the same debatable answer as
before.

Link: https://lkml.kernel.org/r/af7fb3f9-4415-9e8e-fdac-b1a5253ad21@google.com
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

 mm/shmem.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/shmem.c~huge-tmpfs-decide-statst_blksize-by-shmem_is_huge
+++ a/mm/shmem.c
@@ -686,15 +686,6 @@ static unsigned long shmem_unused_huge_s
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline bool is_huge_enabled(struct shmem_sb_info *sbinfo)
-{
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    (shmem_huge == SHMEM_HUGE_FORCE || sbinfo->huge) &&
-	    shmem_huge != SHMEM_HUGE_DENY)
-		return true;
-	return false;
-}
-
 /*
  * Like add_to_page_cache_locked, but error if expected item has gone.
  */
@@ -1075,7 +1066,6 @@ static int shmem_getattr(struct user_nam
 {
 	struct inode *inode = path->dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct shmem_sb_info *sb_info = SHMEM_SB(inode->i_sb);
 
 	if (info->alloced - info->swapped != inode->i_mapping->nrpages) {
 		spin_lock_irq(&info->lock);
@@ -1084,7 +1074,7 @@ static int shmem_getattr(struct user_nam
 	}
 	generic_fillattr(&init_user_ns, inode, stat);
 
-	if (is_huge_enabled(sb_info))
+	if (shmem_is_huge(NULL, inode, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	return 0;
_

Patches currently in -mm which might be from hughd@google.com are



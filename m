Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E396C43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB19610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347885AbhIBVzp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347864AbhIBVzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09138610F7;
        Thu,  2 Sep 2021 21:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619681;
        bh=WrKZBF7y5mn7jJFKB9osVDlRzs/iMDMYbP29S04QXQU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cA5n4i1M4y/b5m7YR/Omdkind/XVgYncvl/QRP8msq8G+EEUwW0fgjn/wH9//VOdB
         z2HcLpQjI8hPPzR/frGNHVRWLOv1tcdvtIAvuubbK59Btrn6Eyuw2b9VigF8jvwU92
         zyau0Aj+chIwF8v93wCWkKnqKl375tB7hXT0/gfQ=
Date:   Thu, 02 Sep 2021 14:54:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 090/212] huge tmpfs: decide stat.st_blksize by
 shmem_is_huge()
Message-ID: <20210902215440.KSFJ7L5eD%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

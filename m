Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD77CC43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5BC610CE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347874AbhIBVzk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347636AbhIBVzV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5DB460F12;
        Thu,  2 Sep 2021 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619662;
        bh=HhmaLmvemuOtAZlPpcv0b4HuxWX5jyOKV36R1lt2PTk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EO/00R8p3lNG8G+VFoTEf7JDDszsy3/ivoYUZY8AY9UZhoNK38Q4DuKGFl6mJdEYl
         jonMJGQy4v7G5vh1aWl2fT9JW5RudbKlz5Df0cOVMGZ26nALcOnDhVLwmO4LSSGuRG
         hwtPjpb0Xm5DfnTxY+UkwgBioJTPskm+UmTwvqZ0=
Date:   Thu, 02 Sep 2021 14:54:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 084/212] huge tmpfs: fix split_huge_page() after
 FALLOC_FL_KEEP_SIZE
Message-ID: <20210902215421.QwylkKaVJ%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: fix split_huge_page() after FALLOC_FL_KEEP_SIZE

A successful shmem_fallocate() guarantees that the extent has been
reserved, even beyond i_size when the FALLOC_FL_KEEP_SIZE flag was used. 
But that guarantee is broken by shmem_unused_huge_shrink()'s attempts to
split huge pages and free their excess beyond i_size; and by other uses of
split_huge_page() near i_size.

It's sad to add a shmem inode field just for this, but I did not find a
better way to keep the guarantee.  A flag to say KEEP_SIZE has been used
would be cheaper, but I'm averse to unclearable flags.  The fallocend
field is not perfect either (many disjoint ranges might be fallocated),
but good enough; and gains another use later on.

Link: https://lkml.kernel.org/r/ca9a146-3a59-6cd3-7f28-e9a044bb1052@google.com
Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
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

 include/linux/shmem_fs.h |   13 +++++++++++++
 mm/huge_memory.c         |    6 ++++--
 mm/shmem.c               |   15 ++++++++++++++-
 3 files changed, 31 insertions(+), 3 deletions(-)

--- a/include/linux/shmem_fs.h~huge-tmpfs-fix-split_huge_page-after-falloc_fl_keep_size
+++ a/include/linux/shmem_fs.h
@@ -18,6 +18,7 @@ struct shmem_inode_info {
 	unsigned long		flags;
 	unsigned long		alloced;	/* data pages alloced to file */
 	unsigned long		swapped;	/* subtotal assigned to swap */
+	pgoff_t			fallocend;	/* highest fallocate endindex */
 	struct list_head        shrinklist;     /* shrinkable hpage inodes */
 	struct list_head	swaplist;	/* chain of maybes on swap */
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
@@ -119,6 +120,18 @@ static inline bool shmem_file(struct fil
 	return shmem_mapping(file->f_mapping);
 }
 
+/*
+ * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
+ * beyond i_size's notion of EOF, which fallocate has committed to reserving:
+ * which split_huge_page() must therefore not delete.  This use of a single
+ * "fallocend" per inode errs on the side of not deleting a reservation when
+ * in doubt: there are plenty of cases when it preserves unreserved pages.
+ */
+static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
+{
+	return max(eof, SHMEM_I(inode)->fallocend);
+}
+
 extern bool shmem_charge(struct inode *inode, long pages);
 extern void shmem_uncharge(struct inode *inode, long pages);
 
--- a/mm/huge_memory.c~huge-tmpfs-fix-split_huge_page-after-falloc_fl_keep_size
+++ a/mm/huge_memory.c
@@ -2454,11 +2454,11 @@ static void __split_huge_page(struct pag
 
 	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
-		/* Some pages can be beyond i_size: drop them from page cache */
+		/* Some pages can be beyond EOF: drop them from page cache */
 		if (head[i].index >= end) {
 			ClearPageDirty(head + i);
 			__delete_from_page_cache(head + i, NULL);
-			if (IS_ENABLED(CONFIG_SHMEM) && PageSwapBacked(head))
+			if (shmem_mapping(head->mapping))
 				shmem_uncharge(head->mapping->host, 1);
 			put_page(head + i);
 		} else if (!PageAnon(page)) {
@@ -2686,6 +2686,8 @@ int split_huge_page_to_list(struct page
 		 * head page lock is good enough to serialize the trimming.
 		 */
 		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+		if (shmem_mapping(mapping))
+			end = shmem_fallocend(mapping->host, end);
 	}
 
 	/*
--- a/mm/shmem.c~huge-tmpfs-fix-split_huge_page-after-falloc_fl_keep_size
+++ a/mm/shmem.c
@@ -902,6 +902,9 @@ static void shmem_undo_range(struct inod
 	if (lend == -1)
 		end = -1;	/* unsigned, so actually very big */
 
+	if (info->fallocend > start && info->fallocend <= end && !unfalloc)
+		info->fallocend = start;
+
 	pagevec_init(&pvec);
 	index = start;
 	while (index < end && find_lock_entries(mapping, index, end - 1,
@@ -2650,7 +2653,7 @@ static long shmem_fallocate(struct file
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_falloc shmem_falloc;
-	pgoff_t start, index, end;
+	pgoff_t start, index, end, undo_fallocend;
 	int error;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -2719,6 +2722,15 @@ static long shmem_fallocate(struct file
 	inode->i_private = &shmem_falloc;
 	spin_unlock(&inode->i_lock);
 
+	/*
+	 * info->fallocend is only relevant when huge pages might be
+	 * involved: to prevent split_huge_page() freeing fallocated
+	 * pages when FALLOC_FL_KEEP_SIZE committed beyond i_size.
+	 */
+	undo_fallocend = info->fallocend;
+	if (info->fallocend < end)
+		info->fallocend = end;
+
 	for (index = start; index < end; ) {
 		struct page *page;
 
@@ -2733,6 +2745,7 @@ static long shmem_fallocate(struct file
 		else
 			error = shmem_getpage(inode, index, &page, SGP_FALLOC);
 		if (error) {
+			info->fallocend = undo_fallocend;
 			/* Remove the !PageUptodate pages we added */
 			if (index > start) {
 				shmem_undo_range(inode,
_

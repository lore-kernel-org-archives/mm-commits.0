Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C299C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42244224B1
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgLODGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727294AbgLODGa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:30 -0500
Date:   Mon, 14 Dec 2020 19:06:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001575;
        bh=wWVq71+PT5XlLPpUfE1O3S4J1hPGEJHflU3nIIEOklw=;
        h=From:To:Subject:In-Reply-To:From;
        b=Wh5LWFRgt4l2pSia29lOltBxefT24EejbQU4atDu2FnMmuBnLX3gOp6FxOWBf7Nmq
         wNUSzIgvGKGNEn6Y653YxeGIZUnQul4R1m+uDwhar6iPzTzBLhEv0PG2oxGLrn1iKN
         JST/8+cjPp1OTyVJt39n2IHmlIWQKCTFwKqcuypc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sh_def@163.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 053/200] mm/shmem.c: make shmem_mapping() inline
Message-ID: <20201215030614.Vg9QZ3vO8%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/shmem.c: make shmem_mapping() inline

shmem_mapping() isn't worth an out-of-line call from any callsite.

So make it inline by
- make shmem_aops global
- export shmem_aops
- inline the shmem_mapping()

and replace the direct call 'shmem_aops' with shmem_mapping()
in shmem.c.

Link: https://lkml.kernel.org/r/20201115165207.GA265355@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    6 +++++-
 mm/shmem.c               |   16 ++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmemc-make-shmem_mapping-inline
+++ a/include/linux/shmem_fs.h
@@ -67,7 +67,11 @@ extern unsigned long shmem_get_unmapped_
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #ifdef CONFIG_SHMEM
-extern bool shmem_mapping(struct address_space *mapping);
+extern const struct address_space_operations shmem_aops;
+static inline bool shmem_mapping(struct address_space *mapping)
+{
+	return mapping->a_ops == &shmem_aops;
+}
 #else
 static inline bool shmem_mapping(struct address_space *mapping)
 {
--- a/mm/shmem.c~mm-shmemc-make-shmem_mapping-inline
+++ a/mm/shmem.c
@@ -246,7 +246,7 @@ static inline void shmem_inode_unacct_bl
 }
 
 static const struct super_operations shmem_ops;
-static const struct address_space_operations shmem_aops;
+const struct address_space_operations shmem_aops;
 static const struct file_operations shmem_file_operations;
 static const struct inode_operations shmem_inode_operations;
 static const struct inode_operations shmem_dir_inode_operations;
@@ -1152,7 +1152,7 @@ static void shmem_evict_inode(struct ino
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 
-	if (inode->i_mapping->a_ops == &shmem_aops) {
+	if (shmem_mapping(inode->i_mapping)) {
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
 		shmem_truncate_range(inode, 0, (loff_t)-1);
@@ -1858,7 +1858,7 @@ repeat:
 	}
 
 	/* shmem_symlink() */
-	if (mapping->a_ops != &shmem_aops)
+	if (!shmem_mapping(mapping))
 		goto alloc_nohuge;
 	if (shmem_huge == SHMEM_HUGE_DENY || sgp_huge == SGP_NOHUGE)
 		goto alloc_nohuge;
@@ -2352,11 +2352,6 @@ static struct inode *shmem_get_inode(str
 	return inode;
 }
 
-bool shmem_mapping(struct address_space *mapping)
-{
-	return mapping->a_ops == &shmem_aops;
-}
-
 static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 				  pmd_t *dst_pmd,
 				  struct vm_area_struct *dst_vma,
@@ -3865,7 +3860,7 @@ static void shmem_destroy_inodecache(voi
 	kmem_cache_destroy(shmem_inode_cachep);
 }
 
-static const struct address_space_operations shmem_aops = {
+const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
@@ -3877,6 +3872,7 @@ static const struct address_space_operat
 #endif
 	.error_remove_page = generic_error_remove_page,
 };
+EXPORT_SYMBOL(shmem_aops);
 
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
@@ -4312,7 +4308,7 @@ struct page *shmem_read_mapping_page_gfp
 	struct page *page;
 	int error;
 
-	BUG_ON(mapping->a_ops != &shmem_aops);
+	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
 				  gfp, NULL, NULL, NULL);
 	if (error)
_

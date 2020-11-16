Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8079FC5519F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F1B2244C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="V61AmUMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgKPXGo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 18:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbgKPXGo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 18:06:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BB8222E8;
        Mon, 16 Nov 2020 23:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568003;
        bh=7T82HRUI5t60JMBXgRug18tBh6/bqxL7jtEmll6HPhM=;
        h=Date:From:To:Subject:From;
        b=V61AmUMbdvcc4HIiGBfor0A6wknoky4KVKgCnBC7BcRZORAoQgWnSF32Oqyqn6bPj
         +AH6KWzxDaB2BmI+6sTBdgB0uagnzTOGas7eOm+JrHdfdbxcXe/gnpfuBClz0p5bZR
         PKzw375+k4uH8lcGX3W5N0PNtHa8v2Pz0ZdKpTCs=
Date:   Mon, 16 Nov 2020 15:06:42 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org, sh_def@163.com
Subject:  + mm-shmemc-make-shmem_mapping-inline.patch added to -mm
 tree
Message-ID: <20201116230642.Y4hiwLWtU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: make shmem_mapping() inline
has been added to the -mm tree.  Its filename is
     mm-shmemc-make-shmem_mapping-inline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmemc-make-shmem_mapping-inline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmemc-make-shmem_mapping-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/shmem.c: make shmem_mapping() inline

shmem_mapping() isn't worth an out-of-line call from any callsite.

So make it inline by
- make shmem_aops global
- export shmem_aops
- inline the shmem_mapping()

and replace the direct call 'shmem_aops' with shmem_mapping()
in shmem.c.

v1->v2:
remove the inline for func declaration in shmem_fs.h

v2->v3:
make shmem_aops global, and export it to modules.

Link: https://lkml.kernel.org/r/20201115165207.GA265355@rlk
Signed-off-by: Hui Su <sh_def@163.com>
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
@@ -1879,7 +1879,7 @@ repeat:
 	}
 
 	/* shmem_symlink() */
-	if (mapping->a_ops != &shmem_aops)
+	if (!shmem_mapping(mapping))
 		goto alloc_nohuge;
 	if (shmem_huge == SHMEM_HUGE_DENY || sgp_huge == SGP_NOHUGE)
 		goto alloc_nohuge;
@@ -2374,11 +2374,6 @@ static struct inode *shmem_get_inode(str
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
@@ -3887,7 +3882,7 @@ static void shmem_destroy_inodecache(voi
 	kmem_cache_destroy(shmem_inode_cachep);
 }
 
-static const struct address_space_operations shmem_aops = {
+const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
@@ -3899,6 +3894,7 @@ static const struct address_space_operat
 #endif
 	.error_remove_page = generic_error_remove_page,
 };
+EXPORT_SYMBOL(shmem_aops);
 
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
@@ -4334,7 +4330,7 @@ struct page *shmem_read_mapping_page_gfp
 	struct page *page;
 	int error;
 
-	BUG_ON(mapping->a_ops != &shmem_aops);
+	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
 				  gfp, NULL, NULL, NULL);
 	if (error)
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
mm-shmemc-make-shmem_mapping-inline.patch
mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-compaction-move-compaction_suitables-comment-to-right-place.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch


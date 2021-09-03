Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC233C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A282A610FA
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhICU6S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350362AbhICU6J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75FA0601FD;
        Fri,  3 Sep 2021 20:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702628;
        bh=ujRMd2JFl4epdH2Te6W4TzVn+Bu+YI1cDXtR7VELwUU=;
        h=Date:From:To:Subject:From;
        b=iT0Wfq6g9j3kSqCbMX3ZOQUQ1eaj+VT6bgTCz0lx3KciKvBROr1wGLZqf8JqxQqCq
         iCH3XcJAQj73LsGCmi+eL7Ub2Tz2SUy/TSaJQKT+O3z/+Qbn7+/KRH+mq0qoagmIeI
         XHUMldN//R1j3rt4WjMgLMKNehuNgv3xHk/ArSA8=
Date:   Fri, 03 Sep 2021 13:57:08 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  [merged] huge-tmpfs-shmem_is_hugevma-inode-index.patch
 removed from -mm tree
Message-ID: <20210903205708.kNVuYUGye%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: shmem_is_huge(vma, inode, index)
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-shmem_is_hugevma-inode-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: shmem_is_huge(vma, inode, index)

Extend shmem_huge_enabled(vma) to shmem_is_huge(vma, inode, index), so
that a consistent set of checks can be applied, even when the inode is
accessed through read/write syscalls (with NULL vma) instead of mmaps (the
index argument is seldom of interest, but required by mount option
"huge=within_size").  Clean up and rearrange the checks a little.

This then replaces the checks which shmem_fault() and shmem_getpage_gfp()
were making, and eliminates the SGP_HUGE and SGP_NOHUGE modes.

Replace a couple of 0s by explicit SHMEM_HUGE_NEVERs; and replace the
obscure !shmem_mapping() symlink check by explicit S_ISLNK() - nothing
else needs that symlink check, so leave it there in shmem_getpage_gfp().

Link: https://lkml.kernel.org/r/23a77889-2ddc-b030-75cd-44ca27fd4d1@google.com
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

 include/linux/shmem_fs.h |    9 ++-
 mm/shmem.c               |   84 +++++++++++--------------------------
 2 files changed, 31 insertions(+), 62 deletions(-)

--- a/include/linux/shmem_fs.h~huge-tmpfs-shmem_is_hugevma-inode-index
+++ a/include/linux/shmem_fs.h
@@ -86,7 +86,12 @@ extern void shmem_truncate_range(struct
 extern int shmem_unuse(unsigned int type, bool frontswap,
 		       unsigned long *fs_pages_to_unuse);
 
-extern bool shmem_huge_enabled(struct vm_area_struct *vma);
+extern bool shmem_is_huge(struct vm_area_struct *vma,
+			  struct inode *inode, pgoff_t index);
+static inline bool shmem_huge_enabled(struct vm_area_struct *vma)
+{
+	return shmem_is_huge(vma, file_inode(vma->vm_file), vma->vm_pgoff);
+}
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end);
@@ -96,8 +101,6 @@ enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
 	SGP_NOALLOC,	/* similar, but fail on hole or use fallocated page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
-	SGP_NOHUGE,	/* like SGP_CACHE, but no huge pages */
-	SGP_HUGE,	/* like SGP_CACHE, huge pages preferred */
 	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
 	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
 };
--- a/mm/shmem.c~huge-tmpfs-shmem_is_hugevma-inode-index
+++ a/mm/shmem.c
@@ -471,39 +471,35 @@ static bool shmem_confirm_swap(struct ad
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* ifdef here to avoid bloating shmem.o when not necessary */
 
-static int shmem_huge __read_mostly;
+static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-bool shmem_huge_enabled(struct vm_area_struct *vma)
+bool shmem_is_huge(struct vm_area_struct *vma,
+		   struct inode *inode, pgoff_t index)
 {
-	struct inode *inode = file_inode(vma->vm_file);
-	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	loff_t i_size;
-	pgoff_t off;
 
-	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return false;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
-	switch (sbinfo->huge) {
-	case SHMEM_HUGE_NEVER:
+	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return false;
+	if (shmem_huge == SHMEM_HUGE_FORCE)
+		return true;
+
+	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
 		return true;
 	case SHMEM_HUGE_WITHIN_SIZE:
-		off = round_up(vma->vm_pgoff, HPAGE_PMD_NR);
+		index = round_up(index, HPAGE_PMD_NR);
 		i_size = round_up(i_size_read(inode), PAGE_SIZE);
-		if (i_size >= HPAGE_PMD_SIZE &&
-				i_size >> PAGE_SHIFT >= off)
+		if (i_size >= HPAGE_PMD_SIZE && (i_size >> PAGE_SHIFT) >= index)
 			return true;
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
-		/* TODO: implement fadvise() hints */
-		return (vma->vm_flags & VM_HUGEPAGE);
+		if (vma && (vma->vm_flags & VM_HUGEPAGE))
+			return true;
+		fallthrough;
 	default:
-		VM_BUG_ON(1);
 		return false;
 	}
 }
@@ -677,6 +673,12 @@ static long shmem_unused_huge_count(stru
 
 #define shmem_huge SHMEM_HUGE_DENY
 
+bool shmem_is_huge(struct vm_area_struct *vma,
+		   struct inode *inode, pgoff_t index)
+{
+	return false;
+}
+
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		struct shrink_control *sc, unsigned long nr_to_split)
 {
@@ -1812,7 +1814,6 @@ static int shmem_getpage_gfp(struct inod
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
 	struct page *page;
-	enum sgp_type sgp_huge = sgp;
 	pgoff_t hindex = index;
 	gfp_t huge_gfp;
 	int error;
@@ -1821,8 +1822,6 @@ static int shmem_getpage_gfp(struct inod
 
 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
-	if (sgp == SGP_NOHUGE || sgp == SGP_HUGE)
-		sgp = SGP_CACHE;
 repeat:
 	if (sgp <= SGP_CACHE &&
 	    ((loff_t)index << PAGE_SHIFT) >= i_size_read(inode)) {
@@ -1886,36 +1885,12 @@ repeat:
 		return 0;
 	}
 
-	/* shmem_symlink() */
-	if (!shmem_mapping(mapping))
-		goto alloc_nohuge;
-	if (shmem_huge == SHMEM_HUGE_DENY || sgp_huge == SGP_NOHUGE)
+	/* Never use a huge page for shmem_symlink() */
+	if (S_ISLNK(inode->i_mode))
 		goto alloc_nohuge;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		goto alloc_huge;
-	switch (sbinfo->huge) {
-	case SHMEM_HUGE_NEVER:
+	if (!shmem_is_huge(vma, inode, index))
 		goto alloc_nohuge;
-	case SHMEM_HUGE_WITHIN_SIZE: {
-		loff_t i_size;
-		pgoff_t off;
-
-		off = round_up(index, HPAGE_PMD_NR);
-		i_size = round_up(i_size_read(inode), PAGE_SIZE);
-		if (i_size >= HPAGE_PMD_SIZE &&
-		    i_size >> PAGE_SHIFT >= off)
-			goto alloc_huge;
 
-		fallthrough;
-	}
-	case SHMEM_HUGE_ADVISE:
-		if (sgp_huge == SGP_HUGE)
-			goto alloc_huge;
-		/* TODO: implement fadvise() hints */
-		goto alloc_nohuge;
-	}
-
-alloc_huge:
 	huge_gfp = vma_thp_gfp_mask(vma);
 	huge_gfp = limit_gfp_mask(huge_gfp, gfp);
 	page = shmem_alloc_and_acct_page(huge_gfp, inode, index, true);
@@ -2071,7 +2046,6 @@ static vm_fault_t shmem_fault(struct vm_
 	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = file_inode(vma->vm_file);
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
-	enum sgp_type sgp;
 	int err;
 	vm_fault_t ret = VM_FAULT_LOCKED;
 
@@ -2134,15 +2108,7 @@ static vm_fault_t shmem_fault(struct vm_
 		spin_unlock(&inode->i_lock);
 	}
 
-	sgp = SGP_CACHE;
-
-	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		sgp = SGP_NOHUGE;
-	else if (vma->vm_flags & VM_HUGEPAGE)
-		sgp = SGP_HUGE;
-
-	err = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, sgp,
+	err = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, SGP_CACHE,
 				  gfp, vma, vmf, &ret);
 	if (err)
 		return vmf_error(err);
@@ -3950,7 +3916,7 @@ int __init shmem_init(void)
 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
-		shmem_huge = 0; /* just in case it was patched */
+		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
 #endif
 	return 0;
 
_

Patches currently in -mm which might be from hughd@google.com are



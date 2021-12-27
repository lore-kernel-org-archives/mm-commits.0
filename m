Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F45C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhL0AIa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbhL0AIa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:08:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F39C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 16:08:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8786CB80E66
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DD2C36AE9;
        Mon, 27 Dec 2021 00:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563707;
        bh=075Xrxls5ydAGSBEjTsH0MU0pH3Sdvft7PDw9sbAdWM=;
        h=Date:From:To:Subject:From;
        b=Tr4bjyPaaFXnRm/wmu4Lp1/i5RJVqQ/ou+0MHRwp/NHOpUcdYKl1rdGXANF/xQ0GC
         Qlp9zVqBmW3mRWky014a1eyJqisficclJ2tKiuZMUH0zinUb5s3rEDikYY+ofQjZZG
         ACBEioWz74gWQPqHI9fKs+8iDwozhZOIdzHKu7Xc=
Date:   Sun, 26 Dec 2021 16:08:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        Konrad.wilk@oracle.com, jgross@suse.com, hughd@google.com,
        geert@linux-m68k.org, ddstreet@ieee.org, hch@lst.de
Subject:  + mm-simplify-try_to_unuse.patch added to -mm tree
Message-ID: <20211227000826.l1bsY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify try_to_unuse
has been added to the -mm tree.  Its filename is
     mm-simplify-try_to_unuse.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-try_to_unuse.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-try_to_unuse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: simplify try_to_unuse

Remove the unused frontswap and pages_to_unuse arguments, and mark
the function static now that the caller in frontswap is gone.

Link: https://lkml.kernel.org/r/20211224062246.1258487-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/frontswap.h |    7 ---
 include/linux/shmem_fs.h  |    3 -
 include/linux/swapfile.h  |    1 
 mm/shmem.c                |   33 ++------------
 mm/swapfile.c             |   83 +++++++++---------------------------
 5 files changed, 30 insertions(+), 97 deletions(-)

--- a/include/linux/frontswap.h~mm-simplify-try_to_unuse
+++ a/include/linux/frontswap.h
@@ -7,13 +7,6 @@
 #include <linux/bitops.h>
 #include <linux/jump_label.h>
 
-/*
- * Return code to denote that requested number of
- * frontswap pages are unused(moved to page cache).
- * Used in shmem_unuse and try_to_unuse.
- */
-#define FRONTSWAP_PAGES_UNUSED	2
-
 struct frontswap_ops {
 	void (*init)(unsigned); /* this swap type was just swapon'ed */
 	int (*store)(unsigned, pgoff_t, struct page *); /* store a page */
--- a/include/linux/shmem_fs.h~mm-simplify-try_to_unuse
+++ a/include/linux/shmem_fs.h
@@ -83,8 +83,7 @@ extern void shmem_unlock_mapping(struct
 extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					pgoff_t index, gfp_t gfp_mask);
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
-extern int shmem_unuse(unsigned int type, bool frontswap,
-		       unsigned long *fs_pages_to_unuse);
+int shmem_unuse(unsigned int type);
 
 extern bool shmem_is_huge(struct vm_area_struct *vma,
 			  struct inode *inode, pgoff_t index);
--- a/include/linux/swapfile.h~mm-simplify-try_to_unuse
+++ a/include/linux/swapfile.h
@@ -9,7 +9,6 @@
 extern spinlock_t swap_lock;
 extern struct plist_head swap_active_head;
 extern struct swap_info_struct *swap_info[];
-extern int try_to_unuse(unsigned int, bool, unsigned long);
 extern unsigned long generic_max_swapfile_size(void);
 extern unsigned long max_swapfile_size(void);
 
--- a/mm/shmem.c~mm-simplify-try_to_unuse
+++ a/mm/shmem.c
@@ -36,7 +36,6 @@
 #include <linux/uio.h>
 #include <linux/khugepaged.h>
 #include <linux/hugetlb.h>
-#include <linux/frontswap.h>
 #include <linux/fs_parser.h>
 #include <linux/swapfile.h>
 
@@ -1146,7 +1145,7 @@ static void shmem_evict_inode(struct ino
 static int shmem_find_swap_entries(struct address_space *mapping,
 				   pgoff_t start, unsigned int nr_entries,
 				   struct page **entries, pgoff_t *indices,
-				   unsigned int type, bool frontswap)
+				   unsigned int type)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
@@ -1167,9 +1166,6 @@ static int shmem_find_swap_entries(struc
 		entry = radix_to_swp_entry(page);
 		if (swp_type(entry) != type)
 			continue;
-		if (frontswap &&
-		    !frontswap_test(swap_info[type], swp_offset(entry)))
-			continue;
 
 		indices[ret] = xas.xa_index;
 		entries[ret] = page;
@@ -1222,26 +1218,20 @@ static int shmem_unuse_swap_entries(stru
 /*
  * If swap found in inode, free it and move page from swapcache to filecache.
  */
-static int shmem_unuse_inode(struct inode *inode, unsigned int type,
-			     bool frontswap, unsigned long *fs_pages_to_unuse)
+static int shmem_unuse_inode(struct inode *inode, unsigned int type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	pgoff_t start = 0;
 	struct pagevec pvec;
 	pgoff_t indices[PAGEVEC_SIZE];
-	bool frontswap_partial = (frontswap && *fs_pages_to_unuse > 0);
 	int ret = 0;
 
 	pagevec_init(&pvec);
 	do {
 		unsigned int nr_entries = PAGEVEC_SIZE;
 
-		if (frontswap_partial && *fs_pages_to_unuse < PAGEVEC_SIZE)
-			nr_entries = *fs_pages_to_unuse;
-
 		pvec.nr = shmem_find_swap_entries(mapping, start, nr_entries,
-						  pvec.pages, indices,
-						  type, frontswap);
+						  pvec.pages, indices, type);
 		if (pvec.nr == 0) {
 			ret = 0;
 			break;
@@ -1251,14 +1241,6 @@ static int shmem_unuse_inode(struct inod
 		if (ret < 0)
 			break;
 
-		if (frontswap_partial) {
-			*fs_pages_to_unuse -= ret;
-			if (*fs_pages_to_unuse == 0) {
-				ret = FRONTSWAP_PAGES_UNUSED;
-				break;
-			}
-		}
-
 		start = indices[pvec.nr - 1];
 	} while (true);
 
@@ -1270,8 +1252,7 @@ static int shmem_unuse_inode(struct inod
  * device 'type' back into memory, so the swap device can be
  * unused.
  */
-int shmem_unuse(unsigned int type, bool frontswap,
-		unsigned long *fs_pages_to_unuse)
+int shmem_unuse(unsigned int type)
 {
 	struct shmem_inode_info *info, *next;
 	int error = 0;
@@ -1294,8 +1275,7 @@ int shmem_unuse(unsigned int type, bool
 		atomic_inc(&info->stop_eviction);
 		mutex_unlock(&shmem_swaplist_mutex);
 
-		error = shmem_unuse_inode(&info->vfs_inode, type, frontswap,
-					  fs_pages_to_unuse);
+		error = shmem_unuse_inode(&info->vfs_inode, type);
 		cond_resched();
 
 		mutex_lock(&shmem_swaplist_mutex);
@@ -4009,8 +3989,7 @@ int __init shmem_init(void)
 	return 0;
 }
 
-int shmem_unuse(unsigned int type, bool frontswap,
-		unsigned long *fs_pages_to_unuse)
+int shmem_unuse(unsigned int type, unsigned long *fs_pages_to_unuse)
 {
 	return 0;
 }
--- a/mm/swapfile.c~mm-simplify-try_to_unuse
+++ a/mm/swapfile.c
@@ -1923,8 +1923,7 @@ out:
 
 static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
-			unsigned int type, bool frontswap,
-			unsigned long *fs_pages_to_unuse)
+			unsigned int type)
 {
 	struct page *page;
 	swp_entry_t entry;
@@ -1945,9 +1944,6 @@ static int unuse_pte_range(struct vm_are
 			continue;
 
 		offset = swp_offset(entry);
-		if (frontswap && !frontswap_test(si, offset))
-			continue;
-
 		pte_unmap(pte);
 		swap_map = &si->swap_map[offset];
 		page = lookup_swap_cache(entry, vma, addr);
@@ -1979,11 +1975,6 @@ static int unuse_pte_range(struct vm_are
 		try_to_free_swap(page);
 		unlock_page(page);
 		put_page(page);
-
-		if (*fs_pages_to_unuse && !--(*fs_pages_to_unuse)) {
-			ret = FRONTSWAP_PAGES_UNUSED;
-			goto out;
-		}
 try_next:
 		pte = pte_offset_map(pmd, addr);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
@@ -1996,8 +1987,7 @@ out:
 
 static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 				unsigned long addr, unsigned long end,
-				unsigned int type, bool frontswap,
-				unsigned long *fs_pages_to_unuse)
+				unsigned int type)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -2009,8 +1999,7 @@ static inline int unuse_pmd_range(struct
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
-		ret = unuse_pte_range(vma, pmd, addr, next, type,
-				      frontswap, fs_pages_to_unuse);
+		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
 			return ret;
 	} while (pmd++, addr = next, addr != end);
@@ -2019,8 +2008,7 @@ static inline int unuse_pmd_range(struct
 
 static inline int unuse_pud_range(struct vm_area_struct *vma, p4d_t *p4d,
 				unsigned long addr, unsigned long end,
-				unsigned int type, bool frontswap,
-				unsigned long *fs_pages_to_unuse)
+				unsigned int type)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -2031,8 +2019,7 @@ static inline int unuse_pud_range(struct
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		ret = unuse_pmd_range(vma, pud, addr, next, type,
-				      frontswap, fs_pages_to_unuse);
+		ret = unuse_pmd_range(vma, pud, addr, next, type);
 		if (ret)
 			return ret;
 	} while (pud++, addr = next, addr != end);
@@ -2041,8 +2028,7 @@ static inline int unuse_pud_range(struct
 
 static inline int unuse_p4d_range(struct vm_area_struct *vma, pgd_t *pgd,
 				unsigned long addr, unsigned long end,
-				unsigned int type, bool frontswap,
-				unsigned long *fs_pages_to_unuse)
+				unsigned int type)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -2053,16 +2039,14 @@ static inline int unuse_p4d_range(struct
 		next = p4d_addr_end(addr, end);
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
-		ret = unuse_pud_range(vma, p4d, addr, next, type,
-				      frontswap, fs_pages_to_unuse);
+		ret = unuse_pud_range(vma, p4d, addr, next, type);
 		if (ret)
 			return ret;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
 }
 
-static int unuse_vma(struct vm_area_struct *vma, unsigned int type,
-		     bool frontswap, unsigned long *fs_pages_to_unuse)
+static int unuse_vma(struct vm_area_struct *vma, unsigned int type)
 {
 	pgd_t *pgd;
 	unsigned long addr, end, next;
@@ -2076,16 +2060,14 @@ static int unuse_vma(struct vm_area_stru
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		ret = unuse_p4d_range(vma, pgd, addr, next, type,
-				      frontswap, fs_pages_to_unuse);
+		ret = unuse_p4d_range(vma, pgd, addr, next, type);
 		if (ret)
 			return ret;
 	} while (pgd++, addr = next, addr != end);
 	return 0;
 }
 
-static int unuse_mm(struct mm_struct *mm, unsigned int type,
-		    bool frontswap, unsigned long *fs_pages_to_unuse)
+static int unuse_mm(struct mm_struct *mm, unsigned int type)
 {
 	struct vm_area_struct *vma;
 	int ret = 0;
@@ -2093,8 +2075,7 @@ static int unuse_mm(struct mm_struct *mm
 	mmap_read_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->anon_vma) {
-			ret = unuse_vma(vma, type, frontswap,
-					fs_pages_to_unuse);
+			ret = unuse_vma(vma, type);
 			if (ret)
 				break;
 		}
@@ -2110,7 +2091,7 @@ static int unuse_mm(struct mm_struct *mm
  * if there are no inuse entries after prev till end of the map.
  */
 static unsigned int find_next_to_unuse(struct swap_info_struct *si,
-					unsigned int prev, bool frontswap)
+					unsigned int prev)
 {
 	unsigned int i;
 	unsigned char count;
@@ -2124,8 +2105,7 @@ static unsigned int find_next_to_unuse(s
 	for (i = prev + 1; i < si->max; i++) {
 		count = READ_ONCE(si->swap_map[i]);
 		if (count && swap_count(count) != SWAP_MAP_BAD)
-			if (!frontswap || frontswap_test(si, i))
-				break;
+			break;
 		if ((i % LATENCY_LIMIT) == 0)
 			cond_resched();
 	}
@@ -2136,12 +2116,7 @@ static unsigned int find_next_to_unuse(s
 	return i;
 }
 
-/*
- * If the boolean frontswap is true, only unuse pages_to_unuse pages;
- * pages_to_unuse==0 means all pages; ignored if frontswap is false
- */
-int try_to_unuse(unsigned int type, bool frontswap,
-		 unsigned long pages_to_unuse)
+static int try_to_unuse(unsigned int type)
 {
 	struct mm_struct *prev_mm;
 	struct mm_struct *mm;
@@ -2155,13 +2130,10 @@ int try_to_unuse(unsigned int type, bool
 	if (!READ_ONCE(si->inuse_pages))
 		return 0;
 
-	if (!frontswap)
-		pages_to_unuse = 0;
-
 retry:
-	retval = shmem_unuse(type, frontswap, &pages_to_unuse);
+	retval = shmem_unuse(type);
 	if (retval)
-		goto out;
+		return retval;
 
 	prev_mm = &init_mm;
 	mmget(prev_mm);
@@ -2178,11 +2150,10 @@ retry:
 		spin_unlock(&mmlist_lock);
 		mmput(prev_mm);
 		prev_mm = mm;
-		retval = unuse_mm(mm, type, frontswap, &pages_to_unuse);
-
+		retval = unuse_mm(mm, type);
 		if (retval) {
 			mmput(prev_mm);
-			goto out;
+			return retval;
 		}
 
 		/*
@@ -2199,7 +2170,7 @@ retry:
 	i = 0;
 	while (READ_ONCE(si->inuse_pages) &&
 	       !signal_pending(current) &&
-	       (i = find_next_to_unuse(si, i, frontswap)) != 0) {
+	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
 		page = find_get_page(swap_address_space(entry), i);
@@ -2217,14 +2188,6 @@ retry:
 		try_to_free_swap(page);
 		unlock_page(page);
 		put_page(page);
-
-		/*
-		 * For frontswap, we just need to unuse pages_to_unuse, if
-		 * it was specified. Need not check frontswap again here as
-		 * we already zeroed out pages_to_unuse if not frontswap.
-		 */
-		if (pages_to_unuse && --pages_to_unuse == 0)
-			goto out;
 	}
 
 	/*
@@ -2242,10 +2205,10 @@ retry:
 	if (READ_ONCE(si->inuse_pages)) {
 		if (!signal_pending(current))
 			goto retry;
-		retval = -EINTR;
+		return -EINTR;
 	}
-out:
-	return (retval == FRONTSWAP_PAGES_UNUSED) ? 0 : retval;
+
+	return 0;
 }
 
 /*
@@ -2577,7 +2540,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	disable_swap_slots_cache_lock();
 
 	set_current_oom_origin();
-	err = try_to_unuse(p->type, false, 0); /* force unuse all pages */
+	err = try_to_unuse(p->type);
 	clear_current_oom_origin();
 
 	if (err) {
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-cleancache.patch
frontswap-remove-frontswap_writethrough.patch
frontswap-remove-frontswap_tmem_exclusive_gets.patch
frontswap-remove-frontswap_shrink.patch
frontswap-remove-frontswap_curr_pages.patch
frontswap-simplify-frontswap_init.patch
frontswap-remove-the-frontswap-exports.patch
mm-simplify-try_to_unuse.patch
frontswap-remove-frontswap_test.patch
frontswap-simplify-frontswap_register_ops.patch
mm-mark-swap_lock-and-swap_active_head-static.patch
frontswap-remove-support-for-multiple-ops.patch
mm-hide-the-frontswap-kconfig-symbol.patch


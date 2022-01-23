Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E061EC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbiAWX6s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiAWX6s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F258EC06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F55B61207
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A261C340E3;
        Sun, 23 Jan 2022 23:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982326;
        bh=ks2wdKWA1JFqYBM7TauD7VA4Jpt7kctNF3PkrL3jsMQ=;
        h=Date:From:To:Subject:From;
        b=HrvkfxifJHWZwWya0eEaztDh4eYa5qJqu6/2pZ5uSrfeV1Si4INOty/TtVaxHrW6o
         LyDOpNrfC0/39tVPst1B1oaoB1kkbnNZCQAwrviQ1wVnUlMtnUXifSZBUaer4Hsb1O
         vtrml+k7sg8UlYJOSdFNILZBZiRnRUUCItMsiqIw=
Date:   Sun, 23 Jan 2022 15:58:46 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, geert@linux-m68k.org, hch@lst.de,
        hughd@google.com, jgross@suse.com, Konrad.wilk@oracle.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        sjenning@redhat.com, vitaly.wool@konsulko.com, willy@infradead.org
Subject:  [merged] mm-simplify-try_to_unuse.patch removed from -mm
 tree
Message-ID: <20220123235846.1fya_y7TB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify try_to_unuse
has been removed from the -mm tree.  Its filename was
     mm-simplify-try_to_unuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: simplify try_to_unuse

Remove the unused frontswap and pages_to_unuse arguments, and mark
the function static now that the caller in frontswap is gone.

[akpm@linux-foundation.org: fix shmem_unuse() stub, per Matthew]
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
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
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
 
@@ -1152,7 +1151,7 @@ static void shmem_evict_inode(struct ino
 static int shmem_find_swap_entries(struct address_space *mapping,
 				   pgoff_t start, unsigned int nr_entries,
 				   struct page **entries, pgoff_t *indices,
-				   unsigned int type, bool frontswap)
+				   unsigned int type)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
@@ -1173,9 +1172,6 @@ static int shmem_find_swap_entries(struc
 		entry = radix_to_swp_entry(page);
 		if (swp_type(entry) != type)
 			continue;
-		if (frontswap &&
-		    !frontswap_test(swap_info[type], swp_offset(entry)))
-			continue;
 
 		indices[ret] = xas.xa_index;
 		entries[ret] = page;
@@ -1228,26 +1224,20 @@ static int shmem_unuse_swap_entries(stru
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
@@ -1257,14 +1247,6 @@ static int shmem_unuse_inode(struct inod
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
 
@@ -1276,8 +1258,7 @@ static int shmem_unuse_inode(struct inod
  * device 'type' back into memory, so the swap device can be
  * unused.
  */
-int shmem_unuse(unsigned int type, bool frontswap,
-		unsigned long *fs_pages_to_unuse)
+int shmem_unuse(unsigned int type)
 {
 	struct shmem_inode_info *info, *next;
 	int error = 0;
@@ -1300,8 +1281,7 @@ int shmem_unuse(unsigned int type, bool
 		atomic_inc(&info->stop_eviction);
 		mutex_unlock(&shmem_swaplist_mutex);
 
-		error = shmem_unuse_inode(&info->vfs_inode, type, frontswap,
-					  fs_pages_to_unuse);
+		error = shmem_unuse_inode(&info->vfs_inode, type);
 		cond_resched();
 
 		mutex_lock(&shmem_swaplist_mutex);
@@ -4015,8 +3995,7 @@ int __init shmem_init(void)
 	return 0;
 }
 
-int shmem_unuse(unsigned int type, bool frontswap,
-		unsigned long *fs_pages_to_unuse)
+int shmem_unuse(unsigned int type)
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



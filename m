Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3112FC148
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628226; cv=none; b=Eh/HT17t6r0ARRoL2ASfCXZGTxt1Y/IpfYTTgnpQ/O6doNusxjtIWaNJBcK6DkNPB+BBzHBCv+SdL7tT4nxTgb6xmKHdy5WT7oHudfz7HphQ1iF06u412YP6uzh5qhfqMp5kdklym0xwvUVflObz9P7FRUoDOIoa+1/3abzMUSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628226; c=relaxed/simple;
	bh=a4j74JrkabJr2SYiVpS31ooNBYXR3lZrYE3PMKyOJLA=;
	h=Date:To:From:Subject:Message-Id; b=axvISZ5B2o+G6eHfPwYobaVHLS99aChDX+XdPAf/LoLiFlZMMnhVTSr9/6w1l/5yWQu71XdwVGc5dZEITlGWyFxj0wlBYt1OUuaPlrdNvD/3CYZGS2UXORkX/60hEQ3gfe6OYmipgMfp8IT7PwsIzkC1w/7LZaZOX1uZU20zCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGRXNUUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGRXNUUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ADEC32786;
	Sat, 29 Jun 2024 02:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628226;
	bh=a4j74JrkabJr2SYiVpS31ooNBYXR3lZrYE3PMKyOJLA=;
	h=Date:To:From:Subject:From;
	b=ZGRXNUUq7P7f641L/6qaNQ0nI/zazLnQw/J/jWt6Y/wGY+9bKkwdWx77c40b9yxjM
	 YBHyCTxOgxT7kp2FRgrE1I5wsC45LoVVMBYyVSo02UGjukVJrJy5ISaDt+Fvzg8JHx
	 YHrJFz2hH+OEK42HPK81KVJ1l1pmpwTxv3hwnCUM=
Date: Fri, 28 Jun 2024 19:30:25 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-convert-clear_huge_page-to-folio_zero_user.patch removed from -mm tree
Message-Id: <20240629023026.08ADEC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: convert clear_huge_page() to folio_zero_user()
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-clear_huge_page-to-folio_zero_user.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: convert clear_huge_page() to folio_zero_user()
Date: Tue, 18 Jun 2024 17:12:39 +0800

Patch series "mm: improve clear and copy user folio", v2.

Some folio conversions.  An improvement is to move address alignment into
the caller as it is only needed if we don't know which address will be
accessed when clearing/copying user folios.


This patch (of 4):

Replace clear_huge_page() with folio_zero_user(), and take a folio
instead of a page. Directly get number of pages by folio_nr_pages()
to remove pages_per_huge_page argument, furthermore, move the address
alignment from folio_zero_user() to the callers since the alignment
is only needed when we don't know which address will be accessed.

Link: https://lkml.kernel.org/r/20240618091242.2140164-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240618091242.2140164-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 include/linux/mm.h   |    4 +---
 mm/huge_memory.c     |    4 ++--
 mm/hugetlb.c         |    3 +--
 mm/memory.c          |   34 ++++++++++++++++------------------
 5 files changed, 21 insertions(+), 26 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/fs/hugetlbfs/inode.c
@@ -892,7 +892,7 @@ static long hugetlbfs_fallocate(struct f
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		clear_huge_page(&folio->page, addr, pages_per_huge_page(h));
+		folio_zero_user(folio, ALIGN_DOWN(addr, hpage_size));
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
--- a/include/linux/mm.h~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/include/linux/mm.h
@@ -4067,9 +4067,7 @@ enum mf_action_page_type {
 };
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
-extern void clear_huge_page(struct page *page,
-			    unsigned long addr_hint,
-			    unsigned int pages_per_huge_page);
+void folio_zero_user(struct folio *folio, unsigned long addr_hint);
 int copy_user_large_folio(struct folio *dst, struct folio *src,
 			  unsigned long addr_hint,
 			  struct vm_area_struct *vma);
--- a/mm/huge_memory.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/mm/huge_memory.c
@@ -944,10 +944,10 @@ static vm_fault_t __do_huge_pmd_anonymou
 		goto release;
 	}
 
-	clear_huge_page(page, vmf->address, HPAGE_PMD_NR);
+	folio_zero_user(folio, vmf->address);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * clear_huge_page writes become visible before the set_pmd_at()
+	 * folio_zero_user writes become visible before the set_pmd_at()
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
--- a/mm/hugetlb.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/mm/hugetlb.c
@@ -6300,8 +6300,7 @@ static vm_fault_t hugetlb_no_page(struct
 				ret = 0;
 			goto out;
 		}
-		clear_huge_page(&folio->page, vmf->real_address,
-				pages_per_huge_page(h));
+		folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
--- a/mm/memory.c~mm-memory-convert-clear_huge_page-to-folio_zero_user
+++ a/mm/memory.c
@@ -4488,7 +4488,7 @@ static struct folio *alloc_anon_folio(st
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			clear_huge_page(&folio->page, vmf->address, 1 << order);
+			folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
@@ -6441,41 +6441,39 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct page *page,
-				unsigned long addr,
+static void clear_gigantic_page(struct folio *folio, unsigned long addr,
 				unsigned int pages_per_huge_page)
 {
 	int i;
-	struct page *p;
 
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page; i++) {
-		p = nth_page(page, i);
 		cond_resched();
-		clear_user_highpage(p, addr + i * PAGE_SIZE);
+		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
 	}
 }
 
 static int clear_subpage(unsigned long addr, int idx, void *arg)
 {
-	struct page *page = arg;
+	struct folio *folio = arg;
 
-	clear_user_highpage(nth_page(page, idx), addr);
+	clear_user_highpage(folio_page(folio, idx), addr);
 	return 0;
 }
 
-void clear_huge_page(struct page *page,
-		     unsigned long addr_hint, unsigned int pages_per_huge_page)
+/**
+ * folio_zero_user - Zero a folio which will be mapped to userspace.
+ * @folio: The folio to zero.
+ * @addr_hint: The address will be accessed or the base address if uncelar.
+ */
+void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned long addr = addr_hint &
-		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
+	unsigned int nr_pages = folio_nr_pages(folio);
 
-	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
-		clear_gigantic_page(page, addr, pages_per_huge_page);
-		return;
-	}
-
-	process_huge_page(addr_hint, pages_per_huge_page, clear_subpage, page);
+	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
+		clear_gigantic_page(folio, addr_hint, nr_pages);
+	else
+		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch


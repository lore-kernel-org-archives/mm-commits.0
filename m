Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4031C8603
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754429241; cv=none; b=JJNyhCtkMr6mL8FO7qnkjuQFaBxKcmmHvM3nWziYAQsKK2gJzG0GPNfmz2zQU0Nr2KWo4uOWxHnbHbYOkuFP8DAxI6LdEqcQK7qeC123tclO1SrcQXBSbL7QlIGBZFVzoTE1StfLOgbCLuVL/FL4RTYtA55HqwGi2gyDE0DaE+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754429241; c=relaxed/simple;
	bh=ENmA+UgoHlsToD93QnYkQnD8a5sDI0TrUUw5+qtGDwU=;
	h=Date:To:From:Subject:Message-Id; b=IRQ9B0R4nsuJFXqUh6ngw00mMnWtuVKOjxu60z9/Pj0AR9M3Fo3gRnchKBOJYZIFl7JIzBPIHmmde03UJzBWHVaZXY65AA4hvoUMefmEmNq3u/wtUVF3Q1EC9QNLnnvb0hBWIjxADcGTZIBQ7/3v7WLziP5U+PYNJUwBDAcw8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V11C6D0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V11C6D0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA192C4CEF0;
	Tue,  5 Aug 2025 21:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754429240;
	bh=ENmA+UgoHlsToD93QnYkQnD8a5sDI0TrUUw5+qtGDwU=;
	h=Date:To:From:Subject:From;
	b=V11C6D0TwhMHFE4kGzf5YjwUZLE+N13I+TWiLczYMFARLrQTni0x01Pbqzvz9leiZ
	 jm6fiv7kmavRBCZ9/jZVX+gDI5T1MJifRTPY++57pAvyer2xJ4z1ThhfLDSC2gyXND
	 Wj6kyJyQDqD5u6OJ5WrMAzQmRNhb7SSGtzy67XMk=
Date: Tue, 05 Aug 2025 14:27:20 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,surenb@google.com,peterx@redhat.com,kaleshsingh@google.com,david@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move.patch added to mm-new branch
Message-Id: <20250805212720.DA192C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: opportunistic TLB-flush batching for present pages in MOVE
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: opportunistic TLB-flush batching for present pages in MOVE
Date: Tue, 5 Aug 2025 05:14:10 -0700

MOVE ioctl's runtime is dominated by TLB-flush cost, which is required for
moving present pages.  Mitigate this cost by opportunistically batching
present contiguous pages for TLB flushing.

Without batching, in our testing on an arm64 Android device with UFFD GC,
which uses MOVE ioctl for compaction, we observed that out of the total
time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
~20% in vm_normal_folio().

With batching, the proportion of vm_normal_folio() increases to over 70%
of move_pages_pte() without any changes to vm_normal_folio(). 
Furthermore, time spent within move_pages_pte() is only ~20%, which
includes TLB-flush overhead.

Link: https://lkml.kernel.org/r/20250805121410.1658418-1-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |  169 +++++++++++++++++++++++++++++++--------------
 1 file changed, 118 insertions(+), 51 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move
+++ a/mm/userfaultfd.c
@@ -1026,18 +1026,61 @@ static inline bool is_pte_pages_stable(p
 	       pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
 }
 
-static int move_present_pte(struct mm_struct *mm,
-			    struct vm_area_struct *dst_vma,
-			    struct vm_area_struct *src_vma,
-			    unsigned long dst_addr, unsigned long src_addr,
-			    pte_t *dst_pte, pte_t *src_pte,
-			    pte_t orig_dst_pte, pte_t orig_src_pte,
-			    pmd_t *dst_pmd, pmd_t dst_pmdval,
-			    spinlock_t *dst_ptl, spinlock_t *src_ptl,
-			    struct folio *src_folio)
+/*
+ * Checks if the two ptes and the corresponding folio are eligible for batched
+ * move. If so, then returns pointer to the folio, after locking it. Otherwise,
+ * returns NULL.
+ */
+static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
+						 unsigned long src_addr,
+						 pte_t *src_pte, pte_t *dst_pte)
+{
+	pte_t orig_dst_pte, orig_src_pte;
+	struct folio *folio;
+
+	orig_dst_pte = ptep_get(dst_pte);
+	if (!pte_none(orig_dst_pte))
+		return NULL;
+
+	orig_src_pte = ptep_get(src_pte);
+	if (pte_none(orig_src_pte) || !pte_present(orig_src_pte) ||
+	    is_zero_pfn(pte_pfn(orig_src_pte)))
+		return NULL;
+
+	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
+	if (!folio || !folio_trylock(folio))
+		return NULL;
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
+		folio_unlock(folio);
+		return NULL;
+	}
+	return folio;
+}
+
+static long move_present_ptes(struct mm_struct *mm,
+			      struct vm_area_struct *dst_vma,
+			      struct vm_area_struct *src_vma,
+			      unsigned long dst_addr, unsigned long src_addr,
+			      pte_t *dst_pte, pte_t *src_pte,
+			      pte_t orig_dst_pte, pte_t orig_src_pte,
+			      pmd_t *dst_pmd, pmd_t dst_pmdval,
+			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
+			      struct folio *src_folio, unsigned long len)
 {
 	int err = 0;
+	unsigned long src_start = src_addr;
+	unsigned long addr_end;
 
+	if (len > PAGE_SIZE) {
+		addr_end = (dst_addr + PMD_SIZE) & PMD_MASK;
+		if (dst_addr + len > addr_end)
+			len = addr_end - dst_addr;
+
+		addr_end = (src_addr + PMD_SIZE) & PMD_MASK;
+		if (src_addr + len > addr_end)
+			len = addr_end - src_addr;
+	}
+	flush_cache_range(src_vma, src_addr, src_addr + len);
 	double_pt_lock(dst_ptl, src_ptl);
 
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
@@ -1051,31 +1094,53 @@ static int move_present_pte(struct mm_st
 		err = -EBUSY;
 		goto out;
 	}
+	arch_enter_lazy_mmu_mode();
 
-	orig_src_pte = ptep_clear_flush(src_vma, src_addr, src_pte);
-	/* Folio got pinned from under us. Put it back and fail the move. */
-	if (folio_maybe_dma_pinned(src_folio)) {
-		set_pte_at(mm, src_addr, src_pte, orig_src_pte);
-		err = -EBUSY;
-		goto out;
-	}
+	addr_end = src_start + len;
+	while (true) {
+		orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+		/* Folio got pinned from under us. Put it back and fail the move. */
+		if (folio_maybe_dma_pinned(src_folio)) {
+			set_pte_at(mm, src_addr, src_pte, orig_src_pte);
+			err = -EBUSY;
+			break;
+		}
 
-	folio_move_anon_rmap(src_folio, dst_vma);
-	src_folio->index = linear_page_index(dst_vma, dst_addr);
+		folio_move_anon_rmap(src_folio, dst_vma);
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
 
-	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
-	/* Set soft dirty bit so userspace can notice the pte was moved */
+		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
+		/* Set soft dirty bit so userspace can notice the pte was moved */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
+		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 #endif
-	if (pte_dirty(orig_src_pte))
-		orig_dst_pte = pte_mkdirty(orig_dst_pte);
-	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_dirty(orig_src_pte))
+			orig_dst_pte = pte_mkdirty(orig_dst_pte);
+		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+
+		src_addr += PAGE_SIZE;
+		if (src_addr == addr_end)
+			break;
+		src_pte++;
+		dst_pte++;
+
+		folio_unlock(src_folio);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte, dst_pte);
+		if (!src_folio)
+			break;
+		dst_addr += PAGE_SIZE;
+	}
+
+	arch_leave_lazy_mmu_mode();
+	if (src_addr > src_start)
+		flush_tlb_range(src_vma, src_start, src_addr);
 
-	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 out:
 	double_pt_unlock(dst_ptl, src_ptl);
-	return err;
+	if (src_folio)
+		folio_unlock(src_folio);
+	return src_addr > src_start ? src_addr - src_start : err;
 }
 
 static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
@@ -1140,7 +1205,7 @@ static int move_swap_pte(struct mm_struc
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 static int move_zeropage_pte(struct mm_struct *mm,
@@ -1154,6 +1219,7 @@ static int move_zeropage_pte(struct mm_s
 {
 	pte_t zero_pte;
 
+	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	double_pt_lock(dst_ptl, src_ptl);
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
 				 dst_pmd, dst_pmdval)) {
@@ -1167,20 +1233,19 @@ static int move_zeropage_pte(struct mm_s
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 
 /*
- * The mmap_lock for reading is held by the caller. Just move the page
- * from src_pmd to dst_pmd if possible, and return true if succeeded
- * in moving the page.
+ * The mmap_lock for reading is held by the caller. Just move the page(s)
+ * from src_pmd to dst_pmd if possible, and return number of bytes moved.
  */
-static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *dst_vma,
-			  struct vm_area_struct *src_vma,
-			  unsigned long dst_addr, unsigned long src_addr,
-			  __u64 mode)
+static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
+			    struct vm_area_struct *dst_vma,
+			    struct vm_area_struct *src_vma,
+			    unsigned long dst_addr, unsigned long src_addr,
+			    unsigned long len, __u64 mode)
 {
 	swp_entry_t entry;
 	struct swap_info_struct *si = NULL;
@@ -1196,9 +1261,8 @@ static int move_pages_pte(struct mm_stru
 	struct mmu_notifier_range range;
 	int err = 0;
 
-	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				src_addr, src_addr + PAGE_SIZE);
+				src_addr, src_addr + len);
 	mmu_notifier_invalidate_range_start(&range);
 retry:
 	/*
@@ -1257,7 +1321,7 @@ retry:
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
 			err = -ENOENT;
 		else /* nothing to do to move a hole */
-			err = 0;
+			err = PAGE_SIZE;
 		goto out;
 	}
 
@@ -1375,10 +1439,13 @@ retry:
 			}
 		}
 
-		err = move_present_pte(mm,  dst_vma, src_vma,
-				       dst_addr, src_addr, dst_pte, src_pte,
-				       orig_dst_pte, orig_src_pte, dst_pmd,
-				       dst_pmdval, dst_ptl, src_ptl, src_folio);
+		err = move_present_ptes(mm, dst_vma, src_vma,
+					dst_addr, src_addr, dst_pte, src_pte,
+					orig_dst_pte, orig_src_pte, dst_pmd,
+					dst_pmdval, dst_ptl, src_ptl, src_folio, len);
+		/* folio is already unlocked by move_present_ptes() */
+		folio_put(src_folio);
+		src_folio = NULL;
 	} else {
 		struct folio *folio = NULL;
 
@@ -1737,7 +1804,7 @@ ssize_t move_pages(struct userfaultfd_ct
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *src_vma, *dst_vma;
-	unsigned long src_addr, dst_addr;
+	unsigned long src_addr, dst_addr, src_end;
 	pmd_t *src_pmd, *dst_pmd;
 	long err = -EINVAL;
 	ssize_t moved = 0;
@@ -1780,8 +1847,8 @@ ssize_t move_pages(struct userfaultfd_ct
 	if (err)
 		goto out_unlock;
 
-	for (src_addr = src_start, dst_addr = dst_start;
-	     src_addr < src_start + len;) {
+	for (src_addr = src_start, dst_addr = dst_start, src_end = src_start + len;
+	     src_addr < src_end;) {
 		spinlock_t *ptl;
 		pmd_t dst_pmdval;
 		unsigned long step_size;
@@ -1862,10 +1929,10 @@ ssize_t move_pages(struct userfaultfd_ct
 				break;
 			}
 
-			err = move_pages_pte(mm, dst_pmd, src_pmd,
-					     dst_vma, src_vma,
-					     dst_addr, src_addr, mode);
-			step_size = PAGE_SIZE;
+			err = move_pages_ptes(mm, dst_pmd, src_pmd,
+					      dst_vma, src_vma, dst_addr,
+					      src_addr, src_end - src_addr, mode);
+			step_size = err;
 		}
 
 		cond_resched();
@@ -1877,7 +1944,7 @@ ssize_t move_pages(struct userfaultfd_ct
 			break;
 		}
 
-		if (err) {
+		if (err < 0) {
 			if (err == -EAGAIN)
 				continue;
 			break;
_

Patches currently in -mm which might be from lokeshgidra@google.com are

userfaultfd-opportunistic-tlb-flush-batching-for-present-pages-in-move.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDAA146D4C
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721771466; cv=none; b=jLv18hc6K4a55N2GXhuaM0Tl699lzdrwEPOZZ3iZDG2nNiy1TDelq/2oUbIWEu4AW8swvHb/96xw1rDf5MEs1RAit8AYYuiJc2dpxUyXnGW0x31uhlu9AUb2aX1KNV7dFN+A+B15GBh2nbPSfynWJJvsZXLYJwCvA8G4vPX71G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721771466; c=relaxed/simple;
	bh=yWSlV2kXWBvm/901CBkIBYqVoJDqoNN9URxAgnwX/gU=;
	h=Date:To:From:Subject:Message-Id; b=Yb9q+5C45ELT1YJvRqTu1kekB42ndAjc4u5ejux6VUrQ32rn+eXwRalF6rG9/cfppFitAkZT5drxqPtkbAmucIDP3LksIvOeGLkQRzJMS/GW/KNXofRZqEZb1Hktq/o8v4uTEDAQD/VBp3apAfnOkKT3HF/kkiPrwBFsyxNMDt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hfyyqJvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hfyyqJvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5533C4AF09;
	Tue, 23 Jul 2024 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721771465;
	bh=yWSlV2kXWBvm/901CBkIBYqVoJDqoNN9URxAgnwX/gU=;
	h=Date:To:From:Subject:From;
	b=hfyyqJvtNYGIwN1a6Kl8F0klmqVwpDe9JPp7TNgdz9iE4PugDEnFlwxL+X1WY7SMb
	 6DACyNVhwKgmiTF5kVN6dOxxjJwXN4/sYkuiS/tu2WsHkhcBTTvHXKXE7og5I+kB4b
	 efFOyCIzU5odgVyswlhEIj8lRJP5LLD6Qr3ReS8c=
Date: Tue, 23 Jul 2024 14:51:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mass-constification-of-folio-page-pointers.patch added to mm-unstable branch
Message-Id: <20240723215105.A5533C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mass constification of folio/page pointers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mass-constification-of-folio-page-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mass-constification-of-folio-page-pointers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: mass constification of folio/page pointers
Date: Tue, 23 Jul 2024 16:34:59 +0100

Now that page_pgoff() takes const pointers, we can constify the pointers
to a lot of functions.

Link: https://lkml.kernel.org/r/20240723153503.1669586-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h  |    7 ++++---
 include/linux/rmap.h |   10 +++++-----
 mm/internal.h        |    5 +++--
 mm/ksm.c             |    5 +++--
 mm/memory-failure.c  |   24 +++++++++++++-----------
 mm/page_vma_mapped.c |    5 +++--
 mm/rmap.c            |   11 ++++++-----
 7 files changed, 37 insertions(+), 30 deletions(-)

--- a/include/linux/ksm.h~mm-mass-constification-of-folio-page-pointers
+++ a/include/linux/ksm.h
@@ -92,7 +92,7 @@ struct folio *ksm_might_need_to_copy(str
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
 void folio_migrate_ksm(struct folio *newfolio, struct folio *folio);
-void collect_procs_ksm(struct folio *folio, struct page *page,
+void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		struct list_head *to_kill, int force_early);
 long ksm_process_profit(struct mm_struct *);
 
@@ -125,8 +125,9 @@ static inline void ksm_might_unmap_zero_
 {
 }
 
-static inline void collect_procs_ksm(struct folio *folio, struct page *page,
-				     struct list_head *to_kill, int force_early)
+static inline void collect_procs_ksm(const struct folio *folio,
+		const struct page *page, struct list_head *to_kill,
+		int force_early)
 {
 }
 
--- a/include/linux/rmap.h~mm-mass-constification-of-folio-page-pointers
+++ a/include/linux/rmap.h
@@ -171,7 +171,7 @@ static inline void anon_vma_merge(struct
 	unlink_anon_vmas(next);
 }
 
-struct anon_vma *folio_get_anon_vma(struct folio *folio);
+struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 /* RMAP flags, currently only relevant for some anon rmap operations. */
 typedef int __bitwise rmap_t;
@@ -194,8 +194,8 @@ enum rmap_level {
 	RMAP_LEVEL_PMD,
 };
 
-static inline void __folio_rmap_sanity_checks(struct folio *folio,
-		struct page *page, int nr_pages, enum rmap_level level)
+static inline void __folio_rmap_sanity_checks(const struct folio *folio,
+		const struct page *page, int nr_pages, enum rmap_level level)
 {
 	/* hugetlb folios are handled separately. */
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
@@ -769,14 +769,14 @@ struct rmap_walk_control {
 	bool (*rmap_one)(struct folio *folio, struct vm_area_struct *vma,
 					unsigned long addr, void *arg);
 	int (*done)(struct folio *folio);
-	struct anon_vma *(*anon_lock)(struct folio *folio,
+	struct anon_vma *(*anon_lock)(const struct folio *folio,
 				      struct rmap_walk_control *rwc);
 	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
 };
 
 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc);
 void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
-struct anon_vma *folio_lock_anon_vma_read(struct folio *folio,
+struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 					  struct rmap_walk_control *rwc);
 
 #else	/* !CONFIG_MMU */
--- a/mm/internal.h~mm-mass-constification-of-folio-page-pointers
+++ a/mm/internal.h
@@ -1064,10 +1064,11 @@ void ClearPageHWPoisonTakenOff(struct pa
 bool take_page_off_buddy(struct page *page);
 bool put_page_back_buddy(struct page *page);
 struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
-void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
+void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
 		     struct vm_area_struct *vma, struct list_head *to_kill,
 		     unsigned long ksm_addr);
-unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
+unsigned long page_mapped_in_vma(const struct page *page,
+		struct vm_area_struct *vma);
 
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
--- a/mm/ksm.c~mm-mass-constification-of-folio-page-pointers
+++ a/mm/ksm.c
@@ -1080,7 +1080,8 @@ static int unmerge_ksm_pages(struct vm_a
 	return err;
 }
 
-static inline struct ksm_stable_node *folio_stable_node(struct folio *folio)
+static inline
+struct ksm_stable_node *folio_stable_node(const struct folio *folio)
 {
 	return folio_test_ksm(folio) ? folio_raw_mapping(folio) : NULL;
 }
@@ -3085,7 +3086,7 @@ again:
 /*
  * Collect processes when the error hit an ksm page.
  */
-void collect_procs_ksm(struct folio *folio, struct page *page,
+void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		struct list_head *to_kill, int force_early)
 {
 	struct ksm_stable_node *stable_node;
--- a/mm/memory-failure.c~mm-mass-constification-of-folio-page-pointers
+++ a/mm/memory-failure.c
@@ -445,7 +445,7 @@ static unsigned long dev_pagemap_mapping
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
  */
-static void __add_to_kill(struct task_struct *tsk, struct page *p,
+static void __add_to_kill(struct task_struct *tsk, const struct page *p,
 			  struct vm_area_struct *vma, struct list_head *to_kill,
 			  unsigned long addr)
 {
@@ -461,7 +461,7 @@ static void __add_to_kill(struct task_st
 	if (is_zone_device_page(p))
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
 	else
-		tk->size_shift = page_shift(compound_head(p));
+		tk->size_shift = folio_shift(page_folio(p));
 
 	/*
 	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
@@ -486,7 +486,7 @@ static void __add_to_kill(struct task_st
 	list_add_tail(&tk->nd, to_kill);
 }
 
-static void add_to_kill_anon_file(struct task_struct *tsk, struct page *p,
+static void add_to_kill_anon_file(struct task_struct *tsk, const struct page *p,
 		struct vm_area_struct *vma, struct list_head *to_kill,
 		unsigned long addr)
 {
@@ -509,7 +509,7 @@ static bool task_in_to_kill_list(struct
 	return false;
 }
 
-void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
+void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
 		     struct vm_area_struct *vma, struct list_head *to_kill,
 		     unsigned long addr)
 {
@@ -606,8 +606,9 @@ struct task_struct *task_early_kill(stru
 /*
  * Collect processes when the error hit an anonymous page.
  */
-static void collect_procs_anon(struct folio *folio, struct page *page,
-		struct list_head *to_kill, int force_early)
+static void collect_procs_anon(const struct folio *folio,
+		const struct page *page, struct list_head *to_kill,
+		int force_early)
 {
 	struct task_struct *tsk;
 	struct anon_vma *av;
@@ -643,8 +644,9 @@ static void collect_procs_anon(struct fo
 /*
  * Collect processes when the error hit a file mapped page.
  */
-static void collect_procs_file(struct folio *folio, struct page *page,
-		struct list_head *to_kill, int force_early)
+static void collect_procs_file(const struct folio *folio,
+		const struct page *page, struct list_head *to_kill,
+		int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -680,7 +682,7 @@ static void collect_procs_file(struct fo
 }
 
 #ifdef CONFIG_FS_DAX
-static void add_to_kill_fsdax(struct task_struct *tsk, struct page *p,
+static void add_to_kill_fsdax(struct task_struct *tsk, const struct page *p,
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
@@ -691,7 +693,7 @@ static void add_to_kill_fsdax(struct tas
 /*
  * Collect processes when the error hit a fsdax page.
  */
-static void collect_procs_fsdax(struct page *page,
+static void collect_procs_fsdax(const struct page *page,
 		struct address_space *mapping, pgoff_t pgoff,
 		struct list_head *to_kill, bool pre_remove)
 {
@@ -725,7 +727,7 @@ static void collect_procs_fsdax(struct p
 /*
  * Collect the processes who have the corrupted page mapped to kill.
  */
-static void collect_procs(struct folio *folio, struct page *page,
+static void collect_procs(const struct folio *folio, const struct page *page,
 		struct list_head *tokill, int force_early)
 {
 	if (!folio->mapping)
--- a/mm/page_vma_mapped.c~mm-mass-constification-of-folio-page-pointers
+++ a/mm/page_vma_mapped.c
@@ -325,9 +325,10 @@ next_pte:
  * outside the VMA or not present, returns -EFAULT.
  * Only valid for normal file or anonymous VMAs.
  */
-unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
+unsigned long page_mapped_in_vma(const struct page *page,
+		struct vm_area_struct *vma)
 {
-	struct folio *folio = page_folio(page);
+	const struct folio *folio = page_folio(page);
 	pgoff_t pgoff = folio->index + folio_page_idx(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
--- a/mm/rmap.c~mm-mass-constification-of-folio-page-pointers
+++ a/mm/rmap.c
@@ -496,7 +496,7 @@ void __init anon_vma_init(void)
  * concurrently without folio lock protection). See folio_lock_anon_vma_read()
  * which has already covered that, and comment above remap_pages().
  */
-struct anon_vma *folio_get_anon_vma(struct folio *folio)
+struct anon_vma *folio_get_anon_vma(const struct folio *folio)
 {
 	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
@@ -540,7 +540,7 @@ out:
  * reference like with folio_get_anon_vma() and then block on the mutex
  * on !rwc->try_lock case.
  */
-struct anon_vma *folio_lock_anon_vma_read(struct folio *folio,
+struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 					  struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma = NULL;
@@ -1250,8 +1250,9 @@ static void __folio_set_anon(struct foli
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
  */
-static void __page_check_anon_rmap(struct folio *folio, struct page *page,
-	struct vm_area_struct *vma, unsigned long address)
+static void __page_check_anon_rmap(const struct folio *folio,
+		const struct page *page, struct vm_area_struct *vma,
+		unsigned long address)
 {
 	/*
 	 * The page's anon-rmap details (mapping and index) are guaranteed to
@@ -2535,7 +2536,7 @@ void __put_anon_vma(struct anon_vma *ano
 		anon_vma_free(root);
 }
 
-static struct anon_vma *rmap_walk_anon_lock(struct folio *folio,
+static struct anon_vma *rmap_walk_anon_lock(const struct folio *folio,
 					    struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
_

Patches currently in -mm which might be from willy@infradead.org are

bootmem-stop-using-page-index.patch
mm-constify-page_address_in_vma.patch
mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-mass-constification-of-folio-page-pointers.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch


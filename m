Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4A3EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjHUS6Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjHUS6O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1154EDC
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC046422B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2417C433C8;
        Mon, 21 Aug 2023 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692643633;
        bh=Xo6xBJu9OOYeKIQu2gT5ceprVpe6ENC4orJsWOv4ico=;
        h=Date:To:From:Subject:From;
        b=J4bK8iH9GNK6f5cGnl/2Xc2N4DOTmphDKqg1T1noZVFfYEt/WmG4bLKL1WlYKHgs+
         j8608IFn8nxC0+RGNia7c7Xc3hBTS0Qbf71rAh4lFpIr0uJZu12T9nz1VtwHN6fouI
         gGrdhtbP8N1g1C1E3AGBnHoHhDZfFAeVKtdFLtfk=
Date:   Mon, 21 Aug 2023 11:47:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch added to mm-unstable branch
Message-Id: <20230821184713.B2417C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow ->huge_fault() to be called without the mmap_lock held
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch

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
Subject: mm: allow ->huge_fault() to be called without the mmap_lock held
Date: Fri, 18 Aug 2023 21:23:34 +0100

Remove the checks for the VMA lock being held, allowing the page fault
path to call into the filesystem instead of retrying with the mmap_lock
held.  This will improve scalability for DAX page faults.  Also update the
documentation to match (and fix some other changes that have happened
recently).

Link: https://lkml.kernel.org/r/20230818202335.2739663-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |   36 +++++++++++++++---------
 Documentation/filesystems/porting.rst |   11 +++++++
 mm/memory.c                           |   22 +-------------
 3 files changed, 36 insertions(+), 33 deletions(-)

--- a/Documentation/filesystems/locking.rst~mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held
+++ a/Documentation/filesystems/locking.rst
@@ -628,26 +628,29 @@ vm_operations_struct
 
 prototypes::
 
-	void (*open)(struct vm_area_struct*);
-	void (*close)(struct vm_area_struct*);
-	vm_fault_t (*fault)(struct vm_area_struct*, struct vm_fault *);
+	void (*open)(struct vm_area_struct *);
+	void (*close)(struct vm_area_struct *);
+	vm_fault_t (*fault)(struct vm_fault *);
+	vm_fault_t (*huge_fault)(struct vm_fault *, unsigned int order);
+	vm_fault_t (*map_pages)(struct vm_fault *, pgoff_t start, pgoff_t end);
 	vm_fault_t (*page_mkwrite)(struct vm_area_struct *, struct vm_fault *);
 	vm_fault_t (*pfn_mkwrite)(struct vm_area_struct *, struct vm_fault *);
 	int (*access)(struct vm_area_struct *, unsigned long, void*, int, int);
 
 locking rules:
 
-=============	=========	===========================
+=============	==========	===========================
 ops		mmap_lock	PageLocked(page)
-=============	=========	===========================
-open:		yes
-close:		yes
-fault:		yes		can return with page locked
-map_pages:	read
-page_mkwrite:	yes		can return with page locked
-pfn_mkwrite:	yes
-access:		yes
-=============	=========	===========================
+=============	==========	===========================
+open:		write
+close:		read/write
+fault:		read		can return with page locked
+huge_fault:	maybe-read
+map_pages:	maybe-read
+page_mkwrite:	read		can return with page locked
+pfn_mkwrite:	read
+access:		read
+=============	==========	===========================
 
 ->fault() is called when a previously not present pte is about to be faulted
 in. The filesystem must find and return the page associated with the passed in
@@ -657,6 +660,13 @@ then ensure the page is not already trun
 subsequent truncate), and then return with VM_FAULT_LOCKED, and the page
 locked. The VM will unlock the page.
 
+->huge_fault() is called when there is no PUD or PMD entry present.  This
+gives the filesystem the opportunity to install a PUD or PMD sized page.
+Filesystems can also use the ->fault method to return a PMD sized page,
+so implementing this function may not be necessary.  In particular,
+filesystems should not call filemap_fault() from ->huge_fault().
+The mmap_lock may not be held when this method is called.
+
 ->map_pages() is called when VM asks to map easy accessible pages.
 Filesystem should find and map pages associated with offsets from "start_pgoff"
 till "end_pgoff". ->map_pages() is called with the RCU lock held and must
--- a/Documentation/filesystems/porting.rst~mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held
+++ a/Documentation/filesystems/porting.rst
@@ -943,3 +943,14 @@ file pointer instead of struct dentry po
 changed to simplify callers.  The passed file is in a non-open state and on
 success must be opened before returning (e.g. by calling
 finish_open_simple()).
+
+---
+
+**mandatory**
+
+Calling convention for ->huge_fault has changed.  It now takes a page
+order instead of an enum page_entry_size, and it may be called without the
+mmap_lock held.  All in-tree users have been audited and do not seem to
+depend on the mmap_lock being held, but out of tree users should verify
+for themselves.  If they do need it, they can return VM_FAULT_RETRY to
+be called with the mmap_lock held.
--- a/mm/memory.c~mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held
+++ a/mm/memory.c
@@ -4857,13 +4857,8 @@ static inline vm_fault_t create_huge_pmd
 	struct vm_area_struct *vma = vmf->vma;
 	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
-	if (vma->vm_ops->huge_fault) {
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-			vma_end_read(vma);
-			return VM_FAULT_RETRY;
-		}
+	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
-	}
 	return VM_FAULT_FALLBACK;
 }
 
@@ -4883,10 +4878,6 @@ static inline vm_fault_t wp_huge_pmd(str
 
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		if (vma->vm_ops->huge_fault) {
-			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-				vma_end_read(vma);
-				return VM_FAULT_RETRY;
-			}
 			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
@@ -4907,13 +4898,8 @@ static vm_fault_t create_huge_pud(struct
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vma))
 		return VM_FAULT_FALLBACK;
-	if (vma->vm_ops->huge_fault) {
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-			vma_end_read(vma);
-			return VM_FAULT_RETRY;
-		}
+	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
-	}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	return VM_FAULT_FALLBACK;
 }
@@ -4930,10 +4916,6 @@ static vm_fault_t wp_huge_pud(struct vm_
 		goto split;
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		if (vma->vm_ops->huge_fault) {
-			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-				vma_end_read(vma);
-				return VM_FAULT_RETRY;
-			}
 			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch
mm-allow-fault_dirty_shared_page-to-be-called-under-the-vma-lock.patch
io_uring-stop-calling-free_compound_page.patch
mm-call-free_huge_page-directly.patch
mm-convert-free_huge_page-to-free_huge_folio.patch
mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch
mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch
mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch
mm-remove-hugetlb_page_dtor.patch
mm-add-large_rmappable-page-flag.patch
mm-rearrange-page-flags.patch
mm-free-up-a-word-in-the-first-tail-page.patch
mm-remove-folio_test_transhuge.patch
mm-add-tail-private-fields-to-struct-folio.patch
mm-convert-split_huge_pages_pid-to-use-a-folio.patch
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch


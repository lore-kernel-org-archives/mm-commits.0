Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0251EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiANWGd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47898 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiANWGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59C2F61FB7
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ACAC36AE5;
        Fri, 14 Jan 2022 22:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197990;
        bh=QywIrIHRdQWHbIF8krE1slR1movNTr0w4PFjaGy6SU0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CDndbAGi0qzABfsFWZZxNPJl3xnXc877FaHSbIfiW6LfSrLaC5e6QllEOIirPsFNm
         pIEjIK1nGDMm/aEy50y/ayDmOQHe/AkyJkDd8dZkqC2FnuF+Pfw0xqrkZBRm5xP3VN
         0OKm0lgbsxRLyY5Y13J1hHUEPE8o+jOx0wanrilE=
Date:   Fri, 14 Jan 2022 14:06:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        corbet@lwn.net, dave.hansen@linux.intel.com, frederic@kernel.org,
        gthelen@google.com, hpa@zytor.com, hughd@google.com,
        jirislaby@kernel.org, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, peterz@infradead.org, pjt@google.com,
        rientjes@google.com, rppt@kernel.org, samitolvanen@google.com,
        songmuchun@bytedance.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, weixugc@google.com, will@kernel.org
Subject:  [patch 065/146] mm: change page type prior to adding page
 table entry
Message-ID: <20220114220629.y-VkIZDj3%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: change page type prior to adding page table entry

Patch series "page table check", v3.

Ensure that some memory corruptions are prevented by checking at the time
of insertion of entries into user page tables that there is no illegal
sharing.

We have recently found a problem [1] that existed in kernel since 4.14. 
The problem was caused by broken page ref count and led to memory leaking
from one process into another.  The problem was accidentally detected by
studying a dump of one process and noticing that one page contains memory
that should not belong to this process.

There are some other page->_refcount related problems that were recently
fixed: [2], [3] which potentially could also lead to illegal sharing.

In addition to hardening refcount [4] itself, this work is an attempt to
prevent this class of memory corruption issues.

It uses a simple state machine that is independent from regular MM logic
to check for illegal sharing at time pages are inserted and removed from
page tables.

[1] https://lore.kernel.org/all/xr9335nxwc5y.fsf@gthelen2.svl.corp.google.com
[2] https://lore.kernel.org/all/1582661774-30925-2-git-send-email-akaher@vmware.com
[3] https://lore.kernel.org/all/20210622021423.154662-3-mike.kravetz@oracle.com
[4] https://lore.kernel.org/all/20211221150140.988298-1-pasha.tatashin@soleen.com


This patch (of 4):

There are a few places where we first update the entry in the user page
table, and later change the struct page to indicate that this is anonymous
or file page.

In most places, however, we first configure the page metadata and then
insert entries into the page table.  Page table check, will use the
information from struct page to verify the type of entry is inserted.

Change the order in all places to first update struct page, and later to
update page table.

This means that we first do calls that may change the type of page (anon
or file):

	page_move_anon_rmap
	page_add_anon_rmap
	do_page_add_anon_rmap
	page_add_new_anon_rmap
	page_add_file_rmap
	hugepage_add_anon_rmap
	hugepage_add_new_anon_rmap

And after that do calls that add entries to the page table:

	set_huge_pte_at
	set_pte_at

Link: https://lkml.kernel.org/r/20211221154650.1047963-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20211221154650.1047963-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Turner <pjt@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    6 +++---
 mm/memory.c   |    9 +++++----
 mm/migrate.c  |    5 ++---
 mm/swapfile.c |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-change-page-type-prior-to-adding-page-table-entry
+++ a/mm/hugetlb.c
@@ -4684,8 +4684,8 @@ hugetlb_install_page(struct vm_area_stru
 		     struct page *new_page)
 {
 	__SetPageUptodate(new_page);
-	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, new_page, 1));
 	hugepage_add_new_anon_rmap(new_page, vma, addr);
+	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, new_page, 1));
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	ClearHPageRestoreReserve(new_page);
 	SetHPageMigratable(new_page);
@@ -5259,10 +5259,10 @@ retry_avoidcopy:
 		/* Break COW */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
-		set_huge_pte_at(mm, haddr, ptep,
-				make_huge_pte(vma, new_page, 1));
 		page_remove_rmap(old_page, true);
 		hugepage_add_new_anon_rmap(new_page, vma, haddr);
+		set_huge_pte_at(mm, haddr, ptep,
+				make_huge_pte(vma, new_page, 1));
 		SetHPageMigratable(new_page);
 		/* Make the old page be freed below */
 		new_page = old_page;
--- a/mm/memory.c~mm-change-page-type-prior-to-adding-page-table-entry
+++ a/mm/memory.c
@@ -720,8 +720,6 @@ static void restore_exclusive_pte(struct
 	else if (is_writable_device_exclusive_entry(entry))
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 
-	set_pte_at(vma->vm_mm, address, ptep, pte);
-
 	/*
 	 * No need to take a page reference as one was already
 	 * created when the swap entry was made.
@@ -735,6 +733,8 @@ static void restore_exclusive_pte(struct
 		 */
 		WARN_ON_ONCE(!PageAnon(page));
 
+	set_pte_at(vma->vm_mm, address, ptep, pte);
+
 	if (vma->vm_flags & VM_LOCKED)
 		mlock_vma_page(page);
 
@@ -3640,8 +3640,6 @@ vm_fault_t do_swap_page(struct vm_fault
 		pte = pte_mkuffd_wp(pte);
 		pte = pte_wrprotect(pte);
 	}
-	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
-	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
 	vmf->orig_pte = pte;
 
 	/* ksm created a completely new copy */
@@ -3652,6 +3650,9 @@ vm_fault_t do_swap_page(struct vm_fault
 		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
 	}
 
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
+
 	swap_free(entry);
 	if (mem_cgroup_swap_full(page) ||
 	    (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
--- a/mm/migrate.c~mm-change-page-type-prior-to-adding-page-table-entry
+++ a/mm/migrate.c
@@ -236,20 +236,19 @@ static bool remove_migration_pte(struct
 
 			pte = pte_mkhuge(pte);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
-			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 			if (PageAnon(new))
 				hugepage_add_anon_rmap(new, vma, pvmw.address);
 			else
 				page_dup_rmap(new, true);
+			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		} else
 #endif
 		{
-			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
-
 			if (PageAnon(new))
 				page_add_anon_rmap(new, vma, pvmw.address, false);
 			else
 				page_add_file_rmap(new, false);
+			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		}
 		if (vma->vm_flags & VM_LOCKED && !PageTransCompound(new))
 			mlock_vma_page(new);
--- a/mm/swapfile.c~mm-change-page-type-prior-to-adding-page-table-entry
+++ a/mm/swapfile.c
@@ -1917,14 +1917,14 @@ static int unuse_pte(struct vm_area_stru
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
-	set_pte_at(vma->vm_mm, addr, pte,
-		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	if (page == swapcache) {
 		page_add_anon_rmap(page, vma, addr, false);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, addr, false);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	}
+	set_pte_at(vma->vm_mm, addr, pte,
+		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	swap_free(entry);
 out:
 	pte_unmap_unlock(pte, ptl);
_

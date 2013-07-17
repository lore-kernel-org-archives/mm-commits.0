From: akpm@linux-foundation.org
Subject: + thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch added to
 -mm tree
Date: Wed, 17 Jul 2013 14:12:37 -0700
Message-ID: <51e708c5.P6/N730XC7TGC0d6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3GQVMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,viro@zeniv.linux.org.uk,willy@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:12:37 -0700


The patch titled
     Subject: thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()
has been added to the -mm tree.  Its filename is
     thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()

It's confusing that mk_huge_pmd() has semantics different from mk_pte() or
mk_pmd().  I spent some time on debugging issue cased by this
inconsistency.

Let's move maybe_pmd_mkwrite() out of mk_huge_pmd() and adjust prototype
to match mk_pte().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd
+++ a/mm/huge_memory.c
@@ -695,11 +695,10 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 	return pmd;
 }
 
-static inline pmd_t mk_huge_pmd(struct page *page, struct vm_area_struct *vma)
+static inline pmd_t mk_huge_pmd(struct page *page, pgprot_t prot)
 {
 	pmd_t entry;
-	entry = mk_pmd(page, vma->vm_page_prot);
-	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	entry = mk_pmd(page, prot);
 	entry = pmd_mkhuge(entry);
 	return entry;
 }
@@ -732,7 +731,8 @@ static int __do_huge_pmd_anonymous_page(
 		pte_free(mm, pgtable);
 	} else {
 		pmd_t entry;
-		entry = mk_huge_pmd(page, vma);
+		entry = mk_huge_pmd(page, vma->vm_page_prot);
+		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		page_add_new_anon_rmap(page, vma, haddr);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -1215,7 +1215,8 @@ alloc:
 		goto out_mn;
 	} else {
 		pmd_t entry;
-		entry = mk_huge_pmd(new_page, vma);
+		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
+		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
@@ -2361,7 +2362,8 @@ static void collapse_huge_page(struct mm
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = mk_huge_pmd(new_page, vma);
+	_pmd = mk_huge_pmd(new_page, vma->vm_page_prot);
+	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
 	/*
 	 * spin_lock() below is not the equivalent of smp_wmb(), so
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch
thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
thp-mm-locking-tail-page-is-a-bug.patch


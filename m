From: akpm@linux-foundation.org
Subject: - mm-rmap-kernel-doc-fixes.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:05 -0700
Message-ID: <200803212029.m2LKT5W8008838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756356AbYCUU3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm: rmap kernel-doc fixes
has been removed from the -mm tree.  Its filename was
     mm-rmap-kernel-doc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rmap kernel-doc fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

Correct kernel-doc function names and parameters in rmap.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-rmap-kernel-doc-fixes mm/rmap.c
--- a/mm/rmap.c~mm-rmap-kernel-doc-fixes
+++ a/mm/rmap.c
@@ -335,6 +335,7 @@ static int page_referenced_anon(struct p
 /**
  * page_referenced_file - referenced check for object-based rmap
  * @page: the page we're checking references on.
+ * @mem_cont: target memory controller
  *
  * For an object-based mapped page, find all the places it is mapped and
  * check/clear the referenced flag.  This is done by following the page->mapping
@@ -402,6 +403,7 @@ static int page_referenced_file(struct p
  * page_referenced - test if the page was referenced
  * @page: the page to test
  * @is_locked: caller holds lock on the page
+ * @mem_cont: target memory controller
  *
  * Quick test_and_clear_referenced for all mappings to a page,
  * returns the number of ptes which referenced the page.
@@ -506,7 +508,7 @@ int page_mkclean(struct page *page)
 EXPORT_SYMBOL_GPL(page_mkclean);
 
 /**
- * page_set_anon_rmap - setup new anonymous rmap
+ * __page_set_anon_rmap - setup new anonymous rmap
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
@@ -530,7 +532,7 @@ static void __page_set_anon_rmap(struct 
 }
 
 /**
- * page_set_anon_rmap - sanity check anonymous rmap addition
+ * __page_check_anon_rmap - sanity check anonymous rmap addition
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
@@ -583,7 +585,7 @@ void page_add_anon_rmap(struct page *pag
 	}
 }
 
-/*
+/**
  * page_add_new_anon_rmap - add pte mapping to a new anonymous page
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
@@ -623,6 +625,8 @@ void page_add_file_rmap(struct page *pag
 /**
  * page_dup_rmap - duplicate pte mapping to a page
  * @page:	the page to add the mapping to
+ * @vma:	the vm area being duplicated
+ * @address:	the user virtual address mapped
  *
  * For copy_page_range only: minimal extract from page_add_file_rmap /
  * page_add_anon_rmap, avoiding unnecessary tests (already checked) so it's
@@ -642,6 +646,7 @@ void page_dup_rmap(struct page *page, st
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
+ * @vma: the vm area in which the mapping is removed
  *
  * The caller needs to hold the pte lock.
  */
@@ -890,6 +895,7 @@ static int try_to_unmap_anon(struct page
 /**
  * try_to_unmap_file - unmap file page using the object-based rmap method
  * @page: the page to unmap
+ * @migration: migration flag
  *
  * Find all the mappings of a page using the mapping pointer and the vma chains
  * contained in the address_space struct it points to.
@@ -986,6 +992,7 @@ out:
 /**
  * try_to_unmap - try to remove all page table mappings to a page
  * @page: the page to get unmapped
+ * @migration: migration flag
  *
  * Tries to remove all the page table entries which are mapping this
  * page, used in the pageout path.  Caller must hold the page lock.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch


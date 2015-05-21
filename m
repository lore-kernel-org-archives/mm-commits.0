From: akpm@linux-foundation.org
Subject: + hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch added to -mm tree
Date: Thu, 21 May 2015 13:49:45 -0700
Message-ID: <555e44e9.Ndw2hvs5/JijdJgH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbbEUUtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 16:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix
has been added to the -mm tree.  Its filename is
     hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix

tweak comments

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix mm/filemap.c
--- a/mm/filemap.c~hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix
+++ a/mm/filemap.c
@@ -196,7 +196,7 @@ void __delete_from_page_cache(struct pag
 	page->mapping = NULL;
 	/* Leave page->index set: truncation lookup relies upon it */
 
-	/* hugetlb pages do not participate into page cache accounting. */
+	/* hugetlb pages do not participate in page cache accounting. */
 	if (!PageHuge(page))
 		__dec_zone_page_state(page, NR_FILE_PAGES);
 	if (PageSwapBacked(page))
@@ -487,8 +487,7 @@ int replace_page_cache_page(struct page
 		mapping->nrpages++;
 
 		/*
-		 * hugetlb pages do not participate into page cache
-		 * accounting.
+		 * hugetlb pages do not participate in page cache accounting.
 		 */
 		if (!PageHuge(new))
 			__inc_zone_page_state(new, NR_FILE_PAGES);
@@ -584,7 +583,7 @@ static int __add_to_page_cache_locked(st
 	if (unlikely(error))
 		goto err_insert;
 
-	/* hugetlb pages do not participate into page cache accounting. */
+	/* hugetlb pages do not participate in page cache accounting. */
 	if (!huge)
 		__inc_zone_page_state(page, NR_FILE_PAGES);
 	spin_unlock_irq(&mapping->tree_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


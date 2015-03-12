From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
 added to -mm tree
Date: Thu, 12 Mar 2015 13:05:12 -0700
Message-ID: <5501f178.oAFnDFKeor9z0wpC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbCLUFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@stgolabs.net, gthelen@google.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: abort __get_user_pages if current has been oom killed
has been added to the -mm tree.  Its filename is
     mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: abort __get_user_pages if current has been oom killed

If __get_user_pages() is faulting a significant number of hugetlb pages,
usually as the result of mmap(MAP_LOCKED), it can potentially allocate a
very large amount of memory.

If the process has been oom killed, this will cause a lot of memory to
potentially deplete memory reserves.

In the same way that commit 4779280d1ea4 ("mm: make get_user_pages()
interruptible") aborted for pending SIGKILLs when faulting non-hugetlb
memory, based on the premise of commit 462e00cc7151 ("oom: stop allocating
user memory if TIF_MEMDIE is set"), hugetlb page faults now terminate when
the process has been oom killed.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: "Greg Thelen" <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed
+++ a/mm/hugetlb.c
@@ -3278,6 +3278,15 @@ long follow_hugetlb_page(struct mm_struc
 		struct page *page;
 
 		/*
+		 * If we have a pending SIGKILL, don't keep faulting pages and
+		 * potentially allocating memory.
+		 */
+		if (unlikely(fatal_signal_pending(current))) {
+			remainder = 0;
+			break;
+		}
+
+		/*
 		 * Some archs (sparc64, sh*) have multiple pte_ts to
 		 * each hugepage.  We have to make sure we get the
 		 * first, for the page indexing below to work.
_

Patches currently in -mm which might be from rientjes@google.com are

mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-utilc-add-kstrimdup.patch


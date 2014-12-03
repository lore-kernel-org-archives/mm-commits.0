From: akpm@linux-foundation.org
Subject: +
 mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages.patch added to -mm tree
Date: Wed, 03 Dec 2014 15:26:50 -0800
Message-ID: <547f9c3a.zk/KBIaHV71KvkYm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaLCX0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 18:26:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fadvise: document the fadvise(FADV_DONTNEED) behaviour for partial pages
has been added to the -mm tree.  Its filename is
     mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: fadvise: document the fadvise(FADV_DONTNEED) behaviour for partial pages

A random seek IO benchmark appeared to regress because of a change to
readahead but the real problem was the benchmark.  To ensure the IO
request accesssed disk, it used fadvise(FADV_DONTNEED) on a block boundary
(512K) but the hint is ignored by the kernel.  This is correct but not
necessarily obvious behaviour.  As much as I dislike comment patches, the
explanation for this behaviour predates current git history.  Clarify why
it behaves like this in case someone "fixes" fadvise or readahead for the
wrong reasons.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/fadvise.c~mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages
+++ a/mm/fadvise.c
@@ -117,7 +117,11 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 			__filemap_fdatawrite_range(mapping, offset, endbyte,
 						   WB_SYNC_NONE);
 
-		/* First and last FULL page! */
+		/*
+		 * First and last FULL page! Partial pages are deliberately
+		 * preserved on the expectation that it is better to preserve
+		 * needed memory than to discard unneeded memory.
+		 */
 		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
 		end_index = (endbyte >> PAGE_CACHE_SHIFT);
 
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-numa-balancing-rearrange-kconfig-entry.patch
mm-hugetlb-correct-bit-shift-in-hstate_sizelog.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch


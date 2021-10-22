Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A80CC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 620D06109D
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhJVTcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232443AbhJVTcl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB7460E0C;
        Fri, 22 Oct 2021 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634931024;
        bh=5wPsQkTIgwPR/FKILZhAtkLbEeScE/1CuZG2WlgGlNw=;
        h=Date:From:To:Subject:From;
        b=X5KMN9X71mWpsh03XETjk3ARzFO5/IgoD85mjRLS4qwkKUiYDWxDmzCu/fN+D1BcX
         pK23l8EEWk3Uw8Hp3EjNT6dP1W6pCM6yewYV/DGsKAw+pAAbsOlrVHTGn644gtFxrZ
         xdjxBdO2Ohul7Z9OiSIduPDAI/6/VfOLB6Au7PJ8=
Date:   Fri, 22 Oct 2021 12:30:23 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, peterx@redhat.com,
        sj@kernel.org
Subject:  +
 docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch added
 to -mm tree
Message-ID: <20211022193023._aVNCnDq2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/pagemap: wordsmith page flags descriptions
has been added to the -mm tree.  Its filename is
     docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/pagemap: wordsmith page flags descriptions

Some descriptions of page flags in 'pagemap.rst' are written in
assumption of none-rst, which respects every new line, as below:

    7 - SLAB
       page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator
       When compound page is used, SLUB/SLQB will only set this flag on the head

Because rst ignores the new line between the first sentence and second
sentence, resulting html looks a little bit weird, as below.

    7 - SLAB
    page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator When
                                                                       ^
    compound page is used, SLUB/SLQB will only set this flag on the head
    page; SLOB will not flag it at all.

This commit makes it more natural and consistent with other parts in the
rendered version.

Link: https://lkml.kernel.org/r/20211022090311.3856-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |   53 ++++++++++-----------
 1 file changed, 27 insertions(+), 26 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -90,13 +90,14 @@ Short descriptions to the page flags
 ====================================
 
 0 - LOCKED
-   page is being locked for exclusive access, e.g. by undergoing read/write IO
+   The page is being locked for exclusive access, e.g. by undergoing read/write
+   IO.
 7 - SLAB
-   page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator
+   The page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator.
    When compound page is used, SLUB/SLQB will only set this flag on the head
    page; SLOB will not flag it at all.
 10 - BUDDY
-    a free memory block managed by the buddy system allocator
+    A free memory block managed by the buddy system allocator.
     The buddy system organizes free memory in blocks of various orders.
     An order N block has 2^N physically contiguous pages, with the BUDDY flag
     set for and _only_ for the first page.
@@ -112,65 +113,65 @@ Short descriptions to the page flags
 16 - COMPOUND_TAIL
     A compound page tail (see description above).
 17 - HUGE
-    this is an integral part of a HugeTLB page
+    This is an integral part of a HugeTLB page.
 19 - HWPOISON
-    hardware detected memory corruption on this page: don't touch the data!
+    Hardware detected memory corruption on this page: don't touch the data!
 20 - NOPAGE
-    no page frame exists at the requested address
+    No page frame exists at the requested address.
 21 - KSM
-    identical memory pages dynamically shared between one or more processes
+    Identical memory pages dynamically shared between one or more processes.
 22 - THP
-    contiguous pages which construct transparent hugepages
+    Contiguous pages which construct transparent hugepages.
 23 - OFFLINE
-    page is logically offline
+    The page is logically offline.
 24 - ZERO_PAGE
-    zero page for pfn_zero or huge_zero page
+    Zero page for pfn_zero or huge_zero page.
 25 - IDLE
-    page has not been accessed since it was marked idle (see
+    The page has not been accessed since it was marked idle (see
     :ref:`Documentation/admin-guide/mm/idle_page_tracking.rst <idle_page_tracking>`).
     Note that this flag may be stale in case the page was accessed via
     a PTE. To make sure the flag is up-to-date one has to read
     ``/sys/kernel/mm/page_idle/bitmap`` first.
 26 - PGTABLE
-    page is in use as a page table
+    The page is in use as a page table.
 
 IO related page flags
 ---------------------
 
 1 - ERROR
-   IO error occurred
+   IO error occurred.
 3 - UPTODATE
-   page has up-to-date data
+   The page has up-to-date data.
    ie. for file backed page: (in-memory data revision >= on-disk one)
 4 - DIRTY
-   page has been written to, hence contains new data
+   The page has been written to, hence contains new data.
    i.e. for file backed page: (in-memory data revision >  on-disk one)
 8 - WRITEBACK
-   page is being synced to disk
+   The page is being synced to disk.
 
 LRU related page flags
 ----------------------
 
 5 - LRU
-   page is in one of the LRU lists
+   The page is in one of the LRU lists.
 6 - ACTIVE
-   page is in the active LRU list
+   The page is in the active LRU list.
 18 - UNEVICTABLE
-   page is in the unevictable (non-)LRU list It is somehow pinned and
+   The page is in the unevictable (non-)LRU list It is somehow pinned and
    not a candidate for LRU page reclaims, e.g. ramfs pages,
-   shmctl(SHM_LOCK) and mlock() memory segments
+   shmctl(SHM_LOCK) and mlock() memory segments.
 2 - REFERENCED
-   page has been referenced since last LRU list enqueue/requeue
+   The page has been referenced since last LRU list enqueue/requeue.
 9 - RECLAIM
-   page will be reclaimed soon after its pageout IO completed
+   The page will be reclaimed soon after its pageout IO completed.
 11 - MMAP
-   a memory mapped page
+   A memory mapped page.
 12 - ANON
-   a memory mapped page that is not part of a file
+   A memory mapped page that is not part of a file.
 13 - SWAPCACHE
-   page is mapped to swap space, i.e. has an associated swap entry
+   The page is mapped to swap space, i.e. has an associated swap entry.
 14 - SWAPBACKED
-   page is backed by swap/RAM
+   The page is backed by swap/RAM.
 
 The page-types tool in the tools/vm directory can be used to query the
 above flags.
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch
docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch
docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
docs-admin-guide-mm-damon-start-simplify-the-content.patch
docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch


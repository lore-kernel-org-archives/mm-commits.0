Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD8CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434D3610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhKKCxb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234609AbhKKCxX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C72D60F26;
        Thu, 11 Nov 2021 02:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599035;
        bh=w9/ZvLlRogfQoGnbId3igHyMA6SNtiYnfq+tjRXJ50I=;
        h=Date:From:To:Subject:From;
        b=qCcUc4HC/pJDS/TueWQSWyFzyPOncYC7o+O9uYJKQ9riaH+M+dXRD7ArmtXKJbKxU
         g13L0BxPaciALqSN31qd0QwumtSLLJMM8s/YOM6V075/NR79YNUhC1oowN8j3V+RFN
         VvI1qWF8VprwZL4GlXWbWP5ZADwNnHxNIMc9NXCw=
Date:   Wed, 10 Nov 2021 18:50:35 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, peterx@redhat.com,
        sj@kernel.org
Subject:  [merged]
 docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch removed
 from -mm tree
Message-ID: <20211111025035.ss6BP2ZrK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/pagemap: wordsmith page flags descriptions
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



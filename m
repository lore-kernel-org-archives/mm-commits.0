From: akpm@linux-foundation.org
Subject: + mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch added to -mm tree
Date: Mon, 19 Aug 2013 15:49:04 -0700
Message-ID: <5212a0e0.66ayxretnYOr7bHS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3HSWtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 18:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: + mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch added to -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 15:49:04 -0700


The patch titled
     Subject: mm: munlock: remove unnecessary call to lru_add_drain()
has been added to the -mm tree.  Its filename is
     mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: munlock: remove unnecessary call to lru_add_drain()

In munlock_vma_range(), lru_add_drain() is currently called in a loop
before each munlock_vma_page() call.

This is suboptimal for performance when munlocking many pages.  The
benefits of per-cpu pagevec for batching the LRU putback are removed since
the pagevec only holds at most one page from the previous loop's
iteration.

The lru_add_drain() call also does not serve any purposes for correctness
- it does not even drain pagavecs of all cpu's.  The munlock code already
expects and handles situations where a page cannot be isolated from the
LRU (e.g.  because it is on some per-cpu pagevec).

The history of the (not commented) call also suggest that it appears there
as an oversight rather than intentionally.  Before commit ff6a6da6 ("mm:
accelerate munlock() treatment of THP pages") the call happened only once
upon entering the function.  The commit has moved the call into the while
loope.  So while the other changes in the commit improved munlock
performance for THP pages, it introduced the abovementioned suboptimal
per-cpu pagevec usage.

Further in history, before commit 408e82b7 ("mm: munlock use
follow_page"), munlock_vma_pages_range() was just a wrapper around
__mlock_vma_pages_range which performed both mlock and munlock depending
on a flag.  However, before ba470de4 ("mmap: handle mlocked pages during
map, remap, unmap") the function handled only mlock, not munlock.  The
lru_add_drain call thus comes from the implementation in commit b291f000
("mlock: mlocked pages are unevictable" and was intended only for
mlocking, not munlocking.  The original intention of draining the LRU
pagevec at mlock time was to ensure the pages were on the LRU before the
lock operation so that they could be placed on the unevictable list
immediately.  There is very little motivation to do the same in the
munlock path this, particularly for every single page.

This patch therefore removes the call completely.  After removing the
call, a 10% speedup was measured for munlock() of a 56GB large memory area
with THP disabled.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jörn Engel <joern@logfs.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mlock.c~mm-munlock-remove-unnecessary-call-to-lru_add_drain mm/mlock.c
--- a/mm/mlock.c~mm-munlock-remove-unnecessary-call-to-lru_add_drain
+++ a/mm/mlock.c
@@ -247,7 +247,6 @@ void munlock_vma_pages_range(struct vm_a
 					&page_mask);
 		if (page && !IS_ERR(page)) {
 			lock_page(page);
-			lru_add_drain();
 			/*
 			 * Any THP page found by follow_page_mask() may have
 			 * gotten split before reaching munlock_vma_page(),
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch


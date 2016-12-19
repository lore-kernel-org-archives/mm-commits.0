From: akpm@linux-foundation.org
Subject: +
 mm-fadvise-avoid-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch added to -mm tree
Date: Mon, 19 Dec 2016 13:34:33 -0800
Message-ID: <58585269.H9cWxk90eHI6M1Ya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754424AbcLSVdd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 16:33:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fadvise: avoid expensive remote LRU cache draining after FADV_DONTNEED
has been added to the -mm tree.  Its filename is
     mm-fadvise-avoid-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fadvise-avoid-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fadvise-avoid-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fadvise: avoid expensive remote LRU cache draining after FADV_DONTNEED

When FADV_DONTNEED cannot drop all pages in the range, it observes that
some pages might still be on per-cpu LRU caches after recent instantiation
and so initiates remote calls to all CPUs to flush their local caches. 
However, in most cases, the fadvise happens from the same context that
instantiated the pages, and any pre-LRU pages in the specified range are
most likely sitting on the local CPU's LRU cache, and so in many cases
this results in unnecessary remote calls, which, in a loaded system, can
hold up the fadvise() call significantly.

[ I didn't record it in the extreme case we observed at Facebook,
  unfortunately. We had a slow-to-respond system and noticed it
  lru_add_drain_all() leading the profile during fadvise calls. This
  patch came out of thinking about the code and how we commonly call
  FADV_DONTNEED.

  FWIW, I wrote a silly directory tree walker/searcher that recurses
  through /usr to read and FADV_DONTNEED each file it finds. On a 2
  socket 40 ht machine, over 1% is spent in lru_add_drain_all(). With
  the patch, that cost is gone; the local drain cost shows at 0.09%. ]

Try to avoid the remote call by flushing the local LRU cache before even
attempting to invalidate anything.  It's a cheap operation, and the local
LRU cache is the most likely to hold any pre-LRU pages in the specified
fadvise range.

Link: http://lkml.kernel.org/r/20161214210017.GA1465@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/fadvise.c~mm-fadvise-avoid-expensive-remote-lru-cache-draining-after-fadv_dontneed mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-avoid-expensive-remote-lru-cache-draining-after-fadv_dontneed
+++ a/mm/fadvise.c
@@ -139,7 +139,20 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 		}
 
 		if (end_index >= start_index) {
-			unsigned long count = invalidate_mapping_pages(mapping,
+			unsigned long count;
+
+			/*
+			 * It's common to FADV_DONTNEED right after
+			 * the read or write that instantiates the
+			 * pages, in which case there will be some
+			 * sitting on the local LRU cache. Try to
+			 * avoid the expensive remote drain and the
+			 * second cache tree walk below by flushing
+			 * them out right away.
+			 */
+			lru_add_drain();
+
+			count = invalidate_mapping_pages(mapping,
 						start_index, end_index);
 
 			/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fadvise-avoid-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch


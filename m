From: akpm@linux-foundation.org
Subject: [merged] mm-improve-page_lock_anon_vma-comment.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:56 -0700
Message-ID: <201105252027.p4PKRJ4D014564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077Ab1EYU2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     mm: improve page_lock_anon_vma() comment
has been removed from the -mm tree.  Its filename was
     mm-improve-page_lock_anon_vma-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: improve page_lock_anon_vma() comment
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

A slightly more verbose comment to go along with the trickery in
page_lock_anon_vma().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-improve-page_lock_anon_vma-comment mm/rmap.c
--- a/mm/rmap.c~mm-improve-page_lock_anon_vma-comment
+++ a/mm/rmap.c
@@ -320,8 +320,22 @@ void __init anon_vma_init(void)
 }
 
 /*
- * Getting a lock on a stable anon_vma from a page off the LRU is
- * tricky: page_lock_anon_vma rely on RCU to guard against the races.
+ * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
+ *
+ * Since there is no serialization what so ever against page_remove_rmap()
+ * the best this function can do is return a locked anon_vma that might
+ * have been relevant to this page.
+ *
+ * The page might have been remapped to a different anon_vma or the anon_vma
+ * returned may already be freed (and even reused).
+ *
+ * All users of this function must be very careful when walking the anon_vma
+ * chain and verify that the page in question is indeed mapped in it
+ * [ something equivalent to page_mapped_in_vma() ].
+ *
+ * Since anon_vma's slab is DESTROY_BY_RCU and we know from page_remove_rmap()
+ * that the anon_vma pointer from page->mapping is valid if there is a
+ * mapcount, we can dereference the anon_vma after observing those.
  */
 struct anon_vma *page_lock_anon_vma(struct page *page)
 {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch


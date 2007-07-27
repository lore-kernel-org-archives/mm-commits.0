From: akpm@linux-foundation.org
Subject: + slub-add-lock-debugging-check.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:18:20 -0700
Message-ID: <200707270518.l6R5IKCw007040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbXG0FSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, clameter@sgi.com, mingo@elte.hu, penberg@cs.helsinki.fi


The patch titled
     slub: add lock debugging check
has been added to the -mm tree.  Its filename is
     slub-add-lock-debugging-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: add lock debugging check
From: Peter Zijlstra <peterz@infradead.org>

Ingo noticed that the SLUB code does include the lock debugging free check.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slub.c~slub-add-lock-debugging-check mm/slub.c
--- a/mm/slub.c~slub-add-lock-debugging-check
+++ a/mm/slub.c
@@ -1656,6 +1656,7 @@ static void __always_inline slab_free(st
 	unsigned long flags;
 
 	local_irq_save(flags);
+	debug_check_no_locks_freed(object, s->objsize);
 	if (likely(page == s->cpu_slab[smp_processor_id()] &&
 						!SlabDebug(page))) {
 		object[page->offset] = page->lockless_freelist;
_

Patches currently in -mm which might be from peterz@infradead.org are

slub-add-lock-debugging-check.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch

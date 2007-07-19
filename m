From: akpm@linux-foundation.org
Subject: + random-fix-bound-check-ordering.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:09:07 -0700
Message-ID: <200707192209.l6JM97qw025542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763036AbXGSWJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, chrisw@sous-sol.org, pageexec@freemail.hu, stable@kernel.org, tytso@mit.edu, w@1wt.eu


The patch titled
     random: fix bound check ordering
has been added to the -mm tree.  Its filename is
     random-fix-bound-check-ordering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: random: fix bound check ordering
From: Matt Mackall <mpm@selenic.com>

If root raised the default wakeup threshold over the size of the output
pool, the pool transfer function could overflow the stack with RNG bytes,
causing a DoS or potential privilege escalation.

(Bug reported by the PaX Team <pageexec@freemail.hu>)

This fix is already part of PaX, so can be considered public.  I updated
the changelog to reflect the PaX Team's preferred credit, and to note
the privilege escalation potential.  I've also verified the fix.

Cc: Theodore Tso <tytso@mit.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/char/random.c~random-fix-bound-check-ordering drivers/char/random.c
--- a/drivers/char/random.c~random-fix-bound-check-ordering
+++ a/drivers/char/random.c
@@ -693,9 +693,14 @@ static void xfer_secondary_pool(struct e
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
-		int bytes = max_t(int, random_read_wakeup_thresh / 8,
-				min_t(int, nbytes, sizeof(tmp)));
+		/* If we're limited, always leave two wakeup worth's BITS */
 		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
+		int bytes = nbytes;
+
+		/* pull at least as many as BYTES as wakeup BITS */
+		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
+		/* but never more than the buffer size */
+		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
 			  "(%d of %d requested)\n",
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
slob-reduce-list-scanning.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
hwrng-add-type-categories.patch
random-fix-bound-check-ordering.patch

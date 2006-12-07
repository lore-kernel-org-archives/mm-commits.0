From: akpm@osdl.org
Subject: - mm-thrash-detect-process-thrashing-against-itself.patch removed from -mm tree
Date: Wed, 06 Dec 2006 21:21:07 -0800
Message-ID: <200612070521.kB75L7Bt031278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968805AbWLGFVU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:21:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, diegocg@gmail.com, jcipar@cs.umass.edu, mm-commits@vger.kernel.org


The patch titled
     mm: thrash: detect process thrashing against itself
has been removed from the -mm tree.  Its filename was
     mm-thrash-detect-process-thrashing-against-itself.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mm: thrash: detect process thrashing against itself
From: Rik van Riel <riel@redhat.com>


I guess the swap token hurts workloads where you have just one large
process, since it does not sort the pages within that process by referenced
bit...

This means the swap token is helpful when processes are paging against each
other, but hurts when you have just one process that is paging against
itself.

The current swap token code does seem to help servers pull out of load
spikes and not descend into thrashing like the VM used to do before, so I
would rather not disable it by default.

Instead, we can detect the situation where we have one process paging
against itself, and then disable the swap token automatically.

(Related to http://bugzilla.kernel.org/show_bug.cgi?id=6039)

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Diego Calleja <diegocg@gmail.com>
Cc: Jim Cipar <jcipar@cs.umass.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/thrash.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/thrash.c~mm-thrash-detect-process-thrashing-against-itself mm/thrash.c
--- 25/mm/thrash.c~mm-thrash-detect-process-thrashing-against-itself	Fri Mar 24 16:06:04 2006
+++ 25-akpm/mm/thrash.c	Fri Mar 24 16:06:04 2006
@@ -16,6 +16,7 @@
 static DEFINE_SPINLOCK(swap_token_lock);
 static unsigned long swap_token_timeout;
 static unsigned long swap_token_check;
+static unsigned long somebody_wants_token;
 struct mm_struct * swap_token_mm = &init_mm;
 
 #define SWAP_TOKEN_CHECK_INTERVAL (HZ * 2)
@@ -57,11 +58,18 @@ void grab_swap_token(void)
 	/* We have the token. Let others know we still need it. */
 	if (has_swap_token(current->mm)) {
 		current->mm->recent_pagein = 1;
-		if (unlikely(!swap_token_default_timeout))
+		/* If nobody wants the token, we are paging against ourselves
+		   and should disable the token. */
+		if (unlikely(!swap_token_default_timeout ||
+				(!somebody_wants_token &&
+				time_after(jiffies, swap_token_check))))
 			disable_swap_token();
 		return;
 	}
 
+	if (!somebody_wants_token)
+		somebody_wants_token = 1;
+
 	if (time_after(jiffies, swap_token_check)) {
 
 		if (!swap_token_default_timeout) {
@@ -87,6 +95,7 @@ void grab_swap_token(void)
 			mm->swap_token_time = eligible;
 			swap_token_timeout = jiffies + swap_token_default_timeout;
 			swap_token_mm = current->mm;
+			somebody_wants_token = 0;
 		}
 		spin_unlock(&swap_token_lock);
 	}
_

Patches currently in -mm which might be from riel@redhat.com are

grab-swap-token-reordered.patch
new-scheme-to-preempt-swap-token.patch


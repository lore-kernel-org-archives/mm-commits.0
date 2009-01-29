From: akpm@linux-foundation.org
Subject: + futex-comment-requeue-key-reference-semantics.patch added to -mm tree
Date: Wed, 28 Jan 2009 17:06:08 -0800
Message-ID: <200901290106.n0T168hN029088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168AbZA2BG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 20:06:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dvhltc@us.ibm.com, a.p.zijlstra@chello.nl, mingo@elte.hu, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au


The patch titled
     futex: comment requeue key reference semantics
has been added to the -mm tree.  Its filename is
     futex-comment-requeue-key-reference-semantics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: comment requeue key reference semantics
From: Darren Hart <dvhltc@us.ibm.com>

We've tripped over the futex_requeue drop_count refering to key2
instead of key1.  The code is actually correct, but is non-intuitive. 
This patch adds an explicit comment explaining the requeue.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/futex.c~futex-comment-requeue-key-reference-semantics kernel/futex.c
--- a/kernel/futex.c~futex-comment-requeue-key-reference-semantics
+++ a/kernel/futex.c
@@ -927,7 +927,12 @@ out_unlock:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 
-	/* drop_futex_key_refs() must be called outside the spinlocks. */
+	/*
+	 * drop_futex_key_refs() must be called outside the spinlocks. During
+	 * the requeue we moved futex_q's from the hash bucket at key1 to the
+	 * one at key2 and updated their key pointer.  We no longer need to
+	 * hold the references to key1.
+	 */
 	while (--drop_count >= 0)
 		drop_futex_key_refs(&key1);
 
_

Patches currently in -mm which might be from dvhltc@us.ibm.com are

futex-comment-requeue-key-reference-semantics.patch


From: akpm@linux-foundation.org
Subject: [merged] futex-comment-requeue-key-reference-semantics.patch removed from -mm tree
Date: Thu, 09 Apr 2009 11:46:45 -0700
Message-ID: <200904091846.n39IkjEb031101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758886AbZDISuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 14:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvhltc@us.ibm.com, a.p.zijlstra@chello.nl, mingo@elte.hu, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     futex: comment requeue key reference semantics
has been removed from the -mm tree.  Its filename was
     futex-comment-requeue-key-reference-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -883,7 +883,12 @@ retry_private:
 out_unlock:
 	double_unlock_hb(hb1, hb2);
 
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

linux-next.patch


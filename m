From: akpm@linux-foundation.org
Subject: [merged] random-align-rekey_works-timer.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:31 -0700
Message-ID: <200904061932.n36JWV9w010735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754256AbZDFTfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: align rekey_work's timer
has been removed from the -mm tree.  Its filename was
     random-align-rekey_works-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: align rekey_work's timer
From: Anton Blanchard <anton@samba.org>

Align rekey_work. Even though it's infrequent, we may as well line it up.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/random.c~random-align-rekey_works-timer drivers/char/random.c
--- a/drivers/char/random.c~random-align-rekey_works-timer
+++ a/drivers/char/random.c
@@ -1488,7 +1488,8 @@ static void rekey_seq_generator(struct w
 	keyptr->count = (ip_cnt & COUNT_MASK) << HASH_BITS;
 	smp_wmb();
 	ip_cnt++;
-	schedule_delayed_work(&rekey_work, REKEY_INTERVAL);
+	schedule_delayed_work(&rekey_work,
+			      round_jiffies_relative(REKEY_INTERVAL));
 }
 
 static inline struct keydata *get_keyptr(void)
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
sunrpc-align-cache_clean-works-timer.patch


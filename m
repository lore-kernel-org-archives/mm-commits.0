From: akpm@linux-foundation.org
Subject: + random-align-rekey_works-timer.patch added to -mm tree
Date: Wed, 01 Apr 2009 12:45:34 -0700
Message-ID: <200904011945.n31JjYiq028118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934279AbZDATs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, mpm@selenic.com, tytso@mit.edu


The patch titled
     random: align rekey_work's timer
has been added to the -mm tree.  Its filename is
     random-align-rekey_works-timer.patch

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
Subject: random: align rekey_work's timer
From: Anton Blanchard <anton@samba.org>

Align rekey_work. Even though it's infrequent, we may as well line it up.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Matt Mackall <mpm@selenic.com>
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
mm-align-vmstat_works-timer.patch
random-align-rekey_works-timer.patch
sunrpc-align-cache_clean-works-timer.patch


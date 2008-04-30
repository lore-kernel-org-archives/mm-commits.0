From: akpm@linux-foundation.org
Subject: - random-consolidate-wakeup-logic.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:07 -0700
Message-ID: <200804300548.m3U5m7xL029855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759944AbYD3GLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: consolidate wakeup logic
has been removed from the -mm tree.  Its filename was
     random-consolidate-wakeup-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: consolidate wakeup logic
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/char/random.c~random-consolidate-wakeup-logic drivers/char/random.c
--- a/drivers/char/random.c~random-consolidate-wakeup-logic
+++ a/drivers/char/random.c
@@ -540,6 +540,10 @@ static void credit_entropy_store(struct 
 				  nbits, r->name);
 	}
 
+	/* should we wake readers? */
+	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
+		wake_up_interruptible(&random_read_wait);
+
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
@@ -624,10 +628,6 @@ static void add_timer_randomness(struct 
 		credit_entropy_store(&input_pool,
 				     min_t(int, fls(delta>>1), 11));
 	}
-
-	if (input_pool.entropy_count >= random_read_wakeup_thresh)
-		wake_up_interruptible(&random_read_wait);
-
 out:
 	preempt_enable();
 }
@@ -1081,12 +1081,6 @@ static int random_ioctl(struct inode *in
 		if (get_user(ent_count, p))
 			return -EFAULT;
 		credit_entropy_store(&input_pool, ent_count);
-		/*
-		 * Wake up waiting processes if we have enough
-		 * entropy.
-		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
-			wake_up_interruptible(&random_read_wait);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1102,12 +1096,6 @@ static int random_ioctl(struct inode *in
 		if (retval < 0)
 			return retval;
 		credit_entropy_store(&input_pool, ent_count);
-		/*
-		 * Wake up waiting processes if we have enough
-		 * entropy.
-		 */
-		if (input_pool.entropy_count >= random_read_wakeup_thresh)
-			wake_up_interruptible(&random_read_wait);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch


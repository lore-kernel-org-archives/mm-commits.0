From: akpm@linux-foundation.org
Subject: - random-simplify-and-rename-credit_entropy_store.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:27 -0700
Message-ID: <200804300548.m3U5mRQq029885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760693AbYD3GMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: simplify and rename credit_entropy_store
has been removed from the -mm tree.  Its filename was
     random-simplify-and-rename-credit_entropy_store.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: simplify and rename credit_entropy_store
From: Matt Mackall <mpm@selenic.com>

- emphasize bits in the name
- make zero bits lock-free
- simplify logic

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/char/random.c~random-simplify-and-rename-credit_entropy_store drivers/char/random.c
--- a/drivers/char/random.c~random-simplify-and-rename-credit_entropy_store
+++ a/drivers/char/random.c
@@ -441,7 +441,7 @@ static struct entropy_store nonblocking_
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
- * credit_entropy_store if this is appropriate.
+ * credit_entropy_bits if this is appropriate.
  *
  * The pool is stirred with a primitive polynomial of the appropriate
  * degree, and then twisted.  We twist by three bits at a time because
@@ -515,24 +515,22 @@ static void mix_pool_bytes(struct entrop
 /*
  * Credit (or debit) the entropy store with n bits of entropy
  */
-static void credit_entropy_store(struct entropy_store *r, int nbits)
+static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	unsigned long flags;
 
+	if (!nbits)
+		return;
+
 	spin_lock_irqsave(&r->lock, flags);
 
-	if (r->entropy_count + nbits < 0) {
-		DEBUG_ENT("negative entropy/overflow (%d+%d)\n",
-			  r->entropy_count, nbits);
+	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
+	r->entropy_count += nbits;
+	if (r->entropy_count < 0) {
+		DEBUG_ENT("negative entropy/overflow\n");
 		r->entropy_count = 0;
-	} else if (r->entropy_count + nbits > r->poolinfo->POOLBITS) {
+	} else if (r->entropy_count > r->poolinfo->POOLBITS)
 		r->entropy_count = r->poolinfo->POOLBITS;
-	} else {
-		r->entropy_count += nbits;
-		if (nbits)
-			DEBUG_ENT("added %d entropy credits to %s\n",
-				  nbits, r->name);
-	}
 
 	/* should we wake readers? */
 	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
@@ -619,8 +617,8 @@ static void add_timer_randomness(struct 
 		 * Round down by 1 bit on general principles,
 		 * and limit entropy entimate to 12 bits.
 		 */
-		credit_entropy_store(&input_pool,
-				     min_t(int, fls(delta>>1), 11));
+		credit_entropy_bits(&input_pool,
+				    min_t(int, fls(delta>>1), 11));
 	}
 out:
 	preempt_enable();
@@ -702,7 +700,7 @@ static void xfer_secondary_pool(struct e
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
 		mix_pool_bytes(r, tmp, bytes);
-		credit_entropy_store(r, bytes*8);
+		credit_entropy_bits(r, bytes*8);
 	}
 }
 
@@ -1073,7 +1071,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		credit_entropy_store(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1088,7 +1086,7 @@ static long random_ioctl(struct file *f,
 				    size);
 		if (retval < 0)
 			return retval;
-		credit_entropy_store(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch


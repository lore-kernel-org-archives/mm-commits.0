From: akpm@linux-foundation.org
Subject: + random32-seeding-improvement.patch added to -mm tree
Date: Wed, 02 Jul 2008 12:17:10 -0700
Message-ID: <200807021917.m62JHAlf031805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbYGBTRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 15:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, ak@suse.de, bboissin@gmail.com, davem@davemloft.net, lloyd@randombit.net, mpm@selenic.com, tytso@mit.edu


The patch titled
     random32: seeding improvement
has been added to the -mm tree.  Its filename is
     random32-seeding-improvement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random32: seeding improvement
From: Stephen Hemminger <shemminger@linux-foundation.org>

Please consider this patch instead for fixing the seeding issue with
random32.  The rationale is:

   * use u32 consistently
   * no need to do LCG on values from (better) get_random_bytes
   * use more data from get_random_bytes for secondary seeding
   * don't reduce state space on srandom32()
   * enforce state variable initialization restrictions

Note: the second paper has a version of random32() with even longer period
and a version of random64() if needed.

Cc: Jack Lloyd <lloyd@randombit.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: Benoit Boissinot <bboissin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/random32.c |   48 ++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff -puN lib/random32.c~random32-seeding-improvement lib/random32.c
--- a/lib/random32.c~random32-seeding-improvement
+++ a/lib/random32.c
@@ -56,23 +56,12 @@ static u32 __random32(struct rnd_state *
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
 
-static void __set_random32(struct rnd_state *state, unsigned long s)
+/*
+ * Handle minimum values for seeds
+ */
+static inline u32 __seed(u32 x, u32 m)
 {
-	if (s == 0)
-		s = 1;      /* default seed is 1 */
-
-#define LCG(n) (69069 * n)
-	state->s1 = LCG(s);
-	state->s2 = LCG(state->s1);
-	state->s3 = LCG(state->s2);
-
-	/* "warm it up" */
-	__random32(state);
-	__random32(state);
-	__random32(state);
-	__random32(state);
-	__random32(state);
-	__random32(state);
+	return (x < m) ? x + m : x;
 }
 
 /**
@@ -107,7 +96,7 @@ void srandom32(u32 entropy)
 	 */
 	for_each_possible_cpu (i) {
 		struct rnd_state *state = &per_cpu(net_rand_state, i);
-		__set_random32(state, state->s1 ^ entropy);
+		state->s1 = __seed(state->s1 ^ entropy, 1);
 	}
 }
 EXPORT_SYMBOL(srandom32);
@@ -122,7 +111,19 @@ static int __init random32_init(void)
 
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
-		__set_random32(state, i + jiffies);
+
+#define LCG(x)	(x * 69069)	/* super-duper LCG */
+		state->s1 = __seed(LCG(i + jiffies), 1);
+		state->s2 = __seed(LCG(state->s1), 7);
+		state->s3 = __seed(LCG(state->s2), 15);
+
+		/* "warm it up" */
+		__random32(state);
+		__random32(state);
+		__random32(state);
+		__random32(state);
+		__random32(state);
+		__random32(state);
 	}
 	return 0;
 }
@@ -135,13 +136,18 @@ core_initcall(random32_init);
 static int __init random32_reseed(void)
 {
 	int i;
-	unsigned long seed;
 
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
+		u32 seeds[3];
+
+		get_random_bytes(&seeds, sizeof(seeds));
+		state->s1 = __seed(seeds[0], 1);
+		state->s2 = __seed(seeds[1], 7);
+		state->s3 = __seed(seeds[2], 15);
 
-		get_random_bytes(&seed, sizeof(seed));
-		__set_random32(state, seed);
+		/* mix it in */
+		__random32(state);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

random32-seeding-improvement.patch


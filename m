From: akpm@linux-foundation.org
Subject: + random32-seeding-improvement-v2.patch added to -mm tree
Date: Wed, 02 Jul 2008 12:51:57 -0700
Message-ID: <200807021951.m62Jpvcw000722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbYGBTxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 15:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, ak@suse.de, bboissin@gmail.com, davem@davemloft.net, lloyd@randombit.net, mpm@selenic.com, shemminger@vyatta.com, tytso@mit.edu


The patch titled
     random32: seeding improvement (v2)
has been added to the -mm tree.  Its filename is
     random32-seeding-improvement-v2.patch

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
Subject: random32: seeding improvement (v2)
From: Stephen Hemminger <shemminger@linux-foundation.org>

Please consider this patch instead for fixing the seeding issue with random32.
The rationale is:
   * use u32 consistently
   * no need to do LCG on values from (better) get_random_bytes
   * use more data from get_random_bytes for secondary seeding
   * don't reduce state space on srandom32()
   * enforce state variable initialization restrictions

Note: the second paper has a version of random32() with even longer period
and a version of random64() if needed.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jack Lloyd <lloyd@randombit.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: Benoit Boissinot <bboissin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/random32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/random32.c~random32-seeding-improvement-v2 lib/random32.c
--- a/lib/random32.c~random32-seeding-improvement-v2
+++ a/lib/random32.c
@@ -112,7 +112,7 @@ static int __init random32_init(void)
 	for_each_possible_cpu(i) {
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
 
-#define LCG(x)	(x * 69069)	/* super-duper LCG */
+#define LCG(x)	((x) * 69069)	/* super-duper LCG */
 		state->s1 = __seed(LCG(i + jiffies), 1);
 		state->s2 = __seed(LCG(state->s1), 7);
 		state->s3 = __seed(LCG(state->s2), 15);
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

random32-seeding-improvement.patch
random32-seeding-improvement-v2.patch


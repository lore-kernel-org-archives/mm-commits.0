From: akpm@linux-foundation.org
Subject: - random32-seeding-improvement-v2.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:35:24 -0700
Message-ID: <200807301935.m6UJZPTf012326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755506AbYG3Tfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, ak@suse.de, bboissin@gmail.com, davem@davemloft.net, lloyd@randombit.net, mpm@selenic.com, shemminger@vyatta.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random32: seeding improvement (v2)
has been removed from the -mm tree.  Its filename was
     random32-seeding-improvement-v2.patch

This patch was dropped because it was folded into random32-seeding-improvement.patch

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
bridge-send-correct-mtu-value-in-pmtu.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
sky2-adapt-to-use-reworked-pci-pm-code.patch
tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch


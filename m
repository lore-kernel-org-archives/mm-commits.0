From: akpm@linux-foundation.org
Subject: + bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs.patch added to -mm tree
Date: Tue, 01 Jul 2008 02:11:10 -0700
Message-ID: <200807010911.m619BAde019198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbYGAJL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 05:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lloyd@randombit.net, ak@suse.de, davem@davemloft.net, mpm@selenic.com, shemminger@linuxfoundation.org, tytso@mit.edu


The patch titled
     Bug in random32.c: all-zero outputs with probability 1/2^32, other seeding bugs
has been added to the -mm tree.  Its filename is
     bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs.patch

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
Subject: Bug in random32.c: all-zero outputs with probability 1/2^32, other seeding bugs
From: Jack Lloyd <lloyd@randombit.net>

There appears to be an error in how random seeding is done in the
random32.c RNG.  I am looking at 2.6.25.7.

For background, that file contains this comment:

"""
        ... the k_j most significant bits of z_j must be non-
        zero, for each j. (Note: this restriction also applies to the
        computer code given in [4], but was mistakenly not mentioned in
        that paper.)

   This affects the seeding procedure by imposing the requirement
   s1 > 1, s2 > 7, s3 > 15.
"""

The function random32_reseed takes an unsigned long's worth of entropy
from the entropy pool (get_random_bytes) and passes it to __set_random32. 
That function (seemingly attempts) to impose the requirement mentioned
above by first checking if the seed is == 0, and if so setting it to one,
then setting s2 to s*69069 and s3 to s2*69069

However this will allow bad seeds.  On 64-bit systems, if the low order 32
bits of the seed are zero, then the check for s == 0 will pass, but s1,
s2, and s3 will all be initialized to zero due to truncation.  This will,
since there are no additive factors in the RNG sequence, cause the RNG to
output nothing but zero values.  Assuming get_random_bytes returns uniform
random numbers, this will occur with probability around 1/2^32.

An easy and straightforward fix for this that doesn't require changing any
interfaces is to add

  s &= 0xFFFFFFFF;

before the check in __set_random32, which ensures this condition will be
caught by the check.  Alternately, you could replace the check for s == 0
with some logic like:

  if((s & 0xFFFFFFFF) == 0)
     s += 1;

since just chopping the seed to 32 bits does throw away some of your seed
input (with sizeof(long) == 8, at least; doesn't make any difference for
sizeof(long) == 4)

There are also many other seeds which will cause some (but not all) of the
seeding requirements to be violated.  Which seeds will cause this problem
depend on the size of unsigned long, since the multiplications by 69069
are done in that size.

For instance on 32-bit systems, a seed of 0x4BC54E0A will generate the
state:

  s1 = 0x4BC54E0A
  s2 = (s1 * 69069) % 2^32 = 2
  s3 = 2*69069 = 138138

In general, there seem to be large numbers of seeds that cause at least
one of the restrictions on s1, s2, s3 to be false.  The paper referenced
in the source is not clear exactly how badly the generator fails when only
one of the restrictions is violated.  Certainly it seems much less serious
than the 64-bit specific bug described above; which is fortunate since it
seems to occur much more often.  A trivial patch for both problems is
attached.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/random32.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/random32.c~bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs lib/random32.c
--- a/lib/random32.c~bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs
+++ a/lib/random32.c
@@ -58,13 +58,17 @@ static u32 __random32(struct rnd_state *
 
 static void __set_random32(struct rnd_state *state, unsigned long s)
 {
+       s &= 0xFFFFFFFF;
 	if (s == 0)
 		s = 1;      /* default seed is 1 */
 
 #define LCG(n) (69069 * n)
 	state->s1 = LCG(s);
+       if(state->s1 < 2) state->s1 += 2;
 	state->s2 = LCG(state->s1);
+       if(state->s2 < 8) state->s2 += 8;
 	state->s3 = LCG(state->s2);
+       if(state->s3 < 16) state->s3 += 16;
 
 	/* "warm it up" */
 	__random32(state);
_

Patches currently in -mm which might be from lloyd@randombit.net are

bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs.patch


From: akpm@linux-foundation.org
Subject: [merged] lib-random32c-minor-cleanups-and-kdoc-fix.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:33:44 -0700
Message-ID: <533f0918.LVmuEuRo1M50dMcR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaDDTdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:33:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, dborkman@redhat.com

Subject: [merged] lib-random32c-minor-cleanups-and-kdoc-fix.patch removed from -mm tree
To: dborkman@redhat.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:33:44 -0700


The patch titled
     Subject: lib/random32.c: minor cleanups and kdoc fix
has been removed from the -mm tree.  Its filename was
     lib-random32c-minor-cleanups-and-kdoc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Borkmann <dborkman@redhat.com>
Subject: lib/random32.c: minor cleanups and kdoc fix

These are just some very minor and misc cleanups in the PRNG.  In
prandom_u32() we store the result in an unsigned long which is unnecessary
as it should be u32 instead that we get from prandom_u32_state(). 
prandom_bytes_state()'s comment is in kdoc format, so change it into such
as it's done everywhere else.  Also, use the normal comment style for the
header comment.  Last but not least for readability, add some newlines.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/random32.c |   76 ++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff -puN lib/random32.c~lib-random32c-minor-cleanups-and-kdoc-fix lib/random32.c
--- a/lib/random32.c~lib-random32c-minor-cleanups-and-kdoc-fix
+++ a/lib/random32.c
@@ -1,37 +1,35 @@
 /*
-  This is a maximally equidistributed combined Tausworthe generator
-  based on code from GNU Scientific Library 1.5 (30 Jun 2004)
-
-  lfsr113 version:
-
-   x_n = (s1_n ^ s2_n ^ s3_n ^ s4_n)
-
-   s1_{n+1} = (((s1_n & 4294967294) << 18) ^ (((s1_n <<  6) ^ s1_n) >> 13))
-   s2_{n+1} = (((s2_n & 4294967288) <<  2) ^ (((s2_n <<  2) ^ s2_n) >> 27))
-   s3_{n+1} = (((s3_n & 4294967280) <<  7) ^ (((s3_n << 13) ^ s3_n) >> 21))
-   s4_{n+1} = (((s4_n & 4294967168) << 13) ^ (((s4_n <<  3) ^ s4_n) >> 12))
-
-   The period of this generator is about 2^113 (see erratum paper).
-
-   From: P. L'Ecuyer, "Maximally Equidistributed Combined Tausworthe
-   Generators", Mathematics of Computation, 65, 213 (1996), 203--213:
-   http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme.ps
-   ftp://ftp.iro.umontreal.ca/pub/simulation/lecuyer/papers/tausme.ps
-
-   There is an erratum in the paper "Tables of Maximally
-   Equidistributed Combined LFSR Generators", Mathematics of
-   Computation, 68, 225 (1999), 261--269:
-   http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme2.ps
-
-        ... the k_j most significant bits of z_j must be non-
-        zero, for each j. (Note: this restriction also applies to the
-        computer code given in [4], but was mistakenly not mentioned in
-        that paper.)
-
-   This affects the seeding procedure by imposing the requirement
-   s1 > 1, s2 > 7, s3 > 15, s4 > 127.
-
-*/
+ * This is a maximally equidistributed combined Tausworthe generator
+ * based on code from GNU Scientific Library 1.5 (30 Jun 2004)
+ *
+ * lfsr113 version:
+ *
+ * x_n = (s1_n ^ s2_n ^ s3_n ^ s4_n)
+ *
+ * s1_{n+1} = (((s1_n & 4294967294) << 18) ^ (((s1_n <<  6) ^ s1_n) >> 13))
+ * s2_{n+1} = (((s2_n & 4294967288) <<  2) ^ (((s2_n <<  2) ^ s2_n) >> 27))
+ * s3_{n+1} = (((s3_n & 4294967280) <<  7) ^ (((s3_n << 13) ^ s3_n) >> 21))
+ * s4_{n+1} = (((s4_n & 4294967168) << 13) ^ (((s4_n <<  3) ^ s4_n) >> 12))
+ *
+ * The period of this generator is about 2^113 (see erratum paper).
+ *
+ * From: P. L'Ecuyer, "Maximally Equidistributed Combined Tausworthe
+ * Generators", Mathematics of Computation, 65, 213 (1996), 203--213:
+ * http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme.ps
+ * ftp://ftp.iro.umontreal.ca/pub/simulation/lecuyer/papers/tausme.ps
+ *
+ * There is an erratum in the paper "Tables of Maximally Equidistributed
+ * Combined LFSR Generators", Mathematics of Computation, 68, 225 (1999),
+ * 261--269: http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme2.ps
+ *
+ *      ... the k_j most significant bits of z_j must be non-zero,
+ *      for each j. (Note: this restriction also applies to the
+ *      computer code given in [4], but was mistakenly not mentioned
+ *      in that paper.)
+ *
+ * This affects the seeding procedure by imposing the requirement
+ * s1 > 1, s2 > 7, s3 > 15, s4 > 127.
+ */
 
 #include <linux/types.h>
 #include <linux/percpu.h>
@@ -75,15 +73,17 @@ EXPORT_SYMBOL(prandom_u32_state);
  */
 u32 prandom_u32(void)
 {
-	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = prandom_u32_state(state);
+	u32 res;
+
+	res = prandom_u32_state(state);
 	put_cpu_var(state);
-	return r;
+
+	return res;
 }
 EXPORT_SYMBOL(prandom_u32);
 
-/*
+/**
  *	prandom_bytes_state - get the requested number of pseudo-random bytes
  *
  *	@state: pointer to state structure holding seeded state.
@@ -204,6 +204,7 @@ static int __init prandom_init(void)
 		prandom_seed_very_weak(state, (i + jiffies) ^ random_get_entropy());
 		prandom_warmup(state);
 	}
+
 	return 0;
 }
 core_initcall(prandom_init);
@@ -259,6 +260,7 @@ static void __prandom_reseed(bool late)
 
 	if (latch && !late)
 		goto out;
+
 	latch = true;
 
 	for_each_possible_cpu(i) {
_

Patches currently in -mm which might be from dborkman@redhat.com are

origin.patch
linux-next.patch


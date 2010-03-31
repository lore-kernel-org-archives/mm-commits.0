From: akpm@linux-foundation.org
Subject: + lib-random32-export-pseudo-random-number-generator-for-modules.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:30:25 -0700
Message-ID: <201003312130.o2VLUPfQ009758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758208Ab0CaVda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeykholt@cisco.com, mpm@selenic.com, tytso@mit.edu


The patch titled
     lib/random32: export pseudo-random number generator for modules
has been added to the -mm tree.  Its filename is
     lib-random32-export-pseudo-random-number-generator-for-modules.patch

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
Subject: lib/random32: export pseudo-random number generator for modules
From: Joe Eykholt <jeykholt@cisco.com>

This patch moves the definition of struct rnd_state and the inline
__seed() function to linux/random.h.  It renames the static __random32()
function to prandom32() and exports it for use in modules.

prandom32() is useful as a privately-seeded pseudo random number generator
that can give the same result every time it is initialized.

For FCoE FC-BB-6 VN2VN mode self-selected unique FC address generation, we
need an pseudo-random number generator seeded with the 64-bit world-wide
port name.  A truly random generator or one seeded with randomness won't
do because the same sequence of numbers should be generated each time we
boot or the link comes up.

A prandom32_seed() inline function is added to the header file.  It is
inlined not for speed, but so the function won't be expanded in the base
kernel, but only in the module that uses it.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/random.h |   28 ++++++++++++++++++++++++++++
 lib/random32.c         |   38 +++++++++++++++++---------------------
 2 files changed, 45 insertions(+), 21 deletions(-)

diff -puN include/linux/random.h~lib-random32-export-pseudo-random-number-generator-for-modules include/linux/random.h
--- a/include/linux/random.h~lib-random32-export-pseudo-random-number-generator-for-modules
+++ a/include/linux/random.h
@@ -40,6 +40,10 @@ struct rand_pool_info {
 	__u32	buf[0];
 };
 
+struct rnd_state {
+	__u32 s1, s2, s3;
+};
+
 /* Exported functions */
 
 #ifdef __KERNEL__
@@ -74,6 +78,30 @@ unsigned long randomize_range(unsigned l
 u32 random32(void);
 void srandom32(u32 seed);
 
+u32 prandom32(struct rnd_state *);
+
+/*
+ * Handle minimum values for seeds
+ */
+static inline u32 __seed(u32 x, u32 m)
+{
+	return (x < m) ? x + m : x;
+}
+
+/**
+ * prandom32_seed - set seed for prandom32().
+ * @state: pointer to state structure to receive the seed.
+ * @seed: arbitrary 64-bit value to use as a seed.
+ */
+static inline void prandom32_seed(struct rnd_state *state, u64 seed)
+{
+	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
+
+	state->s1 = __seed(i, 1);
+	state->s2 = __seed(i, 7);
+	state->s3 = __seed(i, 15);
+}
+
 #endif /* __KERNEL___ */
 
 #endif /* _LINUX_RANDOM_H */
diff -puN lib/random32.c~lib-random32-export-pseudo-random-number-generator-for-modules lib/random32.c
--- a/lib/random32.c~lib-random32-export-pseudo-random-number-generator-for-modules
+++ a/lib/random32.c
@@ -39,13 +39,16 @@
 #include <linux/jiffies.h>
 #include <linux/random.h>
 
-struct rnd_state {
-	u32 s1, s2, s3;
-};
-
 static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
-static u32 __random32(struct rnd_state *state)
+/**
+ *	prandom32 - seeded pseudo-random number generator.
+ *	@state: pointer to state structure holding seeded state.
+ *
+ *	This is used for pseudo-randomness with no outside seeding.
+ *	For more random results, use random32().
+ */
+u32 prandom32(struct rnd_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
 
@@ -55,14 +58,7 @@ static u32 __random32(struct rnd_state *
 
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
-
-/*
- * Handle minimum values for seeds
- */
-static inline u32 __seed(u32 x, u32 m)
-{
-	return (x < m) ? x + m : x;
-}
+EXPORT_SYMBOL(prandom32);
 
 /**
  *	random32 - pseudo random number generator
@@ -75,7 +71,7 @@ u32 random32(void)
 {
 	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = __random32(state);
+	r = prandom32(state);
 	put_cpu_var(state);
 	return r;
 }
@@ -118,12 +114,12 @@ static int __init random32_init(void)
 		state->s3 = __seed(LCG(state->s2), 15);
 
 		/* "warm it up" */
-		__random32(state);
-		__random32(state);
-		__random32(state);
-		__random32(state);
-		__random32(state);
-		__random32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
+		prandom32(state);
 	}
 	return 0;
 }
@@ -147,7 +143,7 @@ static int __init random32_reseed(void)
 		state->s3 = __seed(seeds[2], 15);
 
 		/* mix it in */
-		__random32(state);
+		prandom32(state);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from jeykholt@cisco.com are

drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
lib-random32-export-pseudo-random-number-generator-for-modules.patch


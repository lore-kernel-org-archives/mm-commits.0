From: akpm@linux-foundation.org
Subject: + random32-rename-random32-to-prandom.patch added to -mm tree
Date: Tue, 13 Nov 2012 12:04:18 -0800
Message-ID: <20121113200418.D0E68100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50584 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab2KMUEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 15:04:20 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so896612ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 12:04:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: random32: rename random32 to prandom
has been added to the -mm tree.  Its filename is
     random32-rename-random32-to-prandom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: random32: rename random32 to prandom

This renames all random32 functions to have 'prandom_' prefix as follows:

void prandom_seed(u32 seed);	/* rename from srandom32() */
u32 prandom_u32(void);		/* rename from random32() */
void prandom_seed_state(struct rnd_state *state, u64 seed);
				/* rename from prandom32_seed() */
u32 prandom_u32_state(struct rnd_state *state);
				/* rename from prandom32() */

The purpose of this renaming is to prevent some kernel developers from
assuming that prandom32() and random32() might imply that only
prandom32() was the one using a pseudo-random number generator by
prandom32's "p", and the result may be a very embarassing security
exposure.  This concern was expressed by Theodore Ts'o.

And furthermore, I'm going to introduce new functions for getting the
requested number of pseudo-random bytes.  If I continue to use both
prandom32 and random32 prefixes for these functions, the confusion
is getting worse.

As a result of this renaming, "prandom_" is the common prefix for
pseudo-random number library.

Currently, srandom32() and random32() are preserved because it is

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: David Laight <david.laight@aculab.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fcoe/fcoe_ctlr.c |    4 +-
 include/linux/random.h        |   17 ++++++++---
 lib/interval_tree_test_main.c |    7 ++--
 lib/random32.c                |   48 ++++++++++++++++----------------
 lib/rbtree_test.c             |    6 ++--
 5 files changed, 45 insertions(+), 37 deletions(-)

diff -puN drivers/scsi/fcoe/fcoe_ctlr.c~random32-rename-random32-to-prandom drivers/scsi/fcoe/fcoe_ctlr.c
--- a/drivers/scsi/fcoe/fcoe_ctlr.c~random32-rename-random32-to-prandom
+++ a/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2144,7 +2144,7 @@ static void fcoe_ctlr_vn_restart(struct 
 	 */
 	port_id = fip->port_id;
 	if (fip->probe_tries)
-		port_id = prandom32(&fip->rnd_state) & 0xffff;
+		port_id = prandom_u32_state(&fip->rnd_state) & 0xffff;
 	else if (!port_id)
 		port_id = fip->lp->wwpn & 0xffff;
 	if (!port_id || port_id == 0xffff)
@@ -2169,7 +2169,7 @@ static void fcoe_ctlr_vn_restart(struct 
 static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
 {
 	fip->probe_tries = 0;
-	prandom32_seed(&fip->rnd_state, fip->lp->wwpn);
+	prandom_seed_state(&fip->rnd_state, fip->lp->wwpn);
 	fcoe_ctlr_vn_restart(fip);
 }
 
diff -puN include/linux/random.h~random32-rename-random32-to-prandom include/linux/random.h
--- a/include/linux/random.h~random32-rename-random32-to-prandom
+++ a/include/linux/random.h
@@ -25,10 +25,17 @@ extern const struct file_operations rand
 unsigned int get_random_int(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
-u32 random32(void);
-void srandom32(u32 seed);
+u32 prandom_u32(void);
+void prandom_seed(u32 seed);
 
-u32 prandom32(struct rnd_state *);
+/*
+ * These macros are preserved for backward compatibility and should be
+ * removed as soon as a transition is finished.
+ */
+#define random32() prandom_u32()
+#define srandom32(seed) prandom_seed(seed)
+
+u32 prandom_u32_state(struct rnd_state *);
 
 /*
  * Handle minimum values for seeds
@@ -39,11 +46,11 @@ static inline u32 __seed(u32 x, u32 m)
 }
 
 /**
- * prandom32_seed - set seed for prandom32().
+ * prandom_seed_state - set seed for prandom_u32_state().
  * @state: pointer to state structure to receive the seed.
  * @seed: arbitrary 64-bit value to use as a seed.
  */
-static inline void prandom32_seed(struct rnd_state *state, u64 seed)
+static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
 	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
 
diff -puN lib/interval_tree_test_main.c~random32-rename-random32-to-prandom lib/interval_tree_test_main.c
--- a/lib/interval_tree_test_main.c~random32-rename-random32-to-prandom
+++ a/lib/interval_tree_test_main.c
@@ -30,7 +30,8 @@ static void init(void)
 {
 	int i;
 	for (i = 0; i < NODES; i++) {
-		u32 a = prandom32(&rnd), b = prandom32(&rnd);
+		u32 a = prandom_u32_state(&rnd);
+		u32 b = prandom_u32_state(&rnd);
 		if (a <= b) {
 			nodes[i].start = a;
 			nodes[i].last = b;
@@ -40,7 +41,7 @@ static void init(void)
 		}
 	}
 	for (i = 0; i < SEARCHES; i++)
-		queries[i] = prandom32(&rnd);
+		queries[i] = prandom_u32_state(&rnd);
 }
 
 static int interval_tree_test_init(void)
@@ -51,7 +52,7 @@ static int interval_tree_test_init(void)
 
 	printk(KERN_ALERT "interval tree insert/remove");
 
-	prandom32_seed(&rnd, 3141592653589793238ULL);
+	prandom_seed_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
diff -puN lib/random32.c~random32-rename-random32-to-prandom lib/random32.c
--- a/lib/random32.c~random32-rename-random32-to-prandom
+++ a/lib/random32.c
@@ -42,13 +42,13 @@
 static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 /**
- *	prandom32 - seeded pseudo-random number generator.
+ *	prandom_u32_state - seeded pseudo-random number generator.
  *	@state: pointer to state structure holding seeded state.
  *
  *	This is used for pseudo-randomness with no outside seeding.
- *	For more random results, use random32().
+ *	For more random results, use prandom_u32().
  */
-u32 prandom32(struct rnd_state *state)
+u32 prandom_u32_state(struct rnd_state *state)
 {
 #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
 
@@ -58,32 +58,32 @@ u32 prandom32(struct rnd_state *state)
 
 	return (state->s1 ^ state->s2 ^ state->s3);
 }
-EXPORT_SYMBOL(prandom32);
+EXPORT_SYMBOL(prandom_u32_state);
 
 /**
- *	random32 - pseudo random number generator
+ *	prandom_u32 - pseudo random number generator
  *
  *	A 32 bit pseudo-random number is generated using a fast
  *	algorithm suitable for simulation. This algorithm is NOT
  *	considered safe for cryptographic use.
  */
-u32 random32(void)
+u32 prandom_u32(void)
 {
 	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = prandom32(state);
+	r = prandom_u32_state(state);
 	put_cpu_var(state);
 	return r;
 }
-EXPORT_SYMBOL(random32);
+EXPORT_SYMBOL(prandom_u32);
 
 /**
- *	srandom32 - add entropy to pseudo random number generator
+ *	prandom_seed - add entropy to pseudo random number generator
  *	@seed: seed value
  *
- *	Add some additional seeding to the random32() pool.
+ *	Add some additional seeding to the prandom pool.
  */
-void srandom32(u32 entropy)
+void prandom_seed(u32 entropy)
 {
 	int i;
 	/*
@@ -95,13 +95,13 @@ void srandom32(u32 entropy)
 		state->s1 = __seed(state->s1 ^ entropy, 1);
 	}
 }
-EXPORT_SYMBOL(srandom32);
+EXPORT_SYMBOL(prandom_seed);
 
 /*
  *	Generate some initially weak seeding values to allow
- *	to start the random32() engine.
+ *	to start the prandom_u32() engine.
  */
-static int __init random32_init(void)
+static int __init prandom_init(void)
 {
 	int i;
 
@@ -114,22 +114,22 @@ static int __init random32_init(void)
 		state->s3 = __seed(LCG(state->s2), 15);
 
 		/* "warm it up" */
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
-		prandom32(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
+		prandom_u32_state(state);
 	}
 	return 0;
 }
-core_initcall(random32_init);
+core_initcall(prandom_init);
 
 /*
  *	Generate better values after random number generator
  *	is fully initialized.
  */
-static int __init random32_reseed(void)
+static int __init prandom_reseed(void)
 {
 	int i;
 
@@ -143,8 +143,8 @@ static int __init random32_reseed(void)
 		state->s3 = __seed(seeds[2], 15);
 
 		/* mix it in */
-		prandom32(state);
+		prandom_u32_state(state);
 	}
 	return 0;
 }
-late_initcall(random32_reseed);
+late_initcall(prandom_reseed);
diff -puN lib/rbtree_test.c~random32-rename-random32-to-prandom lib/rbtree_test.c
--- a/lib/rbtree_test.c~random32-rename-random32-to-prandom
+++ a/lib/rbtree_test.c
@@ -96,8 +96,8 @@ static void init(void)
 {
 	int i;
 	for (i = 0; i < NODES; i++) {
-		nodes[i].key = prandom32(&rnd);
-		nodes[i].val = prandom32(&rnd);
+		nodes[i].key = prandom_u32_state(&rnd);
+		nodes[i].val = prandom_u32_state(&rnd);
 	}
 }
 
@@ -155,7 +155,7 @@ static int rbtree_test_init(void)
 
 	printk(KERN_ALERT "rbtree testing");
 
-	prandom32_seed(&rnd, 3141592653589793238ULL);
+	prandom_seed_state(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch


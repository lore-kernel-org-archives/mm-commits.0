From: akpm@linux-foundation.org
Subject: [merged] prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:45 -0800
Message-ID: <20121218201146.5BE7420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:37002 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRULw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:52 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so69938lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prandom: introduce prandom_bytes() and prandom_bytes_state()
has been removed from the -mm tree.  Its filename was
     prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: prandom: introduce prandom_bytes() and prandom_bytes_state()

Add functions to get the requested number of pseudo-random bytes.

The difference from get_random_bytes() is that it generates pseudo-random
numbers by prandom_u32().  It doesn't consume the entropy pool, and the
sequence is reproducible if the same rnd_state is used.  So it is suitable
for generating random bytes for testing.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: David Laight <david.laight@aculab.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/random.h |    2 +
 lib/random32.c         |   49 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff -puN include/linux/random.h~prandom-introduce-prandom_bytes-and-prandom_bytes_state include/linux/random.h
--- a/include/linux/random.h~prandom-introduce-prandom_bytes-and-prandom_bytes_state
+++ a/include/linux/random.h
@@ -26,6 +26,7 @@ unsigned int get_random_int(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
 u32 prandom_u32(void);
+void prandom_bytes(void *buf, int nbytes);
 void prandom_seed(u32 seed);
 
 /*
@@ -36,6 +37,7 @@ void prandom_seed(u32 seed);
 #define srandom32(seed) prandom_seed(seed)
 
 u32 prandom_u32_state(struct rnd_state *);
+void prandom_bytes_state(struct rnd_state *state, void *buf, int nbytes);
 
 /*
  * Handle minimum values for seeds
diff -puN lib/random32.c~prandom-introduce-prandom_bytes-and-prandom_bytes_state lib/random32.c
--- a/lib/random32.c~prandom-introduce-prandom_bytes-and-prandom_bytes_state
+++ a/lib/random32.c
@@ -77,6 +77,55 @@ u32 prandom_u32(void)
 }
 EXPORT_SYMBOL(prandom_u32);
 
+/*
+ *	prandom_bytes_state - get the requested number of pseudo-random bytes
+ *
+ *	@state: pointer to state structure holding seeded state.
+ *	@buf: where to copy the pseudo-random bytes to
+ *	@bytes: the requested number of bytes
+ *
+ *	This is used for pseudo-randomness with no outside seeding.
+ *	For more random results, use prandom_bytes().
+ */
+void prandom_bytes_state(struct rnd_state *state, void *buf, int bytes)
+{
+	unsigned char *p = buf;
+	int i;
+
+	for (i = 0; i < round_down(bytes, sizeof(u32)); i += sizeof(u32)) {
+		u32 random = prandom_u32_state(state);
+		int j;
+
+		for (j = 0; j < sizeof(u32); j++) {
+			p[i + j] = random;
+			random >>= BITS_PER_BYTE;
+		}
+	}
+	if (i < bytes) {
+		u32 random = prandom_u32_state(state);
+
+		for (; i < bytes; i++) {
+			p[i] = random;
+			random >>= BITS_PER_BYTE;
+		}
+	}
+}
+EXPORT_SYMBOL(prandom_bytes_state);
+
+/**
+ *	prandom_bytes - get the requested number of pseudo-random bytes
+ *	@buf: where to copy the pseudo-random bytes to
+ *	@bytes: the requested number of bytes
+ */
+void prandom_bytes(void *buf, int bytes)
+{
+	struct rnd_state *state = &get_cpu_var(net_rand_state);
+
+	prandom_bytes_state(state, buf, bytes);
+	put_cpu_var(state);
+}
+EXPORT_SYMBOL(prandom_bytes);
+
 /**
  *	prandom_seed - add entropy to pseudo random number generator
  *	@seed: seed value
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch


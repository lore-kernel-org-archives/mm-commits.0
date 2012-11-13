From: akpm@linux-foundation.org
Subject: + prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:54:24 -0800
Message-ID: <20121113195424.7BAA8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55182 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab2KMTy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:54:26 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so38412yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:54:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: prandom: introduce prandom_bytes() and prandom_bytes_state()
has been added to the -mm tree.  Its filename is
     prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch

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


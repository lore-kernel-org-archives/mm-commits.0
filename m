From: akpm@linux-foundation.org
Subject: + random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on.patch added to -mm tree
Date: Tue, 25 Nov 2008 17:10:02 -0800
Message-ID: <200811260110.mAQ1A2HS001243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbYKZBLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com, mpm@selenic.com, tytso@mit.edu


The patch titled
     random: add a way to get some random bits into the entropy pools early on
has been added to the -mm tree.  Its filename is
     random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on.patch

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
Subject: random: add a way to get some random bits into the entropy pools early on
From: Arjan van de Ven <arjan@infradead.org>

Currently the entropy pool gets seeded on the module_init() level, but
there is at least one consumer of random bits which wants random data at
an earluier time: the oops ID that is printed as part of the oops.  As a
result of this, kerneloops.org is seeing a lot of oopses that all share
the same 'random' number; which used to get filed away as "duplicate".

This patch adds a function to the random driver so that various pieces of
the kernel can add random bits (but not entropy!) to the pool, to avoid
this duplicate ID problem.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic.c |    7 +++++++
 drivers/char/random.c  |   29 +++++++++++++++++++++++++++++
 include/linux/random.h |    3 +++
 kernel/panic.c         |    1 +
 4 files changed, 40 insertions(+)

diff -puN arch/x86/kernel/apic.c~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on arch/x86/kernel/apic.c
--- a/arch/x86/kernel/apic.c~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on
+++ a/arch/x86/kernel/apic.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/dmar.h>
+#include <linux/random.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -687,6 +688,12 @@ static int __init calibrate_APIC_clock(v
 	} else
 		local_irq_enable();
 
+	/*
+	 * by now we have enough time spent that there is some value in
+	 * pushing the timestamp to the random pools for early kernel use.
+	 */
+	seed_random_pools();
+
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
 		pr_warning("APIC timer disabled due to verification failure.\n");
 			return -1;
diff -puN drivers/char/random.c~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on drivers/char/random.c
--- a/drivers/char/random.c~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on
+++ a/drivers/char/random.c
@@ -929,6 +929,35 @@ static int rand_initialize(void)
 }
 module_init(rand_initialize);
 
+/*
+ * seed_std_data - seed pool with system timing data
+ *
+ * @r: pool to initialize
+ *
+ * This function mixes some system data into the pool to prepare it for use.
+ * This function can be called really early during boot to at least get some
+ * randomness from the system if random numbers are needed early, for example
+ * as part of the early oops printing.
+ *
+ * No entropy is credited for this seeding.
+ */
+static void seed_std_data(struct entropy_store *r)
+{
+	ktime_t now;
+	unsigned long flags;
+
+	now = ktime_get_real();
+	mix_pool_bytes(r, &now, sizeof(now));
+}
+
+int seed_random_pools(void)
+{
+	seed_std_data(&input_pool);
+	seed_std_data(&blocking_pool);
+	seed_std_data(&nonblocking_pool);
+	return 0;
+}
+
 void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
diff -puN include/linux/random.h~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on include/linux/random.h
--- a/include/linux/random.h~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on
+++ a/include/linux/random.h
@@ -72,6 +72,9 @@ unsigned long randomize_range(unsigned l
 u32 random32(void);
 void srandom32(u32 seed);
 
+int seed_random_pools(void);
+
+
 #endif /* __KERNEL___ */
 
 #endif /* _LINUX_RANDOM_H */
diff -puN kernel/panic.c~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on kernel/panic.c
--- a/kernel/panic.c~random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on
+++ a/kernel/panic.c
@@ -299,6 +299,7 @@ static u64 oops_id;
 
 static int init_oops_id(void)
 {
+	seed_random_pools();
 	if (!oops_id)
 		get_random_bytes(&oops_id, sizeof(oops_id));
 	else
_

Patches currently in -mm which might be from arjan@infradead.org are

mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
vfs-expand-some-comments-d_path-seq_path.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
jbd-improve-fsync-batching.patch
jbd-improve-fsync-batching-update.patch
random-add-a-way-to-get-some-random-bits-into-the-entropy-pools-early-on.patch


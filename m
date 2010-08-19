From: akpm@linux-foundation.org
Subject: + replace-nested-max-min-macros-with-maxmin3-macro.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:14:34 -0700
Message-ID: <201008192314.o7JNEZqI014134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab0HSXPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hagen@jauu.net, benh@kernel.crashing.org, herbert@gondor.hengli.com.au, hsweeten@visionengravers.com, joe@perches.com, linux@arm.linux.org.uk, mingo@elte.hu, penberg@cs.helsinki.fi, rolandd@cisco.com, sean.hefty@intel.com, tglx@linutronix.de


The patch titled
     replace nested max/min macros with {max,min}3 macro
has been added to the -mm tree.  Its filename is
     replace-nested-max-min-macros-with-maxmin3-macro.patch

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
Subject: replace nested max/min macros with {max,min}3 macro
From: Hagen Paul Pfeifer <hagen@jauu.net>

Use the new {max,min}3 macros to save some cycles and bytes on the stack. 
This patch substitutes trivial nested macros with their counterpart.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ep93xx/clock.c              |    3 +--
 arch/powerpc/kernel/vio.c                 |    4 +---
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    1 +
 drivers/crypto/hifn_795x.c                |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 +--
 drivers/macintosh/windfarm_pm121.c        |    2 +-
 drivers/video/au1200fb.c                  |    2 +-
 mm/slab.c                                 |    2 +-
 8 files changed, 9 insertions(+), 12 deletions(-)

diff -puN arch/arm/mach-ep93xx/clock.c~replace-nested-max-min-macros-with-maxmin3-macro arch/arm/mach-ep93xx/clock.c
--- a/arch/arm/mach-ep93xx/clock.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/arch/arm/mach-ep93xx/clock.c
@@ -358,8 +358,7 @@ static int calc_clk_div(struct clk *clk,
 	int i, found = 0, __div = 0, __pdiv = 0;
 
 	/* Don't exceed the maximum rate */
-	max_rate = max(max(clk_pll1.rate / 4, clk_pll2.rate / 4),
-		       clk_xtali.rate / 4);
+	max_rate = max3(clk_pll1.rate / 4, clk_pll2.rate / 4, clk_xtali.rate / 4);
 	rate = min(rate, max_rate);
 
 	/*
diff -puN arch/powerpc/kernel/vio.c~replace-nested-max-min-macros-with-maxmin3-macro arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/arch/powerpc/kernel/vio.c
@@ -238,9 +238,7 @@ static inline void vio_cmo_dealloc(struc
 	 * memory in this pool does not change.
 	 */
 	if (spare_needed && reserve_freed) {
-		tmp = min(spare_needed, min(reserve_freed,
-		                            (viodev->cmo.entitled -
-		                             VIO_CMO_MIN_ENT)));
+		tmp = min3(spare_needed, reserve_freed, (viodev->cmo.entitled - VIO_CMO_MIN_ENT));
 
 		vio_cmo.spare += tmp;
 		viodev->cmo.entitled -= tmp;
diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~replace-nested-max-min-macros-with-maxmin3-macro arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -327,6 +327,7 @@ static void __cpuinit amd_calc_l3_indice
 	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
 	l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
 static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
diff -puN drivers/crypto/hifn_795x.c~replace-nested-max-min-macros-with-maxmin3-macro drivers/crypto/hifn_795x.c
--- a/drivers/crypto/hifn_795x.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/drivers/crypto/hifn_795x.c
@@ -1467,7 +1467,7 @@ static int ablkcipher_add(unsigned int *
 		return -EINVAL;
 
 	while (size) {
-		copy = min(drest, min(size, dst->length));
+		copy = min3(drest, size, dst->length);
 
 		size -= copy;
 		drest -= copy;
@@ -1729,7 +1729,7 @@ static int ablkcipher_get(void *saddr, u
 		return -EINVAL;
 
 	while (size) {
-		copy = min(srest, min(dst->length, size));
+		copy = min3(srest, dst->length, size);
 
 		daddr = kmap_atomic(sg_page(dst), KM_IRQ0);
 		memcpy(daddr + dst->offset + offset, saddr, copy);
diff -puN drivers/infiniband/ulp/ipoib/ipoib_main.c~replace-nested-max-min-macros-with-maxmin3-macro drivers/infiniband/ulp/ipoib/ipoib_main.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1409,8 +1409,7 @@ static int __init ipoib_init_module(void
 
 	ipoib_sendq_size = roundup_pow_of_two(ipoib_sendq_size);
 	ipoib_sendq_size = min(ipoib_sendq_size, IPOIB_MAX_QUEUE_SIZE);
-	ipoib_sendq_size = max(ipoib_sendq_size, max(2 * MAX_SEND_CQE,
-						     IPOIB_MIN_QUEUE_SIZE));
+	ipoib_sendq_size = max3(ipoib_sendq_size, 2 * MAX_SEND_CQE, IPOIB_MIN_QUEUE_SIZE);
 #ifdef CONFIG_INFINIBAND_IPOIB_CM
 	ipoib_max_conn_qp = min(ipoib_max_conn_qp, IPOIB_CM_MAX_CONN_QP);
 #endif
diff -puN drivers/macintosh/windfarm_pm121.c~replace-nested-max-min-macros-with-maxmin3-macro drivers/macintosh/windfarm_pm121.c
--- a/drivers/macintosh/windfarm_pm121.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/drivers/macintosh/windfarm_pm121.c
@@ -482,7 +482,7 @@ static s32 pm121_correct(s32 new_setpoin
 	new_min += correction->offset;
 	new_min = (new_min >> 16) + min;
 
-	return max(new_setpoint, max(new_min, 0));
+	return max3(new_setpoint, new_min, 0);
 }
 
 static s32 pm121_connect(unsigned int control_id, s32 setpoint)
diff -puN drivers/video/au1200fb.c~replace-nested-max-min-macros-with-maxmin3-macro drivers/video/au1200fb.c
--- a/drivers/video/au1200fb.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/drivers/video/au1200fb.c
@@ -1079,7 +1079,7 @@ static int au1200fb_fb_check_var(struct 
 	 * clock can only be obtain by dividing this value by an even integer.
 	 * Fallback to a slower pixel clock if necessary. */
 	pixclock = max((u32)(PICOS2KHZ(var->pixclock) * 1000), fbi->monspecs.dclkmin);
-	pixclock = min(pixclock, min(fbi->monspecs.dclkmax, (u32)AU1200_LCD_MAX_CLK/2));
+	pixclock = min3(pixclock, fbi->monspecs.dclkmax, (u32)AU1200_LCD_MAX_CLK/2);
 
 	if (AU1200_LCD_MAX_CLK % pixclock) {
 		int diff = AU1200_LCD_MAX_CLK % pixclock;
diff -puN mm/slab.c~replace-nested-max-min-macros-with-maxmin3-macro mm/slab.c
--- a/mm/slab.c~replace-nested-max-min-macros-with-maxmin3-macro
+++ a/mm/slab.c
@@ -901,7 +901,7 @@ static int transfer_objects(struct array
 		struct array_cache *from, unsigned int max)
 {
 	/* Figure out how many entries to transfer */
-	int nr = min(min(from->avail, max), to->limit - to->avail);
+	int nr = min3(from->avail, max, to->limit - to->avail);
 
 	if (!nr)
 		return 0;
_

Patches currently in -mm which might be from hagen@jauu.net are

kernelh-add-minmax3-macros.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch


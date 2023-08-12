Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A789C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjHLWGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjHLWF7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561EC9F
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF958620CF
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E24C433C8;
        Sat, 12 Aug 2023 22:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877961;
        bh=e6KXRao2eYEMwG2WhnuX3+agBatcJpe0TbYcfcTQY3U=;
        h=Date:To:From:Subject:From;
        b=okABbvJaruj8IrQNfI51aCyHULOrWHqUB2KEjPFiASjnsTcI757MBV6OPwCMOR2z7
         QIpZsEHfa3vTlgXDQHqDyYpXlJQBZI21S+QzEOAD6fUrODe4SUytWxV25d2wBnCDkl
         SP8PDWnQUIbLJ2KOBin6p3/7brIV7C7UgK1cydMo=
Date:   Sat, 12 Aug 2023 15:06:00 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@linux.intel.com,
        rodrigo.vivi@intel.com, rdunlap@infradead.org,
        p.zabel@pengutronix.de, linux@rasmusvillemoes.dk,
        joonas.lahtinen@linux.intel.com, jirislaby@kernel.org,
        jani.nikula@linux.intel.com, jani.nikula@intel.com,
        imre.deak@intel.com, gregkh@linuxfoundation.org, deller@gmx.de,
        daniel@ffwll.ch, andi.shyti@linux.intel.com, airlied@gmail.com,
        adobriyan@gmail.com, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-i915-move-abs_diff-to-mathh.patch removed from -mm tree
Message-Id: <20230812220601.42E24C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm/i915: Move abs_diff() to math.h
has been removed from the -mm tree.  Its filename was
     drm-i915-move-abs_diff-to-mathh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drm/i915: Move abs_diff() to math.h
Date: Thu, 3 Aug 2023 16:19:18 +0300

abs_diff() belongs to math.h.  Move it there.  This will allow others to
use it.

[andriy.shevchenko@linux.intel.com: add abs_diff() documentation]
  Link: https://lkml.kernel.org/r/20230804050934.83223-1-andriy.shevchenko@linux.intel.com
[akpm@linux-foundation.org: fix comment, per Randy]
Link: https://lkml.kernel.org/r/20230803131918.53727-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org> # tty/serial
Acked-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de> # gpu/ipu-v3
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |    1 
 drivers/gpu/drm/i915/display/intel_dpll_mgr.h |    7 -----
 drivers/gpu/ipu-v3/ipu-image-convert.c        |   15 +++++-------
 drivers/tty/serial/omap-serial.c              |    7 -----
 drivers/video/fbdev/core/svgalib.c            |    7 -----
 include/linux/math.h                          |   19 ++++++++++++++++
 6 files changed, 29 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c~drm-i915-move-abs_diff-to-mathh
+++ a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -21,6 +21,7 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
+#include <linux/math.h>
 #include <linux/string_helpers.h>
 
 #include "i915_reg.h"
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.h~drm-i915-move-abs_diff-to-mathh
+++ a/drivers/gpu/drm/i915/display/intel_dpll_mgr.h
@@ -29,13 +29,6 @@
 
 #include "intel_wakeref.h"
 
-/*FIXME: Move this to a more appropriate place. */
-#define abs_diff(a, b) ({			\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	(void) (&__a == &__b);			\
-	__a > __b ? (__a - __b) : (__b - __a); })
-
 enum tc_port;
 struct drm_i915_private;
 struct intel_atomic_state;
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c~drm-i915-move-abs_diff-to-mathh
+++ a/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -7,7 +7,10 @@
 
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
+#include <linux/math.h>
+
 #include <video/imx-ipu-image-convert.h>
+
 #include "ipu-prv.h"
 
 /*
@@ -543,7 +546,7 @@ static void find_best_seam(struct ipu_im
 		unsigned int in_pos;
 		unsigned int in_pos_aligned;
 		unsigned int in_pos_rounded;
-		unsigned int abs_diff;
+		unsigned int diff;
 
 		/*
 		 * Tiles in the right row / bottom column may not be allowed to
@@ -575,15 +578,11 @@ static void find_best_seam(struct ipu_im
 		    (in_edge - in_pos_rounded) % in_burst)
 			continue;
 
-		if (in_pos < in_pos_aligned)
-			abs_diff = in_pos_aligned - in_pos;
-		else
-			abs_diff = in_pos - in_pos_aligned;
-
-		if (abs_diff < min_diff) {
+		diff = abs_diff(in_pos, in_pos_aligned);
+		if (diff < min_diff) {
 			in_seam = in_pos_rounded;
 			out_seam = out_pos;
-			min_diff = abs_diff;
+			min_diff = diff;
 		}
 	}
 
--- a/drivers/tty/serial/omap-serial.c~drm-i915-move-abs_diff-to-mathh
+++ a/drivers/tty/serial/omap-serial.c
@@ -222,16 +222,11 @@ static inline int calculate_baud_abs_dif
 				unsigned int baud, unsigned int mode)
 {
 	unsigned int n = port->uartclk / (mode * baud);
-	int abs_diff;
 
 	if (n == 0)
 		n = 1;
 
-	abs_diff = baud - (port->uartclk / (mode * n));
-	if (abs_diff < 0)
-		abs_diff = -abs_diff;
-
-	return abs_diff;
+	return abs_diff(baud, port->uartclk / (mode * n));
 }
 
 /*
--- a/drivers/video/fbdev/core/svgalib.c~drm-i915-move-abs_diff-to-mathh
+++ a/drivers/video/fbdev/core/svgalib.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/fb.h>
+#include <linux/math.h>
 #include <linux/svga.h>
 #include <asm/types.h>
 #include <asm/io.h>
@@ -372,12 +373,6 @@ EXPORT_SYMBOL(svga_get_caps);
  *  F_VCO = (F_BASE * M) / N
  *  F_OUT = F_VCO / (2^R)
  */
-
-static inline u32 abs_diff(u32 a, u32 b)
-{
-	return (a > b) ? (a - b) : (b - a);
-}
-
 int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node)
 {
 	u16 am, an, ar;
--- a/include/linux/math.h~drm-i915-move-abs_diff-to-mathh
+++ a/include/linux/math.h
@@ -156,6 +156,25 @@ __STRUCT_FRACT(u32)
 	({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
 
 /**
+ * abs_diff - return absolute value of the difference between the arguments
+ * @a: the first argument
+ * @b: the second argument
+ *
+ * @a and @b have to be of the same type. With this restriction we compare
+ * signed to signed and unsigned to unsigned. The result is the subtraction
+ * the smaller of the two from the bigger, hence result is always a positive
+ * value.
+ *
+ * Return: an absolute value of the difference between the @a and @b.
+ */
+#define abs_diff(a, b) ({			\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	(void)(&__a == &__b);			\
+	__a > __b ? (__a - __b) : (__b - __a);	\
+})
+
+/**
  * reciprocal_scale - "scale" a value into range [0, ep_ro)
  * @val: value
  * @ep_ro: right open interval endpoint
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



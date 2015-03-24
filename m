From: akpm@linux-foundation.org
Subject: + kernelh-implement-div_round_closest_ull.patch added to -mm tree
Date: Tue, 24 Mar 2015 14:01:27 -0700
Message-ID: <5511d0a7.LtlIW0Y+jWUTCiMk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbCXVB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javi.merino@arm.com, airlied@linux.ie, crope@iki.fi, daniel.vetter@ffwll.ch, elder@linaro.org, jani.nikula@linux.intel.com, linux@roeck-us.net, mchehab@osg.samsung.com, mgorman@suse.de, mturquette@linaro.org, rafael.j.wysocki@intel.com, sboyd@codeaurora.org, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: implement DIV_ROUND_CLOSEST_ULL
has been added to the -mm tree.  Its filename is
     kernelh-implement-div_round_closest_ull.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-implement-div_round_closest_ull.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-implement-div_round_closest_ull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javi Merino <javi.merino@arm.com>
Subject: kernel.h: implement DIV_ROUND_CLOSEST_ULL

We have grown a number of different implementations of
DIV_ROUND_CLOSEST_ULL throughout the kernel.  Move the i915 one to
kernel.h so that it can be reused.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Guenter Roeck <linux@roeck-us.net>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Alex Elder <elder@linaro.org>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Javi Merino <javi.merino@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_drv.h   |    3 ---
 drivers/gpu/drm/i915/intel_panel.c |    1 +
 include/linux/kernel.h             |   12 ++++++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_drv.h~kernelh-implement-div_round_closest_ull drivers/gpu/drm/i915/intel_drv.h
--- a/drivers/gpu/drm/i915/intel_drv.h~kernelh-implement-div_round_closest_ull
+++ a/drivers/gpu/drm/i915/intel_drv.h
@@ -36,9 +36,6 @@
 #include <drm/drm_dp_mst_helper.h>
 #include <drm/drm_rect.h>
 
-#define DIV_ROUND_CLOSEST_ULL(ll, d)	\
-({ unsigned long long _tmp = (ll)+(d)/2; do_div(_tmp, d); _tmp; })
-
 /**
  * _wait_for - magic (register) wait macro
  *
diff -puN drivers/gpu/drm/i915/intel_panel.c~kernelh-implement-div_round_closest_ull drivers/gpu/drm/i915/intel_panel.c
--- a/drivers/gpu/drm/i915/intel_panel.c~kernelh-implement-div_round_closest_ull
+++ a/drivers/gpu/drm/i915/intel_panel.c
@@ -30,6 +30,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kernel.h>
 #include <linux/moduleparam.h>
 #include "intel_drv.h"
 
diff -puN include/linux/kernel.h~kernelh-implement-div_round_closest_ull include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-implement-div_round_closest_ull
+++ a/include/linux/kernel.h
@@ -103,6 +103,18 @@
 		(((__x) - ((__d) / 2)) / (__d));	\
 }							\
 )
+/*
+ * Same as above but for u64 dividends. divisor must be a 32-bit
+ * number.
+ */
+#define DIV_ROUND_CLOSEST_ULL(x, divisor)(		\
+{							\
+	typeof(divisor) __d = divisor;			\
+	unsigned long long _tmp = (x) + (__d) / 2;	\
+	do_div(_tmp, __d);				\
+	_tmp;						\
+}							\
+)
 
 /*
  * Multiplies an integer by a fraction, while avoiding unnecessary
_

Patches currently in -mm which might be from javi.merino@arm.com are

kernelh-implement-div_round_closest_ull.patch
clk-bcm-kona-use-div_round_closest_ull.patch
cpuidle-menu-use-div_round_closest_ull.patch
media-cxd2820r-use-div_round_closest_ull.patch
linux-next.patch


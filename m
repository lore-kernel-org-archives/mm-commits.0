From: akpm@linux-foundation.org
Subject: [merged]
 drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch removed from -mm tree
Date: Fri, 27 May 2016 11:45:42 -0700
Message-ID: <574895d6.ubm2bsJsHG9Ks6Hq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbcE0Spn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heikki.krogerus@linux.intel.com, linus.walleij@linaro.org, mika.westerberg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/pinctrl/intel/pinctrl-baytrail.c: fix build with gcc-4.4
has been removed from the -mm tree.  Its filename was
     drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/pinctrl/intel/pinctrl-baytrail.c: fix build with gcc-4.4


drivers/pinctrl/intel/pinctrl-baytrail.c:413: error: unknown field 'simple_funcs' specified in initializer
drivers/pinctrl/intel/pinctrl-baytrail.c:413: warning: missing braces around initializer
drivers/pinctrl/intel/pinctrl-baytrail.c:413: warning: (near initialization for 'byt_score_groups[0].<anonymous>')
drivers/pinctrl/intel/pinctrl-baytrail.c:415: error: unknown field 'simple_funcs' specified in initializer
drivers/pinctrl/intel/pinctrl-baytrail.c:417: error: unknown field 'simple_funcs' specified in initializer
drivers/pinctrl/intel/pinctrl-baytrail.c:419: error: unknown field 'simple_funcs' specified in initializer
drivers/pinctrl/intel/pinctrl-baytrail.c:421: error: unknown field 'simple_funcs' specified in initializer

... etc

gcc-4.4 and thereabouts has issues with initializers of anonymous unions. 
Work around this.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pinctrl/intel/pinctrl-baytrail.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/pinctrl/intel/pinctrl-baytrail.c~drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44 drivers/pinctrl/intel/pinctrl-baytrail.c
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c~drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44
+++ a/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -153,8 +153,10 @@ struct byt_community {
 		.name			= (n),			\
 		.pins			= (p),			\
 		.npins			= ARRAY_SIZE((p)),	\
-		.has_simple_funcs	= 1,		\
-		.simple_funcs		= (f),			\
+		.has_simple_funcs	= 1,			\
+		{						\
+			.simple_funcs		= (f),		\
+		},						\
 		.nfuncs			= ARRAY_SIZE((f)),	\
 	}
 #define PIN_GROUP_MIXED(n, p, f)				\
@@ -163,7 +165,9 @@ struct byt_community {
 		.pins			= (p),			\
 		.npins			= ARRAY_SIZE((p)),	\
 		.has_simple_funcs	= 0,			\
-		.mixed_funcs		= (f),			\
+		{						\
+			.mixed_funcs		= (f),		\
+		},						\
 		.nfuncs			= ARRAY_SIZE((f)),	\
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


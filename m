From: akpm@linux-foundation.org
Subject: +
 drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch added
 to -mm tree
Date: Tue, 24 May 2016 14:49:01 -0700
Message-ID: <5744cc4d.0Sw29htj2iEdnf2f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbcEXVtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2016 17:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heikki.krogerus@linux.intel.com, linus.walleij@linaro.org, mika.westerberg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/pinctrl/intel/pinctrl-baytrail.c: fix build with gcc-4.4
has been added to the -mm tree.  Its filename is
     drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
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
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


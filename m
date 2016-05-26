From: akpm@linux-foundation.org
Subject: [patch 10/10] drivers/pinctrl/intel/pinctrl-baytrail.c: fix build with gcc-4.4
Date: Thu, 26 May 2016 15:16:30 -0700
Message-ID: <574775be.9XM6+dDlzyA5LoBq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbcEZWQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, heikki.krogerus@linux.intel.com, linus.walleij@linaro.org, mika.westerberg@linux.intel.com

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

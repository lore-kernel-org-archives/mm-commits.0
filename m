From: akpm@linux-foundation.org
Subject: - logoc-get-rid-of-mips_machgroup.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:36 -0700
Message-ID: <200710190340.l9J3eaZl012721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965749AbXJSDlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     logo.c: get rid of mips_machgroup
has been removed from the -mm tree.  Its filename was
     logoc-get-rid-of-mips_machgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: logo.c: get rid of mips_machgroup
From: Ralf Baechle <ralf@linux-mips.org>

This has not been any serious user of this ill conceived thing since the
original invention in like '95 so I recently deleted this from everywhere
except the last instance in logo.c.  This patch removes the last two
instances in logo.c.  They conditions were not useful anyway as when
compiled in they would always evaluate as true.

Last not least this is necessary to get the SGI IP22 and DECstation kernels
to compile again.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/logo.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/video/logo/logo.c~logoc-get-rid-of-mips_machgroup drivers/video/logo/logo.c
--- a/drivers/video/logo/logo.c~logoc-get-rid-of-mips_machgroup
+++ a/drivers/video/logo/logo.c
@@ -78,10 +78,7 @@ const struct linux_logo * __init_refok f
 #endif
 #ifdef CONFIG_LOGO_DEC_CLUT224
 		/* DEC Linux logo on MIPS/MIPS64 or ALPHA */
-#ifndef CONFIG_ALPHA
-		if (mips_machgroup == MACH_GROUP_DEC)
-#endif
-			logo = &logo_dec_clut224;
+		logo = &logo_dec_clut224;
 #endif
 #ifdef CONFIG_LOGO_MAC_CLUT224
 		/* Macintosh Linux logo on m68k */
@@ -94,10 +91,7 @@ const struct linux_logo * __init_refok f
 #endif
 #ifdef CONFIG_LOGO_SGI_CLUT224
 		/* SGI Linux logo on MIPS/MIPS64 and VISWS */
-#ifndef CONFIG_X86_VISWS
-		if (mips_machgroup == MACH_GROUP_SGI)
-#endif
-			logo = &logo_sgi_clut224;
+		logo = &logo_sgi_clut224;
 #endif
 #ifdef CONFIG_LOGO_SUN_CLUT224
 		/* Sun Linux logo */
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
define-global-bit-macro.patch

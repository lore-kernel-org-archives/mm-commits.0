From: akpm@linux-foundation.org
Subject: - uninitialised-variable-in-arm-ixp4xx-clockevents-code.patch removed from -mm tree
Date: Mon, 26 Nov 2007 12:18:30 -0800
Message-ID: <200711262018.lAQKIUCm020867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbXKZUTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 15:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, dsaxena@plexity.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     uninitialised variable in ARM/ixp4xx clockevents code
has been removed from the -mm tree.  Its filename was
     uninitialised-variable-in-arm-ixp4xx-clockevents-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: uninitialised variable in ARM/ixp4xx clockevents code
From: Mikael Pettersson <mikpe@it.uu.se>

Compiling kernel 2.6.23 for an ARM/ixp4xx machine results in:

arch/arm/mach-ixp4xx/common.c: In function 'ixp4xx_set_mode':
arch/arm/mach-ixp4xx/common.c:445: warning: 'opts' may be used uninitialized in this function

The warning is valid: if ixp4xx_set_mode() is called with mode
CLOCK_EVT_MODE_RESUME, then 'opts' will be uninitialised at the
'*IXP4XX_OSRT1 = osrt | opts;' statement.

Initialising opts to zero in this case may not be correct, but
at least it's better than writing random junk to the hardware.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ixp4xx/common.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-ixp4xx/common.c~uninitialised-variable-in-arm-ixp4xx-clockevents-code arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~uninitialised-variable-in-arm-ixp4xx-clockevents-code
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -460,6 +460,7 @@ static void ixp4xx_set_mode(enum clock_e
 		osrt = opts = 0;
 		break;
 	case CLOCK_EVT_MODE_RESUME:
+		opts = 0;
 		break;
 	}
 
_

Patches currently in -mm which might be from mikpe@it.uu.se are

uninitialised-variable-in-arm-ixp4xx-clockevents-code.patch

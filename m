From: akpm@linux-foundation.org
Subject: + powerpc-pegasos-keyboard-detection.patch added to -mm tree
Date: Thu, 26 Jul 2007 18:48:07 -0700
Message-ID: <200707270148.l6R1m7dr032529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbXG0Bs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 21:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pacman@TheWorld.com, benh@kernel.crashing.org, pacman@world.std.com


The patch titled
     powerpc: Pegasos keyboard detection
has been added to the -mm tree.  Its filename is
     powerpc-pegasos-keyboard-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: Pegasos keyboard detection
From: Alan Curry <pacman@TheWorld.com>

As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse
controller on the PegasosPPC.  This is because of a feature/bug in the OF
device tree: the "device_type" attribute is an empty string instead of
"8042" as the kernel expects.  This patch (against 2.6.22.1) adds a
secondary detection which looks for a device whose *name* is "8042" if
there is no device whose *type* is "8042".

Signed-off-by: Alan Curry <pacman@world.std.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null /dev/null
diff -puN arch/powerpc/kernel/setup-common.c~powerpc-pegasos-keyboard-detection arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~powerpc-pegasos-keyboard-detection
+++ a/arch/powerpc/kernel/setup-common.c
@@ -496,6 +496,12 @@ int check_legacy_ioport(unsigned long ba
 			break;
 		}
 		np = of_find_node_by_type(NULL, "8042");
+		/*
+		 * Pegasos has no device_type on its 8042 node, look for the
+		 * name instead
+		 */
+		if (!np)
+			np = of_find_node_by_name(NULL, "8042");
 		break;
 	case FDC_BASE: /* FDC1 */
 		np = of_find_node_by_type(NULL, "fdc");
_

Patches currently in -mm which might be from pacman@TheWorld.com are

powerpc-pegasos-keyboard-detection.patch

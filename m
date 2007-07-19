From: akpm@linux-foundation.org
Subject: - driver-edac-add-mips-and-ppc-visibility.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:45 -0700
Message-ID: <200707192006.l6JK6jMC020170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757112AbXGSUPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add mips and ppc visibility
has been removed from the -mm tree.  Its filename was
     driver-edac-add-mips-and-ppc-visibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add mips and ppc visibility
From: Douglas Thompson <dougthompson@xmission.com>

1) Remove an old CVS ID string

2) change EDAC from a tristate option to a simple bool option

3) In addition to the X86 arch, PPC and MIPS also have drivers in the
submission queue.  This patch turns on the EDAC flag for those archs.  Each
driver will have its respective 'depends on ARCH' set.

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/edac/Kconfig~driver-edac-add-mips-and-ppc-visibility drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~driver-edac-add-mips-and-ppc-visibility
+++ a/drivers/edac/Kconfig
@@ -3,13 +3,12 @@
 #	Copyright (c) 2003 Linux Networx
 #	Licensed and distributed under the GPL
 #
-# $Id: Kconfig,v 1.4.2.7 2005/07/08 22:05:38 dsp_llnl Exp $
-#
 
 menuconfig EDAC
-	tristate "EDAC - error detection and reporting (EXPERIMENTAL)"
+	bool "EDAC - error detection and reporting (EXPERIMENTAL)"
 	depends on HAS_IOMEM
-	depends on X86 && EXPERIMENTAL
+	depends on EXPERIMENTAL
+	depends on X86 || MIPS || PPC
 	help
 	  EDAC is designed to report errors in the core system.
 	  These are low-level errors that are reported in the CPU or
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch

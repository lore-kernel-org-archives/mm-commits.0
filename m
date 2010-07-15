From: akpm@linux-foundation.org
Subject: + parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded.patch added to -mm tree
Date: Thu, 15 Jul 2010 13:05:13 -0700
Message-ID: <201007152005.o6FK5DXZ016453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934613Ab0GOUFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 16:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.jones@canonical.com, rmk@arm.linux.org.uk


The patch titled
     parport: prevent ARM boards frmo crashing when CUPS is loaded
has been added to the -mm tree.  Its filename is
     parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded.patch

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
Subject: parport: prevent ARM boards frmo crashing when CUPS is loaded
From: Lee Jones <lee.jones@canonical.com>

When CUPS loads, it tries to load several drivers that it may need.  When
one of these drivers, specifically parport_pc is loaded on ARM based
systems, it causes a segmentation fault as the ISA addresses which are
attempted are not writable on non-PC based architectures.  This code
prevents ISA addresses from being attempted except on x86.

Addresses http://bugs.launchpad.net/bugs/601226

Signed-off-by: Lee Jones <lee.jones@canonical.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/parport.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/arm/include/asm/parport.h~parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded arch/arm/include/asm/parport.h
--- a/arch/arm/include/asm/parport.h~parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded
+++ a/arch/arm/include/asm/parport.h
@@ -9,10 +9,13 @@
 #ifndef __ASMARM_PARPORT_H
 #define __ASMARM_PARPORT_H
 
-static int __devinit parport_pc_find_isa_ports (int autoirq, int autodma);
 static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
 {
-	return parport_pc_find_isa_ports (autoirq, autodma);
+/* parport_pc_find_isa_ports uses direct register addresses which are
+ * only correct on x86 architectures. This may have undesirable
+ * consequences (including segfaults) when used on other architectures.
+ */
+	return 0;
 }
 
 #endif /* !(_ASMARM_PARPORT_H) */
_

Patches currently in -mm which might be from lee.jones@canonical.com are

parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch


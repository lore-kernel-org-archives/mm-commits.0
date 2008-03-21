From: akpm@linux-foundation.org
Subject: - bootwrapper-add-entries-for-tqm8540-and-sbc85xx.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:47 -0700
Message-ID: <200803212031.m2LKVlnI009097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761258AbYCUUbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     powerpc: bootwrapper: add entries for tqm8540 and sbc85xx
has been removed from the -mm tree.  Its filename was
     bootwrapper-add-entries-for-tqm8540-and-sbc85xx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: bootwrapper: add entries for tqm8540 and sbc85xx
From: Paul Gortmaker <paul.gortmaker@windriver.com>

The wrapper script didn't have entries for the TQM8540 board and the SBC8548
or SBC8560 boards.  I've assumed that the TQM8540 console is 8250 based and
not CPM based by looking at its defconfig.  There was also a trailing * on the
TQM8555 entry that I removed too.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/Makefile |    4 ++--
 arch/powerpc/boot/wrapper  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/boot/Makefile~bootwrapper-add-entries-for-tqm8540-and-sbc85xx arch/powerpc/boot/Makefile
--- a/arch/powerpc/boot/Makefile~bootwrapper-add-entries-for-tqm8540-and-sbc85xx
+++ a/arch/powerpc/boot/Makefile
@@ -253,8 +253,8 @@ image-$(CONFIG_TQM8540)			+= cuImage.tqm
 image-$(CONFIG_TQM8541)			+= cuImage.tqm8541
 image-$(CONFIG_TQM8555)			+= cuImage.tqm8555
 image-$(CONFIG_TQM8560)			+= cuImage.tqm8560
-image-$(CONFIG_SBC8548)			+= cuImage.tqm8548
-image-$(CONFIG_SBC8560)			+= cuImage.tqm8560
+image-$(CONFIG_SBC8548)			+= cuImage.sbc8548
+image-$(CONFIG_SBC8560)			+= cuImage.sbc8560
 
 # Board ports in arch/powerpc/platform/embedded6xx/Kconfig
 image-$(CONFIG_STORCENTER)		+= cuImage.storcenter
diff -puN arch/powerpc/boot/wrapper~bootwrapper-add-entries-for-tqm8540-and-sbc85xx arch/powerpc/boot/wrapper
--- a/arch/powerpc/boot/wrapper~bootwrapper-add-entries-for-tqm8540-and-sbc85xx
+++ a/arch/powerpc/boot/wrapper
@@ -174,10 +174,10 @@ cuboot*)
     *-mpc83*)
         platformo=$object/cuboot-83xx.o
         ;;
-    *-tqm8541|*-mpc8560*|*-tqm8560|*-tqm8555*)
+    *-tqm8541|*-mpc8560*|*-tqm8560|*-tqm8555)
         platformo=$object/cuboot-85xx-cpm2.o
         ;;
-    *-mpc85*)
+    *-mpc85*|*-tqm8540|*-sbc85*)
         platformo=$object/cuboot-85xx.o
         ;;
     esac
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

origin.patch


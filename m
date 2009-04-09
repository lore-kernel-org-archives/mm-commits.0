From: akpm@linux-foundation.org
Subject: [folded] cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch removed from -mm tree
Date: Thu, 09 Apr 2009 14:42:01 -0700
Message-ID: <200904092142.n39Lg1Wo008801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbZDIVrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, david-b@pacbell.net, dilinger@debian.org, jordan@cosmicpenguin.net, katzj@redhat.com, randy.dunlap@oracle.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
has been removed from the -mm tree.  Its filename was
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch

This patch was dropped because it was folded into cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
From: Andres Salomon <dilinger@queued.net>

force GPIO_CS553X to be defined when OLPC is selected

We've begun using the generic GPIO stuff for geodes, so OLPC implicitly
depends upon this.  This patch forces selection of it.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jeremy Katz <katzj@redhat.com>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig         |    1 +
 pci/cs5535audio/Makefile |    0 
 2 files changed, 1 insertion(+)

diff -puN arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix arch/x86/Kconfig
--- a/arch/x86/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
+++ a/arch/x86/Kconfig
@@ -1972,6 +1972,7 @@ config GEODE_MFGPT_TIMER
 
 config OLPC
 	bool "One Laptop Per Child support"
+	select GPIO_CS553X
 	default n
 	---help---
 	  Add support for detecting the unique features of the OLPC
diff -puN sound/pci/cs5535audio/Makefile~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix sound/pci/cs5535audio/Makefile
_

Patches currently in -mm which might be from dilinger@queued.net are

cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization-fix.patch


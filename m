From: akpm@linux-foundation.org
Subject: + cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch added to -mm tree
Date: Mon, 06 Apr 2009 16:55:21 -0700
Message-ID: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbZDGABb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 20:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, david-b@pacbell.net, dilinger@debian.org, jordan@cosmicpenguin.net, katzj@redhat.com, randy.dunlap@oracle.com, tiwai@suse.de


The patch titled
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix
has been added to the -mm tree.  Its filename is
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch

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

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch


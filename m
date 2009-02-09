From: akpm@linux-foundation.org
Subject: + auxdisplay-remove-parport-dependency.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:37:46 -0800
Message-ID: <200902092237.n19MbkKd007710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbZBIWiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:38:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hsweeten@visionengravers.com, miguel.ojeda.sandonis@gmail.com


The patch titled
     auxdisplay: remove PARPORT dependency
has been added to the -mm tree.  Its filename is
     auxdisplay-remove-parport-dependency.patch

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
Subject: auxdisplay: remove PARPORT dependency
From: H Hartley Sweeten <hsweeten@visionengravers.com>

Remove PARPORT dependency for Auxiliary Display support.

This is not needed since the dependency for the KS0108 driver is
PARPORT_PC.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/auxdisplay/Kconfig~auxdisplay-remove-parport-dependency drivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~auxdisplay-remove-parport-dependency
+++ a/drivers/auxdisplay/Kconfig
@@ -6,7 +6,6 @@
 #
 
 menuconfig AUXDISPLAY
-	depends on PARPORT
 	bool "Auxiliary Display support"
 	---help---
 	  Say Y here to get to see options for auxiliary display drivers.
@@ -14,7 +13,7 @@ menuconfig AUXDISPLAY
 
 	  If you say N, all options in this submenu will be skipped and disabled.
 
-if AUXDISPLAY && PARPORT
+if AUXDISPLAY
 
 config KS0108
 	tristate "KS0108 LCD Controller"
_

Patches currently in -mm which might be from hsweeten@visionengravers.com are

auxdisplay-remove-parport-dependency.patch


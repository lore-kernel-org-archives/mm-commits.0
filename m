From: akpm@linux-foundation.org
Subject: + misc-devices-do-not-enable-by-default.patch added to -mm tree
Date: Thu, 23 Sep 2010 16:27:22 -0700
Message-ID: <201009232327.o8NNRMMS025599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab0IWX2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 19:28:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bp@alien8.de, dilinger@collabora.co.uk, khali@linux-fr.org, michael.hennerich@analog.com, randy.dunlap@oracle.com, vapier@gentoo.org


The patch titled
     misc devices: do not enable by default
has been added to the -mm tree.  Its filename is
     misc-devices-do-not-enable-by-default.patch

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
Subject: misc devices: do not enable by default
From: Borislav Petkov <bp@alien8.de>

Do not enable this Kconfig menu by default since it contains devices not
present on the majority of systems.

This is becoming a pain and a waste of time especially when doing a bunch
of kernel builds on different systems daily and have to answer "make
oldconfig" prompts for strange devices.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/Kconfig~misc-devices-do-not-enable-by-default drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-devices-do-not-enable-by-default
+++ a/drivers/misc/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig MISC_DEVICES
 	bool "Misc devices"
-	default y
 	---help---
 	  Say Y here to get to see options for device drivers from various
 	  different categories. This option alone does not add any kernel code.
_

Patches currently in -mm which might be from bp@alien8.de are

misc-devices-do-not-enable-by-default.patch


From: akpm@linux-foundation.org
Subject: + drivers-idle-memory-power-in-config-show-up-only-when-it-applies.patch added to -mm tree
Date: Mon, 27 Oct 2008 15:14:48 -0700
Message-ID: <200810272215.m9RMF5OY019832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYJ0WPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 18:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     drivers/idle/: memory power in config; show up only when it applies
has been added to the -mm tree.  Its filename is
     drivers-idle-memory-power-in-config-show-up-only-when-it-applies.patch

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
Subject: drivers/idle/: memory power in config; show up only when it applies
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Repair the config option for I7300_IDLE.  The menu will now only show up
when applicable.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/idle/Kconfig~drivers-idle-memory-power-in-config-show-up-only-when-it-applies drivers/idle/Kconfig
--- a/drivers/idle/Kconfig~drivers-idle-memory-power-in-config-show-up-only-when-it-applies
+++ a/drivers/idle/Kconfig
@@ -1,5 +1,6 @@
 
 menu "Memory power savings"
+depends on X86_64
 
 config I7300_IDLE_IOAT_CHANNEL
 	bool
@@ -7,7 +8,6 @@ config I7300_IDLE_IOAT_CHANNEL
 config I7300_IDLE
 	tristate "Intel chipset idle power saving driver"
 	select I7300_IDLE_IOAT_CHANNEL
-	depends on X86_64
 	help
 	  Enable idle power savings with certain Intel server chipsets.
 	  The chipset must have I/O AT support, such as the Intel 7300.
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

drivers-idle-memory-power-in-config-show-up-only-when-it-applies.patch


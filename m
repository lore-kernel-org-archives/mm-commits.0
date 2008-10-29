From: akpm@linux-foundation.org
Subject: - drivers-idle-memory-power-in-config-show-up-only-when-it-applies.patch removed from -mm tree
Date: Wed, 29 Oct 2008 12:53:44 -0700
Message-ID: <200810291953.m9TJriId018854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754546AbYJ2Txq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 15:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/idle/: memory power in config; show up only when it applies
has been removed from the -mm tree.  Its filename was
     drivers-idle-memory-power-in-config-show-up-only-when-it-applies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/idle/: memory power in config; show up only when it applies
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Repair the config option for I7300_IDLE.  The menu will now only show up
when applicable.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/idle/Kconfig~drivers-idle-memory-power-in-config-show-up-only-when-it-applies drivers/idle/Kconfig
--- a/drivers/idle/Kconfig~drivers-idle-memory-power-in-config-show-up-only-when-it-applies
+++ a/drivers/idle/Kconfig
@@ -1,5 +1,6 @@
 
 menu "Memory power savings"
+depends on X86_64
 
 config I7300_IDLE_IOAT_CHANNEL
 	bool
@@ -7,7 +8,7 @@ config I7300_IDLE_IOAT_CHANNEL
 config I7300_IDLE
 	tristate "Intel chipset idle memory power saving driver"
 	select I7300_IDLE_IOAT_CHANNEL
-	depends on X86_64 && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  Enable memory power savings when idle with certain Intel server
 	  chipsets. The chipset must have I/O AT support, such as the
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
linux-next.patch


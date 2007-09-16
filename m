From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:21 -0700
Message-ID: <200709160925.l8G9PL8k009100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbXIPJZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix printk level down to debug from emerg
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix printk level down to debug from emerg
From: Doug Thompson <dougthompson@xmission.com>

When EDAC is configured for EDAC DEBUGGING, the debug printk output level
was set TOO high (EMERG). This patch brings it down to a DEBUG level

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-fix-printk-level-down-to-debug-from-emerg drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-fix-printk-level-down-to-debug-from-emerg
+++ a/drivers/edac/edac_core.h
@@ -75,7 +75,7 @@ extern int edac_debug_level;
 #define edac_debug_printk(level, fmt, arg...)                            \
 	do {                                                             \
 		if (level <= edac_debug_level)                           \
-			edac_printk(KERN_EMERG, EDAC_DEBUG, fmt, ##arg); \
+			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
 	} while(0)
 
 #define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch

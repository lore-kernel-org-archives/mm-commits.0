From: akpm@linux-foundation.org
Subject: + drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:58:25 -0700
Message-ID: <200708311858.l7VIwPLV021850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965971AbXHaS63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk


The patch titled
     drivers/edac: fix printk level down to debug from emerg
has been added to the -mm tree.  Its filename is
     drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch
drivers-edac-fix-e752x-correct-return-code.patch

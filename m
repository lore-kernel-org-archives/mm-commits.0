From: akpm@linux-foundation.org
Subject: - isdn4linux-fix-maturity-label-v4.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:53 -0700
Message-ID: <200706011747.l51Hlq13015159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761379AbXFARr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN4Linux: fix maturity label
has been removed from the -mm tree.  Its filename was
     isdn4linux-fix-maturity-label-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN4Linux: fix maturity label
From: Tilman Schmidt <tilman@imap.cc>

According to the definitions recently posted on LKML, the maturity label
for the ISDN4Linux subsystem is wrong.  This patch corrects it and also
clarifies the accompanying help text a bit.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/Kconfig~isdn4linux-fix-maturity-label-v4 drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~isdn4linux-fix-maturity-label-v4
+++ a/drivers/isdn/Kconfig
@@ -26,9 +26,9 @@ menu "Old ISDN4Linux"
 	depends on NET && ISDN
 
 config ISDN_I4L
-	tristate "Old ISDN4Linux (obsolete)"
+	tristate "Old ISDN4Linux (deprecated)"
 	---help---
-	  This driver allows you to use an ISDN-card for networking
+	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
 	  in AT-compatible modem emulator.  Network devices support autodial,
 	  channel-bundling, callback and caller-authentication without having
@@ -39,8 +39,9 @@ config ISDN_I4L
 
 	  ISDN support in the linux kernel is moving towards a new API,
 	  called CAPI (Common ISDN Application Programming Interface).
-	  Therefore the old ISDN4Linux layer is becoming obsolete. It is 
-	  still usable, though, if you select this option.
+	  Therefore the old ISDN4Linux layer will eventually become obsolete.
+	  It is still available, though, for use with adapters that are not
+	  supported by the new CAPI subsystem yet.
 
 if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
_

Patches currently in -mm which might be from tilman@imap.cc are

origin.patch

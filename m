From: akpm@linux-foundation.org
Subject: - drivers-add-lcd-support-update-9.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:10:45 -0800
Message-ID: <200702100810.l1A8AjbC006950@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbXBJIKs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     drivers: add LCD support (update 9)
has been removed from the -mm tree.  Its filename was
     drivers-add-lcd-support-update-9.patch

This patch was dropped because it was folded into drivers-add-lcd-suppo=
rt-3.patch

------------------------------------------------------
Subject: drivers: add LCD support (update 9)
=46rom: Miguel Ojeda Sandonis <maxextreme@gmail.com>

=46ix Randy Dunlap's points:

    =B7 Adds CONFIG_FB dependency to CONFIG_CFAG12864B

    =B7 Spelling fix and improved help.

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/auxdisplay/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/auxdisplay/Kconfig~drivers-add-lcd-support-update-9 d=
rivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~drivers-add-lcd-support-update-9
+++ a/drivers/auxdisplay/Kconfig
@@ -65,6 +65,7 @@ config KS0108_DELAY
 config CFAG12864B
 	tristate "CFAG12864B LCD"
 	depends on X86
+	depends on FB
 	depends on KS0108
 	default n
 	---help---
@@ -74,6 +75,8 @@ config CFAG12864B
 	  For help about how to wire your LCD to the parallel port,
 	  check Documentation/auxdisplay/cfag12864b
=20
+	  Depends on the x86 arch and the framebuffer support.
+
 	  The LCD framebuffer driver can be attached to a console.
 	  It will work fine. However, you can't attach it to the fbdev driver
 	  of the xorg server.
@@ -84,7 +87,7 @@ config CFAG12864B
 	  If unsure, say N.
=20
 config CFAG12864B_RATE
-	int "Refresh rate (hertzs)"
+       int "Refresh rate (hertz)"
 	depends on CFAG12864B
 	default "20"
 	---help---
@@ -104,4 +107,3 @@ config CFAG12864B_RATE
 	  If you compile this as a module, you can still override this
 	  value using the module parameters.
 endmenu
-
_

Patches currently in -mm which might be from maxextreme@gmail.com are

drivers-add-lcd-support-3.patch
drivers-add-lcd-support-update-9.patch
drivers-add-lcd-support-workqueue-fixups.patch

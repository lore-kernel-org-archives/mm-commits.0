From: akpm@linux-foundation.org
Subject: + remove-obsolete-label-from-isdn4linux-v3.patch added to -mm tree
Date: Sat, 21 Apr 2007 12:34:27 -0700
Message-ID: <200704211934.l3LJYR9G012451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbXDUTeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 15:34:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, kkeil@suse.de


The patch titled
     Remove "obsolete" label from ISDN4Linux
has been added to the -mm tree.  Its filename is
     remove-obsolete-label-from-isdn4linux-v3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove "obsolete" label from ISDN4Linux
From: Tilman Schmidt <tilman@imap.cc>

The "obsolete" label on the ISDN_I4L Kconfig option is not, and has never
been, accurate.  It has already prompted repeated attempts to remove
actively used functionality from the kernel without a working replacement. 
This patch removes the incorrect label and corrects the accompanying help
text.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/Kconfig~remove-obsolete-label-from-isdn4linux-v3 drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~remove-obsolete-label-from-isdn4linux-v3
+++ a/drivers/isdn/Kconfig
@@ -25,9 +25,9 @@ menu "Old ISDN4Linux"
 	depends on NET && ISDN
 
 config ISDN_I4L
-	tristate "Old ISDN4Linux (obsolete)"
+	tristate "Old ISDN4Linux subsystem"
 	---help---
-	  This driver allows you to use an ISDN-card for networking
+	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
 	  in AT-compatible modem emulator.  Network devices support autodial,
 	  channel-bundling, callback and caller-authentication without having
@@ -38,8 +38,9 @@ config ISDN_I4L
 
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

remove-obsolete-label-from-isdn4linux-v3.patch
codingstyle-start-flamewar-about-use-of-braces.patch

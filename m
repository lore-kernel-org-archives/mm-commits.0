From: akpm@linux-foundation.org
Subject: [wrecked] asus-laptop-use-select-instead-of-depends-on.patch removed from -mm tree
Date: Tue, 03 Mar 2009 11:40:44 -0800
Message-ID: <200903031940.n23JeiSN029243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZCCTux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 14:50:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corentincj@iksaif.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     asus-laptop: use select instead of depends on
has been removed from the -mm tree.  Its filename was
     asus-laptop-use-select-instead-of-depends-on.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asus-laptop: use select instead of depends on
From: Corentin Chary <corentincj@iksaif.net>

Like thinkpad_acpi or eeepc-laptop, asus-laptop will now use "select"
instead of "depends on".

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/platform/x86/Kconfig~asus-laptop-use-select-instead-of-depends-on drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~asus-laptop-use-select-instead-of-depends-on
+++ a/drivers/platform/x86/Kconfig
@@ -39,10 +39,10 @@ config ASUS_LAPTOP
 	tristate "Asus Laptop Extras (EXPERIMENTAL)"
 	depends on ACPI
 	depends on EXPERIMENTAL && !ACPI_ASUS
-	depends on LEDS_CLASS
-	depends on NEW_LEDS
-	depends on BACKLIGHT_CLASS_DEVICE
-	depends on INPUT
+	select LEDS_CLASS
+	select NEW_LEDS
+	select BACKLIGHT_CLASS_DEVICE
+	select INPUT
 	---help---
 	  This is the new Linux driver for Asus laptops. It may also support some
 	  MEDION, JVC or VICTOR laptops. It makes all the extra buttons generate
_

Patches currently in -mm which might be from corentincj@iksaif.net are

linux-next.patch
asus-laptop-use-select-instead-of-depends-on.patch


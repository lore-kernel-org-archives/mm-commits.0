From: akpm@linux-foundation.org
Subject: + asus-laptop-use-select-instead-of-depends-on.patch added to -mm tree
Date: Tue, 24 Feb 2009 14:08:00 -0800
Message-ID: <200902242208.n1OM809S015067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495AbZBXWI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 17:08:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corentincj@iksaif.net, lenb@kernel.org


The patch titled
     asus-laptop: use select instead of depends on
has been added to the -mm tree.  Its filename is
     asus-laptop-use-select-instead-of-depends-on.patch

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
eeepc-laptop-fix-kconfig.patch
asus-laptop-restore-acpi_generate_proc_event.patch
eeepc-laptop-restore-acpi_generate_proc_event.patch
asus-laptop-use-select-instead-of-depends-on.patch


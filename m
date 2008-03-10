From: akpm@linux-foundation.org
Subject: - leds-add-mail-led-support-for-clevo-d400p.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:30 -0700
Message-ID: <200803101805.m2AI5Ul7030099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbYCJSLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nm127@freemail.hu, akamenov@users.sourceforge.net, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: add mail LED support for "Clevo D400P"
has been removed from the -mm tree.  Its filename was
     leds-add-mail-led-support-for-clevo-d400p.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: leds: add mail LED support for "Clevo D400P"
=46rom: M=E1rton N=E9meth <nm127@freemail.hu>

The leds-clevo-mail module also works with model "Clevo D400P",
add this model to the white list.

Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>
Cc: Andrey Kamenov <akamenov@users.sourceforge.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig           |    4 ++++
 drivers/leds/leds-clevo-mail.c |   10 ++++++++++
 2 files changed, 14 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-mail-led-support-for-clevo-d400=
p drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-mail-led-support-for-clevo-d400p
+++ a/drivers/leds/Kconfig
@@ -135,6 +135,7 @@ config LEDS_CLEVO_MAIL
=20
 	  This module can drive the mail LED for the following notebooks:
=20
+	  	Clevo D400P
 	  	Clevo D410J
 	  	Clevo D410V
 	  	Clevo D400V/D470V (not tested, but might work)
@@ -142,6 +143,9 @@ config LEDS_CLEVO_MAIL
 	  	Clevo M5x0N (not tested, but might work)
 	  	Positivo Mobile (Clevo M5x0V)
=20
+	  If your model is not listed here you can try the "nodetect"
+	  module paramter.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-clevo-mail.
=20
diff -puN drivers/leds/leds-clevo-mail.c~leds-add-mail-led-support-for-=
clevo-d400p drivers/leds/leds-clevo-mail.c
--- a/drivers/leds/leds-clevo-mail.c~leds-add-mail-led-support-for-clev=
o-d400p
+++ a/drivers/leds/leds-clevo-mail.c
@@ -69,6 +69,16 @@ static struct dmi_system_id __initdata m
 	},
 	{
 		.callback =3D clevo_mail_led_dmi_callback,
+		.ident =3D "Clevo D400P",
+		.matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Clevo"),
+			DMI_MATCH(DMI_BOARD_NAME, "D400P"),
+			DMI_MATCH(DMI_BOARD_VERSION, "Rev.A"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "0106")
+		}
+	},
+	{
+		.callback =3D clevo_mail_led_dmi_callback,
 		.ident =3D "Clevo D410V",
 		.matches =3D {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Clevo, Co."),
_

Patches currently in -mm which might be from nm127@freemail.hu are

git-drm.patch
git-leds.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

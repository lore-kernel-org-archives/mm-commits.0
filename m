From: akpm@linux-foundation.org
Subject: - input-i8042-add-dritek-quirk-for-acer-travelmate-660.patch removed from -mm tree
Date: Wed, 30 Jul 2008 13:07:47 -0700
Message-ID: <200807302007.m6UK7lPC014292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756007AbYG3UIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 16:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bonbons@linux-vserver.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: i8042: add Dritek quirk for Acer TravelMate 660
has been removed from the -mm tree.  Its filename was
     input-i8042-add-dritek-quirk-for-acer-travelmate-660.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input: i8042: add Dritek quirk for Acer TravelMate 660
=46rom: Bruno Pr=E9mont <bonbons@linux-vserver.org>

The Acer TravelMate 660 series also requires the Dritek quirk to enable
the extra scancodes.

Signed-off-by: Bruno Pr=E9mont <bonbons@linux-vserver.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-i8042-add-dritek-=
quirk-for-acer-travelmate-660 drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-i8042-add-dritek-quir=
k-for-acer-travelmate-660
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -388,6 +388,13 @@ static struct dmi_system_id __initdata i
 		},
 	},
 	{
+		.ident =3D "Acer TravelMate 660",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+		},
+	},
+	{
 		.ident =3D "Acer TravelMate 2490",
 		.matches =3D {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
_

Patches currently in -mm which might be from bonbons@linux-vserver.org =
are

input-i8042-add-dritek-quirk-for-acer-travelmate-660.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

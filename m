From: akpm@linux-foundation.org
Subject: [merged] lis3-add-support-for-the-hp-hdx-18.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:53:03 -0700
Message-ID: <200910302053.n9UKr385016858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932739AbZJ3Uxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin.wrangler@gmail.com, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: add support for the HP HDX 18
has been removed from the -mm tree.  Its filename was
     lis3-add-support-for-the-hp-hdx-18.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: add support for the HP HDX 18
=46rom: Ian E. Morgan <penguin.wrangler@gmail.com>

I have an HP HDX 18 laptop, and noted that the configuration of the
accelerometer needs to be x_inverted.

Signed-off-by: Ian E. Morgan <penguin.wrangler@gmail.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/hwmon/hp_accel.c~lis3-add-support-for-the-hp-hdx-18 d=
rivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-add-support-for-the-hp-hdx-18
+++ a/drivers/hwmon/hp_accel.c
@@ -216,6 +216,7 @@ static struct dmi_system_id lis3lv02d_dm
 			y_inverted),
 	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
 	AXIS_DMI_MATCH("HP8710", "HP Compaq 8710", y_inverted),
+	AXIS_DMI_MATCH("HDX18", "HP HDX 18", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
_

Patches currently in -mm which might be from penguin.wrangler@gmail.com=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

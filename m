From: akpm@linux-foundation.org
Subject: + lis3-add-support-for-the-hp-hdx-18.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:43:35 -0700
Message-ID: <200910162143.n9GLhZR4018749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbZJPVnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:43:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin.wrangler@gmail.com, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: add support for the HP HDX 18
has been added to the -mm tree.  Its filename is
     lis3-add-support-for-the-hp-hdx-18.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

lis3-add-support-for-the-hp-hdx-18.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

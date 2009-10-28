From: akpm@linux-foundation.org
Subject: + hso-fix-debug-routines.patch added to -mm tree
Date: Wed, 28 Oct 2009 16:17:24 -0700
Message-ID: <200910282317.n9SNHOpm020844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380AbZJ1XRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 19:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: antti.kaijanmaki@nomovok.com, greg@kroah.com


The patch titled
     hso: fix debug routines
has been added to the -mm tree.  Its filename is
     hso-fix-debug-routines.patch

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
Subject: hso: fix debug routines
=46rom: Antti Kaijanm=E4ki <antti.kaijanmaki@nomovok.com>

Signed-off-by: Antti Kaijanm=E4ki <antti.kaijanmaki@nomovok.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/usb/hso.c~hso-fix-debug-routines drivers/net/usb/=
hso.c
--- a/drivers/net/usb/hso.c~hso-fix-debug-routines
+++ a/drivers/net/usb/hso.c
@@ -378,7 +378,7 @@ static void dbg_dump(int line_count, con
 }
=20
 #define DUMP(buf_, len_)	\
-	dbg_dump(__LINE__, __func__, buf_, len_)
+	dbg_dump(__LINE__, __func__, (unsigned char *)buf_, len_)
=20
 #define DUMP1(buf_, len_)			\
 	do {					\
@@ -1527,7 +1527,7 @@ static void tiocmget_intr_callback(struc
 		dev_warn(&usb->dev,
 			 "hso received invalid serial state notification\n");
 		DUMP(serial_state_notification,
-		     sizeof(hso_serial_state_notifation))
+		     sizeof(struct hso_serial_state_notification));
 	} else {
=20
 		UART_state_bitmap =3D le16_to_cpu(serial_state_notification->
_

Patches currently in -mm which might be from antti.kaijanmaki@nomovok.c=
om are

hso-fix-debug-routines.patch
hso-fix-soft-lockup.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

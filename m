From: akpm@linux-foundation.org
Subject: + hso-fix-soft-lockup.patch added to -mm tree
Date: Wed, 28 Oct 2009 16:17:26 -0700
Message-ID: <200910282317.n9SNHQm8021001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbZJ1XR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 19:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: antti.kaijanmaki@nomovok.com, greg@kroah.com


The patch titled
     hso: fix soft-lockup
has been added to the -mm tree.  Its filename is
     hso-fix-soft-lockup.patch

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
Subject: hso: fix soft-lockup
=46rom: Antti Kaijanm=E4ki <antti.kaijanmaki@nomovok.com>

=46ix soft-lockup in hso.c which is triggered on SMP machine when
modem is removed while file descriptor(s) under /dev are still open:

  old version called kref_put() too early which resulted in destroying
  hso_serial and hso_device objects which were still used later on.

Signed-off-by: Antti Kaijanm=E4ki <antti.kaijanmaki@nomovok.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/usb/hso.c~hso-fix-soft-lockup drivers/net/usb/hso=
=2Ec
--- a/drivers/net/usb/hso.c~hso-fix-soft-lockup
+++ a/drivers/net/usb/hso.c
@@ -1363,7 +1363,7 @@ static void hso_serial_close(struct tty_
 	/* reset the rts and dtr */
 	/* do the actual close */
 	serial->open_count--;
-	kref_put(&serial->parent->ref, hso_serial_ref_free);
+
 	if (serial->open_count <=3D 0) {
 		serial->open_count =3D 0;
 		spin_lock_irq(&serial->serial_lock);
@@ -1383,6 +1383,8 @@ static void hso_serial_close(struct tty_
 		usb_autopm_put_interface(serial->parent->interface);
=20
 	mutex_unlock(&serial->parent->mutex);
+
+	kref_put(&serial->parent->ref, hso_serial_ref_free);
 }
=20
 /* close the requested serial port */
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

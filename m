From: akpm@linux-foundation.org
Subject: + jsm-remove-the-ch_custom_speed-field.patch added to -mm tree
Date: Thu, 01 Oct 2009 13:54:17 -0700
Message-ID: <200910012054.n91KsH98014349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbZJAUzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 16:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, scottk@digi.com


The patch titled
     jsm: remove the ch_custom_speed field
has been added to the -mm tree.  Its filename is
     jsm-remove-the-ch_custom_speed-field.patch

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
Subject: jsm: remove the ch_custom_speed field
=46rom: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently the ch_custom_speed field exists but is never used, so, this
patch removes it.

Signed-off-by: Breno Leit=C3=A3o <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h     |    1 -
 drivers/serial/jsm/jsm_neo.c |    4 ----
 2 files changed, 5 deletions(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-remove-the-ch_custom_speed-field=
 drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-remove-the-ch_custom_speed-field
+++ a/drivers/serial/jsm/jsm.h
@@ -216,7 +216,6 @@ struct jsm_channel {
 	u8		ch_startc;	/* Start character		*/
=20
 	u32		ch_old_baud;	/* Cache of the current baud */
-	u32		ch_custom_speed;/* Custom baud, if set */
=20
 	u32		ch_wopen;	/* Waiting for open process cnt */
=20
diff -puN drivers/serial/jsm/jsm_neo.c~jsm-remove-the-ch_custom_speed-f=
ield drivers/serial/jsm/jsm_neo.c
--- a/drivers/serial/jsm/jsm_neo.c~jsm-remove-the-ch_custom_speed-field
+++ a/drivers/serial/jsm/jsm_neo.c
@@ -957,10 +957,6 @@ static void neo_param(struct jsm_channel
 		ch->ch_old_baud =3D 0;
 		return;
=20
-	} else if (ch->ch_custom_speed) {
-			baud =3D ch->ch_custom_speed;
-			if (ch->ch_flags & CH_BAUD0)
-				ch->ch_flags &=3D ~(CH_BAUD0);
 	} else {
 		int i;
 		unsigned int cflag;
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com =
are

icom-converting-space-to-tabs.patch
jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled.patch
jsm-rewriting-a-bad-log-message.patch
jsm-remove-the-ch_custom_speed-field.patch
jsm-remove-ch_old_baud-field.patch
jsm-remove-ch_cpstime-field.patch
jsm-remove-unused-jsm_channel-ch_wopen-field.patch
jsm-remove-the-field-jsm_board-intr_count.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

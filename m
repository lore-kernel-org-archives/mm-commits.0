From: akpm@linux-foundation.org
Subject: + accessrunner-avoid-unnecessary-memset.patch added to -mm tree
Date: Thu, 15 May 2008 14:11:27 -0700
Message-ID: <200805152111.m4FLBRdM010738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433AbYEOVL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christophe.jaillet@wanadoo.fr


The patch titled
     AccessRunner: avoid unnecessary memset
has been added to the -mm tree.  Its filename is
     accessrunner-avoid-unnecessary-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: AccessRunner: avoid unnecessary memset
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Remove an explicit memset(.., 0, ...) to a variable allocated with kzalloc
(i.e.  'card_info' array of the structure 'instance').

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/cxacru.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/usb/atm/cxacru.c~accessrunner-avoid-unnecessary-memset drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~accessrunner-avoid-unnecessary-memset
+++ a/drivers/usb/atm/cxacru.c
@@ -1052,7 +1052,6 @@ static int cxacru_bind(struct usbatm_dat
 
 	instance->usbatm = usbatm_instance;
 	instance->modem_type = (struct cxacru_modem_type *) id->driver_info;
-	memset(instance->card_info, 0, sizeof(instance->card_info));
 
 	mutex_init(&instance->poll_state_serialize);
 	instance->poll_state = CXPOLL_STOPPED;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

linux-next.patch
drivers-ata-pata_at32c-avoid-unnecessary-memset.patch
accessrunner-avoid-unnecessary-memset.patch


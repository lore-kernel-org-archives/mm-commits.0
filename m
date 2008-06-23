From: akpm@linux-foundation.org
Subject: - accessrunner-avoid-unnecessary-memset.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:27 -0700
Message-ID: <200806232102.m5NL2RwS016077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758137AbYFWVC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     AccessRunner: avoid unnecessary memset
has been removed from the -mm tree.  Its filename was
     accessrunner-avoid-unnecessary-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


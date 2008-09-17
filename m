From: akpm@linux-foundation.org
Subject: + anysee-initialize-anysee_usb_mutex-statically.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:10:38 -0700
Message-ID: <200809171910.m8HJAcJi025976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbYIQTKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     anysee: initialize anysee_usb_mutex statically
has been added to the -mm tree.  Its filename is
     anysee-initialize-anysee_usb_mutex-statically.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: anysee: initialize anysee_usb_mutex statically
From: Akinobu Mita <akinobu.mita@gmail.com>

anysee_usb_mutex is initialized at every time the anysee device is probed.
 If the second anysee device is probed while anysee_usb_mutex is locked by
the first anysee device, the mutex is broken.

This patch fixes by initialize anysee_usb_mutex statically rather
than initialize at probe time.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: v4l-dvb-maintainer@linuxtv.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/anysee.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/anysee.c~anysee-initialize-anysee_usb_mutex-statically drivers/media/dvb/dvb-usb/anysee.c
--- a/drivers/media/dvb/dvb-usb/anysee.c~anysee-initialize-anysee_usb_mutex-statically
+++ a/drivers/media/dvb/dvb-usb/anysee.c
@@ -43,7 +43,7 @@ module_param_named(debug, dvb_usb_anysee
 MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-static struct mutex anysee_usb_mutex;
+static DEFINE_MUTEX(anysee_usb_mutex);
 
 static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	u8 *rbuf, u8 rlen)
@@ -436,8 +436,6 @@ static int anysee_probe(struct usb_inter
 	struct usb_host_interface *alt;
 	int ret;
 
-	mutex_init(&anysee_usb_mutex);

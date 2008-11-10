From: akpm@linux-foundation.org
Subject: - anysee-initialize-anysee_usb_mutex-statically.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:02 -0800
Message-ID: <200811102034.mAAKY2FY024838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412AbYKJUec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     anysee: initialize anysee_usb_mutex statically
has been removed from the -mm tree.  Its filename was
     anysee-initialize-anysee_usb_mutex-statically.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -46,7 +46,7 @@ module_param_named(delsys, dvb_usb_anyse
 MODULE_PARM_DESC(delsys, "select delivery mode (0=DVB-C, 1=DVB-T)");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-static struct mutex anysee_usb_mutex;
+static DEFINE_MUTEX(anysee_usb_mutex);
 
 static int anysee_ctrl_msg(struct dvb_usb_device *d, u8 *sbuf, u8 slen,
 	u8 *rbuf, u8 rlen)
@@ -456,8 +456,6 @@ static int anysee_probe(struct usb_inter
 	struct usb_host_interface *alt;
 	int ret;
 
-	mutex_init(&anysee_usb_mutex);

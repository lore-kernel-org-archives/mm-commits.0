From: akpm@osdl.org
Subject: + avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:20:42 -0800
Message-ID: <200612102020.kBAKKgi7002116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762500AbWLJUUv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:20:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rankincj@yahoo.com, mchehab@infradead.org


The patch titled
     Avoid race when deregistering the IR control for dvb-usb
has been added to the -mm tree.  Its filename is
     avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid race when deregistering the IR control for dvb-usb
From: Chris Rankin <rankincj@yahoo.com>

The work item function is dvb_usb_read_remote_control():

        INIT_WORK(&d->rc_query_work, dvb_usb_read_remote_control, d);

and the last piece of work it does is:

        schedule_delayed_work(&d->rc_query_work,msecs_to_jiffies(d->props.rc_interval));

Hence you need to call "cancel_rearming_delayed_work()" and not
"cancel_delayed_work()", correct?  I certainly haven't seen this oops
reoccur since I applied this patch.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/dvb-usb-remote.c~avoid-race-when-deregistering-the-ir-control-for-dvb-usb drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c~avoid-race-when-deregistering-the-ir-control-for-dvb-usb
+++ a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -151,7 +151,7 @@ int dvb_usb_remote_init(struct dvb_usb_d
 int dvb_usb_remote_exit(struct dvb_usb_device *d)
 {
 	if (d->state & DVB_USB_STATE_REMOTE) {
-		cancel_delayed_work(&d->rc_query_work);
+		cancel_rearming_delayed_work(&d->rc_query_work);
 		flush_scheduled_work();
 		input_unregister_device(d->rc_input_dev);
 	}
_

Patches currently in -mm which might be from rankincj@yahoo.com are

avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch


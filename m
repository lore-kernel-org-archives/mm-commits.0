From: akpm@linux-foundation.org
Subject: - avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:11 -0800
Message-ID: <200702150851.l1F8pBs9025281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965533AbXBOIvV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:51:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rankincj@yahoo.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Avoid race when deregistering the IR control for dvb-usb
has been removed from the -mm tree.  Its filename was
     avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/dvb-usb-remote.c~avoid-race-when-deregistering-the-ir-control-for-dvb-usb drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c~avoid-race-when-deregistering-the-ir-control-for-dvb-usb
+++ a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -154,7 +154,7 @@ int dvb_usb_remote_init(struct dvb_usb_d
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

git-dvb.patch

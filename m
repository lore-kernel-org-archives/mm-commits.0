From: akpm@linux-foundation.org
Subject: - dvb-usb-remote-fix-oops-when-changing-keymap.patch removed from -mm tree
Date: Mon, 16 Apr 2007 22:20:05 -0700
Message-ID: <200704170520.l3H5K5q4021042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031098AbXDQFU1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 01:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf.kirch@oracle.com, dtor@mail.ru, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dvb-usb-remote: fix oops when changing keymap
has been removed from the -mm tree.  Its filename was
     dvb-usb-remote-fix-oops-when-changing-keymap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dvb-usb-remote: fix oops when changing keymap
From: Olaf Kirch <olaf.kirch@oracle.com>

DVB USB remotes do not support changing keycode maps but set
input_dev->keycodesize and input_dev->keycodemax without setting
input_dev->keycode.  This causes kernel oops when user tries to look up (or
change) current keymap.

While the proper fix would be to make remotes handle keymap changes we'll
just remove keycodemax and keycodesize initialization so EVIOCGKEYCODE and
EVIOCSKEYCODE will simply return -EINVAL.

http://bugzilla.kernel.org/show_bug.cgi?id=8312

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/dvb-usb-remote.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/dvb-usb-remote.c~dvb-usb-remote-fix-oops-when-changing-keymap drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c~dvb-usb-remote-fix-oops-when-changing-keymap
+++ a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -107,8 +107,6 @@ int dvb_usb_remote_init(struct dvb_usb_d
 		return -ENOMEM;
 
 	input_dev->evbit[0] = BIT(EV_KEY);
-	input_dev->keycodesize = sizeof(unsigned char);
-	input_dev->keycodemax = KEY_MAX;
 	input_dev->name = "IR-receiver inside an USB DVB receiver";
 	input_dev->phys = d->rc_phys;
 	usb_to_input_id(d->udev, &input_dev->id);
_

Patches currently in -mm which might be from olaf.kirch@oracle.com are

origin.patch

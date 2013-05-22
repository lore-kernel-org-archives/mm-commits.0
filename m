From: akpm@linux-foundation.org
Subject: [merged]
 fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver.patch removed from -mm tree
Date: Wed, 22 May 2013 12:33:32 -0700
Message-ID: <519d1d8c.QFVtPkCkqRm0plcA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab3EVTdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 15:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: [merged] fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver.patch removed from -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 12:33:32 -0700


The patch titled
     Subject: fbcon: convert last two unregister_con_driver call to do_unregister_con_driver
has been removed from the -mm tree.  Its filename was
     fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: fbcon: convert last two unregister_con_driver call to do_unregister_con_driver

There are only two place use unregister_con_driver now, this patch convert
them to do_unregister_con_driver too, then we can delete
unregister_con_driver whos function can be achieved with
do_unregister_con_driver easily to reduce code size and duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Lu Hua <huax.lu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt.c           |    4 +++-
 drivers/video/console/fbcon.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/tty/vt/vt.c~fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver
+++ a/drivers/tty/vt/vt.c
@@ -3629,7 +3629,9 @@ EXPORT_SYMBOL_GPL(do_take_over_console);
  */
 void give_up_console(const struct consw *csw)
 {
-	unregister_con_driver(csw);
+	console_lock();
+	do_unregister_con_driver(csw);
+	console_unlock();
 }
 
 static int __init vtconsole_class_init(void)
diff -puN drivers/video/console/fbcon.c~fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver
+++ a/drivers/video/console/fbcon.c
@@ -3621,8 +3621,8 @@ static void __exit fb_console_exit(void)
 	fbcon_deinit_device();
 	device_destroy(fb_class, MKDEV(0, 0));
 	fbcon_exit();
+	do_unregister_con_driver(&fb_con);
 	console_unlock();
-	unregister_con_driver(&fb_con);
 }	
 
 module_exit(fb_console_exit);
_

Patches currently in -mm which might be from udknight@gmail.com are

linux-next.patch
fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch


From: akpm@linux-foundation.org
Subject: + vt-delete-unneeded-function-unregister_con_driver.patch added
 to -mm tree
Date: Tue, 21 May 2013 15:27:42 -0700
Message-ID: <519bf4de.lUSME4Be5Fdi+ydv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3EUW1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 18:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: + vt-delete-unneeded-function-unregister_con_driver.patch added to -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 15:27:42 -0700


The patch titled
     Subject: vt: delete unneeded function unregister_con_driver
has been added to the -mm tree.  Its filename is
     vt-delete-unneeded-function-unregister_con_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: vt: delete unneeded function unregister_con_driver

Now there is no place use unregister_con_driver, and we can achieve
unregister_con_driver's function with unregister_con_driver easily, so
just delete it to reduce code size and duplication.

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

 drivers/tty/vt/vt.c     |   13 +------------
 include/linux/console.h |    1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/tty/vt/vt.c~vt-delete-unneeded-function-unregister_con_driver drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~vt-delete-unneeded-function-unregister_con_driver
+++ a/drivers/tty/vt/vt.c
@@ -3543,7 +3543,7 @@ err:
 
 
 /**
- * unregister_con_driver - unregister console driver from console layer
+ * do_unregister_con_driver - unregister console driver from console layer
  * @csw: console driver
  *
  * DESCRIPTION: All drivers that registers to the console layer must
@@ -3553,17 +3553,6 @@ err:
  *
  * The driver must unbind first prior to unregistration.
  */
-int unregister_con_driver(const struct consw *csw)
-{
-	int retval;
-
-	console_lock();
-	retval = do_unregister_con_driver(csw);
-	console_unlock();
-	return retval;
-}
-EXPORT_SYMBOL(unregister_con_driver);
-
 int do_unregister_con_driver(const struct consw *csw)
 {
 	int i, retval = -ENODEV;
diff -puN include/linux/console.h~vt-delete-unneeded-function-unregister_con_driver include/linux/console.h
--- a/include/linux/console.h~vt-delete-unneeded-function-unregister_con_driver
+++ a/include/linux/console.h
@@ -75,7 +75,6 @@ extern const struct consw newport_con;	/
 extern const struct consw prom_con;	/* SPARC PROM console */
 
 int con_is_bound(const struct consw *csw);
-int unregister_con_driver(const struct consw *csw);
 int do_unregister_con_driver(const struct consw *csw);
 int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
_

Patches currently in -mm which might be from udknight@gmail.com are

linux-next.patch
fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch
fbcon-delete-unneeded-function-fbcon_takeover.patch
vt-delete-unneeded-functions-register_con_drivertake_over_console.patch
vt-convert-last-unbind_con_driver-call-to-do_unbind_con_driver.patch
vt-delete-unneeded-function-unbind_con_driver.patch
vt-convert-last-bind_con_driver-call-to-do_bind_con_driver.patch
vt-delete-unneeded-function-bind_con_driver.patch
fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver.patch
vt-delete-unneeded-function-unregister_con_driver.patch


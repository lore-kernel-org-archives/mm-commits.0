From: akpm@linux-foundation.org
Subject: [merged] vt-delete-unneeded-function-unregister_con_driver.patch
 removed from -mm tree
Date: Wed, 22 May 2013 12:33:34 -0700
Message-ID: <519d1d8e.Vh6yO+aOrCF/8uxR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab3EVTdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 15:33:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: [merged] vt-delete-unneeded-function-unregister_con_driver.patch removed from -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 12:33:34 -0700


The patch titled
     Subject: vt: delete unneeded function unregister_con_driver
has been removed from the -mm tree.  Its filename was
     vt-delete-unneeded-function-unregister_con_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

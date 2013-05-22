From: akpm@linux-foundation.org
Subject: [merged] vt-delete-unneeded-function-unbind_con_driver.patch
 removed from -mm tree
Date: Wed, 22 May 2013 12:33:26 -0700
Message-ID: <519d1d86.aL0EJugj/mgomQaR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab3EVTd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 15:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: [merged] vt-delete-unneeded-function-unbind_con_driver.patch removed from -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 12:33:26 -0700


The patch titled
     Subject: vt: delete unneeded function unbind_con_driver
has been removed from the -mm tree.  Its filename was
     vt-delete-unneeded-function-unbind_con_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: vt: delete unneeded function unbind_con_driver

Now there is no place use unbind_con_driver, and we can achieve
unbind_con_driver's function with do_unbind_con_driver easily, so just
delete it to reduce code size and duplication.

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

 drivers/tty/vt/vt.c     |   28 ----------------------------
 include/linux/vt_kern.h |    2 --
 2 files changed, 30 deletions(-)

diff -puN drivers/tty/vt/vt.c~vt-delete-unneeded-function-unbind_con_driver drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~vt-delete-unneeded-function-unbind_con_driver
+++ a/drivers/tty/vt/vt.c
@@ -3114,34 +3114,6 @@ static int con_is_graphics(const struct
 	return retval;
 }
 
-/**
- * unbind_con_driver - unbind a console driver
- * @csw: pointer to console driver to unregister
- * @first: first in range of consoles that @csw should be unbound from
- * @last: last in range of consoles that @csw should be unbound from
- * @deflt: should next bound console driver be default after @csw is unbound?
- *
- * To unbind a driver from all possible consoles, pass 0 as @first and
- * %MAX_NR_CONSOLES as @last.
- *
- * @deflt controls whether the console that ends up replacing @csw should be
- * the default console.
- *
- * RETURNS:
- * -ENODEV if @csw isn't a registered console driver or can't be unregistered
- * or 0 on success.
- */
-int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
-{
-	int retval;
-
-	console_lock();
-	retval = do_unbind_con_driver(csw, first, last, deflt);
-	console_unlock();
-	return retval;
-}
-EXPORT_SYMBOL(unbind_con_driver);

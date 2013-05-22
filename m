From: akpm@linux-foundation.org
Subject: [merged]
 vt-convert-last-unbind_con_driver-call-to-do_unbind_con_driver.patch
 removed from -mm tree
Date: Wed, 22 May 2013 12:33:24 -0700
Message-ID: <519d1d84.R2D8o2F7F1SMi1NT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab3EVTdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 15:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: [merged] vt-convert-last-unbind_con_driver-call-to-do_unbind_con_driver.patch removed from -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 12:33:24 -0700


The patch titled
     Subject: vt: convert last unbind_con_driver call to do_unbind_con_driver
has been removed from the -mm tree.  Its filename was
     vt-convert-last-unbind_con_driver-call-to-do_unbind_con_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: vt: convert last unbind_con_driver call to do_unbind_con_driver

There is only one place use unbind_con_driver, this patch convert it to
do_unbind_con_driver too, then we can delete unbind_con_driver to reduce
code size and duplication.

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

 drivers/tty/vt/vt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/tty/vt/vt.c~vt-convert-last-unbind_con_driver-call-to-do_unbind_con_driver drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~vt-convert-last-unbind_con_driver-call-to-do_unbind_con_driver
+++ a/drivers/tty/vt/vt.c
@@ -3301,8 +3301,11 @@ static int vt_unbind(struct con_driver *
 		if (first == 0 && last == MAX_NR_CONSOLES -1)
 			deflt = 1;
 
-		if (first != -1)
-			unbind_con_driver(csw, first, last, deflt);
+		if (first != -1) {
+			console_lock();
+			do_unbind_con_driver(csw, first, last, deflt);
+			console_unlock();
+		}
 
 		first = -1;
 		last = -1;
_

Patches currently in -mm which might be from udknight@gmail.com are

linux-next.patch
fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch


From: akpm@linux-foundation.org
Subject: [merged]
 vt-convert-last-bind_con_driver-call-to-do_bind_con_driver.patch removed
 from -mm tree
Date: Wed, 22 May 2013 12:33:28 -0700
Message-ID: <519d1d88.5gEIjfyOrLo/aO6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3EVTd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 15:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: [merged] vt-convert-last-bind_con_driver-call-to-do_bind_con_driver.patch removed from -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 12:33:28 -0700


The patch titled
     Subject: vt: convert last bind_con_driver call to do_bind_con_driver
has been removed from the -mm tree.  Its filename was
     vt-convert-last-bind_con_driver-call-to-do_bind_con_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: vt: convert last bind_con_driver call to do_bind_con_driver

There is only one place use bind_con_driver now, this patch convert it to
do_bind_con_driver too, then we can delete bind_con_driver whos function
can be replaced by do_bind_con_driver easily to reduce code size and
duplication.

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

diff -puN drivers/tty/vt/vt.c~vt-convert-last-bind_con_driver-call-to-do_bind_con_driver drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~vt-convert-last-bind_con_driver-call-to-do_bind_con_driver
+++ a/drivers/tty/vt/vt.c
@@ -3234,8 +3234,11 @@ static int vt_bind(struct con_driver *co
 		if (first == 0 && last == MAX_NR_CONSOLES -1)
 			deflt = 1;
 
-		if (first != -1)
-			bind_con_driver(csw, first, last, deflt);
+		if (first != -1) {
+			console_lock();
+			do_bind_con_driver(csw, first, last, deflt);
+			console_unlock();
+		}
 
 		first = -1;
 		last = -1;
_

Patches currently in -mm which might be from udknight@gmail.com are

linux-next.patch
fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch


From: akpm@linux-foundation.org
Subject: [merged]
 fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch removed
 from -mm tree
Date: Wed, 22 May 2013 14:35:48 -0700
Message-ID: <519d3a34.qmAvGnXugGTDJ7v5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab3EVVft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 17:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: [merged] fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch removed from -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 14:35:48 -0700


The patch titled
     Subject: fbcon: convert last fbcon_takeover call to do_fbcon_takeover
has been removed from the -mm tree.  Its filename was
     fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: fbcon: convert last fbcon_takeover call to do_fbcon_takeover

After 50e244cc7 ("fb: rework locking to fix lock ordering on takeover")
and e93a9a8687 ("fb: Yet another band-aid for fixing lockdep mess") we
have two functions implement almost the same, except the caller/callee
hold lock.

fbcon_takeover vs do_fbcon_takeover
register_con_driver vs do_register_con_driver
take_over_console vs do_take_over_console
unbind_con_driver vs do_unbind_con_driver
bind_con_driver vs do_bind_con_driver
unregister_con_driver vs do_unregister_con_driver

This issue brings us much code duplication, like do_fbcon_takeover and
fbcon_takeover, they have almost the same.

Although some of them had been re-written as a wrapper for another, but
the wrapper is so trivial, we can just throw them away.

Also those two versions of almost the same functions will confuse API's
user.

After all, I think this issue is not good for long time maintain.

This patch series converts all to the new version which caller hold the
lock, and then deletes the old version.



This patch:

After 054430e773 ("fbcon: fix locking harder"), there is only one place
use do_fbcon_takeover now, this patch convert it to do_fbcon_takeover too,
then we can delete fbcon_takeover whos function can be achieved with
do_fbcon_takeover easily to reduce code size and duplication.

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

 drivers/video/console/fbcon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover
+++ a/drivers/video/console/fbcon.c
@@ -3515,8 +3515,9 @@ static void fbcon_start(void)
 			}
 		}
 
+		do_fbcon_takeover(0);
 		console_unlock();
-		fbcon_takeover(0);
+
 	}
 }
 
_

Patches currently in -mm which might be from udknight@gmail.com are

linux-next.patch


From: akpm@linux-foundation.org
Subject: + fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch added to -mm tree
Date: Mon, 07 Feb 2011 17:21:11 -0800
Message-ID: <201102080121.p181LBeq006802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab1BHBWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2011 20:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, geert@linux-m68k.org, peter.nordstrom@palm.com, stable@kernel.org


The patch titled
     fb: fix potential deadlock between lock_fb_info and console_lock
has been added to the -mm tree.  Its filename is
     fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.pa=
tch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fb: fix potential deadlock between lock_fb_info and console_lo=
ck
=46rom: Andrea Righi <arighi@develer.com>

fb_set_suspend() must be called with the console semaphore held, which
means the code path coming in here will first take the console_lock() a=
nd
then call lock_fb_info().

However several framebuffer ioctl commands acquire these locks in rever=
se
order (lock_fb_info() and then console_lock()).  This gives rise to
potential AB-BA deadlock.

=46ix this by changing the order of acquisition in the ioctl commands t=
hat
make use of console_lock().

Signed-off-by: Andrea Righi <arighi@develer.com>
Reported-by: Peter Nordstr=F6m (Palm GBU) <peter.nordstrom@palm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/video/fbmem.c~fb-fix-potential-deadlock-between-lock_=
fb_info-and-console_lock drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-fix-potential-deadlock-between-lock_fb_i=
nfo-and-console_lock
+++ a/drivers/video/fbmem.c
@@ -1034,14 +1034,16 @@ static long do_fb_ioctl(struct fb_info *
 	case FBIOPUT_VSCREENINFO:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		info->flags |=3D FBINFO_MISC_USEREVENT;
 		ret =3D fb_set_var(info, &var);
 		info->flags &=3D ~FBINFO_MISC_USEREVENT;
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		if (!ret && copy_to_user(argp, &var, sizeof(var)))
 			ret =3D -EFAULT;
 		break;
@@ -1070,12 +1072,14 @@ static long do_fb_ioctl(struct fb_info *
 	case FBIOPAN_DISPLAY:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		ret =3D fb_pan_display(info, &var);
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		if (ret =3D=3D 0 && copy_to_user(argp, &var, sizeof(var)))
 			return -EFAULT;
 		break;
@@ -1117,14 +1121,16 @@ static long do_fb_ioctl(struct fb_info *
 		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		console_lock();
+		if (!lock_fb_info(info)) {
+			console_unlock();
+			return -ENODEV;
+		}
 		info->flags |=3D FBINFO_MISC_USEREVENT;
 		ret =3D fb_blank(info, arg);
 		info->flags &=3D ~FBINFO_MISC_USEREVENT;
-		console_unlock();
 		unlock_fb_info(info);
+		console_unlock();
 		break;
 	default:
 		if (!lock_fb_info(info))
_

Patches currently in -mm which might be from arighi@develer.com are

fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

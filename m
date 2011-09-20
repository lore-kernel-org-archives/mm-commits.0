From: akpm@google.com
Subject: [alternative-merged] fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch removed from -mm tree
Date: Tue, 20 Sep 2011 15:43:06 -0700
Message-ID: <201109202243.p8KMh7Xu026882@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38596 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1ITWoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2011 18:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arighi@develer.com, geert@linux-m68k.org, peter.nordstrom@palm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fb: fix potential deadlock between lock_fb_info and conso=
le_lock
has been removed from the -mm tree.  Its filename was
     fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.pa=
tch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Andrea Righi <arighi@develer.com>
Subject: fb: fix potential deadlock between lock_fb_info and console_lo=
ck

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

Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/video/fbmem.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/video/fbmem.c~fb-fix-potential-deadlock-between-lock_=
fb_info-and-console_lock drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-fix-potential-deadlock-between-lock_fb_i=
nfo-and-console_lock
+++ a/drivers/video/fbmem.c
@@ -1076,14 +1076,16 @@ static long do_fb_ioctl(struct fb_info *
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
@@ -1112,12 +1114,14 @@ static long do_fb_ioctl(struct fb_info *
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
@@ -1159,14 +1163,16 @@ static long do_fb_ioctl(struct fb_info *
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


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

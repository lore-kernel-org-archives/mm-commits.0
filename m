From: akpm@linux-foundation.org
Subject: + drivers-char-vt_ioctlc-fix-vt_openqry-error-value.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:44:10 -0700
Message-ID: <201009142244.o8EMiA5A022814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab0INWoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graham.gower@gmail.com, greg@kroah.com, stable@kernel.org


The patch titled
     drivers/char/vt_ioctl.c: fix VT_OPENQRY error value
has been added to the -mm tree.  Its filename is
     drivers-char-vt_ioctlc-fix-vt_openqry-error-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/vt_ioctl.c: fix VT_OPENQRY error value
From: Graham Gower <graham.gower@gmail.com>

When all VT's are in use, VT_OPENQRY casts -1 to unsigned char before
returning it to userspace as an int.  VT255 is not the next available
console.

Signed-off-by: Graham Gower <graham.gower@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt_ioctl.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/char/vt_ioctl.c~drivers-char-vt_ioctlc-fix-vt_openqry-error-value drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~drivers-char-vt_ioctlc-fix-vt_openqry-error-value
+++ a/drivers/char/vt_ioctl.c
@@ -503,6 +503,7 @@ int vt_ioctl(struct tty_struct *tty, str
 	struct kbd_struct * kbd;
 	unsigned int console;
 	unsigned char ucval;
+	unsigned int uival;
 	void __user *up = (void __user *)arg;
 	int i, perm;
 	int ret = 0;
@@ -657,7 +658,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		break;
 
 	case KDGETMODE:
-		ucval = vc->vc_mode;
+		uival = vc->vc_mode;
 		goto setint;
 
 	case KDMAPDISP:
@@ -695,7 +696,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		break;
 
 	case KDGKBMODE:
-		ucval = ((kbd->kbdmode == VC_RAW) ? K_RAW :
+		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
 				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
 				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
 				 K_XLATE);
@@ -717,9 +718,9 @@ int vt_ioctl(struct tty_struct *tty, str
 		break;
 
 	case KDGKBMETA:
-		ucval = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
+		uival = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
 	setint:
-		ret = put_user(ucval, (int __user *)arg);
+		ret = put_user(uival, (int __user *)arg);
 		break;
 
 	case KDGETKEYCODE:
@@ -949,7 +950,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
 			if (! VT_IS_IN_USE(i))
 				break;
-		ucval = i < MAX_NR_CONSOLES ? (i+1) : -1;
+		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		goto setint;		 
 
 	/*
_

Patches currently in -mm which might be from graham.gower@gmail.com are

drivers-char-vt_ioctlc-fix-vt_openqry-error-value.patch


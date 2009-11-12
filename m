From: akpm@linux-foundation.org
Subject: + vt-make-the-default-cursor-shape-configurable.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:06:42 -0800
Message-ID: <200911122206.nACM6g5d025297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546AbZKLWHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:07:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clemens@ladisch.de, alan@lxorguk.ukuu.org.uk, daniel@caiaq.de, davidn@davidnewall.com, geert@linux-m68k.org, gregkh@suse.de, pavel@ucw.cz


The patch titled
     vt: make the default cursor shape configurable
has been added to the -mm tree.  Its filename is
     vt-make-the-default-cursor-shape-configurable.patch

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
Subject: vt: make the default cursor shape configurable
From: Clemens Ladisch <clemens@ladisch.de>

-ENOCHANGELOG

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: David Newall <davidn@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 drivers/char/vt.c                   |    7 +++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~vt-make-the-default-cursor-shape-configurable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~vt-make-the-default-cursor-shape-configurable
+++ a/Documentation/kernel-parameters.txt
@@ -2720,6 +2720,11 @@ and is between 256 and 4096 characters. 
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vt.cur_default=	[VT] Default cursor shape.
+			Format: 0xCCBBAA, where AA, BB, and CC are the same as
+			the parameters of the <Esc>[?A;B;Cc escape sequence;
+			see VGA-softcursor.txt. Default: 2 = underline.
+
 	vt.default_blu=	[VT]
 			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
 			Change the default blue palette of the console.
diff -puN drivers/char/vt.c~vt-make-the-default-cursor-shape-configurable drivers/char/vt.c
--- a/drivers/char/vt.c~vt-make-the-default-cursor-shape-configurable
+++ a/drivers/char/vt.c
@@ -162,6 +162,9 @@ static int printable;		/* Is console rea
 int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
+static int cur_default = CUR_DEFAULT;
+module_param(cur_default, int, S_IRUGO | S_IWUSR);
+
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
  * mainly for the privacy of braille terminal users.
@@ -1628,7 +1631,7 @@ static void reset_terminal(struct vc_dat
 	/* do not do set_leds here because this causes an endless tasklet loop
 	   when the keyboard hasn't been initialized yet */
 
-	vc->vc_cursor_type = CUR_DEFAULT;
+	vc->vc_cursor_type = cur_default;
 	vc->vc_complement_mask = vc->vc_s_complement_mask;
 
 	default_attr(vc);
@@ -1830,7 +1833,7 @@ static void do_con_trol(struct tty_struc
 				if (vc->vc_par[0])
 					vc->vc_cursor_type = vc->vc_par[0] | (vc->vc_par[1] << 8) | (vc->vc_par[2] << 16);
 				else
-					vc->vc_cursor_type = CUR_DEFAULT;
+					vc->vc_cursor_type = cur_default;
 				return;
 			}
 			break;
_

Patches currently in -mm which might be from clemens@ladisch.de are

origin.patch
linux-next.patch
vt-make-the-default-cursor-shape-configurable.patch


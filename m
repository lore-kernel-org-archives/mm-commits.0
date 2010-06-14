From: akpm@linux-foundation.org
Subject: + drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long.patch added to -mm tree
Date: Mon, 14 Jun 2010 14:32:09 -0700
Message-ID: <201006142132.o5ELW9Dh032242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab0FNVcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 17:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiaochong@loongson.cn, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     drivers/char/vt.c:vc_do_resize(): local var `end' should be unsigned long
has been added to the -mm tree.  Its filename is
     drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long.patch

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
Subject: drivers/char/vt.c:vc_do_resize(): local var `end' should be unsigned long
From: qiaochong <qiaochong@loongson.cn>

According include/linux/console_struct.h,vc_scr_end is unsigned long.

struct vc_data {
    unsigned short  vc_num;         /* Console number */
    unsigned int    vc_cols;        /* [#] Console size */
    unsigned int    vc_rows;
    unsigned int    vc_size_row;        /* Bytes per row */
    unsigned int    vc_scan_lines;      /* # of scan lines */
    unsigned long   vc_origin;      /* [!] Start of real screen */
    unsigned long   vc_scr_end;     /* [!] End of real screen */
    unsigned long   vc_visible_origin;  /* [!] Top of visible window */
    unsigned int    vc_top, vc_bottom;  /* Scrolling region */
    const struct consw *vc_sw;
    unsigned short  *vc_screenbuf;
...
}

Signed-off-by: qiaochong <qiaochong@loongson.cn>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/vt.c~drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long drivers/char/vt.c
--- a/drivers/char/vt.c~drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long
+++ a/drivers/char/vt.c
@@ -830,10 +830,10 @@ static inline int resize_screen(struct v
 static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 				unsigned int cols, unsigned int lines)
 {
-	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
+	unsigned long old_origin, new_origin, new_scr_end, end, rlth, rrem, err = 0;
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
-	unsigned int end, user;
+	unsigned int user;
 	unsigned short *newscreen;
 
 	WARN_CONSOLE_UNLOCKED();
_

Patches currently in -mm which might be from qiaochong@loongson.cn are

fix-vc-vc_origin-on-take_over_console.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
drivers-char-vtc-vc_do_resize-local-var-end-should-be-unsigned-long.patch


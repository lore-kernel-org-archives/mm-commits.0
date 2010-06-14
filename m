From: akpm@linux-foundation.org
Subject: + fix-vc-vc_origin-on-take_over_console.patch added to -mm tree
Date: Mon, 14 Jun 2010 14:30:39 -0700
Message-ID: <201006142130.o5ELUdYG032137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755907Ab0FNVbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 17:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiaochong@loongson.cn, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     drivers/char/vt.c: fix vc->vc_origin on take_over_console()
has been added to the -mm tree.  Its filename is
     fix-vc-vc_origin-on-take_over_console.patch

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
Subject: drivers/char/vt.c: fix vc->vc_origin on take_over_console()
From: qiaochong <qiaochong@loongson.cn>

kernel will die on some platform when switch from vga mode to framebuffer
mode.  The reason of this bug is that bind_con_driver reset vc->vc_origin
to (unsigned long)vc->vc_screenbuf.

On vgacon vc->vc_origin is not releated to vc->vc_screenbuf,if set
vc->vc_origin to vc->vc_screenbuf,kernel will die on vc_do_resize.

static int vc_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
        struct vc_data *vc, unsigned int cols, unsigned int lines)
{
    unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
    unsigned int old_cols, old_rows, old_row_size, old_screen_size;
    unsigned int new_cols, new_rows, new_row_size, new_screen_size;
    unsigned int end, user;
...
        end = (old_rows > new_rows) ? old_origin +
            (old_row_size * new_rows) :
            vc->vc_scr_end;

...
/*
here for a test from vgacon to framebuffer:
old_origin=0x810814a0,end=0xb00b8fa0,vc->vc_origin=0x810814a0
the code bellow will copy memory from 0x810814a0 to 0xb00b8fa0,
this will cover kernel code,kernel died here.
*/

    while (old_origin < end) {

        scr_memcpyw((unsigned short *) new_origin,
                (unsigned short *) old_origin, rlth);
        if (rrem)
            scr_memsetw((void *)(new_origin + rlth),
                    vc->vc_video_erase_char, rrem);
        old_origin += old_row_size;
        new_origin += new_row_size;
    }

...
}

Signed-off-by: qiaochong <qiaochong@loongson.cn>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/vt.c~fix-vc-vc_origin-on-take_over_console drivers/char/vt.c
--- a/drivers/char/vt.c~fix-vc-vc_origin-on-take_over_console
+++ a/drivers/char/vt.c
@@ -3059,6 +3059,7 @@ static int bind_con_driver(const struct 
 
 		old_was_color = vc->vc_can_do_color;
 		vc->vc_sw->con_deinit(vc);
+		if(!vc->vc_origin)
 		vc->vc_origin = (unsigned long)vc->vc_screenbuf;
 		visual_init(vc, i, 0);
 		set_origin(vc);
_

Patches currently in -mm which might be from qiaochong@loongson.cn are

fix-vc-vc_origin-on-take_over_console.patch


From: akpm@linux-foundation.org
Subject: + usb-serial-console-setup-initialise-tty-kref.patch added to -mm tree
Date: Fri, 14 Nov 2008 14:36:50 -0800
Message-ID: <200811142236.mAEMaoqo029872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbYKNWhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 17:37:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kexin.hao@windriver.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, stable@kernel.org


The patch titled
     usb serial console setup: initialise tty kref
has been added to the -mm tree.  Its filename is
     usb-serial-console-setup-initialise-tty-kref.patch

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
Subject: usb serial console setup: initialise tty kref
From: Kevin Hao <kexin.hao@windriver.com>

We alloc a fake tty in usb serial console setup function.  we should init
the tty's kref otherwise we will face WARN_ON after following invoke of
tty_port_tty_set --> tty_kref_get.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/console.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/serial/console.c~usb-serial-console-setup-initialise-tty-kref drivers/usb/serial/console.c
--- a/drivers/usb/serial/console.c~usb-serial-console-setup-initialise-tty-kref
+++ a/drivers/usb/serial/console.c
@@ -135,6 +135,7 @@ static int usb_console_setup(struct cons
 				err("no more memory");
 				goto reset_open_count;
 			}
+			kref_init(&tty->kref);
 			termios = kzalloc(sizeof(*termios), GFP_KERNEL);
 			if (!termios) {
 				retval = -ENOMEM;
_

Patches currently in -mm which might be from kexin.hao@windriver.com are

usb-serial-console-setup-initialise-tty-kref.patch
usb-serial-console-add-device-function.patch
usb-serial-console-add-device-function-fix.patch


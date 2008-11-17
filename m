From: akpm@linux-foundation.org
Subject: - usb-serial-console-setup-initialise-tty-kref.patch removed from -mm tree
Date: Mon, 17 Nov 2008 13:27:36 -0800
Message-ID: <200811172127.mAHLRaeY024339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbYKQV2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Nov 2008 16:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kexin.hao@windriver.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     usb serial console setup: initialise tty kref
has been removed from the -mm tree.  Its filename was
     usb-serial-console-setup-initialise-tty-kref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
usb-serial-console-add-device-function-fix.patch


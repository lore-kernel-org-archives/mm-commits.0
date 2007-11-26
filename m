From: akpm@linux-foundation.org
Subject: + bluetooth-rfcomm-tty_close-before-destruct.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:35:13 -0800
Message-ID: <200711262235.lAQMZDqH026573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbXKZWfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:35:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, alan@lxorguk.ukuu.org.uk, marcel@holtmann.org


The patch titled
     bluetooth rfcomm: tty_close before destruct
has been added to the -mm tree.  Its filename is
     bluetooth-rfcomm-tty_close-before-destruct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bluetooth rfcomm: tty_close before destruct
From: Dave Young <hidave.darkstar@gmail.com>

rfcomm_dev_del could be called twice time in release function.  one by
rfcomm_tty_hangup, another by rfcomm_release_dev, this will cause the
device being destructed before rfcomm_tty_close.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/tty.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/bluetooth/rfcomm/tty.c~bluetooth-rfcomm-tty_close-before-destruct net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~bluetooth-rfcomm-tty_close-before-destruct
+++ a/net/bluetooth/rfcomm/tty.c
@@ -424,8 +424,8 @@ static int rfcomm_release_dev(void __use
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
 	if (dev->tty)
 		tty_vhangup(dev->tty);
-
-	rfcomm_dev_del(dev);
+	else if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags))
+		rfcomm_dev_del(dev);
 	rfcomm_dev_put(dev);
 	return 0;
 }
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

gx-suspmodc-use-boot_cpu_data-instead-of-current_cpu_data.patch
bluetooth-hidp_process_hid_control-remove-unnecessary-parameter-dealing.patch
bluetooth-rfcomm-tty_close-before-destruct.patch

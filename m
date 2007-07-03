From: akpm@linux-foundation.org
Subject: + rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch added to -mm tree
Date: Tue, 03 Jul 2007 13:49:04 -0700
Message-ID: <200707032049.l63Kn4u8014713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbXGCUtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 16:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcel@holtmann.org, alan@lxorguk.ukuu.org.uk


The patch titled
     rfcomm: hangup ttys before releasing rfcomm_dev
has been added to the -mm tree.  Its filename is
     rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rfcomm: hangup ttys before releasing rfcomm_dev


Addresses the oops at http://bugzilla.kernel.org/show_bug.cgi?id=7509

The core problem is that rfcomm socket layer ioctl can release rfcomm_dev
struct while rfcomm tty layer is still actively using it.  Calling tty_vhangup
is needed for a synchronous hangup before rfcomm_dev is freed.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/tty.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN net/bluetooth/rfcomm/tty.c~rfcomm-hangup-ttys-before-releasing-rfcomm_dev net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~rfcomm-hangup-ttys-before-releasing-rfcomm_dev
+++ a/net/bluetooth/rfcomm/tty.c
@@ -383,6 +383,12 @@ static int rfcomm_release_dev(void __use
 	if (req.flags & (1 << RFCOMM_HANGUP_NOW))
 		rfcomm_dlc_close(dev->dlc, 0);
 
+	/*
+	 * Be nice and shut down tty(s) synchronously before freeing rfcomm_dev
+	 */
+	if (dev->tty)
+		tty_vhangup(dev->tty);
+
 	rfcomm_dev_del(dev);
 	rfcomm_dev_put(dev);
 	return 0;
_

Patches currently in -mm which might be from marcel@holtmann.org are

bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch

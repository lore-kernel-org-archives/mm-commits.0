From: akpm@linux-foundation.org
Subject: - rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:02 -0700
Message-ID: <200707132233.l6DMX2rp025046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206AbXGMWdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcel@holtmann.org, alan@lxorguk.ukuu.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rfcomm: hangup ttys before releasing rfcomm_dev
has been removed from the -mm tree.  Its filename was
     rfcomm-hangup-ttys-before-releasing-rfcomm_dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rfcomm: hangup ttys before releasing rfcomm_dev


Addresses the oops at http://bugzilla.kernel.org/show_bug.cgi?id=7509

The core problem is that rfcomm socket layer ioctl can release rfcomm_dev
struct while rfcomm tty layer is still actively using it.  Calling tty_vhangup
is needed for a synchronous hangup before rfcomm_dev is freed.

Cc: Marcel Holtmann <marcel@holtmann.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/tty.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN net/bluetooth/rfcomm/tty.c~rfcomm-hangup-ttys-before-releasing-rfcomm_dev net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~rfcomm-hangup-ttys-before-releasing-rfcomm_dev
+++ a/net/bluetooth/rfcomm/tty.c
@@ -399,6 +399,12 @@ static int rfcomm_release_dev(void __use
 	if (dev->tty)
 		tty_vhangup(dev->tty);
 
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

origin.patch

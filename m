From: akpm@linux-foundation.org
Subject: - bluetooth-rfcomm-tty_close-before-destruct.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:28:01 -0800
Message-ID: <200803062228.m26MS1AM021140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756804AbYCFW2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:28:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, alan@lxorguk.ukuu.org.uk, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth rfcomm: tty_close before destruct
has been removed from the -mm tree.  Its filename was
     bluetooth-rfcomm-tty_close-before-destruct.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -428,8 +428,8 @@ static int rfcomm_release_dev(void __use
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
 	if (dev->tty)
 		tty_vhangup(dev->tty);

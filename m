From: akpm@linux-foundation.org
Subject: - net-bluetooth-rfcomm-ttyc-use-after-free.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:23 -0700
Message-ID: <200707290613.l6T6DNaa011196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758660AbXG2GXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcel@holtmann.org, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     net/bluetooth/rfcomm/tty.c: use-after-free
has been removed from the -mm tree.  Its filename was
     net-bluetooth-rfcomm-ttyc-use-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/bluetooth/rfcomm/tty.c: use-after-free
From: Marcel Holtmann <marcel@holtmann.org>

Adrian said:

> Commit 8de0a15483b357d0f0b821330ec84d1660cadc4e added the following
> use-after-free in net/bluetooth/rfcomm/tty.c:
>
> <--  snip  -->
>
> ...
> static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
> {
> ...
>         if (IS_ERR(dev->tty_dev)) {
>                 list_del(&dev->list);
>                 kfree(dev);
>                 return PTR_ERR(dev->tty_dev);
>         }
> ...
>
> <--  snip  -->
>
> Spotted by the Coverity checker.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/tty.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN net/bluetooth/rfcomm/tty.c~net-bluetooth-rfcomm-ttyc-use-after-free net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~net-bluetooth-rfcomm-ttyc-use-after-free
+++ a/net/bluetooth/rfcomm/tty.c
@@ -267,7 +267,7 @@ static int rfcomm_dev_add(struct rfcomm_
 out:
 	write_unlock_bh(&rfcomm_dev_lock);
 
-	if (err) {
+	if (err < 0) {
 		kfree(dev);
 		return err;
 	}
@@ -275,9 +275,10 @@ out:
 	dev->tty_dev = tty_register_device(rfcomm_tty_driver, dev->id, NULL);
 
 	if (IS_ERR(dev->tty_dev)) {
+		err = PTR_ERR(dev->tty_dev);
 		list_del(&dev->list);
 		kfree(dev);
-		return PTR_ERR(dev->tty_dev);
+		return err;
 	}
 
 	return dev->id;
_

Patches currently in -mm which might be from marcel@holtmann.org are

git-net.patch

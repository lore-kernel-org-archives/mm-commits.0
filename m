From: akpm@linux-foundation.org
Subject: + net-bluetooth-rfcomm-ttyc-use-after-free.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:18:57 -0700
Message-ID: <200707262018.l6QKIvfO018943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933646AbXGZUTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcel@holtmann.org, bunk@stusta.de


The patch titled
     net/bluetooth/rfcomm/tty.c: use-after-free
has been added to the -mm tree.  Its filename is
     net-bluetooth-rfcomm-ttyc-use-after-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

net-bluetooth-rfcomm-ttyc-use-after-free.patch

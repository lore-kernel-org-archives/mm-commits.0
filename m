From: akpm@linux-foundation.org
Subject: - bluetooth-fix-oops-in-rfcomm-tty-code-v2.patch removed from -mm tree
Date: Sun, 20 Jul 2008 22:34:12 -0700
Message-ID: <200807210534.m6L5YCSQ019427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbYGUFe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 01:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, dwmw2@infradead.org, hidave.darkstar@gmail.com, kernel@nn7.de, marcel@holtmann.org, maxk@qualcomm.com, mm-commits@vger.kernel.org


The patch titled
     Bluetooth: fix oops in rfcomm tty code
has been removed from the -mm tree.  Its filename was
     bluetooth-fix-oops-in-rfcomm-tty-code-v2.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Bluetooth: fix oops in rfcomm tty code
From: Vegard Nossum <vegard.nossum@gmail.com>

Soeren Sonnenburg reported:
> this oops happened after a couple of s2ram cycles so it might be very
> well crap. However I somehow triggered it by /etc/init.d/bluetooth
> stop/start's which also call hid2hci maybe even a connection was about
> to be established at that time. As I remember having seen a problem like
> this before I thought I report it (even though I have a madwifi tainted
> kernel).
>
> kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.

It turns out that the following sequence of actions will reproduce the
oops:

  1. Create a new rfcomm device (using RFCOMMCREATEDEV ioctl)
  2. (Try to) open the device
  3. Release the rfcomm device (using RFCOMMRELEASEDEV ioctl)

At this point, the "rfcomm?" tty is still in use, but the device is gone
from the internal rfcomm list, so the device id can be reused.

  4. Create a new rfcomm device with the same device id as before

And now kobject will complain that the tty already exists.

(See http://lkml.org/lkml/2008/7/13/89 for a reproducible test-case.)

This patch attempts to correct this by only removing the device from the
internal rfcomm list of devices at the final unregister, so that the id
won't get reused until the device has been completely destructed.

This should be safe as the RFCOMM_TTY_RELEASED bit will be set for the
device and prevent the device from being reopened after it has been
released.

We also fix a race (which would lead to the same oops) by including the
tty setup/teardown code in the rfcomm_dev_lock, the lock protecting the
list of devices.

Thanks to Dave Young for additional suggestions.

Reviewed-by: Soeren Sonnenburg <kernel@nn7.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/tty.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN net/bluetooth/rfcomm/tty.c~bluetooth-fix-oops-in-rfcomm-tty-code-v2 net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~bluetooth-fix-oops-in-rfcomm-tty-code-v2
+++ a/net/bluetooth/rfcomm/tty.c
@@ -96,9 +96,11 @@ static void rfcomm_dev_destruct(struct r
 	BT_DBG("dev %p dlc %p", dev, dlc);
 
 	/* Refcount should only hit zero when called from rfcomm_dev_del()
-	   which will have taken us off the list. Everything else are
-	   refcounting bugs. */
-	BUG_ON(!list_empty(&dev->list));
+	   which will have set the RFCOMM_TTY_RELEASED bit. Everything else
+	   are refcounting bugs. */
+	BUG_ON(!test_bit(RFCOMM_TTY_RELEASED, &dev->flags));
+
+	write_lock_bh(&rfcomm_dev_lock);
 
 	rfcomm_dlc_lock(dlc);
 	/* Detach DLC if it's owned by this dev */
@@ -108,8 +110,11 @@ static void rfcomm_dev_destruct(struct r
 
 	rfcomm_dlc_put(dlc);
 
+	list_del_init(&dev->list);
 	tty_unregister_device(rfcomm_tty_driver, dev->id);
 
+	write_unlock_bh(&rfcomm_dev_lock);
+
 	kfree(dev);
 
 	/* It's safe to call module_put() here because socket still
@@ -127,10 +132,8 @@ static inline void rfcomm_dev_put(struct
 	/* The reason this isn't actually a race, as you no
 	   doubt have a little voice screaming at you in your
 	   head, is that the refcount should never actually
-	   reach zero unless the device has already been taken
-	   off the list, in rfcomm_dev_del(). And if that's not
-	   true, we'll hit the BUG() in rfcomm_dev_destruct()
-	   anyway. */
+	   reach zero unless we've already set the
+	   RFCOMM_TTY_RELEASED bit in rfcomm_dev_del(). */
 	if (atomic_dec_and_test(&dev->refcnt))
 		rfcomm_dev_destruct(dev);
 }
@@ -299,9 +302,8 @@ static int rfcomm_dev_add(struct rfcomm_
 	__module_get(THIS_MODULE);
 
 out:
-	write_unlock_bh(&rfcomm_dev_lock);
-
 	if (err < 0) {
+		write_unlock_bh(&rfcomm_dev_lock);
 		kfree(dev);
 		return err;
 	}
@@ -311,6 +313,7 @@ out:
 	if (IS_ERR(dev->tty_dev)) {
 		err = PTR_ERR(dev->tty_dev);
 		list_del(&dev->list);
+		write_unlock_bh(&rfcomm_dev_lock);
 		kfree(dev);
 		return err;
 	}
@@ -323,6 +326,8 @@ out:
 	if (device_create_file(dev->tty_dev, &dev_attr_channel) < 0)
 		BT_ERR("Failed to create channel attribute");
 
+	write_unlock_bh(&rfcomm_dev_lock);
+
 	return dev->id;
 }
 
@@ -335,10 +340,6 @@ static void rfcomm_dev_del(struct rfcomm
 	else
 		set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
 
-	write_lock_bh(&rfcomm_dev_lock);
-	list_del_init(&dev->list);
-	write_unlock_bh(&rfcomm_dev_lock);

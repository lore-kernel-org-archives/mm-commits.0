From: akpm@linux-foundation.org
Subject: - bluetooth-postpone-hci_dev-unregistration.patch removed from -mm tree
Date: Tue, 05 Jun 2007 21:29:40 -0700
Message-ID: <200706060429.l564Teng009433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbXFFE3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 00:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     Bluetooth: postpone hci_dev unregistration
has been removed from the -mm tree.  Its filename was
     bluetooth-postpone-hci_dev-unregistration.patch

This patch was dropped because it might have caused a kmalloc overrun

------------------------------------------------------
Subject: Bluetooth: postpone hci_dev unregistration
From: Jiri Kosina <jkosina@suse.cz>

Bluetooth: postpone hci_dev unregistration

Commit b40df57 substituted bh_lock_sock() in hci_sock_dev_event() for
lock_sock() when unregistering HCI device, in order to prevent deadlock
against locking in l2cap_connect_cfm() from softirq context.

This however introduces another problem - hci_sock_dev_event() for
HCI_DEV_UNREG can also be triggered in atomic context, in which calling
lock_sock() is not safe as it could sleep.  Reported by Jeremy Fitzhardinge
at http://lkml.org/lkml/2007/4/23/271

This patch moves the detaching of sockets from hci_device into workqueue,
so that lock_sock() can be used safely.  This requires movement of
deallocation of hci_dev - deallocating device just after
hci_unregister_dev() would be too soon, as it could happen before the
workqueue has been run.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/bfusb.c        |    2 -
 drivers/bluetooth/bluecard_cs.c  |    2 -
 drivers/bluetooth/bpa10x.c       |    2 -
 drivers/bluetooth/bt3c_cs.c      |    2 -
 drivers/bluetooth/btuart_cs.c    |    2 -
 drivers/bluetooth/dtl1_cs.c      |    2 -
 drivers/bluetooth/hci_ldisc.c    |    1 
 drivers/bluetooth/hci_usb.c      |    2 -
 drivers/bluetooth/hci_vhci.c     |    2 -
 include/net/bluetooth/hci_core.h |    3 +
 net/bluetooth/hci_core.c         |    9 +++++
 net/bluetooth/hci_sock.c         |   46 +++++++++++++++--------------
 12 files changed, 36 insertions(+), 39 deletions(-)

diff -puN drivers/bluetooth/bfusb.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/bfusb.c
--- a/drivers/bluetooth/bfusb.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/bfusb.c
@@ -762,8 +762,6 @@ static void bfusb_disconnect(struct usb_
 
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
-
-	hci_free_dev(hdev);
 }
 
 static struct usb_driver bfusb_driver = {
diff -puN drivers/bluetooth/bluecard_cs.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/bluecard_cs.c
--- a/drivers/bluetooth/bluecard_cs.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/bluecard_cs.c
@@ -851,8 +851,6 @@ static int bluecard_close(bluecard_info_
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff -puN drivers/bluetooth/bpa10x.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/bpa10x.c
--- a/drivers/bluetooth/bpa10x.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/bpa10x.c
@@ -613,8 +613,6 @@ static void bpa10x_disconnect(struct usb
 
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
-
-	hci_free_dev(hdev);
 }
 
 static struct usb_driver bpa10x_driver = {
diff -puN drivers/bluetooth/bt3c_cs.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/bt3c_cs.c
--- a/drivers/bluetooth/bt3c_cs.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/bt3c_cs.c
@@ -640,8 +640,6 @@ static int bt3c_close(bt3c_info_t *info)
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff -puN drivers/bluetooth/btuart_cs.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/btuart_cs.c
--- a/drivers/bluetooth/btuart_cs.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/btuart_cs.c
@@ -570,8 +570,6 @@ static int btuart_close(btuart_info_t *i
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff -puN drivers/bluetooth/dtl1_cs.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/dtl1_cs.c
--- a/drivers/bluetooth/dtl1_cs.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/dtl1_cs.c
@@ -552,8 +552,6 @@ static int dtl1_close(dtl1_info_t *info)
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 
-	hci_free_dev(hdev);
-
 	return 0;
 }
 
diff -puN drivers/bluetooth/hci_ldisc.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/hci_ldisc.c
@@ -314,7 +314,6 @@ static void hci_uart_tty_close(struct tt
 		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 			hu->proto->close(hu);
 			hci_unregister_dev(hdev);
-			hci_free_dev(hdev);
 		}
 	}
 }
diff -puN drivers/bluetooth/hci_usb.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/hci_usb.c
@@ -1075,8 +1075,6 @@ static void hci_usb_disconnect(struct us
 
 	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
-
-	hci_free_dev(hdev);
 }
 
 static int hci_usb_suspend(struct usb_interface *intf, pm_message_t message)
diff -puN drivers/bluetooth/hci_vhci.c~bluetooth-postpone-hci_dev-unregistration drivers/bluetooth/hci_vhci.c
--- a/drivers/bluetooth/hci_vhci.c~bluetooth-postpone-hci_dev-unregistration
+++ a/drivers/bluetooth/hci_vhci.c
@@ -308,8 +308,6 @@ static int vhci_release(struct inode *in
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
 	}
 
-	hci_free_dev(hdev);
-
 	file->private_data = NULL;
 
 	return 0;
diff -puN include/net/bluetooth/hci_core.h~bluetooth-postpone-hci_dev-unregistration include/net/bluetooth/hci_core.h
--- a/include/net/bluetooth/hci_core.h~bluetooth-postpone-hci_dev-unregistration
+++ a/include/net/bluetooth/hci_core.h
@@ -132,6 +132,8 @@ struct hci_dev {
 
 	struct module 		*owner;
 
+	struct work_struct	hci_dev_unreg_work;
+
 	int (*open)(struct hci_dev *hdev);
 	int (*close)(struct hci_dev *hdev);
 	int (*flush)(struct hci_dev *hdev);
@@ -622,6 +624,7 @@ void hci_si_event(struct hci_dev *hdev, 
 
 /* ----- HCI Sockets ----- */
 void hci_send_to_sock(struct hci_dev *hdev, struct sk_buff *skb);
+void hci_sock_detach(struct hci_dev *hdev);
 
 /* HCI info for socket */
 #define hci_pi(sk) ((struct hci_pinfo *) sk)
diff -puN net/bluetooth/hci_core.c~bluetooth-postpone-hci_dev-unregistration net/bluetooth/hci_core.c
--- a/net/bluetooth/hci_core.c~bluetooth-postpone-hci_dev-unregistration
+++ a/net/bluetooth/hci_core.c
@@ -795,6 +795,14 @@ int hci_get_dev_info(void __user *arg)
 	return err;
 }
 
+void hci_dev_unreg(struct work_struct *work)
+{
+	struct hci_dev *hdev =
+		container_of(work, struct hci_dev, hci_dev_unreg_work);
+	hci_sock_detach(hdev);
+	hci_free_dev(hdev);
+}
+
 /* ---- Interface to HCI drivers ---- */
 
 /* Alloc HCI device */
@@ -807,6 +815,7 @@ struct hci_dev *hci_alloc_dev(void)
 		return NULL;
 
 	skb_queue_head_init(&hdev->driver_init);
+	INIT_WORK(&hdev->hci_dev_unreg_work, hci_dev_unreg);
 
 	return hdev;
 }
diff -puN net/bluetooth/hci_sock.c~bluetooth-postpone-hci_dev-unregistration net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~bluetooth-postpone-hci_dev-unregistration
+++ a/net/bluetooth/hci_sock.c
@@ -141,6 +141,28 @@ void hci_send_to_sock(struct hci_dev *hd
 	read_unlock(&hci_sk_list.lock);
 }
 
+void hci_sock_detach(struct hci_dev *hdev)
+{
+	struct sock *sk;
+	struct hlist_node *node;
+
+	/* Detach sockets from device */
+	read_lock(&hci_sk_list.lock);
+	sk_for_each(sk, node, &hci_sk_list.head) {
+		lock_sock(sk);
+		if (hci_pi(sk)->hdev == hdev) {
+			hci_pi(sk)->hdev = NULL;
+			sk->sk_err = EPIPE;
+			sk->sk_state = BT_OPEN;
+			sk->sk_state_change(sk);
+
+			hci_dev_put(hdev);
+		}
+		release_sock(sk);
+	}
+	read_unlock(&hci_sk_list.lock);
+}
+
 static int hci_sock_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -658,28 +680,8 @@ static int hci_sock_dev_event(struct not
 	ev.dev_id = hdev->id;
 	hci_si_event(NULL, HCI_EV_SI_DEVICE, sizeof(ev), &ev);
 
-	if (event == HCI_DEV_UNREG) {
-		struct sock *sk;
-		struct hlist_node *node;
-
-		/* Detach sockets from device */
-		read_lock(&hci_sk_list.lock);
-		sk_for_each(sk, node, &hci_sk_list.head) {
-			local_bh_disable();
-			bh_lock_sock_nested(sk);
-			if (hci_pi(sk)->hdev == hdev) {
-				hci_pi(sk)->hdev = NULL;
-				sk->sk_err = EPIPE;
-				sk->sk_state = BT_OPEN;
-				sk->sk_state_change(sk);
-
-				hci_dev_put(hdev);
-			}
-			bh_unlock_sock(sk);
-			local_bh_enable();
-		}
-		read_unlock(&hci_sk_list.lock);
-	}
+	if (event == HCI_DEV_UNREG)
+		schedule_work(&hdev->hci_dev_unreg_work);
 
 	return NOTIFY_DONE;
 }
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
bluetooth-postpone-hci_dev-unregistration.patch
git-ipwireless_cs.patch
pie-randomization.patch

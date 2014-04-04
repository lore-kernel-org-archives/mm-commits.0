From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 04 Apr 2014 16:01:26 -0700
Message-ID: <533f39c6.l/FHSGT+RJZy+ffL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaDDXB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 19:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 16:01:26 -0700


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/net/stmmac.txt |    3 
 drivers/gpio/gpio-ich.c                          |    3 
 drivers/hid/hid-sony.c                           |  141 -------------
 drivers/infiniband/hw/cxgb4/cm.c                 |    7 
 drivers/input/touchscreen/edt-ft5x06.c           |    9 
 drivers/staging/wlags49_h2/wl_netdev.c           |   12 -
 fs/fs-writeback.c                                |    6 
 kernel/seccomp.c                                 |    4 
 net/bluetooth/hci_conn.c                         |   23 --
 net/bluetooth/hci_event.c                        |   73 ------
 net/bluetooth/mgmt.c                             |   18 -
 net/core/flow.c                                  |   12 -
 12 files changed, 4 insertions(+), 307 deletions(-)

diff -puN Documentation/devicetree/bindings/net/stmmac.txt~linux-next-git-rejects Documentation/devicetree/bindings/net/stmmac.txt
--- a/Documentation/devicetree/bindings/net/stmmac.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/net/stmmac.txt
@@ -31,13 +31,10 @@ Optional properties:
 - reset-names: Should contain the reset signal name "stmmaceth", if a
 	reset phandle is given
 - max-frame-size: See ethernet.txt file in the same directory
-<<<<<<< HEAD
-=======
 - clocks: If present, the first clock should be the GMAC main clock,
   further clocks may be specified in derived bindings.
 - clocks-names: One name for each entry in the clocks property, the
   first one should be "stmmaceth".
->>>>>>> linux-next/akpm-base
 
 Examples:
 
diff -puN drivers/gpio/gpio-ich.c~linux-next-git-rejects drivers/gpio/gpio-ich.c
--- a/drivers/gpio/gpio-ich.c~linux-next-git-rejects
+++ a/drivers/gpio/gpio-ich.c
@@ -361,8 +361,6 @@ static struct ichx_desc intel5_desc = {
 	.ngpio = 76,
 	.regs = ichx_regs,
 	.reglen = ichx_reglen,
-<<<<<<< HEAD
-=======
 };
 
 /* Avoton */
@@ -374,7 +372,6 @@ static struct ichx_desc avoton_desc = {
 	.regs = avoton_regs,
 	.reglen = avoton_reglen,
 	.use_outlvl_cache = true,
->>>>>>> linux-next/akpm-base
 };
 
 static int ichx_gpio_request_regions(struct resource *res_base,
diff -puN drivers/hid/hid-sony.c~linux-next-git-rejects drivers/hid/hid-sony.c
--- a/drivers/hid/hid-sony.c~linux-next-git-rejects
+++ a/drivers/hid/hid-sony.c
@@ -1274,15 +1274,8 @@ static void dualshock4_state_worker(stru
 	struct sony_sc *sc = container_of(work, struct sony_sc, state_worker);
 	struct hid_device *hdev = sc->hdev;
 	int offset;
-<<<<<<< HEAD
-
 	__u8 buf[78] = { 0 };
 
-=======
-
-	__u8 buf[78] = { 0 };
-
->>>>>>> linux-next/akpm-base
 	if (sc->quirks & DUALSHOCK4_CONTROLLER_USB) {
 		buf[0] = 0x05;
 		buf[1] = 0x03;
@@ -1394,7 +1387,6 @@ static int sony_battery_probe(struct son
 	unsigned long power_id;
 	struct hid_device *hdev = sc->hdev;
 	int ret;
-<<<<<<< HEAD
 
 	/*
 	 * Set the default battery level to 100% to avoid low battery warnings
@@ -1423,36 +1415,6 @@ static int sony_battery_probe(struct son
 	power_supply_powers(&sc->battery, &hdev->dev);
 	return 0;
 
-=======
-
-	/*
-	 * Set the default battery level to 100% to avoid low battery warnings
-	 * if the battery is polled before the first device report is received.
-	 */
-	sc->battery_capacity = 100;
-
-	power_id = (unsigned long)atomic_inc_return(&power_id_seq);
-
-	sc->battery.properties = sony_battery_props;
-	sc->battery.num_properties = ARRAY_SIZE(sony_battery_props);
-	sc->battery.get_property = sony_battery_get_property;
-	sc->battery.type = POWER_SUPPLY_TYPE_BATTERY;
-	sc->battery.use_for_apm = 0;
-	sc->battery.name = kasprintf(GFP_KERNEL, "sony_controller_battery_%lu",
-				     power_id);
-	if (!sc->battery.name)
-		return -ENOMEM;
-
-	ret = power_supply_register(&hdev->dev, &sc->battery);
-	if (ret) {
-		hid_err(hdev, "Unable to register battery device\n");
-		goto err_free;
-	}
-
-	power_supply_powers(&sc->battery, &hdev->dev);
-	return 0;
-
->>>>>>> linux-next/akpm-base
 err_free:
 	kfree(sc->battery.name);
 	sc->battery.name = NULL;
@@ -1516,107 +1478,6 @@ static int sony_check_add_dev_list(struc
 
 	ret = 0;
 	list_add(&(sc->list_node), &sony_device_list);
-<<<<<<< HEAD
-
-unlock:
-	spin_unlock_irqrestore(&sony_dev_list_lock, flags);
-	return ret;
-}
-
-static void sony_remove_dev_list(struct sony_sc *sc)
-{
-	unsigned long flags;
-
-	if (sc->list_node.next) {
-		spin_lock_irqsave(&sony_dev_list_lock, flags);
-		list_del(&(sc->list_node));
-		spin_unlock_irqrestore(&sony_dev_list_lock, flags);
-	}
-}
-
-static int sony_get_bt_devaddr(struct sony_sc *sc)
-{
-	int ret;
-
-	/* HIDP stores the device MAC address as a string in the uniq field. */
-	ret = strlen(sc->hdev->uniq);
-	if (ret != 17)
-		return -EINVAL;
-
-	ret = sscanf(sc->hdev->uniq,
-		"%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
-		&sc->mac_address[5], &sc->mac_address[4], &sc->mac_address[3],
-		&sc->mac_address[2], &sc->mac_address[1], &sc->mac_address[0]);
-
-	if (ret != 6)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int sony_check_add(struct sony_sc *sc)
-{
-	int n, ret;
-
-	if ((sc->quirks & DUALSHOCK4_CONTROLLER_BT) ||
-	    (sc->quirks & SIXAXIS_CONTROLLER_BT)) {
-		/*
-		 * sony_get_bt_devaddr() attempts to parse the Bluetooth MAC
-		 * address from the uniq string where HIDP stores it.
-		 * As uniq cannot be guaranteed to be a MAC address in all cases
-		 * a failure of this function should not prevent the connection.
-		 */
-		if (sony_get_bt_devaddr(sc) < 0) {
-			hid_warn(sc->hdev, "UNIQ does not contain a MAC address; duplicate check skipped\n");
-			return 0;
-		}
-	} else if (sc->quirks & DUALSHOCK4_CONTROLLER_USB) {
-		__u8 buf[7];
-
-		/*
-		 * The MAC address of a DS4 controller connected via USB can be
-		 * retrieved with feature report 0x81. The address begins at
-		 * offset 1.
-		 */
-		ret = hid_hw_raw_request(sc->hdev, 0x81, buf, sizeof(buf),
-				HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
-
-		if (ret != 7) {
-			hid_err(sc->hdev, "failed to retrieve feature report 0x81 with the DualShock 4 MAC address\n");
-			return ret < 0 ? ret : -EINVAL;
-		}
-
-		memcpy(sc->mac_address, &buf[1], sizeof(sc->mac_address));
-	} else if (sc->quirks & SIXAXIS_CONTROLLER_USB) {
-		__u8 buf[18];
-
-		/*
-		 * The MAC address of a Sixaxis controller connected via USB can
-		 * be retrieved with feature report 0xf2. The address begins at
-		 * offset 4.
-		 */
-		ret = hid_hw_raw_request(sc->hdev, 0xf2, buf, sizeof(buf),
-				HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
-
-		if (ret != 18) {
-			hid_err(sc->hdev, "failed to retrieve feature report 0xf2 with the Sixaxis MAC address\n");
-			return ret < 0 ? ret : -EINVAL;
-		}
-
-		/*
-		 * The Sixaxis device MAC in the report is big-endian and must
-		 * be byte-swapped.
-		 */
-		for (n = 0; n < 6; n++)
-			sc->mac_address[5-n] = buf[4+n];
-	} else {
-		return 0;
-	}
-
-	return sony_check_add_dev_list(sc);
-}
-
-=======
 
 unlock:
 	spin_unlock_irqrestore(&sony_dev_list_lock, flags);
@@ -1716,8 +1577,6 @@ static int sony_check_add(struct sony_sc
 	return sony_check_add_dev_list(sc);
 }
 
->>>>>>> linux-next/akpm-base
-
 static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret;
diff -puN drivers/infiniband/hw/cxgb4/cm.c~linux-next-git-rejects drivers/infiniband/hw/cxgb4/cm.c
--- a/drivers/infiniband/hw/cxgb4/cm.c~linux-next-git-rejects
+++ a/drivers/infiniband/hw/cxgb4/cm.c
@@ -2521,15 +2521,8 @@ int c4iw_reject_cr(struct iw_cm_id *cm_i
 	struct c4iw_ep *ep = to_ep(cm_id);
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
-<<<<<<< HEAD
 	mutex_lock(&ep->com.mutex);
 	if (ep->com.state == DEAD) {
-		mutex_unlock(&ep->com.mutex);
-=======
-
-	mutex_lock(&ep->com.mutex);
-	if (ep->com.state == DEAD) {
->>>>>>> linux-next/akpm-base
 		c4iw_put_ep(&ep->com);
 		return -ECONNRESET;
 	}
diff -puN drivers/input/touchscreen/edt-ft5x06.c~linux-next-git-rejects drivers/input/touchscreen/edt-ft5x06.c
--- a/drivers/input/touchscreen/edt-ft5x06.c~linux-next-git-rejects
+++ a/drivers/input/touchscreen/edt-ft5x06.c
@@ -291,16 +291,10 @@ static int edt_ft5x06_register_read(stru
 		wrbuf[1] = tsdata->factory_mode ? addr & 0x7f : addr & 0x3f;
 		wrbuf[1] |= tsdata->factory_mode ? 0x80 : 0x40;
 
-<<<<<<< HEAD
 		error = edt_ft5x06_ts_readwrite(tsdata->client, 2, wrbuf, 2,
 						rdbuf);
 		if (error)
 			return error;
-=======
-		error = edt_ft5x06_ts_readwrite(tsdata->client,
-						2, wrbuf, 2, rdbuf);
-		return error;
->>>>>>> linux-next/akpm-base
 
 		if ((wrbuf[0] ^ wrbuf[1] ^ rdbuf[0]) != rdbuf[1]) {
 			dev_err(&tsdata->client->dev,
@@ -934,8 +928,6 @@ edt_ft5x06_ts_set_regs(struct edt_ft5x06
 		reg_addr->reg_num_y = M09_REGISTER_NUM_Y;
 		break;
 	}
-<<<<<<< HEAD
-=======
 }
 
 #ifdef CONFIG_OF
@@ -959,7 +951,6 @@ static inline int edt_ft5x06_i2c_ts_prob
 					struct edt_ft5x06_ts_data *tsdata)
 {
 	return -ENODEV;
->>>>>>> linux-next/akpm-base
 }
 #endif
 
diff -puN drivers/staging/wlags49_h2/wl_netdev.c~linux-next-git-rejects drivers/staging/wlags49_h2/wl_netdev.c
--- a/drivers/staging/wlags49_h2/wl_netdev.c~linux-next-git-rejects
+++ a/drivers/staging/wlags49_h2/wl_netdev.c
@@ -695,11 +695,7 @@ int wl_send(struct wl_private *lp)
 
 		/* Free the skb and perform queue cleanup, as the buffer was
 		   transmitted successfully */
-<<<<<<< HEAD
-		dev_consume_skb_any( lp->txF.skb );
-=======
 		dev_consume_skb_any(lp->txF.skb);
->>>>>>> linux-next/akpm-base
 
 		lp->txF.skb = NULL;
 		lp->txF.port = 0;
@@ -1754,11 +1750,7 @@ int wl_send_dma(struct wl_private *lp, s
 			WL_WDS_NETIF_STOP_QUEUE(lp);
 			lp->netif_queue_on = FALSE;
 
-<<<<<<< HEAD
-			dev_kfree_skb_any( skb );
-=======
 			dev_kfree_skb_any(skb);
->>>>>>> linux-next/akpm-base
 			return 0;
 		}
 	}
@@ -1783,11 +1775,7 @@ int wl_send_dma(struct wl_private *lp, s
 
 	/* Free the skb and perform queue cleanup, as the buffer was
 	   transmitted successfully */
-<<<<<<< HEAD
-	dev_consume_skb_any( skb );
-=======
 	dev_consume_skb_any(skb);
->>>>>>> linux-next/akpm-base
 
 	return TRUE;
 }				/* wl_send_dma */
diff -puN fs/fs-writeback.c~linux-next-git-rejects fs/fs-writeback.c
--- a/fs/fs-writeback.c~linux-next-git-rejects
+++ a/fs/fs-writeback.c
@@ -89,7 +89,8 @@ static inline struct inode *wb_inode(str
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
-<<<<<<< HEAD
+EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepage);
+
 static void bdi_wakeup_thread(struct backing_dev_info *bdi)
 {
 	spin_lock_bh(&bdi->wb_lock);
@@ -97,9 +98,6 @@ static void bdi_wakeup_thread(struct bac
 		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
 	spin_unlock_bh(&bdi->wb_lock);
 }
-=======
-EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepage);
->>>>>>> linux-next/akpm-base
 
 static void bdi_queue_work(struct backing_dev_info *bdi,
 			   struct wb_writeback_work *work)
diff -puN kernel/seccomp.c~linux-next-git-rejects kernel/seccomp.c
--- a/kernel/seccomp.c~linux-next-git-rejects
+++ a/kernel/seccomp.c
@@ -71,11 +71,7 @@ static void populate_seccomp_data(struct
 	struct pt_regs *regs = task_pt_regs(task);
 
 	sd->nr = syscall_get_nr(task, regs);
-<<<<<<< HEAD
-	sd->arch = syscall_get_arch(task, regs);
-=======
 	sd->arch = syscall_get_arch();
->>>>>>> linux-next/akpm-base
 
 	/* Unroll syscall_get_args to help gcc on arm. */
 	syscall_get_arguments(task, regs, 0, 1, (unsigned long *) &sd->args[0]);
diff -puN net/bluetooth/hci_conn.c~linux-next-git-rejects net/bluetooth/hci_conn.c
--- a/net/bluetooth/hci_conn.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_conn.c
@@ -367,11 +367,6 @@ static void le_conn_timeout(struct work_
 {
 	struct hci_conn *conn = container_of(work, struct hci_conn,
 					     le_conn_timeout.work);
-<<<<<<< HEAD
-
-	BT_DBG("");
-
-=======
 	struct hci_dev *hdev = conn->hdev;
 
 	BT_DBG("");
@@ -389,7 +384,6 @@ static void le_conn_timeout(struct work_
 		return;
 	}
 
->>>>>>> linux-next/akpm-base
 	hci_le_create_connection_cancel(conn);
 }
 
@@ -569,14 +563,11 @@ void hci_le_conn_failed(struct hci_conn
 	 * favor of connection establishment, we should restart it.
 	 */
 	hci_update_background_scan(hdev);
-<<<<<<< HEAD
-=======
 
 	/* Re-enable advertising in case this was a failed connection
 	 * attempt as a peripheral.
 	 */
 	mgmt_reenable_advertising(hdev);
->>>>>>> linux-next/akpm-base
 }
 
 static void create_le_conn_complete(struct hci_dev *hdev, u8 status)
@@ -635,8 +626,6 @@ static void hci_req_add_le_create_conn(s
 	hci_req_add(req, HCI_OP_LE_CREATE_CONN, sizeof(cp), &cp);
 
 	conn->state = BT_CONNECT;
-<<<<<<< HEAD
-=======
 }
 
 static void hci_req_directed_advertising(struct hci_request *req,
@@ -676,7 +665,6 @@ static void hci_req_directed_advertising
 	hci_req_add(req, HCI_OP_LE_SET_ADV_ENABLE, sizeof(enable), &enable);
 
 	conn->state = BT_CONNECT;
->>>>>>> linux-next/akpm-base
 }
 
 struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
@@ -735,8 +723,6 @@ struct hci_conn *hci_connect_le(struct h
 		return ERR_PTR(-ENOMEM);
 
 	conn->dst_type = dst_type;
-<<<<<<< HEAD
-=======
 	conn->sec_level = BT_SECURITY_LOW;
 	conn->pending_sec_level = sec_level;
 	conn->auth_type = auth_type;
@@ -747,7 +733,6 @@ struct hci_conn *hci_connect_le(struct h
 		hci_req_directed_advertising(&req, conn);
 		goto create_conn;
 	}
->>>>>>> linux-next/akpm-base
 
 	conn->out = true;
 	conn->link_mode |= HCI_LM_MASTER;
@@ -761,11 +746,6 @@ struct hci_conn *hci_connect_le(struct h
 		conn->le_conn_max_interval = hdev->le_conn_max_interval;
 	}
 
-<<<<<<< HEAD
-	hci_req_init(&req, hdev);
-
-=======
->>>>>>> linux-next/akpm-base
 	/* If controller is scanning, we stop it since some controllers are
 	 * not able to scan and connect at the same time. Also set the
 	 * HCI_LE_SCAN_INTERRUPTED flag so that the command complete
@@ -779,10 +759,7 @@ struct hci_conn *hci_connect_le(struct h
 
 	hci_req_add_le_create_conn(&req, conn);
 
-<<<<<<< HEAD
-=======
 create_conn:
->>>>>>> linux-next/akpm-base
 	err = hci_req_run(&req, create_le_conn_complete);
 	if (err) {
 		hci_conn_del(conn);
diff -puN net/bluetooth/hci_event.c~linux-next-git-rejects net/bluetooth/hci_event.c
--- a/net/bluetooth/hci_event.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_event.c
@@ -996,29 +996,6 @@ static void hci_cc_le_set_adv_enable(str
 
 	hci_dev_lock(hdev);
 
-<<<<<<< HEAD
-	if (!status)
-		mgmt_advertising(hdev, *sent);
-
-	hci_dev_unlock(hdev);
-}
-
-static void hci_cc_le_set_scan_param(struct hci_dev *hdev, struct sk_buff *skb)
-{
-	struct hci_cp_le_set_scan_param *cp;
-	__u8 status = *((__u8 *) skb->data);
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, status);
-
-	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_SCAN_PARAM);
-	if (!cp)
-		return;
-
-	hci_dev_lock(hdev);
-
-	if (!status)
-		hdev->le_scan_type = cp->type;
-=======
 	/* If we're doing connection initation as peripheral. Set a
 	 * timeout in case something goes wrong.
 	 */
@@ -1031,7 +1008,6 @@ static void hci_cc_le_set_scan_param(str
 					   &conn->le_conn_timeout,
 					   HCI_LE_CONN_TIMEOUT);
 	}
->>>>>>> linux-next/akpm-base
 
 	mgmt_advertising(hdev, *sent);
 
@@ -1107,8 +1083,6 @@ static void hci_cc_le_set_scan_enable(st
 		break;
 
 	case LE_SCAN_DISABLE:
-<<<<<<< HEAD
-=======
 		/* We do this here instead of when setting DISCOVERY_STOPPED
 		 * since the latter would potentially require waiting for
 		 * inquiry to stop too.
@@ -1123,7 +1097,6 @@ static void hci_cc_le_set_scan_enable(st
 					  d->last_adv_data_len, NULL, 0);
 		}
 
->>>>>>> linux-next/akpm-base
 		/* Cancel this timer so that we don't try to disable scanning
 		 * when it's already disabled.
 		 */
@@ -2306,7 +2279,6 @@ static void hci_encrypt_change_evt(struc
 			clear_bit(HCI_CONN_AES_CCM, &conn->flags);
 		}
 	}
-<<<<<<< HEAD
 
 	clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
 
@@ -2316,17 +2288,6 @@ static void hci_encrypt_change_evt(struc
 		goto unlock;
 	}
 
-=======
-
-	clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-
-	if (ev->status && conn->state == BT_CONNECTED) {
-		hci_disconnect(conn, HCI_ERROR_AUTH_FAILURE);
-		hci_conn_drop(conn);
-		goto unlock;
-	}
-
->>>>>>> linux-next/akpm-base
 	if (conn->state == BT_CONFIG) {
 		if (!ev->status)
 			conn->state = BT_CONNECTED;
@@ -3773,21 +3734,12 @@ static void hci_remote_oob_data_request_
 				     sizeof(cp), &cp);
 		} else {
 			struct hci_cp_remote_oob_data_reply cp;
-<<<<<<< HEAD
 
 			bacpy(&cp.bdaddr, &ev->bdaddr);
 			memcpy(cp.hash, data->hash192, sizeof(cp.hash));
 			memcpy(cp.randomizer, data->randomizer192,
 			       sizeof(cp.randomizer));
 
-=======
-
-			bacpy(&cp.bdaddr, &ev->bdaddr);
-			memcpy(cp.hash, data->hash192, sizeof(cp.hash));
-			memcpy(cp.randomizer, data->randomizer192,
-			       sizeof(cp.randomizer));
-
->>>>>>> linux-next/akpm-base
 			hci_send_cmd(hdev, HCI_OP_REMOTE_OOB_DATA_REPLY,
 				     sizeof(cp), &cp);
 		}
@@ -3970,32 +3922,11 @@ static void hci_le_conn_complete_evt(str
 							  &conn->init_addr,
 							  &conn->init_addr_type);
 			}
-<<<<<<< HEAD
-		} else {
-			/* Set the responder (our side) address type based on
-			 * the advertising address type.
-			 */
-			conn->resp_addr_type = hdev->adv_addr_type;
-			if (hdev->adv_addr_type == ADDR_LE_DEV_RANDOM)
-				bacpy(&conn->resp_addr, &hdev->random_addr);
-			else
-				bacpy(&conn->resp_addr, &hdev->bdaddr);
-
-			conn->init_addr_type = ev->bdaddr_type;
-			bacpy(&conn->init_addr, &ev->bdaddr);
-=======
->>>>>>> linux-next/akpm-base
 		}
 	} else {
 		cancel_delayed_work(&conn->le_conn_timeout);
 	}
 
-<<<<<<< HEAD
-	/* Ensure that the hci_conn contains the identity address type
-	 * regardless of which address the connection was made with.
-	 */
-	hci_copy_identity_address(hdev, &conn->src, &conn->src_type);
-=======
 	if (!conn->out) {
 		/* Set the responder (our side) address type based on
 		 * the advertising address type.
@@ -4009,7 +3940,6 @@ static void hci_le_conn_complete_evt(str
 		conn->init_addr_type = ev->bdaddr_type;
 		bacpy(&conn->init_addr, &ev->bdaddr);
 	}
->>>>>>> linux-next/akpm-base
 
 	/* Lookup the identity address from the stored connection
 	 * address and address type.
@@ -4089,8 +4019,6 @@ static void check_pending_le_conn(struct
 	}
 }
 
-<<<<<<< HEAD
-=======
 static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 			       u8 bdaddr_type, s8 rssi, u8 *data, u8 len)
 {
@@ -4168,7 +4096,6 @@ static void process_adv_report(struct hc
 	clear_pending_adv_report(hdev);
 }
 
->>>>>>> linux-next/akpm-base
 static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	u8 num_reports = skb->data[0];
diff -puN net/bluetooth/mgmt.c~linux-next-git-rejects net/bluetooth/mgmt.c
--- a/net/bluetooth/mgmt.c~linux-next-git-rejects
+++ a/net/bluetooth/mgmt.c
@@ -2681,7 +2681,7 @@ static int pin_code_reply(struct sock *s
 		goto failed;
 	}
 
-	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &cp->addr.bdaddr);
+	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &cp->addr.bdaddr);q
 	if (!conn) {
 		err = cmd_status(sk, hdev->id, MGMT_OP_PIN_CODE_REPLY,
 				 MGMT_STATUS_NOT_CONNECTED);
@@ -5648,37 +5648,21 @@ void mgmt_read_local_oob_data_complete(s
 			memcpy(rp.hash192, hash192, sizeof(rp.hash192));
 			memcpy(rp.randomizer192, randomizer192,
 			       sizeof(rp.randomizer192));
-<<<<<<< HEAD
 
 			memcpy(rp.hash256, hash256, sizeof(rp.hash256));
 			memcpy(rp.randomizer256, randomizer256,
 			       sizeof(rp.randomizer256));
 
-=======
-
-			memcpy(rp.hash256, hash256, sizeof(rp.hash256));
-			memcpy(rp.randomizer256, randomizer256,
-			       sizeof(rp.randomizer256));
-
->>>>>>> linux-next/akpm-base
 			cmd_complete(cmd->sk, hdev->id,
 				     MGMT_OP_READ_LOCAL_OOB_DATA, 0,
 				     &rp, sizeof(rp));
 		} else {
 			struct mgmt_rp_read_local_oob_data rp;
-<<<<<<< HEAD
-
-			memcpy(rp.hash, hash192, sizeof(rp.hash));
-			memcpy(rp.randomizer, randomizer192,
-			       sizeof(rp.randomizer));
-
-=======
 
 			memcpy(rp.hash, hash192, sizeof(rp.hash));
 			memcpy(rp.randomizer, randomizer192,
 			       sizeof(rp.randomizer));
 
->>>>>>> linux-next/akpm-base
 			cmd_complete(cmd->sk, hdev->id,
 				     MGMT_OP_READ_LOCAL_OOB_DATA, 0,
 				     &rp, sizeof(rp));
diff -puN net/core/flow.c~linux-next-git-rejects net/core/flow.c
--- a/net/core/flow.c~linux-next-git-rejects
+++ a/net/core/flow.c
@@ -52,7 +52,7 @@ static struct kmem_cache *flow_cachep __
 
 static void flow_cache_new_hashrnd(unsigned long arg)
 {
-	struct flow_cache *fc = (void *) arg;
+q	struct flow_cache *fc = (void *) arg;
 	int i;
 
 	for_each_possible_cpu(i)
@@ -498,7 +498,6 @@ void flow_cache_fini(struct net *net)
 
 	del_timer_sync(&fc->rnd_timer);
 	unregister_hotcpu_notifier(&fc->hotcpu_notifier);
-<<<<<<< HEAD
 
 	for_each_possible_cpu(i) {
 		struct flow_cache_percpu *fcp = per_cpu_ptr(fc->percpu, i);
@@ -506,15 +505,6 @@ void flow_cache_fini(struct net *net)
 		fcp->hash_table = NULL;
 	}
 
-=======
-
-	for_each_possible_cpu(i) {
-		struct flow_cache_percpu *fcp = per_cpu_ptr(fc->percpu, i);
-		kfree(fcp->hash_table);
-		fcp->hash_table = NULL;
-	}
-
->>>>>>> linux-next/akpm-base
 	free_percpu(fc->percpu);
 	fc->percpu = NULL;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch


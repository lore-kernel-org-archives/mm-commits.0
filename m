From: akpm@linux-foundation.org
Subject: + uwb-fix-all-printk-format-warnings.patch added to -mm tree
Date: Thu, 01 May 2008 14:56:14 -0700
Message-ID: <200805012156.m41LuEwk027365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758627AbYEAV4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 17:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     uwb: fix all printk format warnings
has been added to the -mm tree.  Its filename is
     uwb-fix-all-printk-format-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uwb: fix all printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix all UWB printk format warnings.  Compiled on i386 and x86_64.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/i1480/dfu/dfu.c       |    4 ++--
 drivers/uwb/i1480/dfu/mac.c       |   10 +++++-----
 drivers/uwb/i1480/dfu/usb.c       |    8 ++++----
 drivers/uwb/i1480/i1480u-wlp/rx.c |    4 ++--
 drivers/uwb/i1480/i1480u-wlp/tx.c |   16 ++++++++--------
 5 files changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/uwb/i1480/dfu/dfu.c~uwb-fix-all-printk-format-warnings drivers/uwb/i1480/dfu/dfu.c
--- a/drivers/uwb/i1480/dfu/dfu.c~uwb-fix-all-printk-format-warnings
+++ a/drivers/uwb/i1480/dfu/dfu.c
@@ -106,7 +106,7 @@ ssize_t i1480_cmd(struct i1480* i1480, c
 		goto error;
 	result = i1480->evt_result;
 	if (result < 0) {
-		dev_err(i1480->dev, "%s: command reply reception failed: %d\n",
+		dev_err(i1480->dev, "%s: command reply reception failed: %zd\n",
 			cmd_name, result);
 		goto error;
 	}
@@ -120,7 +120,7 @@ ssize_t i1480_cmd(struct i1480* i1480, c
 	result = i1480_rceb_check(i1480, i1480->evt_buf, cmd_name, context,
 				  expected_type, expected_event);
 error:
-	d_fnend(3, i1480->dev, "(%p, %s, %zu) = %d\n",
+	d_fnend(3, i1480->dev, "(%p, %s, %zu) = %zd\n",
 		i1480, cmd_name, cmd_size, result);
 	return result;
 }
diff -puN drivers/uwb/i1480/dfu/mac.c~uwb-fix-all-printk-format-warnings drivers/uwb/i1480/dfu/mac.c
--- a/drivers/uwb/i1480/dfu/mac.c~uwb-fix-all-printk-format-warnings
+++ a/drivers/uwb/i1480/dfu/mac.c
@@ -180,13 +180,13 @@ ssize_t i1480_fw_cmp(struct i1480 *i1480
 		result = i1480->read(i1480, hdr->address + src_itr, chunk_size);
 		if (result < 0) {
 			dev_err(i1480->dev, "error reading for verification: "
-				"%d\n", result);
+				"%zd\n", result);
 			goto error;
 		}
 		if (memcmp(i1480->cmd_buf, bin + src_itr, result)) {
 			u8 *buf = i1480->cmd_buf;
 			d_printf(2, i1480->dev,
-				 "original data @ %p + %zu, %zu bytes\n",
+				 "original data @ %p + %u, %zd bytes\n",
 				 bin, src_itr, result);
 			d_dump(4, i1480->dev, bin + src_itr, result);
 			for (cnt = 0; cnt < result; cnt++)
@@ -237,7 +237,7 @@ int mac_fw_hdrs_push(struct i1480 *i1480
 				    hdr_itr->length*sizeof(hdr_itr->bin[0]));
 		if (result < 0) {
 			dev_err(dev, "%s fw '%s': write failed (%zuB @ 0x%lx):"
-				" %d\n", fw_tag, fw_name,
+				" %zd\n", fw_tag, fw_name,
 				hdr_itr->length * sizeof(hdr_itr->bin[0]),
 				hdr_itr->address, result);
 			break;
@@ -245,7 +245,7 @@ int mac_fw_hdrs_push(struct i1480 *i1480
 		result = i1480_fw_cmp(i1480, hdr_itr);
 		if (result < 0) {
 			dev_err(dev, "%s fw '%s': verification read "
-				"failed (%zuB @ 0x%lx): %d\n",
+				"failed (%zuB @ 0x%lx): %zd\n",
 				fw_tag, fw_name,
 				hdr_itr->length * sizeof(hdr_itr->bin[0]),
 				hdr_itr->address, result);
@@ -265,7 +265,7 @@ int mac_fw_hdrs_push(struct i1480 *i1480
 			break;
 		}
 	}
-	d_fnend(3, dev, "(%d)\n", result);
+	d_fnend(3, dev, "(%zd)\n", result);
 	return result;
 }
 
diff -puN drivers/uwb/i1480/dfu/usb.c~uwb-fix-all-printk-format-warnings drivers/uwb/i1480/dfu/usb.c
--- a/drivers/uwb/i1480/dfu/usb.c~uwb-fix-all-printk-format-warnings
+++ a/drivers/uwb/i1480/dfu/usb.c
@@ -134,7 +134,7 @@ int i1480_usb_write(struct i1480* i1480,
 		if (result < 0)
 			break;
 		d_printf(3, i1480->dev,
-			 "wrote @ 0x%08x %zu bytes (of %zu bytes requested)\n",
+			 "wrote @ 0x%08x %u bytes (of %zd bytes requested)\n",
 			 memory_address, result, buffer_size);
 		d_dump(4, i1480->dev, i1480->cmd_buf, result);
 		itr += result;
@@ -187,7 +187,7 @@ ssize_t i1480_usb_read(struct i1480* i14
 			i1480->cmd_buf + itr, itr_size,
 			100 /* FIXME: arbitrary */);
 		if (result < 0) {
-			dev_err(i1480->dev, "%s: USB read error: %d\n",
+			dev_err(i1480->dev, "%s: USB read error: %zd\n",
 				__func__, result);
 			goto out;
 		}
@@ -349,14 +349,14 @@ int i1480_usb_cmd(struct i1480* i1480, c
 			cmd_name, result);
 		goto error_submit_ep0;
 	}
-	d_fnend(3, dev, "(%p, %s, %zu) = %zd\n",
+	d_fnend(3, dev, "(%p, %s, %zu) = %d\n",
 		i1480, cmd_name, cmd_size, result);
 	return result;
 
 error_submit_ep0:
 	usb_kill_urb(i1480_usb->neep_urb);
 error_submit_ep1:
-	d_fnend(3, dev, "(%p, %s, %zu) = %zd\n",
+	d_fnend(3, dev, "(%p, %s, %zu) = %d\n",
 		i1480, cmd_name, cmd_size, result);
 	return result;
 }
diff -puN drivers/uwb/i1480/i1480u-wlp/rx.c~uwb-fix-all-printk-format-warnings drivers/uwb/i1480/i1480u-wlp/rx.c
--- a/drivers/uwb/i1480/i1480u-wlp/rx.c~uwb-fix-all-printk-format-warnings
+++ a/drivers/uwb/i1480/i1480u-wlp/rx.c
@@ -193,7 +193,7 @@ void i1480u_skb_deliver(struct i1480u *i
 	struct net_device *net_dev = i1480u->net_dev;
 	struct device *dev = &i1480u->usb_iface->dev;
 
-	d_printf(6, dev, "RX delivered pre skb(%p), %zu bytes\n",
+	d_printf(6, dev, "RX delivered pre skb(%p), %u bytes\n",
 		 i1480u->rx_skb, i1480u->rx_skb->len);
 	d_dump(7, dev, i1480u->rx_skb->data, i1480u->rx_skb->len);
 	should_parse = wlp_receive_frame(dev, &i1480u->wlp, i1480u->rx_skb,
@@ -201,7 +201,7 @@ void i1480u_skb_deliver(struct i1480u *i
 	if (!should_parse)
 		goto out;
 	i1480u->rx_skb->protocol = eth_type_trans(i1480u->rx_skb, net_dev);
-	d_printf(5, dev, "RX delivered skb(%p), %zu bytes\n",
+	d_printf(5, dev, "RX delivered skb(%p), %u bytes\n",
 		 i1480u->rx_skb, i1480u->rx_skb->len);
 	d_dump(7, dev, i1480u->rx_skb->data,
 	       i1480u->rx_skb->len > 72? 72 : i1480u->rx_skb->len);
diff -puN drivers/uwb/i1480/i1480u-wlp/tx.c~uwb-fix-all-printk-format-warnings drivers/uwb/i1480/i1480u-wlp/tx.c
--- a/drivers/uwb/i1480/i1480u-wlp/tx.c~uwb-fix-all-printk-format-warnings
+++ a/drivers/uwb/i1480/i1480u-wlp/tx.c
@@ -301,8 +301,8 @@ int i1480u_tx_create_n(struct i1480u_tx 
 
 error_bug:
 	printk(KERN_ERR
-	       "BUG: skb %zu bytes\n"
-	       "BUG: frg_pl_size %zd i1480u_MAX_FRG_SIZE %zu\n"
+	       "BUG: skb %u bytes\n"
+	       "BUG: frg_pl_size %zd i1480u_MAX_FRG_SIZE %u\n"
 	       "BUG: buf_itr %zu buf_size %zu pl_size_left %zu\n",
 	       skb->len,
 	       frg_pl_size, i1480u_MAX_FRG_SIZE,
@@ -460,7 +460,7 @@ int i1480u_xmit_frame(struct wlp *wlp, s
 	int lockup = 50;
 #endif
 
-	d_fnstart(6, dev, "(skb %p (%zu), net_dev %p)\n", skb, skb->len,
+	d_fnstart(6, dev, "(skb %p (%u), net_dev %p)\n", skb, skb->len,
 		  net_dev);
 	BUG_ON(i1480u->wlp.rc == NULL);
 	if ((net_dev->flags & IFF_UP) == 0)
@@ -522,7 +522,7 @@ int i1480u_xmit_frame(struct wlp *wlp, s
 	}
 	atomic_inc(&i1480u->tx_inflight.count);
 	net_dev->trans_start = jiffies;
-	d_fnend(6, dev, "(skb %p (%zu), net_dev %p) = %d\n", skb, skb->len,
+	d_fnend(6, dev, "(skb %p (%u), net_dev %p) = %d\n", skb, skb->len,
 		net_dev, result);
 	return result;
 
@@ -531,7 +531,7 @@ error_tx_urb_submit:
 error_wtx_alloc:
 error_max_inflight:
 out:
-	d_fnend(6, dev, "(skb %p (%zu), net_dev %p) = %d\n", skb, skb->len,
+	d_fnend(6, dev, "(skb %p (%u), net_dev %p) = %d\n", skb, skb->len,
 		net_dev, result);
 	return result;
 }
@@ -560,7 +560,7 @@ int i1480u_hard_start_xmit(struct sk_buf
 	struct device *dev = &i1480u->usb_iface->dev;
 	struct uwb_dev_addr dst;
 
-	d_fnstart(6, dev, "(skb %p (%zu), net_dev %p)\n", skb, skb->len,
+	d_fnstart(6, dev, "(skb %p (%u), net_dev %p)\n", skb, skb->len,
 		  net_dev);
 	BUG_ON(i1480u->wlp.rc == NULL);
 	if ((net_dev->flags & IFF_UP) == 0)
@@ -582,14 +582,14 @@ int i1480u_hard_start_xmit(struct sk_buf
 		dev_err(dev, "Frame TX failed (%d).\n", result);
 		goto error;
 	}
-	d_fnend(6, dev, "(skb %p (%zu), net_dev %p) = %d\n", skb, skb->len,
+	d_fnend(6, dev, "(skb %p (%u), net_dev %p) = %d\n", skb, skb->len,
 		net_dev, result);
 	return NETDEV_TX_OK;
 error:
 	dev_kfree_skb_any(skb);
 	i1480u->stats.tx_dropped++;
 out:
-	d_fnend(6, dev, "(skb %p (%zu), net_dev %p) = %d\n", skb, skb->len,
+	d_fnend(6, dev, "(skb %p (%u), net_dev %p) = %d\n", skb, skb->len,
 		net_dev, result);
 	return NETDEV_TX_OK;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
pnp-fix-printk-format-warnings.patch
x86-fix-setup-printk-format-warning.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-sched.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
uwb-fix-all-printk-format-warnings.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch


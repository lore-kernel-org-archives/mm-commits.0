From: akpm@linux-foundation.org
Subject: + wireless-replace-__function__-with-__func__.patch added to -mm tree
Date: Tue, 29 Jul 2008 16:42:53 -0700
Message-ID: <200807292342.m6TNgrov028259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869AbYG2Xo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 19:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com


The patch titled
     wireless: replace __FUNCTION__ with __func__
has been added to the -mm tree.  Its filename is
     wireless-replace-__function__-with-__func__.patch

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
Subject: wireless: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c                   |   16 ++++++++--------
 drivers/net/wireless/hermes.c                 |    2 +-
 drivers/net/wireless/ipw2100.c                |    2 +-
 drivers/net/wireless/ipw2200.h                |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c   |    4 ++--
 drivers/net/wireless/libertas/if_cs.c         |    2 +-
 drivers/net/wireless/prism54/isl_ioctl.c      |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00.h          |    4 ++--
 drivers/net/wireless/wl3501_cs.c              |    8 ++++----
 12 files changed, 31 insertions(+), 31 deletions(-)

diff -puN drivers/net/wireless/airo.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/airo.c
@@ -1915,7 +1915,7 @@ static int mpi_start_xmit(struct sk_buff
 	struct airo_info *ai = dev->priv;
 
 	if (!skb) {
-		airo_print_err(dev->name, "%s: skb == NULL!",__FUNCTION__);
+		airo_print_err(dev->name, "%s: skb == NULL!",__func__);
 		return 0;
 	}
 	npacks = skb_queue_len (&ai->txq);
@@ -1964,7 +1964,7 @@ static int mpi_send_packet (struct net_d
 	if ((skb = skb_dequeue(&ai->txq)) == NULL) {
 		airo_print_err(dev->name,
 			"%s: Dequeue'd zero in send_packet()",
-			__FUNCTION__);
+			__func__);
 		return 0;
 	}
 
@@ -2115,7 +2115,7 @@ static int airo_start_xmit(struct sk_buf
 	u32 *fids = priv->fids;
 
 	if ( skb == NULL ) {
-		airo_print_err(dev->name, "%s: skb == NULL!", __FUNCTION__);
+		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return 0;
 	}
 
@@ -2186,7 +2186,7 @@ static int airo_start_xmit11(struct sk_b
 	}
 
 	if ( skb == NULL ) {
-		airo_print_err(dev->name, "%s: skb == NULL!", __FUNCTION__);
+		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return 0;
 	}
 
@@ -4127,7 +4127,7 @@ static int PC4500_writerid(struct airo_i
 		if (test_bit(FLAG_ENABLED, &ai->flags) && (RID_WEP_TEMP != rid))
 			airo_print_err(ai->dev->name,
 				"%s: MAC should be disabled (rid=%04x)",
-				__FUNCTION__, rid);
+				__func__, rid);
 		memset(&cmd, 0, sizeof(cmd));
 		memset(&rsp, 0, sizeof(rsp));
 
@@ -4142,7 +4142,7 @@ static int PC4500_writerid(struct airo_i
 			&ai->config_desc.rid_desc, sizeof(Rid));
 
 		if (len < 4 || len > 2047) {
-			airo_print_err(ai->dev->name, "%s: len=%d", __FUNCTION__, len);
+			airo_print_err(ai->dev->name, "%s: len=%d", __func__, len);
 			rc = -1;
 		} else {
 			memcpy((char *)ai->config_desc.virtual_host_addr,
@@ -4151,9 +4151,9 @@ static int PC4500_writerid(struct airo_i
 			rc = issuecommand(ai, &cmd, &rsp);
 			if ((rc & 0xff00) != 0) {
 				airo_print_err(ai->dev->name, "%s: Write rid Error %d",
-						__FUNCTION__, rc);
+						__func__, rc);
 				airo_print_err(ai->dev->name, "%s: Cmd=%04x",
-						__FUNCTION__, cmd.cmd);
+						__func__, cmd.cmd);
 			}
 
 			if ((rsp.status & 0x7f00))
diff -puN drivers/net/wireless/hermes.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/hermes.c
--- a/drivers/net/wireless/hermes.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/hermes.c
@@ -463,7 +463,7 @@ int hermes_read_ltv(hermes_t *hw, int ba
 	if (rtype != rid)
 		printk(KERN_WARNING "hermes @ %p: %s(): "
 		       "rid (0x%04x) does not match type (0x%04x)\n",
-		       hw->iobase, __FUNCTION__, rid, rtype);
+		       hw->iobase, __func__, rid, rtype);
 	if (HERMES_RECLEN_TO_BYTES(rlength) > bufsize)
 		printk(KERN_WARNING "hermes @ %p: "
 		       "Truncating LTV record from %d to %d bytes. "
diff -puN drivers/net/wireless/ipw2100.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/ipw2100.c
@@ -212,7 +212,7 @@ static u32 ipw2100_debug_level = IPW_DL_
 do { \
 	if (ipw2100_debug_level & (level)) { \
 		printk(KERN_DEBUG "ipw2100: %c %s ", \
-                       in_interrupt() ? 'I' : 'U',  __FUNCTION__); \
+                       in_interrupt() ? 'I' : 'U',  __func__); \
 		printk(message); \
 	} \
 } while (0)
diff -puN drivers/net/wireless/ipw2200.h~wireless-replace-__function__-with-__func__ drivers/net/wireless/ipw2200.h
--- a/drivers/net/wireless/ipw2200.h~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/ipw2200.h
@@ -1394,13 +1394,13 @@ BIT_ARG16(x)
 #define IPW_DEBUG(level, fmt, args...) \
 do { if (ipw_debug_level & (level)) \
   printk(KERN_DEBUG DRV_NAME": %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #ifdef CONFIG_IPW2200_DEBUG
 #define IPW_LL_DEBUG(level, fmt, args...) \
 do { if (ipw_debug_level & (level)) \
   printk(KERN_DEBUG DRV_NAME": %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 #else
 #define IPW_LL_DEBUG(level, fmt, args...) do {} while (0)
 #endif				/* CONFIG_IPW2200_DEBUG */
diff -puN drivers/net/wireless/iwlwifi/iwl-3945-debug.h~wireless-replace-__function__-with-__func__ drivers/net/wireless/iwlwifi/iwl-3945-debug.h
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
@@ -34,12 +34,12 @@ extern u32 iwl3945_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (iwl3945_debug_level & (level)) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #define IWL_DEBUG_LIMIT(level, fmt, args...) \
 do { if ((iwl3945_debug_level & (level)) && net_ratelimit()) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 static inline void iwl3945_print_hex_dump(int level, void *p, u32 len)
 {
diff -puN drivers/net/wireless/iwlwifi/iwl-debug.h~wireless-replace-__function__-with-__func__ drivers/net/wireless/iwlwifi/iwl-debug.h
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -33,12 +33,12 @@
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (priv->debug_level & (level)) \
   dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #define IWL_DEBUG_LIMIT(level, fmt, args...) \
 do { if ((priv->debug_level & (level)) && net_ratelimit()) \
   dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 struct iwl_debugfs {
diff -puN drivers/net/wireless/iwlwifi/iwl3945-base.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/iwlwifi/iwl3945-base.c
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6336,7 +6336,7 @@ static void iwl3945_bg_post_associate(st
 	DECLARE_MAC_BUF(mac);
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __FUNCTION__);
+		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -6417,7 +6417,7 @@ static void iwl3945_bg_post_associate(st
 
 	default:
 		 IWL_ERROR("%s Should not be called in %d mode\n",
-			   __FUNCTION__, priv->iw_mode);
+			   __func__, priv->iw_mode);
 		break;
 	}
 
diff -puN drivers/net/wireless/iwlwifi/iwl4965-base.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/iwlwifi/iwl4965-base.c
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2415,7 +2415,7 @@ static void iwl4965_post_associate(struc
 	unsigned long flags;
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __FUNCTION__);
+		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -2491,7 +2491,7 @@ static void iwl4965_post_associate(struc
 
 	default:
 		IWL_ERROR("%s Should not be called in %d mode\n",
-				__FUNCTION__, priv->iw_mode);
+				__func__, priv->iw_mode);
 		break;
 	}
 
diff -puN drivers/net/wireless/libertas/if_cs.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/libertas/if_cs.c
--- a/drivers/net/wireless/libertas/if_cs.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/libertas/if_cs.c
@@ -720,7 +720,7 @@ static int if_cs_host_to_card(struct lbs
 		ret = if_cs_send_cmd(priv, buf, nb);
 		break;
 	default:
-		lbs_pr_err("%s: unsupported type %d\n", __FUNCTION__, type);
+		lbs_pr_err("%s: unsupported type %d\n", __func__, type);
 	}
 
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
diff -puN drivers/net/wireless/prism54/isl_ioctl.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -71,7 +71,7 @@ prism54_mib_mode_helper(islpci_private *
 	if (iw_mode == IW_MODE_REPEAT || iw_mode == IW_MODE_SECOND) {
 		printk(KERN_DEBUG
 		       "%s(): Sorry, Repeater mode and Secondary mode "
-		       "are not yet supported by this driver.\n", __FUNCTION__);
+		       "are not yet supported by this driver.\n", __func__);
 		return -EINVAL;
 	}
 
@@ -333,7 +333,7 @@ prism54_set_mode(struct net_device *ndev
 	if (*uwrq > IW_MODE_MONITOR || *uwrq < IW_MODE_AUTO) {
 		printk(KERN_DEBUG
 		       "%s: %s() You passed a non-valid init_mode.\n",
-		       priv->ndev->name, __FUNCTION__);
+		       priv->ndev->name, __func__);
 		return -EINVAL;
 	}
 
@@ -1234,7 +1234,7 @@ prism54_set_txpower(struct net_device *n
 		/* don't know how to disable radio */
 		printk(KERN_DEBUG
 		       "%s: %s() disabling radio is not yet supported.\n",
-		       priv->ndev->name, __FUNCTION__);
+		       priv->ndev->name, __func__);
 		return -ENOTSUPP;
 	} else if (vwrq->fixed)
 		/* currently only fixed value is supported */
@@ -1242,7 +1242,7 @@ prism54_set_txpower(struct net_device *n
 	else {
 		printk(KERN_DEBUG
 		       "%s: %s() auto power will be implemented later.\n",
-		       priv->ndev->name, __FUNCTION__);
+		       priv->ndev->name, __func__);
 		return -ENOTSUPP;
 	}
 }
diff -puN drivers/net/wireless/rt2x00/rt2x00.h~wireless-replace-__function__-with-__func__ drivers/net/wireless/rt2x00/rt2x00.h
--- a/drivers/net/wireless/rt2x00/rt2x00.h~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/rt2x00/rt2x00.h
@@ -53,11 +53,11 @@
  */
 #define DEBUG_PRINTK_MSG(__dev, __kernlvl, __lvl, __msg, __args...)	\
 	printk(__kernlvl "%s -> %s: %s - " __msg,			\
-	       wiphy_name((__dev)->hw->wiphy), __FUNCTION__, __lvl, ##__args)
+	       wiphy_name((__dev)->hw->wiphy), __func__, __lvl, ##__args)
 
 #define DEBUG_PRINTK_PROBE(__kernlvl, __lvl, __msg, __args...)	\
 	printk(__kernlvl "%s -> %s: %s - " __msg,		\
-	       KBUILD_MODNAME, __FUNCTION__, __lvl, ##__args)
+	       KBUILD_MODNAME, __func__, __lvl, ##__args)
 
 #ifdef CONFIG_RT2X00_DEBUG
 #define DEBUG_PRINTK(__dev, __kernlvl, __lvl, __msg, __args...)	\
diff -puN drivers/net/wireless/wl3501_cs.c~wireless-replace-__function__-with-__func__ drivers/net/wireless/wl3501_cs.c
--- a/drivers/net/wireless/wl3501_cs.c~wireless-replace-__function__-with-__func__
+++ a/drivers/net/wireless/wl3501_cs.c
@@ -79,7 +79,7 @@ static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0);
 #define dprintk(n, format, args...) \
 	{ if (pc_debug > (n)) \
-		printk(KERN_INFO "%s: " format "\n", __FUNCTION__ , ##args); }
+		printk(KERN_INFO "%s: " format "\n", __func__ , ##args); }
 #else
 #define dprintk(n, format, args...)
 #endif
@@ -470,7 +470,7 @@ static int wl3501_pwr_mgmt(struct wl3501
 			spin_unlock_irqrestore(&this->lock, flags);
 			rc = wait_event_interruptible(this->wait,
 				this->sig_pwr_mgmt_confirm.status != 255);
-			printk(KERN_INFO "%s: %s status=%d\n", __FUNCTION__,
+			printk(KERN_INFO "%s: %s status=%d\n", __func__,
 			       suspend ? "suspend" : "resume",
 			       this->sig_pwr_mgmt_confirm.status);
 			goto out;
@@ -1199,7 +1199,7 @@ static int wl3501_reset_board(struct wl3
 		}
 		WL3501_NOPLOOP(10);
 	}
-	printk(KERN_WARNING "%s: failed to reset the board!\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: failed to reset the board!\n", __func__);
 	rc = -ENODEV;
 out:
 	return rc;
@@ -1250,7 +1250,7 @@ static int wl3501_init_firmware(struct w
 out:
 	return rc;
 fail:
-	printk(KERN_WARNING "%s: failed!\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: failed!\n", __func__);
 	goto out;
 }
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

omfs-sparse-annotations.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
irda-replace-__function__-with-__func__.patch
isdn-use-the-common-ascii-hex-helpers.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
drivers-net-replace-__function__-with-__func__.patch
media-drx397xd-replace-__function__-with-__func__.patch
include-replace-__function__-with-__func__.patch
powerpc-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch


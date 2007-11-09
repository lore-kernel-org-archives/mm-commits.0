From: akpm@linux-foundation.org
Subject: - tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:39 -0800
Message-ID: <200711091913.lA9JDdhX028045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbXKITRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     tty: fix tty network driver interactions with TCGET/TCSET calls
has been removed from the -mm tree.  Its filename was
     tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: fix tty network driver interactions with TCGET/TCSET calls
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We consciously make a change here - we permit mode and speed setting to be
done in things like SLIP mode.  There isn't actually a technical reason to
disallow this.  It's usually a silly thing to do but we can do it and soemone
might wish to do so.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/6pack.c |   26 ++++++++++----------------
 drivers/net/irda/irtty-sir.c |    7 +------
 drivers/net/ppp_async.c      |   10 +++-------
 drivers/net/ppp_synctty.c    |   10 +++-------
 drivers/net/slip.c           |    8 +-------
 drivers/net/wan/x25_asy.c    |    6 +-----
 drivers/net/wireless/strip.c |   10 +---------
 7 files changed, 20 insertions(+), 57 deletions(-)

diff -puN drivers/net/hamradio/6pack.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls
+++ a/drivers/net/hamradio/6pack.c
@@ -762,26 +762,20 @@ static int sixpack_ioctl(struct tty_stru
 
 		if (copy_from_user(&addr,
 		                   (void __user *) arg, AX25_ADDR_LEN)) {
-			err = -EFAULT;
-			break;
-		}
+				err = -EFAULT;
+				break;
+			}
 
-		netif_tx_lock_bh(dev);
-		memcpy(dev->dev_addr, &addr, AX25_ADDR_LEN);
-		netif_tx_unlock_bh(dev);
+			netif_tx_lock_bh(dev);
+			memcpy(dev->dev_addr, &addr, AX25_ADDR_LEN);
+			netif_tx_unlock_bh(dev);
 
-		err = 0;
-		break;
-	}
-
-	/* Allow stty to read, but not set, the serial port */
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, (struct file *) file, cmd, arg);
-		break;
+			err = 0;
+			break;
+		}
 
 	default:
-		err = -ENOIOCTLCMD;
+		err = tty_mode_ioctl(tty, file, cmd, arg);
 	}
 
 	sp_put(sp);
diff -puN drivers/net/irda/irtty-sir.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls drivers/net/irda/irtty-sir.c
--- a/drivers/net/irda/irtty-sir.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls
+++ a/drivers/net/irda/irtty-sir.c
@@ -434,11 +434,6 @@ static int irtty_ioctl(struct tty_struct
 	IRDA_ASSERT(dev != NULL, return -1;);
 
 	switch (cmd) {
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, file, cmd, arg);
-		break;
-
 	case IRTTY_IOCTDONGLE:
 		/* this call blocks for completion */
 		err = sirdev_set_dongle(dev, (IRDA_DONGLE) arg);
@@ -454,7 +449,7 @@ static int irtty_ioctl(struct tty_struct
 			err = -EFAULT;
 		break;
 	default:
-		err = -ENOIOCTLCMD;
+		err = tty_mode_ioctl(tty, file, cmd, arg);
 		break;
 	}
 	return err;
diff -puN drivers/net/ppp_async.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls drivers/net/ppp_async.c
--- a/drivers/net/ppp_async.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls
+++ a/drivers/net/ppp_async.c
@@ -309,16 +309,11 @@ ppp_asynctty_ioctl(struct tty_struct *tt
 		err = 0;
 		break;
 
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, file, cmd, arg);
-		break;
-
 	case TCFLSH:
 		/* flush our buffers and the serial port's buffer */
 		if (arg == TCIOFLUSH || arg == TCOFLUSH)
 			ppp_async_flush_output(ap);
-		err = n_tty_ioctl(tty, file, cmd, arg);
+		err = tty_perform_flush(tty, arg);
 		break;
 
 	case FIONREAD:
@@ -329,7 +324,8 @@ ppp_asynctty_ioctl(struct tty_struct *tt
 		break;
 
 	default:
-		err = -ENOIOCTLCMD;
+		/* Try the various mode ioctls */
+		err = tty_mode_ioctl(tty, file, cmd, arg);
 	}
 
 	ap_put(ap);
diff -puN drivers/net/ppp_synctty.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls drivers/net/ppp_synctty.c
--- a/drivers/net/ppp_synctty.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls
+++ a/drivers/net/ppp_synctty.c
@@ -349,16 +349,11 @@ ppp_synctty_ioctl(struct tty_struct *tty
 		err = 0;
 		break;
 
-	case TCGETS:
-	case TCGETA:
-		err = n_tty_ioctl(tty, file, cmd, arg);
-		break;
-
 	case TCFLSH:
 		/* flush our buffers and the serial port's buffer */
 		if (arg == TCIOFLUSH || arg == TCOFLUSH)
 			ppp_sync_flush_output(ap);
-		err = n_tty_ioctl(tty, file, cmd, arg);
+		err = tty_perform_flush(tty, arg);
 		break;
 
 	case FIONREAD:
@@ -369,7 +364,8 @@ ppp_synctty_ioctl(struct tty_struct *tty
 		break;
 
 	default:
-		err = -ENOIOCTLCMD;
+		err = tty_mode_ioctl(tty, file, cmd, arg);
+		break;
 	}
 
 	sp_put(ap);
diff -puN drivers/net/slip.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls drivers/net/slip.c
--- a/drivers/net/slip.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls
+++ a/drivers/net/slip.c
@@ -1218,14 +1218,8 @@ static int slip_ioctl(struct tty_struct 
 		return 0;
 	/* VSV changes end */
 #endif
-
-	/* Allow stty to read, but not set, the serial port */
-	case TCGETS:
-	case TCGETA:
-		return n_tty_ioctl(tty, file, cmd, arg);
-
 	default:
-		return -ENOIOCTLCMD;
+		return tty_mode_ioctl(tty, file, cmd, arg);
 	}
 }
 
diff -puN drivers/net/wan/x25_asy.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls drivers/net/wan/x25_asy.c
--- a/drivers/net/wan/x25_asy.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls
+++ a/drivers/net/wan/x25_asy.c
@@ -719,12 +719,8 @@ static int x25_asy_ioctl(struct tty_stru
 		return 0;
 	case SIOCSIFHWADDR:
 		return -EINVAL;
-	/* Allow stty to read, but not set, the serial port */
-	case TCGETS:
-	case TCGETA:
-		return n_tty_ioctl(tty, file, cmd, arg);
 	default:
-		return -ENOIOCTLCMD;
+		return tty_mode_ioctl(tty, file, cmd, arg);
 	}
 }
 
diff -puN drivers/net/wireless/strip.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls drivers/net/wireless/strip.c
--- a/drivers/net/wireless/strip.c~tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls
+++ a/drivers/net/wireless/strip.c
@@ -2735,16 +2735,8 @@ static int strip_ioctl(struct tty_struct
 			return -EFAULT;
 		return set_mac_address(strip_info, &addr);
 	}
-	/*
-	 * Allow stty to read, but not set, the serial port
-	 */
-
-	case TCGETS:
-	case TCGETA:
-		return n_tty_ioctl(tty, file, cmd, arg);
-		break;
 	default:
-		return -ENOIOCTLCMD;
+		return tty_mode_ioctl(tty, file, cmd, arg);
 		break;
 	}
 	return 0;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

frv-remove-bogus-no_irq-=-1-define.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
initio-fix-conflict-when-loading-driver.patch
serial-only-use-pnp-irq-if-its-valid.patch
keyspan-init-termios-properly.patch
tty-fix-network-driver-interactions-with-tcget-set-checkpatch-fixes.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch

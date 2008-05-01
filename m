From: akpm@linux-foundation.org
Subject: - esp-lock_kernel-push-down.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:50 -0700
Message-ID: <200805010927.m419RoOi030451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777AbYEAJ2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     esp: lock_kernel push down
has been removed from the -mm tree.  Its filename was
     esp-lock_kernel-push-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: esp: lock_kernel push down
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the BKL down into a few internal bits of code in this driver.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN drivers/char/esp.c~esp-lock_kernel-push-down drivers/char/esp.c
--- a/drivers/char/esp.c~esp-lock_kernel-push-down
+++ a/drivers/char/esp.c
@@ -1355,6 +1355,7 @@ static int get_serial_info(struct esp_st
 {
 	struct serial_struct tmp;
   
+	lock_kernel();
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.type = PORT_16550A;
 	tmp.line = info->line;
@@ -1367,6 +1368,7 @@ static int get_serial_info(struct esp_st
 	tmp.closing_wait = info->closing_wait;
 	tmp.custom_divisor = info->custom_divisor;
 	tmp.hub6 = 0;
+	unlock_kernel();
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -1381,6 +1383,7 @@ static int get_esp_config(struct esp_str
 		return -EFAULT;
 
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.rx_timeout = info->config.rx_timeout;
 	tmp.rx_trigger = info->config.rx_trigger;
 	tmp.tx_trigger = info->config.tx_trigger;
@@ -1388,6 +1391,7 @@ static int get_esp_config(struct esp_str
 	tmp.flow_on = info->config.flow_on;
 	tmp.pio_threshold = info->config.pio_threshold;
 	tmp.dma_channel = (info->stat_flags & ESP_STAT_NEVER_DMA ? 0 : dma);
+	unlock_kernel();
 
 	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
 }
@@ -1766,6 +1770,7 @@ static int rs_ioctl(struct tty_struct *t
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
+	int ret;
 
 	if (serial_paranoia_check(info, tty->name, "rs_ioctl"))
 		return -ENODEV;
@@ -1783,7 +1788,10 @@ static int rs_ioctl(struct tty_struct *t
 		case TIOCGSERIAL:
 			return get_serial_info(info, argp);
 		case TIOCSSERIAL:
-			return set_serial_info(info, argp);
+			lock_kernel();
+			ret = set_serial_info(info, argp);
+			unlock_kernel();
+			return ret;
 		case TIOCSERCONFIG:
 			/* do not reconfigure after initial configuration */
 			return 0;
@@ -1855,11 +1863,13 @@ static int rs_ioctl(struct tty_struct *t
 				return -EFAULT;
 
 			return 0;
-	case TIOCGHAYESESP:
-		return get_esp_config(info, argp);
-	case TIOCSHAYESESP:
-		return set_esp_config(info, argp);
-
+		case TIOCGHAYESESP:
+			return get_esp_config(info, argp);
+		case TIOCSHAYESESP:
+			lock_kernel();
+			ret = set_esp_config(info, argp);
+			unlock_kernel();
+			return ret;
 		default:
 			return -ENOIOCTLCMD;
 		}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch


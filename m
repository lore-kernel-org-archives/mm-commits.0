From: akpm@linux-foundation.org
Subject: + esp-lock_kernel-push-down.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:15 -0800
Message-ID: <200802230737.m1N7b4je018480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbYBWHyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     esp: lock_kernel push down
has been added to the -mm tree.  Its filename is
     esp-lock_kernel-push-down.patch

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
libata-isolate-and-rework-cable-logic.patch
pata_amd-fix-sparse-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
megaraid-outb_p-extermination.patch
usb-serial-prepare-for-bkl-push-down.patch
ftdi_sio-note-missing-locking.patch
usb-serial-note-mos7480-and-option-dont-lock-modem-status.patch
io_ti-lock-mcr-and-msr-shadows-properly.patch
iuu_phoenix-lock-priv-tiostatus-properly.patch
kobil_sct-get-rid-of-unneeded-priv-line_state.patch
ti_usb_3410_5052-extend-locking-to-msr-and-shadow-mcr.patch
git-watchdog.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
nozomi-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

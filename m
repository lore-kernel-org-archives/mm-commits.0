From: akpm@linux-foundation.org
Subject: + rocket-prepare-for-bkl-pushdown.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:27 -0800
Message-ID: <200802230737.m1N7bG1L018500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755023AbYBWHyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     rocket: Prepare for BKL pushdown
has been added to the -mm tree.  Its filename is
     rocket-prepare-for-bkl-pushdown.patch

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
Subject: rocket: Prepare for BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Wrap the ioctl code in lock_kernel calls

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN drivers/char/rocket.c~rocket-prepare-for-bkl-pushdown drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocket-prepare-for-bkl-pushdown
+++ a/drivers/char/rocket.c
@@ -1432,29 +1432,38 @@ static int rp_ioctl(struct tty_struct *t
 {
 	struct r_port *info = (struct r_port *) tty->driver_data;
 	void __user *argp = (void __user *)arg;
+	int ret = 0;
 
 	if (cmd != RCKP_GET_PORTS && rocket_paranoia_check(info, "rp_ioctl"))
 		return -ENXIO;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case RCKP_GET_STRUCT:
 		if (copy_to_user(argp, info, sizeof (struct r_port)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		break;
 	case RCKP_GET_CONFIG:
-		return get_config(info, argp);
+		ret = get_config(info, argp);
+		break;
 	case RCKP_SET_CONFIG:
-		return set_config(info, argp);
+		ret = set_config(info, argp);
+		break;
 	case RCKP_GET_PORTS:
-		return get_ports(info, argp);
+		ret = get_ports(info, argp);
+		break;
 	case RCKP_RESET_RM2:
-		return reset_rm2(info, argp);
+		ret = reset_rm2(info, argp);
+		break;
 	case RCKP_GET_VERSION:
-		return get_version(info, argp);
+		ret = get_version(info, argp);
+		break;
 	default:
-		return -ENOIOCTLCMD;
+		ret = -ENOIOCTLCMD;
 	}
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 static void rp_send_xchar(struct tty_struct *tty, char ch)
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

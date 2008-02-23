From: akpm@linux-foundation.org
Subject: + isicom-istallion-prepare-for-lock_kernel-pushdown.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:36:19 -0800
Message-ID: <200802230737.m1N7b8F8018486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919AbYBWHyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     isicom: istallion prepare for lock_kernel pushdown
has been added to the -mm tree.  Its filename is
     isicom-istallion-prepare-for-lock_kernel-pushdown.patch

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
Subject: isicom: istallion prepare for lock_kernel pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is an ancient driver so just wrap it in lock_kernel internally and
be done.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/char/istallion.c~isicom-istallion-prepare-for-lock_kernel-pushdown drivers/char/istallion.c
--- a/drivers/char/istallion.c~isicom-istallion-prepare-for-lock_kernel-pushdown
+++ a/drivers/char/istallion.c
@@ -4433,6 +4433,8 @@ static int stli_memioctl(struct inode *i
 	done = 0;
 	rc = 0;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stli_getportstats(NULL, argp);
@@ -4455,6 +4457,7 @@ static int stli_memioctl(struct inode *i
 		done++;
 		break;
 	}
+	unlock_kernel();
 
 	if (done)
 		return rc;
@@ -4472,6 +4475,8 @@ static int stli_memioctl(struct inode *i
 	if (brdp->state == 0)
 		return -ENODEV;
 
+	lock_kernel();
+
 	switch (cmd) {
 	case STL_BINTR:
 		EBRDINTR(brdp);
@@ -4494,6 +4499,7 @@ static int stli_memioctl(struct inode *i
 		rc = -ENOIOCTLCMD;
 		break;
 	}
+	unlock_kernel();
 	return rc;
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

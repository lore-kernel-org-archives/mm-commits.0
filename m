From: akpm@linux-foundation.org
Subject: + pps-serial-clients-support-warning-fixes.patch added to -mm tree
Date: Wed, 10 Mar 2010 14:03:19 -0800
Message-ID: <201003102229.o2AMTcpn007617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447Ab0CJWaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, giometti@linux.it, greg@kroah.com, lasaine@lvk.cs.msu.su


The patch titled
     pps-serial-clients-support-warning-fixes.txt
has been added to the -mm tree.  Its filename is
     pps-serial-clients-support-warning-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps-serial-clients-support-warning-fixes.txt
From: Andrew Morton <akpm@linux-foundation.org>

s390: 

drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_dcd_change':
drivers/pps/clients/pps-ldisc.c:32: warning: cast from pointer to integer of different size
drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_open':
drivers/pps/clients/pps-ldisc.c:79: warning: cast to pointer from integer of different size
drivers/pps/clients/pps-ldisc.c:84: warning: cast from pointer to integer of different size
drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_close':
drivers/pps/clients/pps-ldisc.c:95: warning: cast from pointer to integer of different size

Cc: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ldisc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-warning-fixes drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-warning-fixes
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -29,7 +29,7 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct timespec *ts)
 {
-	int id = (int) tty->disc_data;
+	int id = (long)tty->disc_data;
 	struct timespec __ts;
 	struct pps_ktime pps_ts;
 
@@ -76,12 +76,12 @@ static int pps_tty_open(struct tty_struc
 		pr_err("cannot register PPS source \"%s\"\n", info.path);
 		return ret;
 	}
-	tty->disc_data = (void *) ret;
+	tty->disc_data = (void *)(long)ret;
 
 	/* Should open N_TTY ldisc too */
 	ret = alias_n_tty_open(tty);
 	if (ret < 0)
-		pps_unregister_source((int) tty->disc_data);
+		pps_unregister_source((long)tty->disc_data);
 
 	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
 
@@ -92,7 +92,7 @@ static void (*alias_n_tty_close)(struct 
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	int id = (int) tty->disc_data;
+	int id = (long)tty->disc_data;
 
 	pps_unregister_source(id);
 	alias_n_tty_close(tty);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-move-charges-of-anonymous-swap-fix-3-fix.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
pps-serial-clients-support-warning-fixes.patch
sysctl-extern-cleanup-binfmts-fix.patch
sysctl-extern-cleanup-module-fix.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch


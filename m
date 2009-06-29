From: akpm@linux-foundation.org
Subject: + drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch added to -mm tree
Date: Mon, 29 Jun 2009 13:58:40 -0700
Message-ID: <200906292058.n5TKweAS006516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbZF2U7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 16:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, dcb314@hotmail.com, vapier@gentoo.org


The patch titled
     drivers/serial/bfin_sport_uart.c: remove wrong and unneeded memset
has been added to the -mm tree.  Its filename is
     drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch

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
Subject: drivers/serial/bfin_sport_uart.c: remove wrong and unneeded memset
From: Andrew Morton <akpm@linux-foundation.org>

dcb314@hotmail.com notes that this memset has its args reversed.

It's unneeded anyway, so remove it.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13587

Cc: <dcb314@hotmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_sport_uart.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/serial/bfin_sport_uart.c~drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset drivers/serial/bfin_sport_uart.c
--- a/drivers/serial/bfin_sport_uart.c~drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset
+++ a/drivers/serial/bfin_sport_uart.c
@@ -236,7 +236,6 @@ static int sport_startup(struct uart_por
 	int retval;
 
 	pr_debug("%s enter\n", __func__);
-	memset(buffer, 20, '\0');
 	snprintf(buffer, 20, "%s rx", up->name);
 	retval = request_irq(up->rx_irq, sport_uart_rx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
 	if (retval) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
drivers-net-usb-usbnetc-fix-proc-net-dev-stats.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch


From: akpm@linux-foundation.org
Subject: + frv-fix-check-on-unsigned-in-do_signal.patch added to -mm tree
Date: Mon, 26 Oct 2009 14:24:01 -0700
Message-ID: <200910262124.n9QLO1ck000890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbZJZVYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Oct 2009 17:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dhowells@redhat.com


The patch titled
     frv: fix check on unsigned in do_signal()
has been added to the -mm tree.  Its filename is
     frv-fix-check-on-unsigned-in-do_signal.patch

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
Subject: frv: fix check on unsigned in do_signal()
From: Roel Kluin <roel.kluin@gmail.com>

syscallno is unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/frv/kernel/signal.c~frv-fix-check-on-unsigned-in-do_signal arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~frv-fix-check-on-unsigned-in-do_signal
+++ a/arch/frv/kernel/signal.c
@@ -527,7 +527,7 @@ static void do_signal(void)
 
 no_signal:
 	/* Did we come from a system call? */
-	if (__frame->syscallno >= 0) {
+	if (__frame->syscallno != -1) {
 		/* Restart the system call - no handlers present */
 		switch (__frame->gr8) {
 		case -ERESTARTNOHAND:
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

frv-fix-check-on-unsigned-in-do_signal.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
hisax-fix-test-in-waitforxfw.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
bfa-fix-test-in-bfad_os_fc_host_init.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
hwmon-fix-check-on-unsigned-in-watchdog_release.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch
cachefiles-cleanup-redundant-tests-on-unsigned.patch


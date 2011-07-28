From: akpm@linux-foundation.org
Subject: + pps-new-client-driver-using-gpio-fix.patch added to -mm tree
Date: Thu, 28 Jul 2011 16:08:46 -0700
Message-ID: <201107282308.p6SN8khn013893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab1G1XI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 19:08:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, giometti@linux.it, jamesnuss@nanometrics.ca, lasaine@lvk.cs.msu.su, plyatov@gmail.com, rasm@fe.up.pt


The patch titled
     pps-new-client-driver-using-gpio-fix
has been added to the -mm tree.  Its filename is
     pps-new-client-driver-using-gpio-fix.patch

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
Subject: pps-new-client-driver-using-gpio-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove unneeded cast of void*

Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Igor Plyatov <plyatov@gmail.com>
Cc: James Nuss <jamesnuss@nanometrics.ca>
Cc: Ricardo Martins <rasm@fe.up.pt>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/clients/pps-gpio.c~pps-new-client-driver-using-gpio-fix drivers/pps/clients/pps-gpio.c
--- a/drivers/pps/clients/pps-gpio.c~pps-new-client-driver-using-gpio-fix
+++ a/drivers/pps/clients/pps-gpio.c
@@ -55,7 +55,7 @@ static irqreturn_t pps_gpio_irq_handler(
 	/* Get the time stamp first */
 	pps_get_ts(&ts);
 
-	info = (const struct pps_gpio_device_data *)data;
+	info = data;
 
 	rising_edge = gpio_get_value(info->pdata->gpio_pin);
 	if ((rising_edge && !info->pdata->assert_falling_edge) ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


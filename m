From: akpm@linux-foundation.org
Subject: + documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch added to -mm tree
Date: Tue, 09 Mar 2010 15:27:15 -0800
Message-ID: <201003092327.o29NRFlo011605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679Ab0CIX2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 18:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, randy.dunlap@oracle.com


The patch titled
     documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix
has been added to the -mm tree.  Its filename is
     documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch

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
Subject: documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix randystuff

Cc: "David S. Miller" <davem@davemloft.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/PCI/PCI-DMA-mapping.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/PCI/PCI-DMA-mapping.txt~documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix Documentation/PCI/PCI-DMA-mapping.txt
--- a/Documentation/PCI/PCI-DMA-mapping.txt~documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix
+++ a/Documentation/PCI/PCI-DMA-mapping.txt
@@ -148,8 +148,8 @@ is to try for 64-bit addressing, but bac
 should not fail.  The kernel may fail the 64-bit mask not because the
 platform is not capable of 64-bit addressing.  Rather, it may fail in
 this case simply because 32-bit addressing is done more efficiently
-than addressing.  For example, Sparc64 PCI SAC addressing is more
-efficient than DAC addressing.
+than 64-bit addressing.  For example, Sparc64 PCI SAC addressing is
+more efficient than DAC addressing.
 
 Here is how you would handle a 64-bit capable device which can drive
 all 64-bits when accessing streaming DMA:
@@ -330,9 +330,9 @@ the dma_pool interface, described below.
 
 The consistent DMA mapping interfaces, for non-NULL dev, will by
 default return a DMA address which is 32-bit addressable.  Even if the
-device indicates (via dma mask) that it may address the upper 32-bits,
+device indicates (via DMA mask) that it may address the upper 32-bits,
 consistent allocation will only return > 32-bit addresses for DMA if
-the consistent dma mask has been explicitly changed via
+the consistent DMA mask has been explicitly changed via
 dma_set_coherent_mask().  This is true of the dma_pool interface as
 well.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
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
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


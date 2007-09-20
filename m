From: akpm@linux-foundation.org
Subject: + isdn-hisax-hfc_usbc-fix-check-after-use.patch added to -mm tree
Date: Thu, 20 Sep 2007 16:03:52 -0700
Message-ID: <200709202303.l8KN3qUO007278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXITXEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 19:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, kkeil@suse.de


The patch titled
     isdn/hisax/hfc_usb.c: fix check-after-use
has been added to the -mm tree.  Its filename is
     isdn-hisax-hfc_usbc-fix-check-after-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isdn/hisax/hfc_usb.c: fix check-after-use
From: Adrian Bunk <bunk@kernel.org>

Fix a check-after-use spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/hfc_usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/hisax/hfc_usb.c~isdn-hisax-hfc_usbc-fix-check-after-use drivers/isdn/hisax/hfc_usb.c
--- a/drivers/isdn/hisax/hfc_usb.c~isdn-hisax-hfc_usbc-fix-check-after-use
+++ a/drivers/isdn/hisax/hfc_usb.c
@@ -1520,14 +1520,15 @@ hfc_usb_disconnect(struct usb_interface
 	hfcusb_data *context = usb_get_intfdata(intf);
 	int i;
 
+	if (!context)
+		return;
+
 	handle_led(context, LED_POWER_OFF);
 	schedule_timeout((10 * HZ) / 1000);
 
 	printk(KERN_INFO "HFC-S USB: device disconnect\n");
 	context->disc_flag = 1;
 	usb_set_intfdata(intf, NULL);
-	if (!context)
-		return;
 	if (timer_pending(&context->t3_timer))
 		del_timer(&context->t3_timer);
 	if (timer_pending(&context->t4_timer))
_

Patches currently in -mm which might be from bunk@kernel.org are

git-alsa.patch
git-arm.patch
git-powerpc.patch
powerpc-proper-defconfig-for-crosscompiles.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
git-dvb.patch
git-kbuild.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
git-net.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-block.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
isdn-hisax-hfc_usbc-fix-check-after-use.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch

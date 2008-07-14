From: akpm@linux-foundation.org
Subject: - ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:30 -0700
Message-ID: <200807141935.m6EJZUZd023926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756283AbYGNTfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hverkuil@xs4all.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ivtv framebuffer driver: fix pointer cast warnings
has been removed from the -mm tree.  Its filename was
     ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ivtv framebuffer driver: fix pointer cast warnings
From: David Howells <dhowells@redhat.com>

Fix casts of pointers to integers of different sizes in the ivtv framebuffer
driver.

These were introduced in patch 38eb6ba5b8487d15b020fe391d324edd2b659b03.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ivtv/ivtvfb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/ivtv/ivtvfb.c~ivtv-framebuffer-driver-fix-pointer-cast-warnings drivers/media/video/ivtv/ivtvfb.c
--- a/drivers/media/video/ivtv/ivtvfb.c~ivtv-framebuffer-driver-fix-pointer-cast-warnings
+++ a/drivers/media/video/ivtv/ivtvfb.c
@@ -417,10 +417,11 @@ static ssize_t ivtvfb_write(struct fb_in
 	if (!err) {
 		/* If transfer size > threshold and both src/dst
 		addresses are aligned, use DMA */
-		if (count >= 4096 && ((u32)buf & 3) == ((u32)dst & 3)) {
+		if (count >= 4096 &&
+		    ((unsigned long)buf & 3) == ((unsigned long)dst & 3)) {
 			/* Odd address = can't DMA. Align */
-			if ((u32)dst & 3) {
-				lead = 4 - ((u32)dst & 3);
+			if ((unsigned long)dst & 3) {
+				lead = 4 - ((unsigned long)dst & 3);
 				memcpy(dst, buf, lead);
 				buf += lead;
 				dst += lead;
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch


From: akpm@linux-foundation.org
Subject: - drivers-scsi-wd33c93c-cleanups.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:17 -0700
Message-ID: <200707181852.l6IIqHZS023653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933206AbXGRSxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/wd33c93.c: cleanups
has been removed from the -mm tree.  Its filename was
     drivers-scsi-wd33c93c-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/wd33c93.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

- #include <asm/irq.h> for getting the prototypes of {dis,en}able_irq()

- make the needlessly global wd33c93_setup() static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/wd33c93.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/wd33c93.c~drivers-scsi-wd33c93c-cleanups drivers/scsi/wd33c93.c
--- a/drivers/scsi/wd33c93.c~drivers-scsi-wd33c93c-cleanups
+++ a/drivers/scsi/wd33c93.c
@@ -89,6 +89,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
+#include <asm/irq.h>
+
 #include "wd33c93.h"
 
 #define optimum_sx_per(hostdata) (hostdata)->sx_table[1].period_ns
@@ -1762,7 +1764,7 @@ static char setup_buffer[SETUP_BUFFER_SI
 static char setup_used[MAX_SETUP_ARGS];
 static int done_setup = 0;
 
-int
+static int
 wd33c93_setup(char *str)
 {
 	int i;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
mm-variable-length-argument-support.patch
kernel-relayc-make-functions-static.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-dvb.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-xen-event-channels.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
drivers-edac-core-make-functions-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

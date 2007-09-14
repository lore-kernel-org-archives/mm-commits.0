From: akpm@linux-foundation.org
Subject: + memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch added to -mm tree
Date: Thu, 13 Sep 2007 17:58:29 -0700
Message-ID: <200709140058.l8E0wTYA014361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbXINA65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 20:58:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, balbir@linux.vnet.ibm.com


The patch titled
     make do_try_to_free_pages() static
has been added to the -mm tree.  Its filename is
     memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make do_try_to_free_pages() static
From: Adrian Bunk <bunk@kernel.org>

do_try_to_free_pages() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-cleanup mm/vmscan.c
--- a/mm/vmscan.c~memory-controller-add-per-container-lru-and-reclaim-v7-cleanup
+++ a/mm/vmscan.c
@@ -1241,8 +1241,8 @@ static unsigned long shrink_zones(int pr
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
  */
-unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
-					struct scan_control *sc)
+static unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
+					  struct scan_control *sc)
 {
 	int priority;
 	int ret = 0;
_

Patches currently in -mm which might be from bunk@kernel.org are

fix-serial_core_console-driver-dependencies.patch
git-alsa.patch
arm-extern-inline-static-inline.patch
omap1-leds-innovatorc-remove-dead-code.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
net-sctp-socketc-make-3-variables-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
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

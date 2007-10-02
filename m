From: akpm@linux-foundation.org
Subject: - slow-down-printk-during-boot-fix-3.patch removed from -mm tree
Date: Tue, 02 Oct 2007 13:20:29 -0700
Message-ID: <200710022020.l92KKTFv020296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbXJBUVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 16:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, davej@redhat.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     kernel/printk.c: make 2 variables static
has been removed from the -mm tree.  Its filename was
     slow-down-printk-during-boot-fix-3.patch

This patch was dropped because it was folded into slow-down-printk-during-boot.patch

------------------------------------------------------
Subject: kernel/printk.c: make 2 variables static
From: Adrian Bunk <bunk@stusta.de>

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +slow-down-printk-during-boot.patch
>...
>  Misc
>...

This patch makes two needlessly global variables static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~slow-down-printk-during-boot-fix-3 kernel/printk.c
--- a/kernel/printk.c~slow-down-printk-during-boot-fix-3
+++ a/kernel/printk.c
@@ -166,8 +166,8 @@ __setup("log_buf_len=", log_buf_len_setu
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
-unsigned int boot_delay; /* msecs delay after each printk during bootup */
-unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
+static unsigned int boot_delay; /* msecs delay after each printk during bootup */
+static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
 
 static int __init boot_delay_setup(char *str)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-3.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
git-nfs.patch
parisc-extern-inline-static-inline.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-immc-fix-check-after-use.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-cryptodev.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

From: akpm@linux-foundation.org
Subject: + slow-down-printk-during-boot-fix-3.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:24:31 -0700
Message-ID: <200707302224.l6UMOVf9001283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968784AbXG3WYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:24:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, davej@redhat.com, rdunlap@xenotime.net


The patch titled
     kernel/printk.c: make 2 variables static
has been added to the -mm tree.  Its filename is
     slow-down-printk-during-boot-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
export-v4l2_int_device_unregister.patch
kernel-pidc-remove-unused-exports.patch
security-cleanups.patch

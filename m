From: akpm@linux-foundation.org
Subject: - mm-slabc-proper-prototypes.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:10 -0700
Message-ID: <200705080002.l4802AQK008823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967321AbXEHACt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     mm/slab.c: proper prototypes
has been removed from the -mm tree.  Its filename was
     mm-slabc-proper-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/slab.c: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add proper prototypes in include/linux/slab.h.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c  |    2 --
 include/linux/slab.h |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_misc.c~mm-slabc-proper-prototypes fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-slabc-proper-prototypes
+++ a/fs/proc/proc_misc.c
@@ -398,8 +398,6 @@ static const struct file_operations proc
 #endif
 
 #ifdef CONFIG_SLAB
-extern struct seq_operations slabinfo_op;
-extern ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
 static int slabinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &slabinfo_op);
diff -puN include/linux/slab.h~mm-slabc-proper-prototypes include/linux/slab.h
--- a/include/linux/slab.h~mm-slabc-proper-prototypes
+++ a/include/linux/slab.h
@@ -219,6 +219,9 @@ extern void *__kmalloc_node_track_caller
 
 #endif /* DEBUG_SLAB */
 
+extern const struct seq_operations slabinfo_op;
+ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-r8169.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
apple-smc-driver-hardware-monitoring-and-control-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
add-file-position-info-to-proc.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
rtc-remove-sys-class-rtc-dev-fix.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
drivers-video-sis-remove-more-kernel-24-code.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch

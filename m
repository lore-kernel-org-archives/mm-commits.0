From: akpm@linux-foundation.org
Subject: + mm-slabc-proper-prototypes.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:55:08 -0800
Message-ID: <200702272055.l1RKtCqU028260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbXB0U61 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     mm/slab.c: proper prototypes
has been added to the -mm tree.  Its filename is
     mm-slabc-proper-prototypes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

arch-arm26-kernel-entrys-remove-dead-code.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
drivers-video-sm501fbc-make-4-functions-static.patch
fix-the-sysctl=n-compilation.patch
remove-the-jffs-maintainers-entry.patch
drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch
git-cpufreq.patch
make-kernel-kmodckmod_mk-static.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
mips-remove-smp_tune_scheduling.patch
drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
mtd_ubi_debug-must-depend-on-sysfs.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

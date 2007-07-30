From: akpm@linux-foundation.org
Subject: + remove-fs-jffs2-ioctlc.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:47:07 -0700
Message-ID: <200707302247.l6UMl7MX002483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbXG3Wr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dwmw2@infradead.org


The patch titled
     remove fs/jffs2/ioctl.c
has been added to the -mm tree.  Its filename is
     remove-fs-jffs2-ioctlc.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: remove fs/jffs2/ioctl.c
=46rom: Adrian Bunk <bunk@stusta.de>

fs/jffs2/ioctl.c is already for so long in the "might be used later" st=
ate
that I doubt it will ever be actually used...

And if it will ever be used, reverting this patch will be trivial.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/Makefile   |    2 +-
 fs/jffs2/dir.c      |    1 -
 fs/jffs2/file.c     |    1 -
 fs/jffs2/ioctl.c    |   21 ---------------------
 fs/jffs2/os-linux.h |    3 ---
 5 files changed, 1 insertion(+), 27 deletions(-)

diff -puN fs/jffs2/Makefile~remove-fs-jffs2-ioctlc fs/jffs2/Makefile
--- a/fs/jffs2/Makefile~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/Makefile
@@ -5,7 +5,7 @@
=20
 obj-$(CONFIG_JFFS2_FS) +=3D jffs2.o
=20
-jffs2-y	:=3D compr.o dir.o file.o ioctl.o nodelist.o malloc.o
+jffs2-y	:=3D compr.o dir.o file.o nodelist.o malloc.o
 jffs2-y	+=3D read.o nodemgmt.o readinode.o write.o scan.o gc.o
 jffs2-y	+=3D symlink.o build.o erase.o background.o fs.o writev.o
 jffs2-y	+=3D super.o debug.o
diff -puN fs/jffs2/dir.c~remove-fs-jffs2-ioctlc fs/jffs2/dir.c
--- a/fs/jffs2/dir.c~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/dir.c
@@ -38,7 +38,6 @@ const struct file_operations jffs2_dir_o
 {
 	.read =3D		generic_read_dir,
 	.readdir =3D	jffs2_readdir,
-	.ioctl =3D	jffs2_ioctl,
 	.fsync =3D	jffs2_fsync
 };
=20
diff -puN fs/jffs2/file.c~remove-fs-jffs2-ioctlc fs/jffs2/file.c
--- a/fs/jffs2/file.c~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/file.c
@@ -46,7 +46,6 @@ const struct file_operations jffs2_file_
  	.aio_read =3D	generic_file_aio_read,
  	.write =3D	do_sync_write,
  	.aio_write =3D	generic_file_aio_write,
-	.ioctl =3D	jffs2_ioctl,
 	.mmap =3D		generic_file_readonly_mmap,
 	.fsync =3D	jffs2_fsync,
 	.splice_read =3D	generic_file_splice_read,
diff -puN fs/jffs2/ioctl.c~remove-fs-jffs2-ioctlc /dev/null
--- a/fs/jffs2/ioctl.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * JFFS2 -- Journalling Flash File System, Version 2.
- *
- * Copyright =C2=A9 2001-2007 Red Hat, Inc.
- *
- * Created by David Woodhouse <dwmw2@infradead.org>
- *
- * For licensing information, see the file 'LICENCE' in this directory=
=2E
- *
- */
-
-#include <linux/fs.h>
-
-int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int c=
md,
-		unsigned long arg)
-{
-	/* Later, this will provide for lsattr.jffs2 and chattr.jffs2, which
-	   will include compression support etc. */
-	return -ENOTTY;
-}
-
diff -puN fs/jffs2/os-linux.h~remove-fs-jffs2-ioctlc fs/jffs2/os-linux.=
h
--- a/fs/jffs2/os-linux.h~remove-fs-jffs2-ioctlc
+++ a/fs/jffs2/os-linux.h
@@ -166,9 +166,6 @@ extern const struct address_space_operat
 int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
=20
-/* ioctl.c */
-int jffs2_ioctl(struct inode *, struct file *, unsigned int, unsigned =
long);
-
 /* symlink.c */
 extern const struct inode_operations jffs2_symlink_inode_operations;
=20
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
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-=
dma.patch
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
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-host=
s.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
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
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.pat=
ch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-=
remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
drivers-scsi-scsi_errorc-should-include.patch
include-linux-kbuild-remove-duplicate-entries.patch
parisc-extern-inline-static-inline.patch
remove-fs-jffs2-ioctlc.patch
drivers-scsi-constantsc-make-2-functions-static.patch
fs-afs-possible-cleanups.patch
ppc-remove-apus-support.patch
lib-ioremapc-should-include-linux-ioh.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
ipc-shmc-make-2-functions-static.patch
kernel-schedc-make-code-static.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch

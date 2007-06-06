From: akpm@linux-foundation.org
Subject: + lockstat-human-readability-tweaks-fix.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:55:48 -0700
Message-ID: <200706060655.l566tm5P011305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365AbXFFG4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, a.p.zijlstra@chello.nl


The patch titled
     kernel/lockdep_proc.c: make 2 functions static
has been added to the -mm tree.  Its filename is
     lockstat-human-readability-tweaks-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/lockdep_proc.c: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_proc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/lockdep_proc.c~lockstat-human-readability-tweaks-fix kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockstat-human-readability-tweaks-fix
+++ a/kernel/lockdep_proc.c
@@ -364,7 +364,7 @@ struct lock_stat_seq {
 /*
  * sort on absolute number of contentions
  */
-int lock_stat_cmp(const void *l, const void *r)
+static int lock_stat_cmp(const void *l, const void *r)
 {
 	const struct lock_stat_data *dl = l, *dr = r;
 	unsigned long nl, nr;
@@ -567,8 +567,8 @@ static int lock_stat_open(struct inode *
 	return res;
 }
 
-ssize_t lock_stat_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos)
+static ssize_t lock_stat_write(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
 {
 	struct lock_class *class;
 	char c;
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
fix-2-gregkh-driver-dmi-based-module-autoloading.patch
git-dvb-fix-the-tea5761-tuner-support.patch
git-input-make-xpad_play_effect-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

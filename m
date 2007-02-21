From: akpm@linux-foundation.org
Subject: + make-ipc-shmcshm_nopage-static.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:14:17 -0800
Message-ID: <200702212214.l1LMEHkW028001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52028 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423190AbXBUWRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:17:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ebiederm@xmission.com


The patch titled
     make ipc/shm.c:shm_nopage() static
has been added to the -mm tree.  Its filename is
     make-ipc-shmcshm_nopage-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make ipc/shm.c:shm_nopage() static
From: Adrian Bunk <bunk@stusta.de>

shm_nopage() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~make-ipc-shmcshm_nopage-static ipc/shm.c
--- a/ipc/shm.c~make-ipc-shmcshm_nopage-static
+++ a/ipc/shm.c
@@ -226,8 +226,8 @@ static void shm_close(struct vm_area_str
 	mutex_unlock(&shm_ids(ns).mutex);
 }
 
-struct page *shm_nopage(struct vm_area_struct *vma, unsigned long address,
-			int *type)
+static struct page *shm_nopage(struct vm_area_struct *vma,
+			       unsigned long address, int *type)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
make-ipc-shmcshm_nopage-static.patch
git-cpufreq.patch
make-kernel-kmodckmod_mk-static.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
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
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
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

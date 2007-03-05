From: akpm@linux-foundation.org
Subject: + cleanup-the-includes-of-linux-pcih-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 01:30:42 -0800
Message-ID: <200703050932.l259WLQ7014985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbXCEJcj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 04:32:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, khali@linux-fr.org


The patch titled
     cleanup-the-includes-of-linux-pcih-fix
has been added to the -mm tree.  Its filename is
     cleanup-the-includes-of-linux-pcih-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup-the-includes-of-linux-pcih-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/linux/scatterlist.h:4,
                 from drivers/scsi/libsas/sas_expander.c:25:
include/asm/scatterlist.h:7: error: expected specifier-qualifier-list before 'dma_addr_t'
In file included from drivers/scsi/libsas/sas_expander.c:25:
include/linux/scatterlist.h: In function 'sg_set_buf':
include/linux/scatterlist.h:13: error: 'struct scatterlist' has no member named 'length'
In file included from include/linux/dma-mapping.h:34,
                 from include/asm-generic/pci-dma-compat.h:7,
                 from include/asm/pci.h:114,
                 from include/linux/pci.h:766,
                 from include/scsi/libsas.h:31,
                 from drivers/scsi/libsas/sas_internal.h:32,
                 from drivers/scsi/libsas/sas_expander.c:27:
include/asm/dma-mapping.h: In function 'dma_map_sg':
include/asm/dma-mapping.h:44: error: 'struct scatterlist' has no member named 'length'
include/asm/dma-mapping.h:44: warning: type defaults to 'int' in declaration of '__ret_warn_on'
include/asm/dma-mapping.h:44: error: 'struct scatterlist' has no member named 'length'
include/asm/dma-mapping.h:49: error: 'struct scatterlist' has no member named 'dma_address'
make[1]: *** [drivers/scsi/libsas/sas_expander.o] Error 1
make: *** [drivers/scsi/libsas/sas_expander.o] Error 2

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/scatterlist.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-i386/scatterlist.h~cleanup-the-includes-of-linux-pcih-fix include/asm-i386/scatterlist.h
--- a/include/asm-i386/scatterlist.h~cleanup-the-includes-of-linux-pcih-fix
+++ a/include/asm-i386/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _I386_SCATTERLIST_H
 #define _I386_SCATTERLIST_H
 
+#include <linux/types.h>
+
 struct scatterlist {
     struct page		*page;
     unsigned int	offset;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
cleanup-the-includes-of-linux-pcih-fix.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch

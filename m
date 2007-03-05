From: akpm@linux-foundation.org
Subject: + ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch added to -mm tree
Date: Mon, 05 Mar 2007 01:14:45 -0800
Message-ID: <200703050914.l259Ej9V014709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbXCEJQG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 04:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, horms@verge.net.au, magnus@valinux.co.jp, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy
has been added to the -mm tree.  Its filename is
     ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy
From: Andrew Morton <akpm@linux-foundation.org>

no need for ifdefs around declarations.

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Magnus Damm <magnus@valinux.co.jp>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/meminit.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN include/asm-ia64/meminit.h~ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy include/asm-ia64/meminit.h
--- a/include/asm-ia64/meminit.h~ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy
+++ a/include/asm-ia64/meminit.h
@@ -37,10 +37,8 @@ extern void find_initrd (void);
 extern int filter_rsvd_memory (unsigned long start, unsigned long end, void *arg);
 extern void efi_memmap_init(unsigned long *, unsigned long *);
 
-#ifdef CONFIG_PROC_VMCORE
-extern unsigned long vmcore_find_descriptor_size (unsigned long address);
+extern unsigned long vmcore_find_descriptor_size(unsigned long address);
 extern int reserve_elfcorehdr(unsigned long *start, unsigned long *end);
-#endif
 
 /*
  * For rounding an address to the next IA64_GRANULE_SIZE or order
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

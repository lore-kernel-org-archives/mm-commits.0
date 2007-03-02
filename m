From: akpm@linux-foundation.org
Subject: + page-migration-fix-vma-flag-checking-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 19:31:48 -0800
Message-ID: <200703020331.l223Vm2Z031248@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39387 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422800AbXCBDbw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 22:31:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     vma_migratable-fix
has been added to the -mm tree.  Its filename is
     page-migration-fix-vma-flag-checking-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vma_migratable-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++--
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/migrate.h~page-migration-fix-vma-flag-checking-fix include/linux/migrate.h
--- a/include/linux/migrate.h~page-migration-fix-vma-flag-checking-fix
+++ a/include/linux/migrate.h
@@ -5,8 +5,8 @@
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
-/* Check if a vma is migratable */
-static inline int vma_migratable(struct vm_area_struct *vma)
+/* Check if a vma is migrateable */
+static inline int vma_migrateable(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
 		return 0;
diff -puN mm/mempolicy.c~page-migration-fix-vma-flag-checking-fix mm/mempolicy.c
--- a/mm/mempolicy.c~page-migration-fix-vma-flag-checking-fix
+++ a/mm/mempolicy.c
@@ -354,7 +354,7 @@ check_range(struct mm_struct *mm, unsign
 		if (!is_vm_hugetlb_page(vma) &&
 		    ((flags & MPOL_MF_STRICT) ||
 		     ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
-				vma_migratable(vma)))) {
+				vma_migrateable(vma)))) {
 			unsigned long endvma = vma->vm_end;
 
 			if (endvma > end)
diff -puN mm/migrate.c~page-migration-fix-vma-flag-checking-fix mm/migrate.c
--- a/mm/migrate.c~page-migration-fix-vma-flag-checking-fix
+++ a/mm/migrate.c
@@ -781,7 +781,7 @@ static int do_move_pages(struct mm_struc
 
 		err = -EFAULT;
 		vma = find_vma(mm, pp->addr);
-		if (!vma || !vma_migratable(vma))
+		if (!vma || !vma_migrateable(vma))
 			goto set_status;
 
 		page = follow_page(vma, pp->addr, FOLL_GET);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
cyclades-return-closing_wait.patch
page-migration-fix-vma-flag-checking-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-hid-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch

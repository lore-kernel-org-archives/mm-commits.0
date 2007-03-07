From: akpm@linux-foundation.org
Subject: + mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch added to -mm tree
Date: Tue, 06 Mar 2007 22:53:37 -0800
Message-ID: <200703070653.l276rb4O021987@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbXCGGxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 01:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, npiggin@suse.de


The patch titled
     mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy
has been added to the -mm tree.  Its filename is
     mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy include/linux/mm.h
--- a/include/linux/mm.h~mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy
+++ a/include/linux/mm.h
@@ -216,7 +216,6 @@ struct fault_data {
 	unsigned long address;
 	pgoff_t pgoff;
 	unsigned int flags;
-
 	int type;
 };
 
@@ -228,10 +227,15 @@ struct fault_data {
 struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
-	struct page * (*fault)(struct vm_area_struct *vma, struct fault_data * fdata);
-	struct page * (*nopage)(struct vm_area_struct * area, unsigned long address, int *type);
-	unsigned long (*nopfn)(struct vm_area_struct * area, unsigned long address);
-	int (*populate)(struct vm_area_struct * area, unsigned long address, unsigned long len, pgprot_t prot, unsigned long pgoff, int nonblock);
+	struct page *(*fault)(struct vm_area_struct *vma,
+			struct fault_data *fdata);
+	struct page *(*nopage)(struct vm_area_struct *area,
+			unsigned long address, int *type);
+	unsigned long (*nopfn)(struct vm_area_struct *area,
+			unsigned long address);
+	int (*populate)(struct vm_area_struct *area, unsigned long address,
+			unsigned long len, pgprot_t prot, unsigned long pgoff,
+			int nonblock);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
@@ -1107,8 +1111,8 @@ extern void truncate_inode_pages_range(s
 
 /* generic vm_area_ops exported for stackable file systems */
 extern struct page *filemap_fault(struct vm_area_struct *, struct fault_data *);
-extern struct page * __deprecated_for_modules filemap_nopage(
-			struct vm_area_struct *, unsigned long, int *);
+extern struct page * __deprecated_for_modules
+filemap_nopage(struct vm_area_struct *, unsigned long, int *);
 extern int __deprecated_for_modules filemap_populate(struct vm_area_struct *,
 		unsigned long, unsigned long, pgprot_t, unsigned long, int);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch

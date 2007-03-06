From: akpm@linux-foundation.org
Subject: + add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 23:35:44 -0800
Message-ID: <200703060737.l267bN53015664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933974AbXCFHhc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 02:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mel@csn.ul.ie


The patch titled
     add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix
has been added to the -mm tree.  Its filename is
     add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix
From: Andrew Morton <akpm@linux-foundation.org>

Missing \

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/page.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-ia64/page.h~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix include/asm-ia64/page.h
--- a/include/asm-ia64/page.h~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix
+++ a/include/asm-ia64/page.h
@@ -87,13 +87,13 @@ do {						\
 } while (0)
 
 
-#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-({						\
-	struct page *page = alloc_page_vma(
-		GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr); \
-	if (page)				\
- 		flush_dcache_page(page);	\
-	page;					\
+#define __alloc_zeroed_user_highpage(movableflags, vma, vaddr)		\
+({									\
+	struct page *page = alloc_page_vma(				\
+		GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr);	\
+	if (page)							\
+ 		flush_dcache_page(page);				\
+	page;								\
 })
 
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
stupid-hack-to-make-mainline-build.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
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

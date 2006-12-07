From: akpm@osdl.org
Subject: - lib-functions-always-build-hweight-for-loadable-modules.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:08:48 -0800
Message-ID: <200612072308.kB7N8m96030438@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52944 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163841AbWLGXJJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lib functions: always build hweight for loadable modules
has been removed from the -mm tree.  Its filename was
     lib-functions-always-build-hweight-for-loadable-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib functions: always build hweight for loadable modules
From: Randy Dunlap <randy.dunlap@oracle.com>

Always build hweight8/16/32/64() functions into the kernel so that loadable
modules may use them.

I didn't remove GENERIC_HWEIGHT since ALPHA_EV67, ia64, and some variants
of UltraSparc(64) provide their own hweight functions.

Fixes config/build problems with NTFS=m and JOYSTICK_ANALOG=m.

Kernel: arch/x86_64/boot/bzImage is ready  (#19)
  Building modules, stage 2.
  MODPOST 94 modules
WARNING: "hweight32" [fs/ntfs/ntfs.ko] undefined!
WARNING: "hweight16" [drivers/input/joystick/analog.ko] undefined!
WARNING: "hweight8" [drivers/input/joystick/analog.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Makefile~lib-functions-always-build-hweight-for-loadable-modules lib/Makefile
--- a/lib/Makefile~lib-functions-always-build-hweight-for-loadable-modules
+++ a/lib/Makefile
@@ -25,7 +25,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += 
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_SEMAPHORE_SLEEPERS) += semaphore-sleepers.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
-lib-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
+obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch


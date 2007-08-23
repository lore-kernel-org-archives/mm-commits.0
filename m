From: akpm@linux-foundation.org
Subject: + redefine-unregister_hotcpu_notifier-hotplug_cpu.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:11:17 -0700
Message-ID: <200708232311.l7NNBHwT031834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbXHWXLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org


The patch titled
     Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs as static inline function
has been added to the -mm tree.  Its filename is
     redefine-unregister_hotcpu_notifier-hotplug_cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs as static inline function
From: Satyam Sharma <satyam@infradead.org>

The return of the present "do {} while" based stub definition of
register_hotcpu_notifier() cannot be checked, but the real HOTPLUG_CPU=y
implementation of register_hotcpu_notifier() is int-returning.  So let us
make this stub consistent with the full version.  Redefining this as such
will also help us remove some #ifdef-ery elsewhere in kernel code, as shown
in forthcoming patch.  Also do the same for unregister_xxx case.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/cpu.h~redefine-unregister_hotcpu_notifier-hotplug_cpu include/linux/cpu.h
--- a/include/linux/cpu.h~redefine-unregister_hotcpu_notifier-hotplug_cpu
+++ a/include/linux/cpu.h
@@ -119,8 +119,13 @@ static inline void cpuhotplug_mutex_unlo
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
-#define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
+static inline int register_hotcpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline void unregister_hotcpu_notifier(struct notifier_block *nb)
+{
+}
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
 static inline int cpu_is_offline(int cpu) { return 0; }
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
s390-appldata_base-misc-cpuinit-annotations-and-bugfix.patch
s390-appldata_base-remove-module_exit-function-and-modular.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch

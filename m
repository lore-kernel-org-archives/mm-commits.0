From: akpm@linux-foundation.org
Subject: + redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:22:59 -0700
Message-ID: <200708272122.l7RLMxTN028690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762892AbXH0VXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org


The patch titled
     Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs
has been added to the -mm tree.  Its filename is
     redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs
From: Satyam Sharma <satyam@infradead.org>

The return of the present "do {} while" based stub definition of
register_hotcpu_notifier() cannot be checked.  This makes the stub
asymmetric w.r.t.  the real HOTPLUG_CPU=y implementation that is
int-returning.  So let us redefine this to be consistent with the full
version.  Also do the same for unregister_hotcpu_notifier().

We cannot define these as static inline functions due to an existing GCC
bug (#33172).  So define as macros that return appropriately instead (int
'0' for the register_hotcpu_notifier case and void for
unregister_hotcpu_notifier).

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/cpu.h~redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs include/linux/cpu.h
--- a/include/linux/cpu.h~redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs
+++ a/include/linux/cpu.h
@@ -119,8 +119,9 @@ static inline void cpuhotplug_mutex_unlo
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
-#define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
+/* These aren't inline functions due to a GCC bug. */
+#define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
+#define unregister_hotcpu_notifier(nb)	({ (void)(nb); })
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
 static inline int cpu_is_offline(int cpu) { return 0; }
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
git-s390.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch

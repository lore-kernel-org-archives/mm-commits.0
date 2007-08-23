From: akpm@linux-foundation.org
Subject: + cpufreq-implement-config_cpu_freq-stub-for.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:17:25 -0700
Message-ID: <200708232317.l7NNHPw3032037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761530AbXHWXRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, davej@codemonkey.org.uk


The patch titled
     cpufreq: implement !CONFIG_CPU_FREQ stub for  cpufreq_unregister_notifier()
has been added to the -mm tree.  Its filename is
     cpufreq-implement-config_cpu_freq-stub-for.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpufreq: implement !CONFIG_CPU_FREQ stub for  cpufreq_unregister_notifier()
From: Satyam Sharma <satyam@infradead.org>

Callsites such as arch/powerpc/oprofile/op_model_cell.c are having to
open-code #ifdef CONFIG_CPU_FREQ only to be able to get at the full definition
of cpufreq_unregister_notifier(), because no empty stub is available for the
!CONFIG_CPU_FREQ case.  Let's provide one, to be able to remove such #ifdef's
from the rest of the kernel tree -- those will come in a subsequent patch.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpufreq.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/cpufreq.h~cpufreq-implement-config_cpu_freq-stub-for include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-implement-config_cpu_freq-stub-for
+++ a/include/linux/cpufreq.h
@@ -34,14 +34,19 @@
 
 #ifdef CONFIG_CPU_FREQ
 int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list);
+int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 #else
 static inline int cpufreq_register_notifier(struct notifier_block *nb,
 						unsigned int list)
 {
 	return 0;
 }
+static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
+						unsigned int list)
+{
+	return 0;
+}
 #endif
-int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 
 #define CPUFREQ_TRANSITION_NOTIFIER	(0)
 #define CPUFREQ_POLICY_NOTIFIER		(1)
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
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
x86_64-mce_amd-fix-section-mismatch-warnings.patch
drivers-video-geode-lxfb_corec-fix-build.patch

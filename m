From: akpm@osdl.org
Subject: - declare-smp_call_function_single-in-generic-code.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:27 -0800
Message-ID: <200612072305.kB7N5Rq6030159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163608AbWLGXGH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     declare smp_call_function_single in generic code
has been removed from the -mm tree.  Its filename was
     declare-smp_call_function_single-in-generic-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: declare smp_call_function_single in generic code
From: Randy Dunlap <randy.dunlap@oracle.com>

smp_call_function_single() needs to be visible in non-SMP builds, to fix:

arch/x86_64/kernel/vsyscall.c:283: warning: implicit declaration of function 'smp_call_function_single'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/smp.h |    7 -------
 include/linux/smp.h      |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-x86_64/smp.h~declare-smp_call_function_single-in-generic-code include/asm-x86_64/smp.h
--- a/include/asm-x86_64/smp.h~declare-smp_call_function_single-in-generic-code
+++ a/include/asm-x86_64/smp.h
@@ -118,13 +118,6 @@ static __inline int logical_smp_processo
 #define cpu_physical_id(cpu)		x86_cpu_to_apicid[cpu]
 #else
 #define cpu_physical_id(cpu)		boot_cpu_id
-static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
-				void *info, int retry, int wait)
-{
-	/* Disable interrupts here? */
-	func(info);
-	return 0;
-}
 #endif /* !CONFIG_SMP */
 #endif
 
diff -puN include/linux/smp.h~declare-smp_call_function_single-in-generic-code include/linux/smp.h
--- a/include/linux/smp.h~declare-smp_call_function_single-in-generic-code
+++ a/include/linux/smp.h
@@ -99,6 +99,13 @@ static inline int up_smp_call_function(v
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
+static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
+				void *info, int retry, int wait)
+{
+	/* Disable interrupts here? */
+	func(info);
+	return 0;
+}
 
 #endif /* !SMP */
 
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


From: akpm@linux-foundation.org
Subject: - cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:28:09 -0800
Message-ID: <200803062228.m26MS9w9021160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899AbYCFW3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, ak@suse.de, akinobu.mita@gmail.com, ashok.raj@intel.com, ego@in.ibm.com, jbeulich@novell.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling: fix a section mismatch warning
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling: fix a section mismatch warning
From: Gabriel C <nix.or.die@googlemail.com>

...

WARNING: vmlinux.o(.text+0x8b9f): Section mismatch: reference to .init.text:cache_remove_shared_cpu_map (between 'cpuid4_cache_sysfs_exit' and 'unexpected_machine_check')

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -681,7 +681,7 @@ static struct kobj_type ktype_percpu_ent
 	.sysfs_ops	= &sysfs_ops,
 };
 
-static void cpuid4_cache_sysfs_exit(unsigned int cpu)
+static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
 {
 	kfree(cache_kobject[cpu]);
 	kfree(index_kobject[cpu]);
_

Patches currently in -mm which might be from nix.or.die@googlemail.com are

git-kvm.patch


From: akpm@linux-foundation.org
Subject: + cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch added to -mm tree
Date: Wed, 01 Aug 2007 16:06:30 -0700
Message-ID: <200708012306.l71N6UlJ022045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbXHAXHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 19:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com, akinobu.mita@gmail.com, ashok.raj@intel.com, ego@in.ibm.com, oleg@tv-sign.ru


The patch titled
     cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling: fix a section mismatch warning
has been added to the -mm tree.  Its filename is
     cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
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

origin.patch
fix-libata-warnings-with-config_pm=n.patch
drivers-scsi-g_ncr5380c-ncr53c400_pseudo_dma-is-not.patch
fix-drivers-scsi-fdomainc-config_pci=n-warnings.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch

From: akpm@linux-foundation.org
Subject: - intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:45 -0700
Message-ID: <200710180707.l9I77jtW031727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759830AbXJRHI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel_cacheinfo: Call cache_add_dev from cache_sysfs_init  explicitly
has been removed from the -mm tree.  Its filename was
     intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_cacheinfo: Call cache_add_dev from cache_sysfs_init  explicitly
From: Satyam Sharma <satyam@infradead.org>

Call cache_add_dev() from cache_sysfs_init() explicitly, instead of
referencing the CPU notifier callback directly from generic startup code. 
Looks cleaner (to me at least) this way, and also makes it possible to use
other tricks to replace __cpuinit{data} annotations, as recently discussed on
this list.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -794,8 +794,8 @@ static int __cpuinit cache_sysfs_init(vo
 	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
 
 	for_each_online_cpu(i) {
-		cacheinfo_cpu_callback(&cacheinfo_cpu_notifier, CPU_ONLINE,
-			(void *)(long)i);
+		struct sys_device *sys_dev = get_cpu_sysdev((unsigned int)i);
+		cache_add_dev(sys_dev);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-watchdog.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch

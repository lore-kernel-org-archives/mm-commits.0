From: akpm@linux-foundation.org
Subject: + intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:22:27 -0700
Message-ID: <200708232222.l7NMMRXi029716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762228AbXHWWWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, ak@suse.de, venkatesh.pallipadi@intel.com


The patch titled
     intel_cacheinfo: Call cache_add_dev from cache_sysfs_init  explicitly
has been added to the -mm tree.  Its filename is
     intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -792,8 +792,8 @@ static int __init cache_sysfs_init(void)
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
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch

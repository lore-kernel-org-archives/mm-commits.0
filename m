From: akpm@linux-foundation.org
Subject: + i386-cpuid-misc-cpuinit-annotations.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:02:59 -0700
Message-ID: <200708232302.l7NN2xhh031543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45874 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761999AbXHWXDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, ak@suse.de


The patch titled
     i386 cpuid: Misc cpuinit annotations
has been added to the -mm tree.  Its filename is
     i386-cpuid-misc-cpuinit-annotations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 cpuid: Misc cpuinit annotations
From: Satyam Sharma <satyam@infradead.org>

cpuid_class_cpu_callback() is callback function of a CPU hotplug
notifier_block (that is already marked as __cpuinitdata).  Therefore it can
safely be marked as __cpuinit.

cpuid_device_create() is only referenced from other functions that are
__cpuinit or __init.  So it can also be safely marked __cpuinit.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpuid.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpuid.c~i386-cpuid-misc-cpuinit-annotations arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~i386-cpuid-misc-cpuinit-annotations
+++ a/arch/i386/kernel/cpuid.c
@@ -136,7 +136,7 @@ static const struct file_operations cpui
 	.open = cpuid_open,
 };
 
-static int cpuid_device_create(int i)
+static int __cpuinit cpuid_device_create(int i)
 {
 	int err = 0;
 	struct device *dev;
@@ -147,7 +147,9 @@ static int cpuid_device_create(int i)
 	return err;
 }
 
-static int cpuid_class_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
+static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
+					      unsigned long action,
+					      void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
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
i386-cpuid-misc-cpuinit-annotations.patch
x86-msr-driver-misc-cpuinit-annotations.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch

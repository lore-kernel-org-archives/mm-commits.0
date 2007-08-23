From: akpm@linux-foundation.org
Subject: + x86-msr-driver-misc-cpuinit-annotations.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:03:01 -0700
Message-ID: <200708232303.l7NN31aa031552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762339AbXHWXDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, ak@suse.de


The patch titled
     x86 msr driver: Misc cpuinit annotations
has been added to the -mm tree.  Its filename is
     x86-msr-driver-misc-cpuinit-annotations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86 msr driver: Misc cpuinit annotations
From: Satyam Sharma <satyam@infradead.org>

msr_class_cpu_callback() can be marked __cpuinit, being the notifier callback
for a __cpuinitdata notifier_block.  So can be marked msr_device_create() too,
called only from the newly-__cpuinit msr_class_cpu_callback() or from
__init-marked msr_init().

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/msr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/msr.c~x86-msr-driver-misc-cpuinit-annotations arch/i386/kernel/msr.c
--- a/arch/i386/kernel/msr.c~x86-msr-driver-misc-cpuinit-annotations
+++ a/arch/i386/kernel/msr.c
@@ -135,7 +135,7 @@ static const struct file_operations msr_
 	.open = msr_open,
 };
 
-static int msr_device_create(int i)
+static int __cpuinit msr_device_create(int i)
 {
 	int err = 0;
 	struct device *dev;
@@ -146,7 +146,7 @@ static int msr_device_create(int i)
 	return err;
 }
 
-static int msr_class_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
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

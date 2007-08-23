From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:25:47 -0700
Message-ID: <200708232325.l7NNPlmt032351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753677AbXHWX0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, mhoffman@lightlink.com, r.marek@assembler.cz


The patch titled
     hwmon coretemp: remove bogus __cpuinitdata etc cleanup
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hwmon coretemp: remove bogus __cpuinitdata etc cleanup
From: Satyam Sharma <satyam@infradead.org>

The CPU hotplug notifier_block coretemp_cpu_notifier is already defined
inside an #ifdef HOTPLUG_CPU, therefore marking it as __cpuinitdata is
quite a pointless thing to do.

Also, remove duplicate prototype of function coretemp_update_device() at
the top of this file (another one already exists barely 10 lines above this
one :-)

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Mark Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-remove-bogus-__cpuinitdata-etc-cleanup
+++ a/drivers/hwmon/coretemp.c
@@ -58,8 +58,6 @@ struct coretemp_data {
 	u8 alarm;
 };
 
-static struct coretemp_data *coretemp_update_device(struct device *dev);
-
 /*
  * Sysfs stuff
  */
@@ -350,7 +348,7 @@ static int coretemp_cpu_callback(struct 
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata coretemp_cpu_notifier = {
+static struct notifier_block coretemp_cpu_notifier = {
 	.notifier_call = coretemp_cpu_callback,
 };
 #endif				/* !CONFIG_HOTPLUG_CPU */
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
s390-appldata_base-misc-cpuinit-annotations-and-bugfix.patch
s390-appldata_base-remove-module_exit-function-and-modular.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
x86_64-mce_amd-fix-section-mismatch-warnings.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch

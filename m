From: akpm@linux-foundation.org
Subject: - drivers-char-nozomic-__devexit_p-usage-build-fix.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:16:25 -0700
Message-ID: <200709202116.l8KLGP4H003006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbXITV2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/nozomi.c: __devexit_p usage build fix
has been removed from the -mm tree.  Its filename was
     drivers-char-nozomic-__devexit_p-usage-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/char/nozomi.c: __devexit_p usage build fix
From: Satyam Sharma <satyam@infradead.org>

A typo results in build breakage:

drivers/char/nozomi.c:2204: error: syntax error before `__attribute__'

when CONFIG_HOTPLUG=n. This was actually meant to be __devexit_p.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/nozomi.c~drivers-char-nozomic-__devexit_p-usage-build-fix drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~drivers-char-nozomic-__devexit_p-usage-build-fix
+++ a/drivers/char/nozomi.c
@@ -2263,7 +2263,7 @@ static struct pci_driver nozomi_driver =
 	.name = NOZOMI_NAME,
 	.id_table = nozomi_pci_tbl,
 	.probe = nozomi_card_init,
-	.remove = __devexit(nozomi_card_exit),
+	.remove = __devexit_p(nozomi_card_exit),
 };
 
 static __init int nozomi_init(void)
_

Patches currently in -mm which might be from satyam@infradead.org are

cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-net.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
mpt-fusion-shut-up-uninitialized-variable.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch

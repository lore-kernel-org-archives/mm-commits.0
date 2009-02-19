From: akpm@linux-foundation.org
Subject: [merged] pm-fix-build-for-config_pm-unset.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:42 -0800
Message-ID: <200902191916.n1JJGgo8016276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbZBSTSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:18:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, mhiramat@redhat.com, mingo@elte.hu, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     pm: fix build for CONFIG_PM unset
has been removed from the -mm tree.  Its filename was
     pm-fix-build-for-config_pm-unset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: fix build for CONFIG_PM unset
From: Rafael J. Wysocki <rjw@sisk.pl>

Compilation of kprobes.c with CONFIG_PM unset is broken due to some broken
config dependncies.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile       |    1 +
 kernel/power/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/Makefile~pm-fix-build-for-config_pm-unset kernel/Makefile
--- a/kernel/Makefile~pm-fix-build-for-config_pm-unset
+++ a/kernel/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
+obj-$(CONFIG_FREEZER) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
diff -puN kernel/power/Makefile~pm-fix-build-for-config_pm-unset kernel/power/Makefile
--- a/kernel/power/Makefile~pm-fix-build-for-config_pm-unset
+++ a/kernel/power/Makefile
@@ -3,7 +3,7 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o
+obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
resume-wait-for-device-probing-to-finish.patch
pm-hibernate-fix-swap-breaks-after-hibernation-failures.patch
pm-fix-pm_notifiers-during-user-mode-hibernation.patch
pm-wait-for-console-in-resume.patch
pm-fix-suspend_console-resume_console-to-use-only-one-semaphore.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
shrink_slab-handle-bad-shrinkers.patch


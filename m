From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-avoid-argv_freenull.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:12 -0700
Message-ID: <20120731184912.D13CA10007E@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2GaStO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:14 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@linux.intel.com, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, rientjes@google.com, serge.hallyn@canonical.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: avoid argv_free(NULL)
has been removed from the -mm tree.  Its filename was
     kernel-sysc-avoid-argv_freenull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/sys.c: avoid argv_free(NULL)

If argv_split() failed, the code will end up calling argv_free(NULL).  Fix
it up and clean things up a bit.

Addresses Coverity report 703573.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-avoid-argv_freenull kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-avoid-argv_freenull
+++ a/kernel/sys.c
@@ -2186,46 +2186,52 @@ static void argv_cleanup(struct subproce
 	argv_free(info->argv);
 }
 
-/**
- * orderly_poweroff - Trigger an orderly system poweroff
- * @force: force poweroff if command execution fails
- *
- * This may be called from any context to trigger a system shutdown.
- * If the orderly shutdown fails, it will force an immediate shutdown.
- */
-int orderly_poweroff(bool force)
+static int __orderly_poweroff(void)
 {
 	int argc;
-	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	char **argv;
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
 		NULL
 	};
-	int ret = -ENOMEM;
+	int ret;
 
+	argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
 		       __func__, poweroff_cmd);
-		goto out;
+		return -ENOMEM;
 	}
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
 				      NULL, argv_cleanup, NULL);
-out:
-	if (likely(!ret))
-		return 0;
-
 	if (ret == -ENOMEM)
 		argv_free(argv);
 
-	if (force) {
+	return ret;
+}
+
+/**
+ * orderly_poweroff - Trigger an orderly system poweroff
+ * @force: force poweroff if command execution fails
+ *
+ * This may be called from any context to trigger a system shutdown.
+ * If the orderly shutdown fails, it will force an immediate shutdown.
+ */
+int orderly_poweroff(bool force)
+{
+	int ret = __orderly_poweroff();
+
+	if (ret && force) {
 		printk(KERN_WARNING "Failed to start orderly shutdown: "
 		       "forcing the issue\n");
 
-		/* I guess this should try to kick off some daemon to
-		   sync and poweroff asap.  Or not even bother syncing
-		   if we're doing an emergency shutdown? */
+		/*
+		 * I guess this should try to kick off some daemon to sync and
+		 * poweroff asap.  Or not even bother syncing if we're doing an
+		 * emergency shutdown?
+		 */
 		emergency_sync();
 		kernel_power_off();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


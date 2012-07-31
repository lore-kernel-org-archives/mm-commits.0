From: akpm@linux-foundation.org
Subject: [merged] kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:32 -0700
Message-ID: <20120731185333.3DAEC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:35472 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab2GaSxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:36 -0400
Received: by bkcjc3 with SMTP id jc3so293508bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, oleg@redhat.com, rusty@rustcorp.com.au, serge.hallyn@canonical.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kmod.c: document call_usermodehelper_fns() a bit
has been removed from the -mm tree.  Its filename was
     kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/kmod.c: document call_usermodehelper_fns() a bit

This function's interface is, uh, subtle.  Attempt to apologise for it.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/kmod.c~kernel-kmodc-document-call_usermodehelper_fns-a-bit kernel/kmod.c
--- a/kernel/kmod.c~kernel-kmodc-document-call_usermodehelper_fns-a-bit
+++ a/kernel/kmod.c
@@ -577,6 +577,12 @@ unlock:
 	return retval;
 }
 
+/*
+ * call_usermodehelper_fns() will not run the caller-provided cleanup function
+ * if a memory allocation failure is experienced.  So the caller might need to
+ * check the call_usermodehelper_fns() return value: if it is -ENOMEM, perform
+ * the necessaary cleanup within the caller.
+ */
 int call_usermodehelper_fns(
 	char *path, char **argv, char **envp, int wait,
 	int (*init)(struct subprocess_info *info, struct cred *new),
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


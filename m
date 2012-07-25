From: akpm@linux-foundation.org
Subject: + drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch added to -mm tree
Date: Wed, 25 Jul 2012 12:51:05 -0700
Message-ID: <20120725195106.9668720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:63395 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2GYTvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 15:51:08 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so54129bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 12:51:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, joe.jin@oracle.com, khali@linux-fr.org, zhenzhong.duan@oracle.com


The patch titled
     Subject: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix
has been added to the -mm tree.  Its filename is
     drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix

tweak code comment

Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix
+++ a/drivers/firmware/dmi_scan.c
@@ -16,7 +16,7 @@
  */
 static char dmi_empty_string[] = "        ";
 
-static u16  __initdata dmi_ver;
+static u16 __initdata dmi_ver;
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -176,11 +176,10 @@ static void __init dmi_save_uuid(const s
 		return;
 
 	/*
-	 * As of version 2.6 of the SMBIOS specification, the first 3
-	 * fields of the UUID are supposed to be encoded on little-endian.
-	 * The specification says that this is the defacto standard,
-	 * update kernel code to match dmidecode data.
-	*/
+	 * As of version 2.6 of the SMBIOS specification, the first 3 fields of
+	 * the UUID are supposed to be little-endian encoded.  The specification
+	 * says that this is the defacto standard.
+	 */
 	if (dmi_ver >= 0x0206)
 		sprintf(s, "%pUL", d);
 	else
_
Subject: Subject: drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
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
memcg-oom-provide-more-info-while-memcg-oom-happening-checkpatch-fixes.patch
memcg-oom-clarify-some-oom-dump-messages-checkpatch-fixes.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
rbtree-performance-and-correctness-test-fix.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


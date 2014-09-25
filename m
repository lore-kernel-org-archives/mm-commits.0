From: akpm@linux-foundation.org
Subject: +
 drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger.patch added to -mm tree
Date: Thu, 25 Sep 2014 14:08:51 -0700
Message-ID: <54248463.C5DsrLn2ypeJAEI3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIYVIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 17:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, k.kozlowski@samsung.com, lee.jones@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/power/Kconfig: revert part of "charger: max14577: Add support for MAX77836 charger"
has been added to the -mm tree.  Its filename is
     drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger.patch

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
Subject: drivers/power/Kconfig: revert part of "charger: max14577: Add support for MAX77836 charger"

`make allnoconfig':

scripts/kconfig/conf --allnoconfig Kconfig
#
# configuration written to .config
#
make: `allnoconfig' is up to date.
fs/sysfs/Kconfig:1:error: recursive dependency detected!
fs/sysfs/Kconfig:1:     symbol SYSFS is selected by CHARGER_MAX14577
drivers/power/Kconfig:327:      symbol CHARGER_MAX14577 depends on POWER_SUPPLY
drivers/power/Kconfig:1:        symbol POWER_SUPPLY is selected by HID_SONY
drivers/hid/Kconfig:649:        symbol HID_SONY depends on NEW_LEDS
drivers/leds/Kconfig:8: symbol NEW_LEDS is selected by SENSORS_APPLESMC
drivers/hwmon/Kconfig:299:      symbol SENSORS_APPLESMC depends on HWMON
drivers/hwmon/Kconfig:5:        symbol HWMON is selected by EEEPC_LAPTOP
drivers/platform/x86/Kconfig:496:       symbol EEEPC_LAPTOP depends on HOTPLUG_PCI
drivers/pci/hotplug/Kconfig:5:  symbol HOTPLUG_PCI depends on SYSFS


Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/power/Kconfig~drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger drivers/power/Kconfig
--- a/drivers/power/Kconfig~drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger
+++ a/drivers/power/Kconfig
@@ -325,12 +325,11 @@ config CHARGER_MANAGER
           with help of suspend_again support.
 
 config CHARGER_MAX14577
-	tristate "Maxim MAX14577/77836 battery charger driver"
+	tristate "Maxim MAX14577 MUIC battery charger driver"
 	depends on MFD_MAX14577
-	select SYSFS
 	help
 	  Say Y to enable support for the battery charger control sysfs and
-	  platform data of MAX14577/77836 MUICs.
+	  platform data of MAX14577 MUICs.
 
 config CHARGER_MAX8997
 	tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
nilfs2-fix-data-loss-with-mmap-fix.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


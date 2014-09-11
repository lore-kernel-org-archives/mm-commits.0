From: akpm@linux-foundation.org
Subject: + mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch added to -mm
 tree
Date: Thu, 11 Sep 2014 14:18:19 -0700
Message-ID: <5412119b.7RPEp/FJupEzkE9N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbaIKVSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 17:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-vm_bug_on_mm-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch

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
Subject: mm-introduce-vm_bug_on_mm-checkpatch-fixes

ERROR: code indent should use tabs where possible
#37: FILE: include/linux/mmdebug.h:33:
+        do {^I^I^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#37: FILE: include/linux/mmdebug.h:33:
+        do {^I^I^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#38: FILE: include/linux/mmdebug.h:34:
+                if (unlikely(cond)) {^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#38: FILE: include/linux/mmdebug.h:34:
+                if (unlikely(cond)) {^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#39: FILE: include/linux/mmdebug.h:35:
+                        dump_mm(mm);^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#39: FILE: include/linux/mmdebug.h:35:
+                        dump_mm(mm);^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#40: FILE: include/linux/mmdebug.h:36:
+                        BUG();^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#40: FILE: include/linux/mmdebug.h:36:
+                        BUG();^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#41: FILE: include/linux/mmdebug.h:37:
+                }^I^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#41: FILE: include/linux/mmdebug.h:37:
+                }^I^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#42: FILE: include/linux/mmdebug.h:38:
+        } while (0)$

WARNING: please, no spaces at the start of a line
#42: FILE: include/linux/mmdebug.h:38:
+        } while (0)$

WARNING: Prefer [subsystem eg: netdev]_alert([subsystem]dev, ... then dev_alert(dev, ... then pr_alert(...  to printk(KERN_ALERT ...
#74: FILE: mm/debug.c:171:
+	printk(KERN_ALERT

total: 6 errors, 7 warnings, 109 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-introduce-vm_bug_on_mm.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/mmdebug.h~mm-introduce-vm_bug_on_mm-checkpatch-fixes include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-introduce-vm_bug_on_mm-checkpatch-fixes
+++ a/include/linux/mmdebug.h
@@ -30,12 +30,12 @@ void dump_mm(const struct mm_struct *mm)
 		}							\
 	} while (0)
 #define VM_BUG_ON_MM(cond, mm)						\
-        do {								\
-                if (unlikely(cond)) {					\
-                        dump_mm(mm);					\
-                        BUG();						\
-                }							\
-        } while (0)
+	do {								\
+		if (unlikely(cond)) {					\
+			dump_mm(mm);					\
+			BUG();						\
+		}							\
+	} while (0)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
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
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-fix.patch
mm-introduce-common-page-state-for-ballooned-memory-fix.patch
mm-balloon_compaction-use-common-page-ballooning-fix.patch
mm-balloon_compaction-general-cleanup-fix.patch
mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debugc-use-pr_emerg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


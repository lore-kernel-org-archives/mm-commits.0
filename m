From: akpm@linux-foundation.org
Subject: + vfs-add-super-operation-writeback_inodes-fix.patch added to -mm tree
Date: Tue, 22 Jun 2010 22:04:00 -0700
Message-ID: <201006230532.o5N5WkvW022659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab0FWFcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 01:32:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, edward.shishkin@gmail.com


The patch titled
     vfs-add-super-operation-writeback_inodes-fix
has been added to the -mm tree.  Its filename is
     vfs-add-super-operation-writeback_inodes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-add-super-operation-writeback_inodes-fix
From: Andrew Morton <akpm@linux-foundation.org>

writeback_inodes_wbc() got removed.

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |    2 +-
 include/linux/fs.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~vfs-add-super-operation-writeback_inodes-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~vfs-add-super-operation-writeback_inodes-fix
+++ a/fs/fs-writeback.c
@@ -588,6 +588,7 @@ void writeback_inodes_wb(struct bdi_writ
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
+EXPORT_SYMBOL(writeback_inodes_wb);
 
 static void __writeback_inodes_sb(struct super_block *sb,
 		struct bdi_writeback *wb, struct writeback_control *wbc)
@@ -601,7 +602,6 @@ static void __writeback_inodes_sb(struct
 	do_writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_lock);
 }
-EXPORT_SYMBOL(writeback_inodes_wbc);
 
 /*
  * The maximum number of pages to writeout in a single bdi flush/kupdate
diff -puN include/linux/fs.h~vfs-add-super-operation-writeback_inodes-fix include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-super-operation-writeback_inodes-fix
+++ a/include/linux/fs.h
@@ -2098,7 +2098,8 @@ extern int invalidate_inode_pages2_range
 extern int write_inode_now(struct inode *, int);
 extern void writeback_skip_sb_inodes(struct super_block *sb,
 				     struct bdi_writeback *wb);
-extern void writeback_inodes_wbc(struct writeback_control *wbc);
+extern void writeback_inodes_wb(struct bdi_writeback *wb,
+				struct writeback_control *wbc);
 extern int generic_writeback_sb_inodes(struct super_block *sb,
 				       struct bdi_writeback *wb,
 				       struct writeback_control *wbc,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
drivers-gpio-is-platform-neutral-fix.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
acpi-fix-bogus-preemption-logic-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


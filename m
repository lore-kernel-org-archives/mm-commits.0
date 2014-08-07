From: akpm@linux-foundation.org
Subject: [merged]
 kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:47 -0700
Message-ID: <53e3db67.Iaq5IWYqhV9C25gF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:36397 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:48 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1175220pab.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: convert printk/pr_warning to pr_foo()
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/watchdog.c: convert printk/pr_warning to pr_foo()

Replace some obsolete functions.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-convert-printk-pr_warning-to-pr_foo kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-convert-printk-pr_warning-to-pr_foo
+++ a/kernel/watchdog.c
@@ -260,9 +260,11 @@ static void watchdog_overflow_callback(s
 			return;
 
 		if (hardlockup_panic)
-			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+			panic("Watchdog detected hard LOCKUP on cpu %d",
+			      this_cpu);
 		else
-			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+			WARN(1, "Watchdog detected hard LOCKUP on cpu %d",
+			     this_cpu);
 
 		__this_cpu_write(hard_watchdog_warn, true);
 		return;
@@ -345,7 +347,7 @@ static enum hrtimer_restart watchdog_tim
 			}
 		}
 
-		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
+		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
 		print_modules();
@@ -484,7 +486,7 @@ static int watchdog_nmi_enable(unsigned
 	if (PTR_ERR(event) == -EOPNOTSUPP)
 		pr_info("disabled (cpu%i): not supported (no LAPIC?)\n", cpu);
 	else if (PTR_ERR(event) == -ENOENT)
-		pr_warning("disabled (cpu%i): hardware events not enabled\n",
+		pr_warn("disabled (cpu%i): hardware events not enabled\n",
 			 cpu);
 	else
 		pr_err("disabled (cpu%i): unable to create perf event: %ld\n",
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
fs-efs-nameic-return-is-not-a-function.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-ufs-inodec-kernel-doc-warning-fixes.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-hpfs-dnodec-fix-suspect-code-indent.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cramfs-convert-printk-to-pr_foo.patch
fs-cramfs-use-pr_fmt.patch
fs-cramfs-code-clean-up.patch
fs-cramfs-inodec-use-linux-uaccessh.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch


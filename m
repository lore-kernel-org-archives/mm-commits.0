From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 10 Sep 2010 14:48:15 -0700
Message-ID: <201009102142.o8ALgmS7004962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab0IJVmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 17:42:49 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o8ALgmnV005087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2010 14:42:48 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kvm_emulate.h |    3 ---
 fs/ocfs2/file.c                    |    3 ---
 virt/kvm/kvm_main.c                |    4 ----
 3 files changed, 10 deletions(-)

diff -puN arch/x86/include/asm/kvm_emulate.h~linux-next-git-rejects arch/x86/include/asm/kvm_emulate.h
--- a/arch/x86/include/asm/kvm_emulate.h~linux-next-git-rejects
+++ a/arch/x86/include/asm/kvm_emulate.h
@@ -157,14 +157,11 @@ struct operand {
 		unsigned long orig_val;
 		u64 orig_val64;
 	};
-<<<<<<< HEAD
 	unsigned long *ptr;
-=======
 	union {
 		unsigned long *reg;
 		unsigned long mem;
 	} addr;
->>>>>>> FETCH_HEAD
 	union {
 		unsigned long val;
 		u64 val64;
diff -puN fs/ocfs2/file.c~linux-next-git-rejects fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~linux-next-git-rejects
+++ a/fs/ocfs2/file.c
@@ -181,13 +181,10 @@ static int ocfs2_sync_file(struct file *
 	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", file, dentry, datasync,
 		   dentry->d_name.len, dentry->d_name.name);
 
-<<<<<<< HEAD
 	err = ocfs2_sync_inode(dentry->d_inode);
 	if (err)
 		goto bail;
 
-=======
->>>>>>> FETCH_HEAD
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
 		/*
 		 * We still have to flush drive's caches to get data to the
diff -puN virt/kvm/kvm_main.c~linux-next-git-rejects virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~linux-next-git-rejects
+++ a/virt/kvm/kvm_main.c
@@ -2007,13 +2007,9 @@ static int kvm_cpu_hotplug(struct notifi
 	case CPU_STARTING:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-<<<<<<< HEAD
-		hardware_enable(NULL);
-=======
 		spin_lock(&kvm_lock);
 		hardware_enable(NULL);
 		spin_unlock(&kvm_lock);
->>>>>>> FETCH_HEAD
 		break;
 	}
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
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


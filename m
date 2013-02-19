From: akpm@linux-foundation.org
Subject: + sys_prctl-coding-style-cleanup.patch added to -mm tree
Date: Tue, 19 Feb 2013 15:18:00 -0800
Message-ID: <20130219231800.92C7D5A43B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:37940 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab3BSXSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 18:18:02 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so448078ghb.5
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 15:18:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gang.chen@asianux.com, gorcunov@openvz.org, keescook@chromium.org


The patch titled
     Subject: sys_prctl(): coding-style cleanup
has been added to the -mm tree.  Its filename is
     sys_prctl-coding-style-cleanup.patch

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
Subject: sys_prctl(): coding-style cleanup

Remove a tabstop from the switch statement, in the usual fashion.  A few
instances of weirdwrapping were removed as a result.

Cc: Chen Gang <gang.chen@asianux.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |  290 ++++++++++++++++++++++++-------------------------
 1 file changed, 144 insertions(+), 146 deletions(-)

diff -puN kernel/sys.c~sys_prctl-coding-style-cleanup kernel/sys.c
--- a/kernel/sys.c~sys_prctl-coding-style-cleanup
+++ a/kernel/sys.c
@@ -2014,161 +2014,159 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 
 	error = 0;
 	switch (option) {
-		case PR_SET_PDEATHSIG:
-			if (!valid_signal(arg2)) {
-				error = -EINVAL;
-				break;
-			}
-			me->pdeath_signal = arg2;
-			break;
-		case PR_GET_PDEATHSIG:
-			error = put_user(me->pdeath_signal, (int __user *)arg2);
-			break;
-		case PR_GET_DUMPABLE:
-			error = get_dumpable(me->mm);
-			break;
-		case PR_SET_DUMPABLE:
-			if (arg2 != SUID_DUMP_DISABLE &&
-			    arg2 != SUID_DUMP_USER) {
-				error = -EINVAL;
-				break;
-			}
-			set_dumpable(me->mm, arg2);
-			break;
-
-		case PR_SET_UNALIGN:
-			error = SET_UNALIGN_CTL(me, arg2);
-			break;
-		case PR_GET_UNALIGN:
-			error = GET_UNALIGN_CTL(me, arg2);
-			break;
-		case PR_SET_FPEMU:
-			error = SET_FPEMU_CTL(me, arg2);
-			break;
-		case PR_GET_FPEMU:
-			error = GET_FPEMU_CTL(me, arg2);
-			break;
-		case PR_SET_FPEXC:
-			error = SET_FPEXC_CTL(me, arg2);
-			break;
-		case PR_GET_FPEXC:
-			error = GET_FPEXC_CTL(me, arg2);
-			break;
-		case PR_GET_TIMING:
-			error = PR_TIMING_STATISTICAL;
-			break;
-		case PR_SET_TIMING:
-			if (arg2 != PR_TIMING_STATISTICAL)
-				error = -EINVAL;
-			break;
-		case PR_SET_NAME:
-			comm[sizeof(me->comm)-1] = 0;
-			if (strncpy_from_user(comm, (char __user *)arg2,
-					      sizeof(me->comm) - 1) < 0)
-				return -EFAULT;
-			set_task_comm(me, comm);
-			proc_comm_connector(me);
-			break;
-		case PR_GET_NAME:
-			get_task_comm(comm, me);
-			if (copy_to_user((char __user *)arg2, comm,
-					 sizeof(comm)))
-				return -EFAULT;
-			break;
-		case PR_GET_ENDIAN:
-			error = GET_ENDIAN(me, arg2);
-			break;
-		case PR_SET_ENDIAN:
-			error = SET_ENDIAN(me, arg2);
-			break;
-		case PR_GET_SECCOMP:
-			error = prctl_get_seccomp();
-			break;
-		case PR_SET_SECCOMP:
-			error = prctl_set_seccomp(arg2, (char __user *)arg3);
-			break;
-		case PR_GET_TSC:
-			error = GET_TSC_CTL(arg2);
-			break;
-		case PR_SET_TSC:
-			error = SET_TSC_CTL(arg2);
-			break;
-		case PR_TASK_PERF_EVENTS_DISABLE:
-			error = perf_event_task_disable();
-			break;
-		case PR_TASK_PERF_EVENTS_ENABLE:
-			error = perf_event_task_enable();
+	case PR_SET_PDEATHSIG:
+		if (!valid_signal(arg2)) {
+			error = -EINVAL;
 			break;
-		case PR_GET_TIMERSLACK:
-			error = current->timer_slack_ns;
+		}
+		me->pdeath_signal = arg2;
+		break;
+	case PR_GET_PDEATHSIG:
+		error = put_user(me->pdeath_signal, (int __user *)arg2);
+		break;
+	case PR_GET_DUMPABLE:
+		error = get_dumpable(me->mm);
+		break;
+	case PR_SET_DUMPABLE:
+		if (arg2 != SUID_DUMP_DISABLE && arg2 != SUID_DUMP_USER) {
+			error = -EINVAL;
 			break;
-		case PR_SET_TIMERSLACK:
-			if (arg2 <= 0)
-				current->timer_slack_ns =
+		}
+		set_dumpable(me->mm, arg2);
+		break;
+
+	case PR_SET_UNALIGN:
+		error = SET_UNALIGN_CTL(me, arg2);
+		break;
+	case PR_GET_UNALIGN:
+		error = GET_UNALIGN_CTL(me, arg2);
+		break;
+	case PR_SET_FPEMU:
+		error = SET_FPEMU_CTL(me, arg2);
+		break;
+	case PR_GET_FPEMU:
+		error = GET_FPEMU_CTL(me, arg2);
+		break;
+	case PR_SET_FPEXC:
+		error = SET_FPEXC_CTL(me, arg2);
+		break;
+	case PR_GET_FPEXC:
+		error = GET_FPEXC_CTL(me, arg2);
+		break;
+	case PR_GET_TIMING:
+		error = PR_TIMING_STATISTICAL;
+		break;
+	case PR_SET_TIMING:
+		if (arg2 != PR_TIMING_STATISTICAL)
+			error = -EINVAL;
+		break;
+	case PR_SET_NAME:
+		comm[sizeof(me->comm) - 1] = 0;
+		if (strncpy_from_user(comm, (char __user *)arg2,
+				      sizeof(me->comm) - 1) < 0)
+			return -EFAULT;
+		set_task_comm(me, comm);
+		proc_comm_connector(me);
+		break;
+	case PR_GET_NAME:
+		get_task_comm(comm, me);
+		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
+			return -EFAULT;
+		break;
+	case PR_GET_ENDIAN:
+		error = GET_ENDIAN(me, arg2);
+		break;
+	case PR_SET_ENDIAN:
+		error = SET_ENDIAN(me, arg2);
+		break;
+	case PR_GET_SECCOMP:
+		error = prctl_get_seccomp();
+		break;
+	case PR_SET_SECCOMP:
+		error = prctl_set_seccomp(arg2, (char __user *)arg3);
+		break;
+	case PR_GET_TSC:
+		error = GET_TSC_CTL(arg2);
+		break;
+	case PR_SET_TSC:
+		error = SET_TSC_CTL(arg2);
+		break;
+	case PR_TASK_PERF_EVENTS_DISABLE:
+		error = perf_event_task_disable();
+		break;
+	case PR_TASK_PERF_EVENTS_ENABLE:
+		error = perf_event_task_enable();
+		break;
+	case PR_GET_TIMERSLACK:
+		error = current->timer_slack_ns;
+		break;
+	case PR_SET_TIMERSLACK:
+		if (arg2 <= 0)
+			current->timer_slack_ns =
 					current->default_timer_slack_ns;
-			else
-				current->timer_slack_ns = arg2;
-			break;
-		case PR_MCE_KILL:
-			if (arg4 | arg5)
+		else
+			current->timer_slack_ns = arg2;
+		break;
+	case PR_MCE_KILL:
+		if (arg4 | arg5)
+			return -EINVAL;
+		switch (arg2) {
+		case PR_MCE_KILL_CLEAR:
+			if (arg3 != 0)
 				return -EINVAL;
-			switch (arg2) {
-			case PR_MCE_KILL_CLEAR:
-				if (arg3 != 0)
-					return -EINVAL;
-				current->flags &= ~PF_MCE_PROCESS;
-				break;
-			case PR_MCE_KILL_SET:
-				current->flags |= PF_MCE_PROCESS;
-				if (arg3 == PR_MCE_KILL_EARLY)
-					current->flags |= PF_MCE_EARLY;
-				else if (arg3 == PR_MCE_KILL_LATE)
-					current->flags &= ~PF_MCE_EARLY;
-				else if (arg3 == PR_MCE_KILL_DEFAULT)
-					current->flags &=
-						~(PF_MCE_EARLY|PF_MCE_PROCESS);
-				else
-					return -EINVAL;
-				break;
-			default:
-				return -EINVAL;
-			}
+			current->flags &= ~PF_MCE_PROCESS;
 			break;
-		case PR_MCE_KILL_GET:
-			if (arg2 | arg3 | arg4 | arg5)
-				return -EINVAL;
-			if (current->flags & PF_MCE_PROCESS)
-				error = (current->flags & PF_MCE_EARLY) ?
-					PR_MCE_KILL_EARLY : PR_MCE_KILL_LATE;
+		case PR_MCE_KILL_SET:
+			current->flags |= PF_MCE_PROCESS;
+			if (arg3 == PR_MCE_KILL_EARLY)
+				current->flags |= PF_MCE_EARLY;
+			else if (arg3 == PR_MCE_KILL_LATE)
+				current->flags &= ~PF_MCE_EARLY;
+			else if (arg3 == PR_MCE_KILL_DEFAULT)
+				current->flags &=
+						~(PF_MCE_EARLY|PF_MCE_PROCESS);
 			else
-				error = PR_MCE_KILL_DEFAULT;
-			break;
-		case PR_SET_MM:
-			error = prctl_set_mm(arg2, arg3, arg4, arg5);
-			break;
-		case PR_GET_TID_ADDRESS:
-			error = prctl_get_tid_address(me, (int __user **)arg2);
-			break;
-		case PR_SET_CHILD_SUBREAPER:
-			me->signal->is_child_subreaper = !!arg2;
-			break;
-		case PR_GET_CHILD_SUBREAPER:
-			error = put_user(me->signal->is_child_subreaper,
-					 (int __user *) arg2);
-			break;
-		case PR_SET_NO_NEW_PRIVS:
-			if (arg2 != 1 || arg3 || arg4 || arg5)
 				return -EINVAL;
-
-			current->no_new_privs = 1;
 			break;
-		case PR_GET_NO_NEW_PRIVS:
-			if (arg2 || arg3 || arg4 || arg5)
-				return -EINVAL;
-			return current->no_new_privs ? 1 : 0;
 		default:
-			error = -EINVAL;
-			break;
+			return -EINVAL;
+		}
+		break;
+	case PR_MCE_KILL_GET:
+		if (arg2 | arg3 | arg4 | arg5)
+			return -EINVAL;
+		if (current->flags & PF_MCE_PROCESS)
+			error = (current->flags & PF_MCE_EARLY) ?
+				PR_MCE_KILL_EARLY : PR_MCE_KILL_LATE;
+		else
+			error = PR_MCE_KILL_DEFAULT;
+		break;
+	case PR_SET_MM:
+		error = prctl_set_mm(arg2, arg3, arg4, arg5);
+		break;
+	case PR_GET_TID_ADDRESS:
+		error = prctl_get_tid_address(me, (int __user **)arg2);
+		break;
+	case PR_SET_CHILD_SUBREAPER:
+		me->signal->is_child_subreaper = !!arg2;
+		break;
+	case PR_GET_CHILD_SUBREAPER:
+		error = put_user(me->signal->is_child_subreaper,
+				 (int __user *)arg2);
+		break;
+	case PR_SET_NO_NEW_PRIVS:
+		if (arg2 != 1 || arg3 || arg4 || arg5)
+			return -EINVAL;
+
+		current->no_new_privs = 1;
+		break;
+	case PR_GET_NO_NEW_PRIVS:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
+		return current->no_new_privs ? 1 : 0;
+	default:
+		error = -EINVAL;
+		break;
 	}
 	return error;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
ocfs2-remove-kfree-redundant-null-checks-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
kernel-smpc-cleanups.patch
maintainers-remove-mark-m-hoffman-fix.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-max77686-add-missing-variable-initialization-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


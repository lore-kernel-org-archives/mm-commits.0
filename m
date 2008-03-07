From: akpm@linux-foundation.org
Subject: + ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch added to -mm tree
Date: Fri, 07 Mar 2008 13:06:12 -0800
Message-ID: <200803072106.m27L6DY7017327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933110AbYCGVGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 16:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, amy.griffis@hp.com, davidm@hpl.hp.com, fenghua.yu@intel.com, seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com


The patch titled
     ia64: fix getpid and set_tid_address fast system calls for pid namespaces
has been added to the -mm tree.  Its filename is
     ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix getpid and set_tid_address fast system calls for pid namespaces
From: Pavel Emelyanov <xemul@openvz.org>

The sys_getpid() and sys_set_tid_address() behavior changed from

	return current->tgid

to

	struct pid *pid;
	pid = current->pids[PIDTYPE_PID].pid;
	return pid->numbers[pid->level].nr;

But the fast system calls on ia64 still operate the old way.  Patch them
appropriately to let ia64 work with pid namespaces.  Besides, this is one more
step in deprecating of pid and tgid on task_struct.

The fsys_getppid() is to be patched as well, but its logic is much
more complex now, so I will make it later.

One thing I'm not 100% sure is the trick with the IA64_UPID_SHIFT.  On order
to access the pid->level's element of an array I have to perform the following
calculations

	pid + sizeof(struct upid) * pid->level

The problem is that ia64 can only multiply float point registers, while all
the offsets I have in code are in rXX ones.  Fortunately, the sizeof(struct
upid) is 32 bytes on ia64 (and is very unlikely to ever change), so the
calculations get simpler:

	pid + pid->level << 5

So, I introduce the IA64_UPID_SHIFT and use the shl instruction.  I also
looked at how gcc compiles the similar place and found that it makes it with
shift as well.  Is this OK to do so?

Tested with ski emulator with 2.6.24 kernel, but fits 2.6.25-rc4 and
2.6.25-rc4-mm1 as well.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: David Mosberger-Tang <davidm@hpl.hp.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Amy Griffis <amy.griffis@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/asm-offsets.c |    7 ++++++
 arch/ia64/kernel/fsys.S        |   34 +++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/asm-offsets.c~ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces arch/ia64/kernel/asm-offsets.c
--- a/arch/ia64/kernel/asm-offsets.c~ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces
+++ a/arch/ia64/kernel/asm-offsets.c
@@ -7,6 +7,7 @@
 #define ASM_OFFSETS_C 1
 
 #include <linux/sched.h>
+#include <linux/pid.h>
 #include <linux/clocksource.h>
 
 #include <asm-ia64/processor.h>
@@ -34,6 +35,9 @@ void foo(void)
 	DEFINE(SIGFRAME_SIZE, sizeof (struct sigframe));
 	DEFINE(UNW_FRAME_INFO_SIZE, sizeof (struct unw_frame_info));
 
+	BUILD_BUG_ON(sizeof(struct upid) != 32);
+	DEFINE(IA64_UPID_SHIFT, 5);
+
 	BLANK();
 
 	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
@@ -51,6 +55,9 @@ void foo(void)
 	DEFINE(IA64_TASK_BLOCKED_OFFSET,offsetof (struct task_struct, blocked));
 	DEFINE(IA64_TASK_CLEAR_CHILD_TID_OFFSET,offsetof (struct task_struct, clear_child_tid));
 	DEFINE(IA64_TASK_GROUP_LEADER_OFFSET, offsetof (struct task_struct, group_leader));
+	DEFINE(IA64_TASK_TGIDLINK_OFFSET, offsetof (struct task_struct, pids[PIDTYPE_PID].pid));
+	DEFINE(IA64_PID_LEVEL_OFFSET, offsetof (struct pid, level));
+	DEFINE(IA64_PID_UPID_OFFSET, offsetof (struct pid, numbers[0]));
 	DEFINE(IA64_TASK_PENDING_OFFSET,offsetof (struct task_struct, pending));
 	DEFINE(IA64_TASK_PID_OFFSET, offsetof (struct task_struct, pid));
 	DEFINE(IA64_TASK_REAL_PARENT_OFFSET, offsetof (struct task_struct, real_parent));
diff -puN arch/ia64/kernel/fsys.S~ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces arch/ia64/kernel/fsys.S
--- a/arch/ia64/kernel/fsys.S~ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces
+++ a/arch/ia64/kernel/fsys.S
@@ -61,13 +61,29 @@ ENTRY(fsys_getpid)
 	.prologue
 	.altrp b6
 	.body
+	add r17=IA64_TASK_GROUP_LEADER_OFFSET,r16
+	;;
+	ld8 r17=[r17]				// r17 = current->group_leader
 	add r9=TI_FLAGS+IA64_TASK_SIZE,r16
 	;;
 	ld4 r9=[r9]
-	add r8=IA64_TASK_TGID_OFFSET,r16
+	add r17=IA64_TASK_TGIDLINK_OFFSET,r17
 	;;
 	and r9=TIF_ALLWORK_MASK,r9
-	ld4 r8=[r8]				// r8 = current->tgid
+	ld8 r17=[r17]				// r17 = current->group_leader->pids[PIDTYPE_PID].pid
+	;;
+	add r8=IA64_PID_LEVEL_OFFSET,r17
+	;;
+	ld4 r8=[r8]				// r8 = pid->level
+	add r17=IA64_PID_UPID_OFFSET,r17	// r17 = &pid->numbers[0]
+	;;
+	shl r8=r8,IA64_UPID_SHIFT
+	;;
+	add r17=r17,r8				// r17 = &pid->numbers[pid->level]
+	;;
+	ld4 r8=[r17]				// r8 = pid->numbers[pid->level].nr
+	;;
+	mov r17=0
 	;;
 	cmp.ne p8,p0=0,r9
 (p8)	br.spnt.many fsys_fallback_syscall
@@ -126,15 +142,25 @@ ENTRY(fsys_set_tid_address)
 	.altrp b6
 	.body
 	add r9=TI_FLAGS+IA64_TASK_SIZE,r16
+	add r17=IA64_TASK_TGIDLINK_OFFSET,r16
 	;;
 	ld4 r9=[r9]
 	tnat.z p6,p7=r32		// check argument register for being NaT
+	ld8 r17=[r17]				// r17 = current->pids[PIDTYPE_PID].pid
 	;;
 	and r9=TIF_ALLWORK_MASK,r9
-	add r8=IA64_TASK_PID_OFFSET,r16
+	add r8=IA64_PID_LEVEL_OFFSET,r17
 	add r18=IA64_TASK_CLEAR_CHILD_TID_OFFSET,r16
 	;;
-	ld4 r8=[r8]
+	ld4 r8=[r8]				// r8 = pid->level
+	add r17=IA64_PID_UPID_OFFSET,r17	// r17 = &pid->numbers[0]
+	;;
+	shl r8=r8,IA64_UPID_SHIFT
+	;;
+	add r17=r17,r8				// r17 = &pid->numbers[pid->level]
+	;;
+	ld4 r8=[r17]				// r8 = pid->numbers[pid->level].nr
+	;;
 	cmp.ne p8,p0=0,r9
 	mov r17=-1
 	;;
_

Patches currently in -mm which might be from xemul@openvz.org are

git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
devscontrol-avoid-magic-constants-in-drivers-base-mapc.patch
devscontrol-clean-up-get_gendisk-a-bit.patch
devscontrol-add-a-mode-on-the-struct-probe.patch
devscontrol-make-kobj_lookup-return-the-mappings-permissions.patch
devscontrol-make-use-of-permissions-returned-by-kobj_lookup.patch
devscontrol-extend-the-drivers-base-mapc-functionality.patch
devscontrol-provide-functions-to-manipulate-char-device-mappings.patch
devscontrol-provide-functions-to-manipulate-block-device-mappings.patch
devscontrol-devices-accessibility-control-group-itself.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch


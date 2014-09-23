From: akpm@linux-foundation.org
Subject: +
 coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch added to -mm tree
Date: Tue, 23 Sep 2014 16:07:17 -0700
Message-ID: <5421fd25.Zk35XzHjTxspQ3bw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIWXHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 19:07:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jan.kratochvil@redhat.com, mjw@redhat.com, mmilata@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add %i/%I in core_pattern to report the tid of the crashed thread
has been added to the -mm tree.  Its filename is
     coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: add %i/%I in core_pattern to report the tid of the crashed thread

format_corename() can only pass the leader's pid to the core handler, but
there is no simple way to figure out which thread originated the coredump.

As Jan explains, this also means that there is no simple way to create the
backtrace of the crashed process:

As programs are mostly compiled with implicit gcc -fomit-frame-pointer one
needs program's .eh_frame section (equivalently PT_GNU_EH_FRAME segment)
or .debug_frame section.  .debug_frame usually is present only in separate
debug info files usually not even installed on the system.  While
.eh_frame is a part of the executable/library (and it is even always
mapped for C++ exceptions unwinding) it no longer has to be present
anywhere on the disk as the program could be upgraded in the meantime and
the running instance has its executable file already unlinked from disk.

One possibility is to echo 0x3f >/proc/*/coredump_filter and dump all the
file-backed memory including the executable's .eh_frame section.  But that
can create huge core files, for example even due to mmapped data files.

Other possibility would be to read .eh_frame from /proc/PID/mem at the
core_pattern handler time of the core dump.  For the backtrace one needs
to read the register state first which can be done from core_pattern
handler:

	ptrace(PTRACE_SEIZE, tid, 0, PTRACE_O_TRACEEXIT)
	close(0);    // close pipe fd to resume the sleeping dumper
	waitpid();   // should report EXIT
	PTRACE_GETREGS or other requests

The remaining problem is how to get the 'tid' value of the crashed thread.
It could be read from the first NT_PRSTATUS note of the core file but
that makes the core_pattern handler complicated.

Unfortunately %t is already used so this patch uses %i/%I.

Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Martin Milata <mmilata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 ++
 fs/coredump.c                   |    8 ++++++++
 2 files changed, 10 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread
+++ a/Documentation/sysctl/kernel.txt
@@ -190,6 +190,8 @@ core_pattern is used to specify a core d
 	%%	output one '%'
 	%p	pid
 	%P	global pid (init PID namespace)
+	%i	tid
+	%I	global tid (init PID namespace)
 	%u	uid
 	%g	gid
 	%d	dump mode, matches PR_SET_DUMPABLE and
diff -puN fs/coredump.c~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread fs/coredump.c
--- a/fs/coredump.c~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread
+++ a/fs/coredump.c
@@ -199,6 +199,14 @@ static int format_corename(struct core_n
 				err = cn_printf(cn, "%d",
 					      task_tgid_nr(current));
 				break;
+			case 'i':
+				err = cn_printf(cn, "%d",
+					      task_pid_vnr(current));
+				break;
+			case 'I':
+				err = cn_printf(cn, "%d",
+					      task_pid_nr(current));
+				break;
 			/* uid */
 			case 'u':
 				err = cn_printf(cn, "%d", cred->uid);
_

Patches currently in -mm which might be from oleg@redhat.com are

fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
proc-maps-make-vm_is_stack-logic-namespace-friendly.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch


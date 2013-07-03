From: akpm@linux-foundation.org
Subject: [folded-merged]
 coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:42:09 -0700
Message-ID: <51d49ab1.ysdSHEZ6NFtjogiP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab3GCVmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walters@verbum.org, vda.linux@googlemail.com, nhorman@tuxdriver.com, mzxreary@0pointer.de, lucas.de.marchi@gmail.com, jslaby@suse.cz, andi@firstfloor.org, oleg@redhat.com

Subject: [folded-merged] coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix.patch removed from -mm tree
To: oleg@redhat.com,andi@firstfloor.org,jslaby@suse.cz,lucas.de.marchi@gmail.com,mzxreary@0pointer.de,nhorman@tuxdriver.com,vda.linux@googlemail.com,walters@verbum.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:42:09 -0700


The patch titled
     Subject: coredump: avoid the uninitialized cn->corename if core_pattern is empty
has been removed from the -mm tree.  Its filename was
     coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix.patch

This patch was dropped because it was folded into coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: avoid the uninitialized cn->corename if core_pattern is empty

If core_pattern is "" or "|", cn->corename is used uninitialized by
filp_open() or call_usermodehelper_exec().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Colin Walters <walters@verbum.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/coredump.c~coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix fs/coredump.c
--- a/fs/coredump.c~coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix
+++ a/fs/coredump.c
@@ -165,6 +165,7 @@ static int format_corename(struct core_n
 	cn->corename = NULL;
 	if (expand_corename(cn, core_name_size))
 		return -ENOMEM;
+	cn->corename[0] = '\0';
 
 	if (ispipe)
 		++pat_ptr;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
kernel-sysc-do_sysinfo-use-get_monotonic_boottime.patch
x86-kill-tif_debug.patch
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
signals-eventpoll-do-not-use-sigprocmask.patch
usermodehelper-kill-the-sub_info-path-check.patch
coredump-format_corename-can-leak-cn-corename.patch
coredump-introduce-cn_vprintf.patch
coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch
coredump-kill-cn_escape-introduce-cn_esc_printf.patch
coredump-kill-call_count-add-core_name_size.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch
fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch
exitc-unexport-__set_special_pids.patch
fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch
fs-execc-do_execve_common-use-current_user.patch
fs-execc-de_thread-mt-exec-should-update-real_start_time.patch


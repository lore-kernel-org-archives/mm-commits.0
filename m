From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-make-prctlpr_set_mm-generally-available.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:08 -0700
Message-ID: <20130507175108.81D7F31C4FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:51034 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:09 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so110856qab.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u3557@miso.sublimeip.com, gorcunov@openvz.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: make prctl(PR_SET_MM) generally available
has been removed from the -mm tree.  Its filename was
     kernel-sysc-make-prctlpr_set_mm-generally-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Amnon Shiloh <u3557@miso.sublimeip.com>
Subject: kernel/sys.c: make prctl(PR_SET_MM) generally available

The purpose of this patch is to allow privileged processes to set
their own per-memory memory-region fields:

      start_code, end_code, start_data, end_data, start_brk, brk,
      start_stack, arg_start, arg_end, env_start, env_end.

This functionality is needed by any application or package that needs to
reconstruct Linux processes, that is, to start them in any way other than
by means of an "execve()" from an executable file.  This includes:

1. Restoring processes from a checkpoint-file (by all potential
   user-level checkpointing packages, not only CRIU's).
2. Restarting processes on another node after process migration.
3. Starting duplicated copies of a running process (for reliability
   and high-availablity).
4. Starting a process from an executable format that is not supported
   by Linux, thus requiring a "manual execve" by a user-level utility.
5. Similarly, starting a process from a networked and/or crypted
   executable that, for confidentiality, licensing or other reasons,
   may not be written to the local file-systems.

The code that does that was already included in the Linux kernel by the
CRIU group, in the form of "prctl(PR_SET_MM)", but prior to this was
enclosed within their private "#ifdef CONFIG_CHECKPOINT_RESTORE", which is
normally disabled.  The patch removes those ifdefs.

Signed-off-by: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-make-prctlpr_set_mm-generally-available kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-make-prctlpr_set_mm-generally-available
+++ a/kernel/sys.c
@@ -1857,7 +1857,6 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
@@ -2051,17 +2050,12 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 {
 	return put_user(me->clear_child_tid, tid_addr);
 }

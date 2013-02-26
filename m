From: akpm@linux-foundation.org
Subject: + kernel-sysc-make-prctlpr_set_mm-generally-available.patch added to -mm tree
Date: Mon, 25 Feb 2013 16:12:31 -0800
Message-ID: <20130226001232.00E145A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:36415 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab3BZAMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 19:12:33 -0500
Received: by mail-qe0-f74.google.com with SMTP id 1so148426qee.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 16:12:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u3557@miso.sublimeip.com, gorcunov@openvz.org, xemul@parallels.com


The patch titled
     Subject: kernel/sys.c: make prctl(PR_SET_MM) generally available
has been added to the -mm tree.  Its filename is
     kernel-sysc-make-prctlpr_set_mm-generally-available.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1790,7 +1790,6 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
@@ -1984,17 +1983,12 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 {
 	return put_user(me->clear_child_tid, tid_addr);
 }

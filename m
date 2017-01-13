From: akpm@linux-foundation.org
Subject: + proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch added
 to -mm tree
Date: Fri, 13 Jan 2017 15:24:16 -0800
Message-ID: <587961a0.h9l4TskvMgou4FNT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdAMXYR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 18:24:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edumazet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-a-schedule-point-in-proc_pid_readdir-fix
has been added to the -mm tree.  Its filename is
     proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch

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
Subject: proc-add-a-schedule-point-in-proc_pid_readdir-fix

coding style fix

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir-fix fs/proc/base.c
--- a/fs/proc/base.c~proc-add-a-schedule-point-in-proc_pid_readdir-fix
+++ a/fs/proc/base.c
@@ -3179,6 +3179,7 @@ int proc_pid_readdir(struct file *file,
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
 		char name[PROC_NUMBUF];
 		int len;
+
 		cond_resched();
 		if (!has_pid_permissions(ns, iter.task, 2))
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


From: akpm@linux-foundation.org
Subject: +
 clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix.patch added to -mm tree
Date: Wed, 13 May 2015 16:29:41 -0700
Message-ID: <5553de65.0SHG/6YX+IgykO9w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338AbbEMX3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 May 2015 19:29:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix
has been added to the -mm tree.  Its filename is
     clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/kgdbts.c |    2 +-
 include/linux/sched.h |    1 +
 kernel/fork.c         |   13 ++++++-------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/misc/kgdbts.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix drivers/misc/kgdbts.c
--- a/drivers/misc/kgdbts.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix
+++ a/drivers/misc/kgdbts.c
@@ -220,7 +220,7 @@ static unsigned long lookup_addr(char *a
 	else if (!strcmp(arg, "sys_open"))
 		addr = (unsigned long)do_sys_open;
 	else if (!strcmp(arg, "do_fork"))
-		addr = (unsigned long)do_fork;
+		addr = (unsigned long)_do_fork;
 	else if (!strcmp(arg, "hw_break_val"))
 		addr = (unsigned long)&hw_break_val;
 	addr = (unsigned long) dereference_function_descriptor((void *)addr);
diff -puN include/linux/sched.h~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix include/linux/sched.h
--- a/include/linux/sched.h~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix
+++ a/include/linux/sched.h
@@ -2523,6 +2523,7 @@ extern int do_execveat(int, struct filen
 		       const char __user * const __user *,
 		       const char __user * const __user *,
 		       int);
+extern long _do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *, unsigned long);
 extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
diff -puN kernel/fork.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix kernel/fork.c
--- a/kernel/fork.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix
+++ a/kernel/fork.c
@@ -1675,13 +1675,12 @@ struct task_struct *fork_idle(int cpu)
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
  */
-static long _do_fork(
-		unsigned long clone_flags,
-		unsigned long stack_start,
-		unsigned long stack_size,
-		int __user *parent_tidptr,
-		int __user *child_tidptr,
-		unsigned long tls)
+long _do_fork(unsigned long clone_flags,
+	      unsigned long stack_start,
+	      unsigned long stack_size,
+	      int __user *parent_tidptr,
+	      int __user *child_tidptr,
+	      unsigned long tls)
 {
 	struct task_struct *p;
 	int trace = 0;
_

Patches currently in -mm which might be from josh@joshtriplett.org are

uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix.patch
make-drivers-misc-kgdbtsc-link.patch
x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch


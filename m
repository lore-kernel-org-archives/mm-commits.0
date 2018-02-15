From: akpm@linux-foundation.org
Subject: + exec-pin-stack-limit-during-exec.patch added to -mm tree
Date: Wed, 14 Feb 2018 16:02:50 -0800
Message-ID: <5a84ce2a.bKm0ASibqOCGrzR2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031901AbeBOACw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:02:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ben@decadent.org.uk, ben.hutchings@codethink.co.uk, greg@kroah.com, hughd@google.com, Jason@zx2c4.com, labbott@redhat.com, luto@kernel.org, mhocko@kernel.org, oleg@redhat.com, riel@redhat.com, spender@grsecurity.net, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: pin stack limit during exec
has been added to the -mm tree.  Its filename is
     exec-pin-stack-limit-during-exec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-pin-stack-limit-during-exec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-pin-stack-limit-during-exec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: pin stack limit during exec

Since the stack rlimit is used in multiple places during exec and it can
be changed via other threads (via setrlimit()) or processes (via
prlimit()), the assumption that the value doesn't change cannot be made. 
This leads to races with mm layout selection and argument size
calculations.  This changes the exec path to use the rlimit stored in bprm
instead of in current.  Before starting the thread, the bprm stack rlimit
is stored back to current.

Link: http://lkml.kernel.org/r/1518638796-20819-4-git-send-email-keescook@chromium.org
Fixes: 64701dee4178e ("exec: Use sane stack rlimit under secureexec")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Reported-by: Andy Lutomirski <luto@kernel.org>
Reported-by: Brad Spengler <spender@grsecurity.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |   27 +++++++++++++++------------
 include/linux/binfmts.h |    2 ++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN fs/exec.c~exec-pin-stack-limit-during-exec fs/exec.c
--- a/fs/exec.c~exec-pin-stack-limit-during-exec
+++ a/fs/exec.c
@@ -257,7 +257,7 @@ static struct page *get_arg_page(struct
 		 *    to work from.
 		 */
 		limit = _STK_LIM / 4 * 3;
-		limit = min(limit, rlimit(RLIMIT_STACK) / 4);
+		limit = min(limit, bprm->rlim_stack.rlim_cur / 4);
 		if (size > limit)
 			goto fail;
 	}
@@ -411,6 +411,11 @@ static int bprm_mm_init(struct linux_bin
 	if (!mm)
 		goto err;
 
+	/* Save current stack limit for all calculations made during exec. */
+	task_lock(current->group_leader);
+	bprm->rlim_stack = current->signal->rlim[RLIMIT_STACK];
+	task_unlock(current->group_leader);
+
 	err = __bprm_mm_init(bprm);
 	if (err)
 		goto err;
@@ -697,7 +702,7 @@ int setup_arg_pages(struct linux_binprm
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size */
-	stack_base = rlimit_max(RLIMIT_STACK);
+	stack_base = bprm->rlim_stack.rlim_max;
 	if (stack_base > STACK_SIZE_MAX)
 		stack_base = STACK_SIZE_MAX;
 
@@ -770,7 +775,7 @@ int setup_arg_pages(struct linux_binprm
 	 * Align this down to a page boundary as expand_stack
 	 * will align it up.
 	 */
-	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
+	rlim_stack = bprm->rlim_stack.rlim_cur & PAGE_MASK;
 #ifdef CONFIG_STACK_GROWSUP
 	if (stack_size + stack_expand > rlim_stack)
 		stack_base = vma->vm_start + rlim_stack;
@@ -1323,8 +1328,6 @@ EXPORT_SYMBOL(would_dump);
 
 void setup_new_exec(struct linux_binprm * bprm)
 {
-	struct rlimit rlim_stack;
-
 	/*
 	 * Once here, prepare_binrpm() will not be called any more, so
 	 * the final state of setuid/setgid/fscaps can be merged into the
@@ -1344,15 +1347,11 @@ void setup_new_exec(struct linux_binprm
 		 * RLIMIT_STACK, but after the point of no return to avoid
 		 * needing to clean up the change on failure.
 		 */
-		if (current->signal->rlim[RLIMIT_STACK].rlim_cur > _STK_LIM)
-			current->signal->rlim[RLIMIT_STACK].rlim_cur = _STK_LIM;
+		if (bprm->rlim_stack.rlim_cur > _STK_LIM)
+			bprm->rlim_stack.rlim_cur = _STK_LIM;
 	}
 
-	task_lock(current->group_leader);
-	rlim_stack = current->signal->rlim[RLIMIT_STACK];
-	task_unlock(current->group_leader);
-
-	arch_pick_mmap_layout(current->mm, &rlim_stack);
+	arch_pick_mmap_layout(current->mm, &bprm->rlim_stack);
 
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
@@ -1388,6 +1387,10 @@ EXPORT_SYMBOL(setup_new_exec);
 /* Runs immediately before start_thread() takes over. */
 void finalize_exec(struct linux_binprm *bprm)
 {
+	/* Store any stack rlimit changes before starting thread. */
+	task_lock(current->group_leader);
+	current->signal->rlim[RLIMIT_STACK] = bprm->rlim_stack;
+	task_unlock(current->group_leader);
 }
 EXPORT_SYMBOL(finalize_exec);
 
diff -puN include/linux/binfmts.h~exec-pin-stack-limit-during-exec include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-pin-stack-limit-during-exec
+++ a/include/linux/binfmts.h
@@ -61,6 +61,8 @@ struct linux_binprm {
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
+
+	struct rlimit rlim_stack; /* Saved RLIMIT_STACK used during exec. */
 } __randomize_layout;
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-pass-stack-rlimit-into-mm-layout-functions.patch
exec-introduce-finalize_exec-before-start_thread.patch
exec-pin-stack-limit-during-exec.patch


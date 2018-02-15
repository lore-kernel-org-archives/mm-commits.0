From: akpm@linux-foundation.org
Subject: + exec-introduce-finalize_exec-before-start_thread.patch added to -mm tree
Date: Wed, 14 Feb 2018 16:02:46 -0800
Message-ID: <5a84ce26.q6R0GUubFcmI3Y9k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031901AbeBOACs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:02:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ben@decadent.org.uk, ben.hutchings@codethink.co.uk, greg@kroah.com, hughd@google.com, Jason@zx2c4.com, labbott@redhat.com, luto@kernel.org, mhocko@kernel.org, oleg@redhat.com, riel@redhat.com, spender@grsecurity.net, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: introduce finalize_exec() before start_thread()
has been added to the -mm tree.  Its filename is
     exec-introduce-finalize_exec-before-start_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-introduce-finalize_exec-before-start_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-introduce-finalize_exec-before-start_thread.patch

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
Subject: exec: introduce finalize_exec() before start_thread()

Provide a final callback into fs/exec.c before start_thread() takes over,
to handle any last-minute changes, like the coming restoration of the
stack limit.

Link: http://lkml.kernel.org/r/1518638796-20819-3-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: Brad Spengler <spender@grsecurity.net>
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

 fs/binfmt_aout.c        |    1 +
 fs/binfmt_elf.c         |    1 +
 fs/binfmt_elf_fdpic.c   |    1 +
 fs/binfmt_flat.c        |    1 +
 fs/exec.c               |    6 ++++++
 include/linux/binfmts.h |    1 +
 6 files changed, 11 insertions(+)

diff -puN fs/binfmt_aout.c~exec-introduce-finalize_exec-before-start_thread fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~exec-introduce-finalize_exec-before-start_thread
+++ a/fs/binfmt_aout.c
@@ -330,6 +330,7 @@ beyond_if:
 #ifdef __alpha__
 	regs->gp = ex.a_gpvalue;
 #endif
+	finalize_exec(bprm);
 	start_thread(regs, ex.a_entry, current->mm->start_stack);
 	return 0;
 }
diff -puN fs/binfmt_elf.c~exec-introduce-finalize_exec-before-start_thread fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~exec-introduce-finalize_exec-before-start_thread
+++ a/fs/binfmt_elf.c
@@ -1167,6 +1167,7 @@ static int load_elf_binary(struct linux_
 	ELF_PLAT_INIT(regs, reloc_func_desc);
 #endif
 
+	finalize_exec(bprm);
 	start_thread(regs, elf_entry, bprm->p);
 	retval = 0;
 out:
diff -puN fs/binfmt_elf_fdpic.c~exec-introduce-finalize_exec-before-start_thread fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~exec-introduce-finalize_exec-before-start_thread
+++ a/fs/binfmt_elf_fdpic.c
@@ -463,6 +463,7 @@ static int load_elf_fdpic_binary(struct
 			    dynaddr);
 #endif
 
+	finalize_exec(bprm);
 	/* everything is now ready... get the userspace context ready to roll */
 	entryaddr = interp_params.entry_addr ?: exec_params.entry_addr;
 	start_thread(regs, entryaddr, current->mm->start_stack);
diff -puN fs/binfmt_flat.c~exec-introduce-finalize_exec-before-start_thread fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~exec-introduce-finalize_exec-before-start_thread
+++ a/fs/binfmt_flat.c
@@ -994,6 +994,7 @@ static int load_flat_binary(struct linux
 	FLAT_PLAT_INIT(regs);
 #endif
 
+	finalize_exec(bprm);
 	pr_debug("start_thread(regs=0x%p, entry=0x%lx, start_stack=0x%lx)\n",
 		 regs, start_addr, current->mm->start_stack);
 	start_thread(regs, start_addr, current->mm->start_stack);
diff -puN fs/exec.c~exec-introduce-finalize_exec-before-start_thread fs/exec.c
--- a/fs/exec.c~exec-introduce-finalize_exec-before-start_thread
+++ a/fs/exec.c
@@ -1385,6 +1385,12 @@ void setup_new_exec(struct linux_binprm
 }
 EXPORT_SYMBOL(setup_new_exec);
 
+/* Runs immediately before start_thread() takes over. */
+void finalize_exec(struct linux_binprm *bprm)
+{
+}
+EXPORT_SYMBOL(finalize_exec);
+
 /*
  * Prepare credentials and lock ->cred_guard_mutex.
  * install_exec_creds() commits the new creds and drops the lock.
diff -puN include/linux/binfmts.h~exec-introduce-finalize_exec-before-start_thread include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-introduce-finalize_exec-before-start_thread
+++ a/include/linux/binfmts.h
@@ -118,6 +118,7 @@ extern int __must_check remove_arg_zero(
 extern int search_binary_handler(struct linux_binprm *);
 extern int flush_old_exec(struct linux_binprm * bprm);
 extern void setup_new_exec(struct linux_binprm * bprm);
+extern void finalize_exec(struct linux_binprm *bprm);
 extern void would_dump(struct linux_binprm *, struct file *);
 
 extern int suid_dumpable;
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-pass-stack-rlimit-into-mm-layout-functions.patch
exec-introduce-finalize_exec-before-start_thread.patch
exec-pin-stack-limit-during-exec.patch


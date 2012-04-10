From: akpm@linux-foundation.org
Subject: + cred-copy_process-should-clear-child-replacement_session_keyring.patch added to -mm tree
Date: Tue, 10 Apr 2012 11:54:16 -0700
Message-ID: <20120410185416.E009FA032F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64856 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2DJSyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 14:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, stable@vger.kernel.org


The patch titled
     Subject: cred: copy_process() should clear child->replacement_session_keyring
has been added to the -mm tree.  Its filename is
     cred-copy_process-should-clear-child-replacement_session_keyring.patch

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
Subject: cred: copy_process() should clear child->replacement_session_keyring

keyctl_session_to_parent(task) sets ->replacement_session_keyring, it
should be processed and cleared by key_replace_session_keyring().

However, this task can fork before it notices TIF_NOTIFY_RESUME and the
new child gets the bogus ->replacement_session_keyring copied by
dup_task_struct().  This is obviously wrong and, if nothing else, this
leads to put_cred(already_freed_cred).

change copy_creds() to clear this member.  If copy_process() fails before
this point the wrong ->replacement_session_keyring doesn't matter,
exit_creds() won't be called.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cred.c~cred-copy_process-should-clear-child-replacement_session_keyring kernel/cred.c
--- a/kernel/cred.c~cred-copy_process-should-clear-child-replacement_session_keyring
+++ a/kernel/cred.c
@@ -386,6 +386,8 @@ int copy_creds(struct task_struct *p, un
 	struct cred *new;
 	int ret;
 
+	p->replacement_session_keyring = NULL;
+
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
_
Subject: Subject: cred: copy_process() should clear child->replacement_session_keyring

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
cred-copy_process-should-clear-child-replacement_session_keyring.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch


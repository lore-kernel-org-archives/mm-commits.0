From: akpm@linux-foundation.org
Subject: + keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:46:54 -0700
Message-ID: <201003262146.o2QLkssN022429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab0CZVrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au


The patch titled
     keys: don't need to use RCU in keyring_read() as semaphore is held
has been added to the -mm tree.  Its filename is
     keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: don't need to use RCU in keyring_read() as semaphore is held
From: David Howells <dhowells@redhat.com>

keyring_read() doesn't need to use rcu_dereference() to access the keyring
payload as the caller holds the key semaphore to prevent modifications
from happening whilst the data is read out.

This should solve the following warning:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
security/keys/keyring.c:204 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by keyctl/2144:
 #0:  (&key->sem){+++++.}, at: [<ffffffff81177f7c>] keyctl_read_key+0x9c/0xcf

stack backtrace:
Pid: 2144, comm: keyctl Not tainted 2.6.34-rc2-cachefs #113
Call Trace:
 [<ffffffff8105121f>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff811762d5>] keyring_read+0x4d/0xe7
 [<ffffffff81177f8c>] keyctl_read_key+0xac/0xcf
 [<ffffffff811788d4>] sys_keyctl+0x75/0xb9
 [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/keyring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/keys/keyring.c~keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held security/keys/keyring.c
--- a/security/keys/keyring.c~keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held
+++ a/security/keys/keyring.c
@@ -199,7 +199,7 @@ static long keyring_read(const struct ke
 	int loop, ret;
 
 	ret = 0;
-	klist = rcu_dereference(keyring->payload.subscriptions);
+	klist = keyring->payload.subscriptions;
 
 	if (klist) {
 		/* calculate how much data we could return */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc-make-collect_sigign_sigcatch-rcu-safe.patch
proc-make-task_sig-lockless.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


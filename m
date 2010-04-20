From: akpm@linux-foundation.org
Subject: + keys-fix-an-rcu-warning.patch added to -mm tree
Date: Tue, 20 Apr 2010 16:21:50 -0700
Message-ID: <201004202321.o3KNLoQT016341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638Ab0DTXWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Apr 2010 19:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, eric.dumazet@gmail.com


The patch titled
     keys: fix an RCU warning
has been added to the -mm tree.  Its filename is
     keys-fix-an-rcu-warning.patch

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
Subject: keys: fix an RCU warning
From: David Howells <dhowells@redhat.com>

Fix the following RCU warning:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
security/keys/request_key.c:116 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by keyctl/5372:
 #0:  (key_types_sem){.+.+.+}, at: [<ffffffff811a4e3d>] key_type_lookup+0x1c/0x70

stack backtrace:
Pid: 5372, comm: keyctl Not tainted 2.6.34-rc3-cachefs #150
Call Trace:
 [<ffffffff810515f8>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff811a9220>] call_sbin_request_key+0x156/0x2b6
 [<ffffffff811a4c66>] ? __key_instantiate_and_link+0xb1/0xdc
 [<ffffffff811a4cd3>] ? key_instantiate_and_link+0x42/0x5f
 [<ffffffff811a96b8>] ? request_key_auth_new+0x17b/0x1f3
 [<ffffffff811a8e00>] ? request_key_and_link+0x271/0x400
 [<ffffffff810aba6f>] ? kmem_cache_alloc+0xe1/0x118
 [<ffffffff811a8f1a>] request_key_and_link+0x38b/0x400
 [<ffffffff811a7b72>] sys_request_key+0xf7/0x14a
 [<ffffffff81052227>] ? trace_hardirqs_on_caller+0x10c/0x130
 [<ffffffff81393f5c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b

This was caused by doing:

	[root@andromeda ~]# keyctl newring fred @s
	539196288
	[root@andromeda ~]# keyctl request2 user a a 539196288
	request_key: Required key not available

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/request_key.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN security/keys/request_key.c~keys-fix-an-rcu-warning security/keys/request_key.c
--- a/security/keys/request_key.c~keys-fix-an-rcu-warning
+++ a/security/keys/request_key.c
@@ -68,7 +68,8 @@ static int call_sbin_request_key(struct 
 {
 	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
-	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
+	struct key *key = cons->key, *authkey = cons->authkey, *keyring,
+		*session;
 	char *argv[9], *envp[3], uid_str[12], gid_str[12];
 	char key_str[12], keyring_str[3][12];
 	char desc[20];
@@ -112,10 +113,12 @@ static int call_sbin_request_key(struct 
 	if (cred->tgcred->process_keyring)
 		prkey = cred->tgcred->process_keyring->serial;
 
-	if (cred->tgcred->session_keyring)
-		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
-	else
-		sskey = cred->user->session_keyring->serial;
+	rcu_read_lock();
+	session = rcu_dereference(cred->tgcred->session_keyring);
+	if (!session)
+		session = cred->user->session_keyring;
+	sskey = session->serial;
+	rcu_read_unlock();
 
 	sprintf(keyring_str[2], "%d", sskey);
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
keys-fix-an-rcu-warning.patch
keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-extend-gdbstub-to-support-more-features-of-gdb.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


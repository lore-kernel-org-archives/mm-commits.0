From: akpm@linux-foundation.org
Subject: [merged] keys-the-request_key-syscall-should-link-an-existing-key-to-the-dest-keyring.patch removed from -mm tree
Date: Wed, 28 Apr 2010 11:03:09 -0400
Message-ID: <201004281804.o3SI4g2A010977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203Ab0D1SE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jmorris@namei.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     keys: the request_key() syscall should link an existing key to the dest keyring
has been removed from the -mm tree.  Its filename was
     keys-the-request_key-syscall-should-link-an-existing-key-to-the-dest-keyring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: the request_key() syscall should link an existing key to the dest keyring
From: David Howells <dhowells@redhat.com>

The request_key() system call and request_key_and_link() should make a
link from an existing key to the destination keyring (if supplied), not
just from a new key to the destination keyring.

This can be tested by:

	ring=`keyctl newring fred @s`
	keyctl request2 user debug:a a
	keyctl request user debug:a $ring
	keyctl list $ring

If it says:

	keyring is empty

then it didn't work.  If it shows something like:

	1 key in keyring:
	1070462727: --alswrv     0     0 user: debug:a

then it did.

request_key() system call is meant to recursively search all your keyrings for
the key you desire, and, optionally, if it doesn't exist, call out to userspace
to create one for you.

If request_key() finds or creates a key, it should, optionally, create a link
to that key from the destination keyring specified.

Therefore, if, after a successful call to request_key() with a desination
keyring specified, you see the destination keyring empty, the code didn't work
correctly.

If you see the found key in the keyring, then it did - which is what the patch
is required for.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/request_key.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN security/keys/request_key.c~keys-the-request_key-syscall-should-link-an-existing-key-to-the-dest-keyring security/keys/request_key.c
--- a/security/keys/request_key.c~keys-the-request_key-syscall-should-link-an-existing-key-to-the-dest-keyring
+++ a/security/keys/request_key.c
@@ -339,8 +339,10 @@ static int construct_alloc_key(struct ke
 
 key_already_present:
 	mutex_unlock(&key_construction_mutex);
-	if (dest_keyring)
+	if (dest_keyring) {
+		__key_link(dest_keyring, key_ref_to_ptr(key_ref));
 		up_write(&dest_keyring->sem);
+	}
 	mutex_unlock(&user->cons_lock);
 	key_put(key);
 	*_key = key = key_ref_to_ptr(key_ref);
@@ -431,6 +433,11 @@ struct key *request_key_and_link(struct 
 
 	if (!IS_ERR(key_ref)) {
 		key = key_ref_to_ptr(key_ref);
+		if (dest_keyring) {
+			construct_get_dest_keyring(&dest_keyring);
+			key_link(dest_keyring, key);
+			key_put(dest_keyring);
+		}
 	} else if (PTR_ERR(key_ref) != -EAGAIN) {
 		key = ERR_CAST(key_ref);
 	} else  {
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
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


From: akpm@linux-foundation.org
Subject: [merged] ecryptfs-fix-lockdep-reported-ab-ba-mutex-issue.patch removed from -mm tree
Date: Tue, 21 Jul 2009 12:59:08 -0700
Message-ID: <200907211959.n6LJx8KN004312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356AbZGUT7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 15:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, kirkland@canonical.com, rolandd@cisco.com, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix lockdep-reported AB-BA mutex issue
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-lockdep-reported-ab-ba-mutex-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: fix lockdep-reported AB-BA mutex issue
From: Roland Dreier <rdreier@cisco.com>

Lockdep reports the following valid-looking possible AB-BA deadlock with
global_auth_tok_list_mutex and keysig_list_mutex:

  ecryptfs_new_file_context() ->
      ecryptfs_copy_mount_wide_sigs_to_inode_sigs() ->
          mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
          -> ecryptfs_add_keysig() ->
              mutex_lock(&crypt_stat->keysig_list_mutex);

vs

  ecryptfs_generate_key_packet_set() ->
      mutex_lock(&crypt_stat->keysig_list_mutex);
      -> ecryptfs_find_global_auth_tok_for_sig() ->
          mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);

ie the two mutexes are taken in opposite orders in the two different
code paths.  I'm not sure if this is a real bug where two threads could
actually hit the two paths in parallel and deadlock, but it at least
makes lockdep impossible to use with ecryptfs since this report triggers
every time and disables future lockdep reporting.

Since ecryptfs_add_keysig() is called only from the single callsite in
ecryptfs_copy_mount_wide_sigs_to_inode_sigs(), the simplest fix seems to
be to move the lock of keysig_list_mutex back up outside of the where
global_auth_tok_list_mutex is taken.  This patch does that, and fixes
the lockdep report on my system (and ecryptfs still works OK).

The full output of lockdep fixed by this patch is:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-2-generic #14~rbd2
-------------------------------------------------------
gdm/2640 is trying to acquire lock:
 (&mount_crypt_stat->global_auth_tok_list_mutex){+.+.+.}, at: [<ffffffff8121591e>] ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90

but task is already holding lock:
 (&crypt_stat->keysig_list_mutex){+.+.+.}, at: [<ffffffff81217728>] ecryptfs_generate_key_packet_set+0x58/0x2b0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&crypt_stat->keysig_list_mutex){+.+.+.}:
       [<ffffffff8108c897>] check_prev_add+0x2a7/0x370
       [<ffffffff8108cfc1>] validate_chain+0x661/0x750
       [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
       [<ffffffff8108d585>] lock_acquire+0xa5/0x150
       [<ffffffff815526cd>] __mutex_lock_common+0x4d/0x3d0
       [<ffffffff81552b56>] mutex_lock_nested+0x46/0x60
       [<ffffffff8121526a>] ecryptfs_add_keysig+0x5a/0xb0
       [<ffffffff81213299>] ecryptfs_copy_mount_wide_sigs_to_inode_sigs+0x59/0xb0
       [<ffffffff81214b06>] ecryptfs_new_file_context+0xa6/0x1a0
       [<ffffffff8120e42a>] ecryptfs_initialize_file+0x4a/0x140
       [<ffffffff8120e54d>] ecryptfs_create+0x2d/0x60
       [<ffffffff8113a7d4>] vfs_create+0xb4/0xe0
       [<ffffffff8113a8c4>] __open_namei_create+0xc4/0x110
       [<ffffffff8113d1c1>] do_filp_open+0xa01/0xae0
       [<ffffffff8112d8d9>] do_sys_open+0x69/0x140
       [<ffffffff8112d9f0>] sys_open+0x20/0x30
       [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mount_crypt_stat->global_auth_tok_list_mutex){+.+.+.}:
       [<ffffffff8108c675>] check_prev_add+0x85/0x370
       [<ffffffff8108cfc1>] validate_chain+0x661/0x750
       [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
       [<ffffffff8108d585>] lock_acquire+0xa5/0x150
       [<ffffffff815526cd>] __mutex_lock_common+0x4d/0x3d0
       [<ffffffff81552b56>] mutex_lock_nested+0x46/0x60
       [<ffffffff8121591e>] ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
       [<ffffffff812177d5>] ecryptfs_generate_key_packet_set+0x105/0x2b0
       [<ffffffff81212f49>] ecryptfs_write_headers_virt+0xc9/0x120
       [<ffffffff8121306d>] ecryptfs_write_metadata+0xcd/0x200
       [<ffffffff8120e44b>] ecryptfs_initialize_file+0x6b/0x140
       [<ffffffff8120e54d>] ecryptfs_create+0x2d/0x60
       [<ffffffff8113a7d4>] vfs_create+0xb4/0xe0
       [<ffffffff8113a8c4>] __open_namei_create+0xc4/0x110
       [<ffffffff8113d1c1>] do_filp_open+0xa01/0xae0
       [<ffffffff8112d8d9>] do_sys_open+0x69/0x140
       [<ffffffff8112d9f0>] sys_open+0x20/0x30
       [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by gdm/2640:
 #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8113cb8b>] do_filp_open+0x3cb/0xae0
 #1:  (&crypt_stat->keysig_list_mutex){+.+.+.}, at: [<ffffffff81217728>] ecryptfs_generate_key_packet_set+0x58/0x2b0

stack backtrace:
Pid: 2640, comm: gdm Tainted: G         C 2.6.31-2-generic #14~rbd2
Call Trace:
 [<ffffffff8108b988>] print_circular_bug_tail+0xa8/0xf0
 [<ffffffff8108c675>] check_prev_add+0x85/0x370
 [<ffffffff81094912>] ? __module_text_address+0x12/0x60
 [<ffffffff8108cfc1>] validate_chain+0x661/0x750
 [<ffffffff81017275>] ? print_context_stack+0x85/0x140
 [<ffffffff81089c68>] ? find_usage_backwards+0x38/0x160
 [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
 [<ffffffff8108d585>] lock_acquire+0xa5/0x150
 [<ffffffff8121591e>] ? ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
 [<ffffffff8108b0b0>] ? check_usage_backwards+0x0/0xb0
 [<ffffffff815526cd>] __mutex_lock_common+0x4d/0x3d0
 [<ffffffff8121591e>] ? ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
 [<ffffffff8121591e>] ? ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
 [<ffffffff8108c02c>] ? mark_held_locks+0x6c/0xa0
 [<ffffffff81125b0d>] ? kmem_cache_alloc+0xfd/0x1a0
 [<ffffffff8108c34d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff81552b56>] mutex_lock_nested+0x46/0x60
 [<ffffffff8121591e>] ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
 [<ffffffff812177d5>] ecryptfs_generate_key_packet_set+0x105/0x2b0
 [<ffffffff81212f49>] ecryptfs_write_headers_virt+0xc9/0x120
 [<ffffffff8121306d>] ecryptfs_write_metadata+0xcd/0x200
 [<ffffffff81210240>] ? ecryptfs_init_persistent_file+0x60/0xe0
 [<ffffffff8120e44b>] ecryptfs_initialize_file+0x6b/0x140
 [<ffffffff8120e54d>] ecryptfs_create+0x2d/0x60
 [<ffffffff8113a7d4>] vfs_create+0xb4/0xe0
 [<ffffffff8113a8c4>] __open_namei_create+0xc4/0x110
 [<ffffffff8113d1c1>] do_filp_open+0xa01/0xae0
 [<ffffffff8129a93e>] ? _raw_spin_unlock+0x5e/0xb0
 [<ffffffff8155410b>] ? _spin_unlock+0x2b/0x40
 [<ffffffff81139e9b>] ? getname+0x3b/0x240
 [<ffffffff81148a5a>] ? alloc_fd+0xfa/0x140
 [<ffffffff8112d8d9>] do_sys_open+0x69/0x140
 [<ffffffff81553b8f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8112d9f0>] sys_open+0x20/0x30
 [<ffffffff81013132>] system_call_fastpath+0x16/0x1b

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c   |    8 +++++---
 fs/ecryptfs/keystore.c |   11 ++++-------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-lockdep-reported-ab-ba-mutex-issue fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-lockdep-reported-ab-ba-mutex-issue
+++ a/fs/ecryptfs/crypto.c
@@ -925,7 +925,9 @@ static int ecryptfs_copy_mount_wide_sigs
 	struct ecryptfs_global_auth_tok *global_auth_tok;
 	int rc = 0;
 
+	mutex_lock(&crypt_stat->keysig_list_mutex);
 	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+
 	list_for_each_entry(global_auth_tok,
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
@@ -934,13 +936,13 @@ static int ecryptfs_copy_mount_wide_sigs
 		rc = ecryptfs_add_keysig(crypt_stat, global_auth_tok->sig);
 		if (rc) {
 			printk(KERN_ERR "Error adding keysig; rc = [%d]\n", rc);
-			mutex_unlock(
-				&mount_crypt_stat->global_auth_tok_list_mutex);
 			goto out;
 		}
 	}
-	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+
 out:
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	mutex_unlock(&crypt_stat->keysig_list_mutex);
 	return rc;
 }
 
diff -puN fs/ecryptfs/keystore.c~ecryptfs-fix-lockdep-reported-ab-ba-mutex-issue fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-fix-lockdep-reported-ab-ba-mutex-issue
+++ a/fs/ecryptfs/keystore.c
@@ -2353,21 +2353,18 @@ struct kmem_cache *ecryptfs_key_sig_cach
 int ecryptfs_add_keysig(struct ecryptfs_crypt_stat *crypt_stat, char *sig)
 {
 	struct ecryptfs_key_sig *new_key_sig;
-	int rc = 0;
 
 	new_key_sig = kmem_cache_alloc(ecryptfs_key_sig_cache, GFP_KERNEL);
 	if (!new_key_sig) {
-		rc = -ENOMEM;
 		printk(KERN_ERR
 		       "Error allocating from ecryptfs_key_sig_cache\n");
-		goto out;
+		return -ENOMEM;
 	}
 	memcpy(new_key_sig->keysig, sig, ECRYPTFS_SIG_SIZE_HEX);
-	mutex_lock(&crypt_stat->keysig_list_mutex);
+	/* Caller must hold keysig_list_mutex */
 	list_add(&new_key_sig->crypt_stat_list, &crypt_stat->keysig_list);
-	mutex_unlock(&crypt_stat->keysig_list_mutex);
-out:
-	return rc;
+
+	return 0;
 }
 
 struct kmem_cache *ecryptfs_global_auth_tok_cache;
_

Patches currently in -mm which might be from rdreier@cisco.com are

linux-next.patch
ecryptfs-another-lockdep-issue.patch


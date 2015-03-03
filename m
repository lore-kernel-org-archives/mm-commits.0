From: akpm@linux-foundation.org
Subject: +
 bug_onlockres-l_level-=-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed.patch added to -mm tree
Date: Tue, 03 Mar 2015 12:52:20 -0800
Message-ID: <54f61f04.Rb4mwIdMkkUUVW3H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbbCCUwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 15:52:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tariq.x.saeed@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: BUG_ON(lockres->l_level != DLM_LOCK_EX && !checkpointed) tripped in ocfs2_ci_checkpointed
has been added to the -mm tree.  Its filename is
     bug_onlockres-l_level-=-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bug_onlockres-l_level-%3D-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bug_onlockres-l_level-%3D-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: BUG_ON(lockres->l_level != DLM_LOCK_EX && !checkpointed) tripped in ocfs2_ci_checkpointed

Orabug: 20189959

PID: 614    TASK: ffff882a739da580  CPU: 3   COMMAND: "ocfs2dc"
 #0 [ffff882ecc3759b0] machine_kexec at ffffffff8103b35d
 #1 [ffff882ecc375a20] crash_kexec at ffffffff810b95b5
 #2 [ffff882ecc375af0] oops_end at ffffffff815091d8
 #3 [ffff882ecc375b20] die at ffffffff8101868b
 #4 [ffff882ecc375b50] do_trap at ffffffff81508bb0
 #5 [ffff882ecc375ba0] do_invalid_op at ffffffff810165e5
 #6 [ffff882ecc375c40] invalid_op at ffffffff815116fb
    [exception RIP: ocfs2_ci_checkpointed+208]
    RIP: ffffffffa0a7e940  RSP: ffff882ecc375cf0  RFLAGS: 00010002
    RAX: 0000000000000001  RBX: 000000000000654b  RCX: ffff8812dc83f1f8
    RDX: 00000000000017d9  RSI: ffff8812dc83f1f8  RDI: ffffffffa0b2c318
    RBP: ffff882ecc375d20   R8: ffff882ef6ecfa60   R9: ffff88301f272200
    R10: 0000000000000000  R11: 0000000000000000  R12: ffffffffffffffff
    R13: ffff8812dc83f4f0  R14: 0000000000000000  R15: ffff8812dc83f1f8
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff882ecc375d28] ocfs2_check_meta_downconvert at ffffffffa0a7edbd [ocfs2]
 #8 [ffff882ecc375d38] ocfs2_unblock_lock at ffffffffa0a84af8 [ocfs2]
 #9 [ffff882ecc375dc8] ocfs2_process_blocked_lock at ffffffffa0a85285 [ocfs2]
#10 [ffff882ecc375e18] ocfs2_downconvert_thread_do_work at ffffffffa0a85445 [ocfs2]
#11 [ffff882ecc375e68] ocfs2_downconvert_thread at ffffffffa0a854de [ocfs2]
#12 [ffff882ecc375ee8] kthread at ffffffff81090da7
#13 [ffff882ecc375f48] kernel_thread_helper at ffffffff81511884

assert is tripped because the tran is not checkpointed and the lock level is PR.
Following call could leave the lock in PR state, latter on causing the assert.
ocfs2_setattr -> ocfs2_acl_chmod -> ocfs2_set_acl -> ocfs2_acl_set_mode
Here is how.

1116 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
1117 {
1261         ocfs2_inode_unlock(inode, 1); <<<
..
1272         if (!status && attr->ia_valid & ATTR_MODE) {
1273                 status = ocfs2_acl_chmod(inode);

330 int ocfs2_acl_chmod(struct inode *inode)
351                 ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,

230 static int ocfs2_set_acl(handle_t *handle,
231                          struct inode *inode,
232                          struct buffer_head *di_bh,
233                          int type,
258                                 ret = ocfs2_acl_set_mode(inode, di_bh,

175 static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
176                               handle_t *handle, umode_t new_mode)
177 {
178         int ret, commit_handle = 0;
179         struct ocfs2_dinode *di;
180
181         if (di_bh == NULL) {
182                 ret = ocfs2_read_inode_block(inode, &di_bh);
183                 if (ret) {
184                         mlog_errno(ret);
185                         goto out;
186                 }
187         } else
188                 get_bh(di_bh);
189
190         if (handle == NULL) {
                    >> BUG: inode lock not held in ex at this point <<
191                 handle = ocfs2_start_trans(OCFS2_SB(inode->i_sb),

ocfs2_setattr.#1261 we unlock and at #1273 call ocfs2_acl_chmod.  When we
reach ocfs2_acl_set_mode.#191 and do trans, the inode cluster lock is not
held in EX mode (it should be).  How this could have happended?

We are the lock master, were holding lock EX and have released it in
ocfs2_setattr.#1261.  Note that there are no holders of this lock at this
point.  Another node needs the lock in PR, and we downconvert from EX to
PR.  So the inode lock is PR when do the trans in ocfs2_acl_set_mode.#191.
 The trans stays in core (not flushed to disc).  Now another node want the
lock in EX, downconvert thread gets kicked (the one that tripped assert
abovt), finds an unflushed trans but the lock is not EX (it is PR).  If
the lock was at EX, it would have flushed the trans ocfs2_ci_checkpointed
-> ocfs2_start_checkpoint before downconverting (to NULL) for the request.
 ocfs2_setattr must retain inode lock ex in this code path from.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/file.c~bug_onlockres-l_level-=-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~bug_onlockres-l_level-=-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed
+++ a/fs/ocfs2/file.c
@@ -1125,7 +1125,7 @@ out:
 
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	int status = 0, size_change;
+	int status = 0, size_change, inode_locked = 0;
 	struct inode *inode = dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
@@ -1171,6 +1171,7 @@ int ocfs2_setattr(struct dentry *dentry,
 			mlog_errno(status);
 		goto bail_unlock_rw;
 	}
+	inode_locked = 1;
 
 	if (size_change) {
 		status = inode_newsize_ok(inode, attr->ia_size);
@@ -1251,7 +1252,10 @@ int ocfs2_setattr(struct dentry *dentry,
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	ocfs2_inode_unlock(inode, 1);
+	if (status) {
+		ocfs2_inode_unlock(inode, 1);
+		inode_locked = 0;
+	}
 bail_unlock_rw:
 	if (size_change)
 		ocfs2_rw_unlock(inode, 1);
@@ -1267,6 +1271,8 @@ bail:
 		if (status < 0)
 			mlog_errno(status);
 	}
+	if (inode_locked)
+		ocfs2_inode_unlock(inode, 1);
 
 	return status;
 }
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

bug_onlockres-l_level-=-dlm_lock_ex-checkpointed-tripped-in-ocfs2_ci_checkpointed.patch


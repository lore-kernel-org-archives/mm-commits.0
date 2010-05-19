From: akpm@linux-foundation.org
Subject: [merged] ecryptfs-another-lockdep-issue.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:30 -0400
Message-ID: <201005191732.o4JHWuhL025784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215Ab0ESRdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: add lockdep annotation to s_vfs_rename_key for ecryptfs
has been removed from the -mm tree.  Its filename was
     ecryptfs-another-lockdep-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add lockdep annotation to s_vfs_rename_key for ecryptfs
From: Roland Dreier <rdreier@cisco.com>

 >  =============================================
 >  [ INFO: possible recursive locking detected ]
 >  2.6.31-2-generic #14~rbd3
 >  ---------------------------------------------
 >  firefox-3.5/4162 is trying to acquire lock:
 >   (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >
 >  but task is already holding lock:
 >   (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >
 >  other info that might help us debug this:
 >  3 locks held by firefox-3.5/4162:
 >   #0:  (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >   #1:  (&sb->s_type->i_mutex_key#11/1){+.+.+.}, at: [<ffffffff81139d5a>] lock_rename+0x6a/0xf0
 >   #2:  (&sb->s_type->i_mutex_key#11/2){+.+.+.}, at: [<ffffffff81139d6f>] lock_rename+0x7f/0xf0
 >
 >  stack backtrace:
 >  Pid: 4162, comm: firefox-3.5 Tainted: G         C 2.6.31-2-generic #14~rbd3
 >  Call Trace:
 >   [<ffffffff8108ae74>] print_deadlock_bug+0xf4/0x100
 >   [<ffffffff8108ce26>] validate_chain+0x4c6/0x750
 >   [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
 >   [<ffffffff8108d585>] lock_acquire+0xa5/0x150
 >   [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
 >   [<ffffffff815526ad>] __mutex_lock_common+0x4d/0x3d0
 >   [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
 >   [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
 >   [<ffffffff8120eaf9>] ? ecryptfs_rename+0x99/0x170
 >   [<ffffffff81552b36>] mutex_lock_nested+0x46/0x60
 >   [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >   [<ffffffff8120eb2a>] ecryptfs_rename+0xca/0x170
 >   [<ffffffff81139a9e>] vfs_rename_dir+0x13e/0x160
 >   [<ffffffff8113ac7e>] vfs_rename+0xee/0x290
 >   [<ffffffff8113c212>] ? __lookup_hash+0x102/0x160
 >   [<ffffffff8113d512>] sys_renameat+0x252/0x280
 >   [<ffffffff81133eb4>] ? cp_new_stat+0xe4/0x100
 >   [<ffffffff8101316a>] ? sysret_check+0x2e/0x69
 >   [<ffffffff8108c34d>] ? trace_hardirqs_on_caller+0x14d/0x190
 >   [<ffffffff8113d55b>] sys_rename+0x1b/0x20
 >   [<ffffffff81013132>] system_call_fastpath+0x16/0x1b

The trace above is totally reproducible by doing a cross-directory
rename on an ecryptfs directory.

The issue seems to be that sys_renameat() does lock_rename() then calls
into the filesystem; if the filesystem is ecryptfs, then
ecryptfs_rename() again does lock_rename() on the lower filesystem, and
lockdep can't tell that the two s_vfs_rename_mutexes are different.  It
seems an annotation like the following is sufficient to fix this (it
does get rid of the lockdep trace in my simple tests); however I would
like to make sure I'm not misunderstanding the locking, hence the CC
list...

Signed-off-by: Roland Dreier <rdreier@cisco.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c         |    1 +
 include/linux/fs.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/super.c~ecryptfs-another-lockdep-issue fs/super.c
--- a/fs/super.c~ecryptfs-another-lockdep-issue
+++ a/fs/super.c
@@ -96,6 +96,7 @@ static struct super_block *alloc_super(s
 		s->s_count = S_BIAS;
 		atomic_set(&s->s_active, 1);
 		mutex_init(&s->s_vfs_rename_mutex);
+		lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
 		mutex_init(&s->s_dquot.dqio_mutex);
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
diff -puN include/linux/fs.h~ecryptfs-another-lockdep-issue include/linux/fs.h
--- a/include/linux/fs.h~ecryptfs-another-lockdep-issue
+++ a/include/linux/fs.h
@@ -1741,6 +1741,7 @@ struct file_system_type {
 
 	struct lock_class_key s_lock_key;
 	struct lock_class_key s_umount_key;
+	struct lock_class_key s_vfs_rename_key;
 
 	struct lock_class_key i_lock_key;
 	struct lock_class_key i_mutex_key;
_

Patches currently in -mm which might be from rdreier@cisco.com are

linux-next.patch
vfs-o_-bit-numbers-uniqueness-check.patch


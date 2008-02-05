From: akpm@linux-foundation.org
Subject: - fix-proc-dcache-deadlock-in-do_exit.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:56 -0800
Message-ID: <200802052231.m15MVbIH012178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932317AbYBEWnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea@suse.de, adobriyan@gmail.com, ebiederm@xmission.com, jack@ucw.cz, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Fix /proc dcache deadlock in do_exit
has been removed from the -mm tree.  Its filename was
     fix-proc-dcache-deadlock-in-do_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix /proc dcache deadlock in do_exit
From: Andrea Arcangeli <andrea@suse.de>

This patch fixes a sles9 system hang in start_this_handle from a customer
with some heavy workload where all tasks are waiting on kjournald to commit
the transaction, but kjournald waits on t_updates to go down to zero (it
never does).

This was reported as a lowmem shortage deadlock but when checking the debug
data I noticed the VM wasn't under pressure at all (well it was really
under vm pressure, because lots of tasks hanged in the VM prune_dcache
methods trying to flush dirty inodes, but no task was hanging in GFP_NOFS
mode, the holder of the journal handle should have if this was a vm issue
in the first place).

No task was apparently holding the leftover handle in the committing
transaction, so I deduced t_updates was stuck to 1 because a journal_stop
was never run by some path (this turned out to be correct).  With a debug
patch adding proper reverse links and stack trace logging in ext3 deployed
in production, I found journal_stop is never run because
mark_inode_dirty_sync is called inside release_task called by do_exit. 
(that was quite fun because I would have never thought about this
subtleness, I thought a regular path in ext3 had a bug and it forgot to
call journal_stop)

do_exit->release_task->mark_inode_dirty_sync->schedule() (will never
come back to run journal_stop)

The reason is that shrink_dcache_parent is racy by design (feature not
a bug) and it can do blocking I/O in some case, but the point is that
calling shrink_dcache_parent at the last stage of do_exit isn't safe
for self-reaping tasks.

I guess the memory pressure of the unbalanced highmem system allowed
to trigger this more easily.

Now mainline doesn't have this line in iput (like sles9 has):

    	     if (inode->i_state & I_DIRTY_DELAYED)
	     			mark_inode_dirty_sync(inode);

so it will probably not crash with ext3, but for example ext2 implements an
I/O-blocking ext2_put_inode that will lead to similar screwups with
ext2_free_blocks never coming back and it's definitely wrong to call
blocking-IO paths inside do_exit.  So this should fix a subtle bug in
mainline too (not verified in practice though).  The equivalent fix for
ext3 is also not verified yet to fix the problem in sles9 but I don't have
doubt it will (it usually takes days to crash, so it'll take weeks to be
sure).

An alternate fix would be to offload that work to a kernel thread, but I
don't think a reschedule for this is worth it, the vm should be able to
collect those entries for the synchronous release_task.

Signed-off-by: Andrea Arcangeli <andrea@suse.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~fix-proc-dcache-deadlock-in-do_exit fs/proc/base.c
--- a/fs/proc/base.c~fix-proc-dcache-deadlock-in-do_exit
+++ a/fs/proc/base.c
@@ -2321,7 +2321,8 @@ static void proc_flush_task_mnt(struct v
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
-		shrink_dcache_parent(dentry);
+		if (!(current->flags & PF_EXITING))
+			shrink_dcache_parent(dentry);
 		d_drop(dentry);
 		dput(dentry);
 	}
_

Patches currently in -mm which might be from andrea@suse.de are

origin.patch
oom-add-sysctl-to-enable-task-memory-dump.patch

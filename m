From: akpm@linux-foundation.org
Subject: [merged] exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:19 -0800
Message-ID: <5489eba3.bX80pM8TkwhsnI3y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbaLKTIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, riel@redhat.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: proc: don't try to flush /proc/tgid/task/tgid
has been removed from the -mm tree.  Its filename was
     exit-proc-dont-try-to-flush-proc-tgid-task-tgid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: proc: don't try to flush /proc/tgid/task/tgid

proc_flush_task_mnt() always tries to flush task/pid, but this is
pointless if we reap the leader. d_invalidate() is recursive, and
if nothing else the next d_hash_and_lookup(tgid) should fail anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/base.c~exit-proc-dont-try-to-flush-proc-tgid-task-tgid fs/proc/base.c
--- a/fs/proc/base.c~exit-proc-dont-try-to-flush-proc-tgid-task-tgid
+++ a/fs/proc/base.c
@@ -2618,6 +2618,9 @@ static void proc_flush_task_mnt(struct v
 		dput(dentry);
 	}
 
+	if (pid == tgid)
+		return;
+
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch


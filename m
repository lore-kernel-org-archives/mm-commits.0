From: akpm@linux-foundation.org
Subject: [merged]
 exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:22 -0800
Message-ID: <5489eba6.XmWgQzHza8nmgK1s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451AbaLKTIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: fix the dead-parent PR_SET_CHILD_SUBREAPER reparenting
has been removed from the -mm tree.  Its filename was
     exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: fix the dead-parent PR_SET_CHILD_SUBREAPER reparenting

The ->has_child_subreaper code in find_new_reaper() finds alive "thread"
but returns another "reaper" thread which can be dead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting kernel/exit.c
--- a/kernel/exit.c~exit-reparent-fix-the-dead-parent-pr_set_child_subreaper-reparenting
+++ a/kernel/exit.c
@@ -512,7 +512,7 @@ static struct task_struct *find_new_reap
 			thread = reaper;
 			do {
 				if (!(thread->flags & PF_EXITING))
-					return reaper;
+					return thread;
 			} while_each_thread(reaper, thread);
 		}
 	}
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


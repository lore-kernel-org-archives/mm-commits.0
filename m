From: akpm@linux-foundation.org
Subject: [merged]
 exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:28 -0800
Message-ID: <5489ebac.72WFeVH7b30Klyqz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbaLKTI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: s/while_each_thread/for_each_thread/ in find_new_reaper()
has been removed from the -mm tree.  Its filename was
     exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: s/while_each_thread/for_each_thread/ in find_new_reaper()

Change find_new_reaper() to use for_each_thread() instead of deprecated
while_each_thread().  We do not bother to check "thread != father" in the
1st loop, we can rely on PF_EXITING check.

Note: this means the minor behavioural change: for_each_thread() starts
from the group leader.  But this should be fine, nobody should make any
assumption about do_wait(__WNOTHREAD) when it comes to reparented tasks. 
And this can avoid the pointless reparenting to a short-living thread
While zombie leaders are not that common.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper kernel/exit.c
--- a/kernel/exit.c~exit-reparent-s-while_each_thread-for_each_thread-in-find_new_reaper
+++ a/kernel/exit.c
@@ -473,8 +473,7 @@ static struct task_struct *find_new_reap
 	struct pid_namespace *pid_ns = task_active_pid_ns(father);
 	struct task_struct *thread;
 
-	thread = father;
-	while_each_thread(father, thread) {
+	for_each_thread(father, thread) {
 		if (thread->flags & PF_EXITING)
 			continue;
 		if (unlikely(pid_ns->child_reaper == father))
@@ -511,11 +510,10 @@ static struct task_struct *find_new_reap
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
-			thread = reaper;
-			do {
+			for_each_thread(reaper, thread) {
 				if (!(thread->flags & PF_EXITING))
 					return thread;
-			} while_each_thread(reaper, thread);
+			}
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


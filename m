From: akpm@linux-foundation.org
Subject: [merged]
 exit-reparent-document-the-has_child_subreaper-checks.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:08:31 -0800
Message-ID: <5489ebaf.cHzCbJSgszhXDP14%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbaLKTIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, kay@vrfy.org, lennart@poettering.net, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: document the ->has_child_subreaper checks
has been removed from the -mm tree.  Its filename was
     exit-reparent-document-the-has_child_subreaper-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: document the ->has_child_subreaper checks

Swap the "init_task" and same_thread_group() checks.  This way it is more
simple to document these checks and we can remove the link to the previous
discussion on lkml.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~exit-reparent-document-the-has_child_subreaper-checks kernel/exit.c
--- a/kernel/exit.c~exit-reparent-document-the-has_child_subreaper-checks
+++ a/kernel/exit.c
@@ -495,18 +495,16 @@ static struct task_struct *find_new_reap
 
 	if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
-
 		/*
-		 * Find the first ancestor marked as child_subreaper.
-		 * Note that the code below checks same_thread_group(reaper,
-		 * pid_ns->child_reaper).  This is what we need to DTRT in a
-		 * PID namespace. However we still need the check above, see
-		 * http://marc.info/?l=linux-kernel&m=131385460420380
+		 * Find the first ->is_child_subreaper ancestor in our pid_ns.
+		 * We start from father to ensure we can not look into another
+		 * namespace, this is safe because all its threads are dead.
 		 */
 		for (reaper = father;
-		     reaper != &init_task;
+		     !same_thread_group(reaper, pid_ns->child_reaper);
 		     reaper = reaper->real_parent) {
-			if (same_thread_group(reaper, pid_ns->child_reaper))
+			/* call_usermodehelper() descendants need this check */
+			if (reaper == &init_task)
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
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


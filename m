From: akpm@linux-foundation.org
Subject: + free_pidmap-turn-it-into-free_pidmapstruct-upid.patch added to -mm tree
Date: Sat, 16 Feb 2008 11:41:24 -0800
Message-ID: <200802161941.m1GJfOkl006702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbYBPTmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 14:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org


The patch titled
     free_pidmap: turn it into free_pidmap(struct upid *)
has been added to the -mm tree.  Its filename is
     free_pidmap-turn-it-into-free_pidmapstruct-upid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: free_pidmap: turn it into free_pidmap(struct upid *)
From: Oleg Nesterov <oleg@tv-sign.ru>

The callers of free_pidmap() pass 2 members of "struct upid", we can just
pass "struct upid *" instead.  Shaves off 10 bytes from pid.o.

Also, simplify the alloc_pid's "out_free:" error path a little bit.  This
way it looks more clear which subset of pid->numbers[] we are freeing.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc :Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN kernel/pid.c~free_pidmap-turn-it-into-free_pidmapstruct-upid kernel/pid.c
--- a/kernel/pid.c~free_pidmap-turn-it-into-free_pidmapstruct-upid
+++ a/kernel/pid.c
@@ -111,10 +111,11 @@ EXPORT_SYMBOL(is_container_init);
 
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(pidmap_lock);
 
-static void free_pidmap(struct pid_namespace *pid_ns, int pid)
+static void free_pidmap(struct upid *upid)
 {
-	struct pidmap *map = pid_ns->pidmap + pid / BITS_PER_PAGE;
-	int offset = pid & BITS_PER_PAGE_MASK;
+	int nr = upid->nr;
+	struct pidmap *map = upid->ns->pidmap + nr / BITS_PER_PAGE;
+	int offset = nr & BITS_PER_PAGE_MASK;
 
 	clear_bit(offset, map->page);
 	atomic_inc(&map->nr_free);
@@ -232,7 +233,7 @@ void free_pid(struct pid *pid)
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
 	for (i = 0; i <= pid->level; i++)
-		free_pidmap(pid->numbers[i].ns, pid->numbers[i].nr);
+		free_pidmap(pid->numbers + i);
 
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
@@ -278,8 +279,8 @@ out:
 	return pid;
 
 out_free:
-	for (i++; i <= ns->level; i++)
-		free_pidmap(pid->numbers[i].ns, pid->numbers[i].nr);
+	while (++i <= ns->level)
+		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
 	pid = NULL;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch

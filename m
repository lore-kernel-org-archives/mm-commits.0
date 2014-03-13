From: akpm@linux-foundation.org
Subject: + printk-remove-outdated-comment.patch added to -mm tree
Date: Thu, 13 Mar 2014 16:14:41 -0700
Message-ID: <53223be1.tQfF5BThLY20N+k/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaCMXOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 19:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, pmladek@suse.cz, fweisbec@gmail.com, jack@suse.cz

Subject: + printk-remove-outdated-comment.patch added to -mm tree
To: jack@suse.cz,fweisbec@gmail.com,pmladek@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 16:14:41 -0700


The patch titled
     Subject: printk: remove outdated comment
has been added to the -mm tree.  Its filename is
     printk-remove-outdated-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-remove-outdated-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-remove-outdated-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: printk: remove outdated comment

Currently, console_unlock() prints messages from kernel printk buffer to
console while the buffer is non-empty.  When serial console is attached,
printing is slow and thus other CPUs in the system have plenty of time to
append new messages to the buffer while one CPU is printing.  Thus the CPU
can spend unbounded amount of time doing printing in console_unlock(). 
This is especially serious since vprintk_emit() calls console_unlock()
with interrupts disabled.

In practice users have observed a CPU can spend tens of seconds printing
in console_unlock() (usually during boot when hundreds of SCSI devices are
discovered) resulting in RCU stalls (CPU doing printing doesn't reach
quiescent state for a long time), softlockup reports (IPIs for the
printing CPU don't get served and thus other CPUs are spinning waiting for
the printing CPU to process IPIs), and eventually a machine death (as
messages from stalls and lockups append to printk buffer faster than we
are able to print).  So these machines are unable to boot with serial
console attached.  Also during artificial stress testing SATA disk
disappears from the system because its interrupts aren't served for too
long.


This is a revised series using my new approach to the problem which
doesn't let CPU out of console_unlock() until there's someone else to take
over the printing.  The main difference since the last version is that
instead of passing printing duty to different CPUs via IPIs we use
dedicated kthreads.  This method is somewhat less reliable (in a sense
that there are more situations in which handover needn't work at all -
e.g.  when the currently printing CPU holds a spinlock and the CPU where
kthread is scheduled to run is spinning on this spinlock) but the code is
much simpler and in my practical testing kthread approach was good enough
to avoid any problems (with one exception - see below).

The patchset is organized as follows:

Patch 1 is just a cleanup which can be taken on its own (a result of my
research in kernel history ;).

Patches 2 and 3 change vprintk_emit() to call console_unlock() with
interrupts enabled so they help to reduce interrupt latency in common case
when printk() itself is called with interrupts enabled.

Patch 4 is a cleanup of printk_sched() facility from Steven.

Patch 5 is the meat of this series implementing passing of printing duty
from current CPU after printing printk.offload_chars.  We wake up a
kthread which starts spinning on console_sem to take over printing.

Patch 6 fixes lockups in one situation which I hit in my testing - if
someone calls stop_machine(), handing over of printing stops working (see
commit message for details).  If you find this too hacky, I'm ok with
dropping this patch at least for now because I'm not sure this problem can
be hit without artificially stressing the machine.



This patch (of 6):

Comment about interesting interlocking between lockbuf_lock and
console_sem is outdated.  It was added in 2002 by commit
a880f45a48be2956d2c78a839c472287d54435c1 during conversion of console_lock
to console_sem + lockbuf_lock.  At that time release_console_sem()
(today's equivalent is console_unlock()) was indeed using lockbuf_lock to
avoid races between trylock on console_sem in printk() and unlock of
console_sem.  However these days the interlocking is gone and the races
are avoided by rechecking logbuf state after releasing console_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-remove-outdated-comment kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-remove-outdated-comment
+++ a/kernel/printk/printk.c
@@ -206,8 +206,7 @@ struct printk_log {
 };
 
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters. It is also
- * used in interesting ways to provide interlocking in console_unlock();
+ * The logbuf_lock protects kmsg buffer, indices, counters.
  */
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
_

Patches currently in -mm which might be from jack@suse.cz are

backing_dev-fix-hung-task-on-sync.patch
backing_dev-fix-hung-task-on-sync-fix.patch
bdi-avoid-oops-on-device-removal.patch
kthread-ensure-locality-of-task_struct-allocations.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
ocfs2-remove-ocfs2_inode_skip_delete-flag.patch
ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
quota-provide-function-to-grab-quota-structure-reference.patch
ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch
ocfs2-revert-iput-deferring-code-in-ocfs2_drop_dentry_lock.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
printk-remove-outdated-comment.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
printk-remove-separate-printk_sched-buffers-and-use-printk-buf-instead.patch
printk-hand-over-printing-to-console-if-printing-too-long.patch
kernel-avoid-softlockups-in-stop_machine-during-heavy-printing.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch


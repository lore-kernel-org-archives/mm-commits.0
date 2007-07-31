From: akpm@linux-foundation.org
Subject: - fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:24 -0700
Message-ID: <200707312357.l6VNvOx8029394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764067AbXHAARl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix leaks on /proc/{*/sched,sched_debug,timer_list,timer_stats}
has been removed from the -mm tree.  Its filename was
     fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix leaks on /proc/{*/sched,sched_debug,timer_list,timer_stats}
From: Alexey Dobriyan <adobriyan@sw.ru>

On every open/close one struct seq_operations leaks.
Kudos to /proc/slab_allocators.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c            |    2 +-
 kernel/sched_debug.c      |    2 +-
 kernel/time/timer_list.c  |    2 +-
 kernel/time/timer_stats.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats fs/proc/base.c
--- a/fs/proc/base.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats
+++ a/fs/proc/base.c
@@ -927,7 +927,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.write		= sched_write,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 #endif
diff -puN kernel/sched_debug.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats kernel/sched_debug.c
--- a/kernel/sched_debug.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats
+++ a/kernel/sched_debug.c
@@ -200,7 +200,7 @@ static struct file_operations sched_debu
 	.open		= sched_debug_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init init_sched_debug_procfs(void)
diff -puN kernel/time/timer_list.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats
+++ a/kernel/time/timer_list.c
@@ -267,7 +267,7 @@ static struct file_operations timer_list
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init init_timer_list_procfs(void)
diff -puN kernel/time/timer_stats.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats
+++ a/kernel/time/timer_stats.c
@@ -399,7 +399,7 @@ static struct file_operations tstats_fop
 	.read		= seq_read,
 	.write		= tstats_write,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 void __init init_timer_stats(void)
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-leak-on-proc-lockdep_stats.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
single_open-seq_release-leak-diagnostics.patch

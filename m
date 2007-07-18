From: akpm@linux-foundation.org
Subject: + fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:54:02 -0700
Message-ID: <200707180054.l6I0s23I016432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757582AbXGRAyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, mingo@elte.hu, stable@kernel.org


The patch titled
     Fix leaks on /proc/{*/sched,sched_debug,timer_list,timer_stats}
has been added to the -mm tree.  Its filename is
     fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -890,7 +890,7 @@ static const struct file_operations proc
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
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch

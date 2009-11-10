From: akpm@linux-foundation.org
Subject: + oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch added to -mm tree
Date: Tue, 10 Nov 2009 13:59:04 -0800
Message-ID: <200911102159.nAALx4ds016632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758445AbZKJV7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 16:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     oom-kill: show virtual size and rss information of the killed process
has been added to the -mm tree.  Its filename is
     oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom-kill: show virtual size and rss information of the killed process
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

In a typical oom analysis scenario, we frequently want to know whether the
killed process has a memory leak or not at the first step.  This patch
adds vsz and rss information to the oom log to help this analysis.  To
save time for the debugging.

example:
===================================================================
rsyslogd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
Pid: 1308, comm: rsyslogd Not tainted 2.6.32-rc6 #24
Call Trace:
[<ffffffff8132e35b>] ?_spin_unlock+0x2b/0x40
[<ffffffff810f186e>] oom_kill_process+0xbe/0x2b0

(snip)

492283 pages non-shared
Out of memory: kill process 2341 (memhog) score 527276 or a child
Killed process 2341 (memhog) vsz:1054552kB, anon-rss:970588kB, file-rss:4kB
===========================================================================
                             ^
                             |
                            here

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process
+++ a/mm/oom_kill.c
@@ -352,6 +352,8 @@ static void dump_header(gfp_t gfp_mask, 
 		dump_tasks(mem);
 }
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 /*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
@@ -371,9 +373,16 @@ static void __oom_kill_task(struct task_
 		return;
 	}
 
-	if (verbose)
-		printk(KERN_ERR "Killed process %d (%s)\n",
-				task_pid_nr(p), p->comm);
+	if (verbose) {
+		task_lock(p);
+		printk(KERN_ERR "Killed process %d (%s) "
+		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+		       task_pid_nr(p), p->comm,
+		       K(p->mm->total_vm),
+		       K(get_mm_counter(p->mm, anon_rss)),
+		       K(get_mm_counter(p->mm, file_rss)));
+		task_unlock(p);
+	}
 
 	/*
 	 * We give our sacrificial lamb high priority and access to
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
prctl-add-pr_set_proctitle_area-option.patch
lib-introduce-strim.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


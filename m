From: akpm@linux-foundation.org
Subject: + mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix.patch added to -mm tree
Date: Tue, 25 Nov 2008 15:45:43 -0800
Message-ID: <200811252345.mAPNjhUU021223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYKYXq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 18:46:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux-foundation.org, david@fromorbit.com, peterz@infradead.org, righi.andrea@gmail.com


The patch titled
     mm: add dirty_background_bytes and dirty_bytes sysctls fix
has been added to the -mm tree.  Its filename is
     mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix.patch

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
Subject: mm: add dirty_background_bytes and dirty_bytes sysctls fix
From: David Rientjes <rientjes@google.com>

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c     |    9 +++------
 mm/page-writeback.c |    4 ++--
 2 files changed, 5 insertions(+), 8 deletions(-)

diff -puN kernel/sysctl.c~mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix kernel/sysctl.c
--- a/kernel/sysctl.c~mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix
+++ a/kernel/sysctl.c
@@ -88,10 +88,6 @@ extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 /* Constants used for minimum and  maximum */
-#if defined(CONFIG_HIGHMEM) || defined(CONFIG_DETECT_SOFTLOCKUP)
-static int one = 1;
-#endif
-
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
 static int neg_one = -1;
@@ -102,6 +98,7 @@ static int two = 2;
 #endif
 
 static int zero;
+static int one = 1;
 static int one_hundred = 100;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
@@ -956,7 +953,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_background_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
+		.extra1		= &one,
 	},
 	{
 		.ctl_name	= VM_DIRTY_RATIO,
@@ -977,7 +974,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
diff -puN mm/page-writeback.c~mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix
+++ a/mm/page-writeback.c
@@ -435,7 +435,7 @@ get_dirty_limits(unsigned long *pbackgro
 	struct task_struct *tsk;
 
 	if (vm_dirty_bytes)
-		dirty = (vm_dirty_bytes + PAGE_SIZE) / PAGE_SIZE;
+		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
 	else {
 		int dirty_ratio;
 
@@ -446,7 +446,7 @@ get_dirty_limits(unsigned long *pbackgro
 	}
 
 	if (dirty_background_bytes)
-		background = (dirty_background_bytes + PAGE_SIZE) / PAGE_SIZE;
+		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
 	else
 		background = (dirty_background_ratio * available_memory) / 100;
 
_

Patches currently in -mm which might be from rientjes@google.com are

oom-fix-zone_scan_mutex-name.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
mm-change-dirty-limit-type-specifiers-to-unsigned-long.patch
mm-add-dirty_background_bytes-and-dirty_bytes-sysctls.patch
mm-add-dirty_background_bytes-and-dirty_bytes-sysctls-fix.patch
make-get_user_pages-interruptible.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch


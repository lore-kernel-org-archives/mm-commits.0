From: akpm@linux-foundation.org
Subject: - mm-oom_kill-fix-kernel-doc.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:01 -0700
Message-ID: <200803212029.m2LKT1ZB008760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225AbYCUU3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm/oom_kill: fix kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-fix-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/oom_kill: fix kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation in oom_kill.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_kill-fix-kernel-doc mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-fix-kernel-doc
+++ a/mm/oom_kill.c
@@ -37,6 +37,7 @@ static DEFINE_SPINLOCK(zone_scan_mutex);
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
  * @uptime: current uptime in seconds
+ * @mem: target memory controller
  *
  * The formula used is relatively simple and documented inline in the
  * function. The main rationale is that we want to select a good task
@@ -264,6 +265,9 @@ static struct task_struct *select_bad_pr
 }
 
 /**
+ * dump_tasks - dump current memory state of all system tasks
+ * @mem: target memory controller
+ *
  * Dumps the current memory state of all system tasks, excluding kernel threads.
  * State information includes task's pid, uid, tgid, vm size, rss, cpu, oom_adj
  * score, and name.
@@ -298,7 +302,7 @@ static void dump_tasks(const struct mem_
 	} while_each_thread(g, p);
 }
 
-/**
+/*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
  * set.
@@ -504,6 +508,9 @@ void clear_zonelist_oom(struct zonelist 
 
 /**
  * out_of_memory - kill the "best" process when we run out of memory
+ * @zonelist: zonelist pointer
+ * @gfp_mask: memory allocation flags
+ * @order: amount of memory being requested as a power of 2
  *
  * If we run out of memory, we have the choice between either
  * killing a random task (bad), letting the system crash (worse)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch


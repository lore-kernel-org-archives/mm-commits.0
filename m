From: akpm@linux-foundation.org
Subject: - reiser4-use-helpers-to-obtain-task-pid-in-printks.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:53 -0700
Message-ID: <200710212347.l9LNlrRR000682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbXJUXzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Use helpers to obtain task pid in printks
has been removed from the -mm tree.  Its filename was
     reiser4-use-helpers-to-obtain-task-pid-in-printks.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: Use helpers to obtain task pid in printks
From: Pavel Emelyanov <xemul@openvz.org>

The task_struct->pid member is going to be deprecated, so start
using the helpers (task_pid_nr/task_pid_vnr/task_pid_nr_ns) in
the kernel.

The first thing to start with is the pid, printed to dmesg - in
this case we may safely use task_pid_nr(). Besides, printks produce
more (much more) than a half of all the explicit pid usage.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/debug.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiser4/debug.h~reiser4-use-helpers-to-obtain-task-pid-in-printks fs/reiser4/debug.h
--- a/fs/reiser4/debug.h~reiser4-use-helpers-to-obtain-task-pid-in-printks
+++ a/fs/reiser4/debug.h
@@ -15,7 +15,7 @@
 #define DCALL(lev, fun, reperr, label, format, ...)			\
 ({									\
 	fun(lev "reiser4[%.16s(%i)]: %s (%s:%i)[%s]:\n" format "\n" ,	\
-	    current->comm, current->pid, __FUNCTION__,			\
+	    current->comm, task_pid_nr(current), __FUNCTION__,		\
 	    __FILE__, __LINE__, label, ## __VA_ARGS__);			\
 })
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch

From: akpm@linux-foundation.org
Subject: + memrlimit-add-memrlimit-controller-accounting-and-control-fixes.patch added to -mm tree
Date: Fri, 19 Sep 2008 13:17:52 -0700
Message-ID: <200809192017.m8JKHqaB004781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586AbYISUaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 16:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit-add-memrlimit-controller-accounting-and-control fixes
has been added to the -mm tree.  Its filename is
     memrlimit-add-memrlimit-controller-accounting-and-control-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit-add-memrlimit-controller-accounting-and-control fixes
From: Balbir Singh <balbir@linux.vnet.ibm.com>

recover from x86 depredations.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ds.c     |   13 ++++++++++---
 arch/x86/kernel/ptrace.c |    1 -
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/ds.c~memrlimit-add-memrlimit-controller-accounting-and-control-fixes arch/x86/kernel/ds.c
--- a/arch/x86/kernel/ds.c~memrlimit-add-memrlimit-controller-accounting-and-control-fixes
+++ a/arch/x86/kernel/ds.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/memrlimitcgroup.h>
 
 
 /*
@@ -339,19 +340,22 @@ static inline void *ds_allocate_buffer(s
 
 	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
+	if (memrlimit_cgroup_charge_as(current->mm, pgsz << PAGE_SHIFT))
+		return NULL;
+
 	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
 	vm   = current->mm->total_vm  + pgsz;
 	if (rlim < vm)
-		return NULL;
+		goto uncharge;
 
 	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
 	vm   = current->mm->locked_vm  + pgsz;
 	if (rlim < vm)
-		return NULL;
+		goto uncharge;
 
 	buffer = kzalloc(size, GFP_KERNEL);
 	if (!buffer)
-		return NULL;
+		goto uncharge;
 
 	current->mm->total_vm  += pgsz;
 	current->mm->locked_vm += pgsz;
@@ -360,6 +364,9 @@ static inline void *ds_allocate_buffer(s
 		*pages = pgsz;
 
 	return buffer;
+uncharge:
+	memrlimit_cgroup_uncharge_as(current->mm, pgsz << PAGE_SHIFT);
+	return NULL;
 }
 
 static int ds_request(struct task_struct *task, void *base, size_t size,
diff -puN arch/x86/kernel/ptrace.c~memrlimit-add-memrlimit-controller-accounting-and-control-fixes arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~memrlimit-add-memrlimit-controller-accounting-and-control-fixes
+++ a/arch/x86/kernel/ptrace.c
@@ -21,7 +21,6 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
-#include <linux/memrlimitcgroup.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch


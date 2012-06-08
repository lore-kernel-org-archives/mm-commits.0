From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:30 -0700
Message-ID: <20120608194130.87278A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63827 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab2FHTlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:31 -0400
Received: by yhgm50 with SMTP id m50so249847yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com, serge.hallyn@canonical.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignment
has been removed from the -mm tree.  Its filename was
     c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignment

In b76437579d134 ("procfs: mark thread stack correctly in
proc/<pid>/maps") the stack allocated via clone() is marked in
/proc/<pid>/maps as [stack:%d] thus it might be out of the former
mm->start_stack/end_stack values (and even has some custom VMA flags set).
 So to be able to restore mm->start_stack/end_stack drop vma flags test,
but still require the underlying VMA to exist.

As always note this feature is under CONFIG_CHECKPOINT_RESTORE and
requires CAP_SYS_RESOURCE to be granted.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN kernel/sys.c~c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment
+++ a/kernel/sys.c
@@ -1786,14 +1786,6 @@ SYSCALL_DEFINE1(umask, int, mask)
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-static bool vma_flags_mismatch(struct vm_area_struct *vma,
-			       unsigned long required,
-			       unsigned long banned)
-{
-	return (vma->vm_flags & required) != required ||
-		(vma->vm_flags & banned);
-}

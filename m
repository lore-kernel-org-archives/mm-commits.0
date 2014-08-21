From: akpm@linux-foundation.org
Subject: + mm-use-may_adjust_brk-helper.patch added to -mm tree
Date: Thu, 21 Aug 2014 16:18:34 -0700
Message-ID: <53f67e4a.qx+8PunUIhxIVvKF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:48967 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbaHUXSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 19:18:36 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1697791igi.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 16:18:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com, jln@google.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use may_adjust_brk helper
has been added to the -mm tree.  Its filename is
     mm-use-may_adjust_brk-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-may_adjust_brk-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-may_adjust_brk-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: use may_adjust_brk helper

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   11 ++++-------
 mm/mmap.c    |    7 +++----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff -puN kernel/sys.c~mm-use-may_adjust_brk-helper kernel/sys.c
--- a/kernel/sys.c~mm-use-may_adjust_brk-helper
+++ a/kernel/sys.c
@@ -1693,7 +1693,6 @@ exit:
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
-	unsigned long rlim = rlimit(RLIMIT_DATA);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int error;
@@ -1733,9 +1732,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (mm->brk - addr) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (check_data_rlimit(rlimit(RLIMIT_DATA), mm->brk, addr,
+				      mm->end_data, mm->start_data))
 			goto out;
 
 		mm->start_brk = addr;
@@ -1745,9 +1743,8 @@ static int prctl_set_mm(int opt, unsigne
 		if (addr <= mm->end_data)
 			goto out;
 
-		if (rlim < RLIM_INFINITY &&
-		    (addr - mm->start_brk) +
-		    (mm->end_data - mm->start_data) > rlim)
+		if (check_data_rlimit(rlimit(RLIMIT_DATA), addr, mm->start_brk,
+				      mm->end_data, mm->start_data))
 			goto out;
 
 		mm->brk = addr;
diff -puN mm/mmap.c~mm-use-may_adjust_brk-helper mm/mmap.c
--- a/mm/mmap.c~mm-use-may_adjust_brk-helper
+++ a/mm/mmap.c
@@ -268,7 +268,7 @@ static unsigned long do_brk(unsigned lon
 
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
-	unsigned long rlim, retval;
+	unsigned long retval;
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
 	unsigned long min_brk;
@@ -298,9 +298,8 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * segment grow beyond its set limit the in case where the limit is
 	 * not page aligned -Ram Gupta
 	 */
-	rlim = rlimit(RLIMIT_DATA);
-	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
-			(mm->end_data - mm->start_data) > rlim)
+	if (check_data_rlimit(rlimit(RLIMIT_DATA), brk, mm->start_brk,
+			      mm->end_data, mm->start_data))
 		goto out;
 
 	newbrk = PAGE_ALIGN(brk);
_

Patches currently in -mm which might be from gorcunov@openvz.org are

mm-introduce-check_data_rlimit-helper-v2.patch
mm-use-may_adjust_brk-helper.patch
prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch


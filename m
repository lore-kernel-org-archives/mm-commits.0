From: akpm@linux-foundation.org
Subject: [folded] c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 17:00:22 -0800
Message-ID: <20120113010022.C4EB620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39314 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab2AMBA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 20:00:26 -0500
Received: by werg1 with SMTP id g1so93wer.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 17:00:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avagin@openvz.org, gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

This patch was dropped because it was folded into c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix

cache current->mm in a local, saving 200 bytes text

Cc: Andrew Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff -puN kernel/sys.c~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix
+++ a/kernel/sys.c
@@ -1701,6 +1701,7 @@ static int prctl_set_mm(int opt, unsigne
 	unsigned long vm_bad_flags;
 	struct vm_area_struct *vma;
 	int error = 0;
+	struct mm_struct *mm = current->mm;
 
 	if (arg4 | arg5)
 		return -EINVAL;
@@ -1711,8 +1712,8 @@ static int prctl_set_mm(int opt, unsigne
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, addr);
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, addr);
 
 	if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
 		/* It must be existing VMA */
@@ -1732,9 +1733,9 @@ static int prctl_set_mm(int opt, unsigne
 			goto out;
 
 		if (opt == PR_SET_MM_START_CODE)
-			current->mm->start_code = addr;
+			mm->start_code = addr;
 		else
-			current->mm->end_code = addr;
+			mm->end_code = addr;
 		break;
 
 	case PR_SET_MM_START_DATA:
@@ -1747,9 +1748,9 @@ static int prctl_set_mm(int opt, unsigne
 			goto out;
 
 		if (opt == PR_SET_MM_START_DATA)
-			current->mm->start_data = addr;
+			mm->start_data = addr;
 		else
-			current->mm->end_data = addr;
+			mm->end_data = addr;
 		break;
 
 	case PR_SET_MM_START_STACK:
@@ -1762,31 +1763,31 @@ static int prctl_set_mm(int opt, unsigne
 		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
 			goto out;
 
-		current->mm->start_stack = addr;
+		mm->start_stack = addr;
 		break;
 
 	case PR_SET_MM_START_BRK:
-		if (addr <= current->mm->end_data)
+		if (addr <= mm->end_data)
 			goto out;
 
 		if (rlim < RLIM_INFINITY &&
-		    (current->mm->brk - addr) +
-		    (current->mm->end_data - current->mm->start_data) > rlim)
+		    (mm->brk - addr) +
+		    (mm->end_data - mm->start_data) > rlim)
 			goto out;
 
-		current->mm->start_brk = addr;
+		mm->start_brk = addr;
 		break;
 
 	case PR_SET_MM_BRK:
-		if (addr <= current->mm->end_data)
+		if (addr <= mm->end_data)
 			goto out;
 
 		if (rlim < RLIM_INFINITY &&
-		    (addr - current->mm->start_brk) +
-		    (current->mm->end_data - current->mm->start_data) > rlim)
+		    (addr - mm->start_brk) +
+		    (mm->end_data - mm->start_data) > rlim)
 			goto out;
 
-		current->mm->brk = addr;
+		mm->brk = addr;
 		break;
 
 	default:
@@ -1797,7 +1798,7 @@ static int prctl_set_mm(int opt, unsigne
 	error = 0;
 
 out:
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 
 	return error;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch


From: akpm@linux-foundation.org
Subject: + c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch added to -mm tree
Date: Mon, 12 Dec 2011 13:54:14 -0800
Message-ID: <201112122154.pBCLsFQH030418@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:63409 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1LLVyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 16:54:17 -0500
Received: by mail-gx0-f202.google.com with SMTP id v2so358649ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 13:54:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avagin@openvz.org, gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix
has been added to the -mm tree.  Its filename is
     c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

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
Subject: Subject: c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


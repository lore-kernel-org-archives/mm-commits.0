From: akpm@linux-foundation.org
Subject: [folded-merged] mm-per-thread-vma-caching-fix-6-fix.patch removed from -mm tree
Date: Mon, 07 Apr 2014 15:04:48 -0700
Message-ID: <53432100.sKANvhCbl4Xtpfv1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaDGWEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, torvalds@linux-foundation.org, riel@redhat.com, oleg@redhat.com, hughd@google.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-per-thread-vma-caching-fix-6-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,hughd@google.com,oleg@redhat.com,riel@redhat.com,torvalds@linux-foundation.org,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:04:48 -0700


The patch titled
     Subject: mm-per-thread-vma-caching-fix-6-fix
has been removed from the -mm tree.  Its filename was
     mm-per-thread-vma-caching-fix-6-fix.patch

This patch was dropped because it was folded into mm-per-thread-vma-caching.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-per-thread-vma-caching-fix-6-fix

adjust and enhance comments

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/vmacache.c~mm-per-thread-vma-caching-fix-6-fix mm/vmacache.c
--- a/mm/vmacache.c~mm-per-thread-vma-caching-fix-6-fix
+++ a/mm/vmacache.c
@@ -31,6 +31,15 @@ void vmacache_flush_all(struct mm_struct
 	rcu_read_unlock();
 }
 
+/*
+ * This task may be accessing a foreign mm via (for example)
+ * get_user_pages()->find_vma().  The vmacache is task-local and this
+ * task's vmacache pertains to a different mm (ie, its own).  There is
+ * nothing we can do here.
+ *
+ * Also handle the case where a kernel thread has adopted this mm via use_mm().
+ * That kernel thread's vmacache is not applicable to this mm.
+ */
 static bool vmacache_valid_mm(struct mm_struct *mm)
 {
 	return current->mm == mm && !(current->flags & PF_KTHREAD);
@@ -46,12 +55,6 @@ static bool vmacache_valid(struct mm_str
 {
 	struct task_struct *curr;
 
-	/*
-	 * This task may be accessing a foreign mm via (for example)
-	 * get_user_pages()->find_vma().  The vmacache is task-local and this
-	 * task's vmacache pertains to a different mm (ie, its own).  There is
-	 * nothing we can do here.
-	 */
 	if (!vmacache_valid_mm(mm))
 		return false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch


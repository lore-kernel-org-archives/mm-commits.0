From: akpm@linux-foundation.org
Subject: + mm-export-get_vma_policy.patch added to -mm tree
Date: Wed, 04 May 2011 16:10:29 -0700
Message-ID: <201105042310.p44NAUNs020293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab1EDXKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 19:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com


The patch titled
     mm: export get_vma_policy()
has been added to the -mm tree.  Its filename is
     mm-export-get_vma_policy.patch

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
Subject: mm: export get_vma_policy()
From: Stephen Wilson <wilsons@start.ca>

Recently a concern was raised[1] that performing an allocation while
holding a reference on a tasks mm could lead to a stalemate in the oom
killer.  The concern was specific to the goings-on in /proc.  Hugh Dickins
stated the issue thusly:

    ...imagine what happens if the system is out of memory, and the mm
    we're looking at is selected for killing by the OOM killer: while we
    wait in __get_free_page for more memory, no memory is freed from the
    selected mm because it cannot reach exit_mmap while we hold that
    reference.

The primary goal of this series is to eliminate repeated allocation/free
cycles currently happening in show_numa_maps() while we hold a reference
to an mm.

The strategy is to perform the allocation once when /proc/pid/numa_maps is
opened, before a reference on the target tasks mm is taken.

Unfortunately, show_numa_maps() is implemented in mm/mempolicy.c while the
primary procfs implementation lives in fs/proc/task_mmu.c.  This makes
clean cooperation between show_numa_maps() and the other seq_file
operations (start(), stop(), etc) difficult.


Patches 1-5 convert show_numa_maps() to use the generic walk_page_range()
functionality instead of the mempolicy.c specific page table walking
logic.  Also, get_vma_policy() is exported.  This makes the
show_numa_maps() implementation independent of mempolicy.c.  

Patch 6 moves show_numa_maps() and supporting routines over to
fs/proc/task_mmu.c.

Finally, patches 7 and 8 provide minor cleanup and eliminates the
troublesome allocation.

 
Please note that moving show_numa_maps() into fs/proc/task_mmu.c
essentially reverts 1a75a6c825 ("Fold numa_maps into mempolicies.c") and
48fce3429d ("mempolicies: unexport get_vma_policy()").  Also, please see
the discussion at [2].  My main justifications for moving the code back
into task_mmu.c is:

  - Having the show() operation "miles away" from the corresponding
    seq_file iteration operations is a maintenance burden. 
    
  - The need to export ad hoc info like struct proc_maps_private is
    eliminated.


This patch:

In commit 48fce3429df84a ("mempolicies: unexport get_vma_policy()")
get_vma_policy() was marked static as all clients were local to
mempolicy.c.

However, the decision to generate /proc/pid/numa_maps in the numa memory
policy code and outside the procfs subsystem introduces an artificial
interdependency between the two systems.  Exporting get_vma_policy() once
again is the first step to clean up this interdependency.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    3 +++
 mm/mempolicy.c            |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~mm-export-get_vma_policy include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-export-get_vma_policy
+++ a/include/linux/mempolicy.h
@@ -199,6 +199,9 @@ void mpol_free_shared_policy(struct shar
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    unsigned long idx);
 
+struct mempolicy *get_vma_policy(struct task_struct *tsk,
+		struct vm_area_struct *vma, unsigned long addr);
+
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
diff -puN mm/mempolicy.c~mm-export-get_vma_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-export-get_vma_policy
+++ a/mm/mempolicy.c
@@ -1489,7 +1489,7 @@ asmlinkage long compat_sys_mbind(compat_
  * freeing by another task.  It is the caller's responsibility to free the
  * extra reference for shared policies.
  */
-static struct mempolicy *get_vma_policy(struct task_struct *task,
+struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mempolicy *pol = task->mempolicy;
_

Patches currently in -mm which might be from wilsons@start.ca are

mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch


From: akpm@linux-foundation.org
Subject: + x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch added to -mm tree
Date: Wed, 01 Aug 2012 15:28:20 -0700
Message-ID: <20120801222820.D905A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59553 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab2HAW2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 18:28:23 -0400
Received: by obbwc20 with SMTP id wc20so5494219obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 15:28:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, khlebnikov@openvz.org, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pfn vma routines
has been added to the -mm tree.  Its filename is
     x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pfn vma routines

'pfn' argument for track_pfn_vma_new() can be used for reserving the
attribute for the pfn range.  No need to depend on 'vm_pgoff'

Similarly, untrack_pfn_vma() can depend on the 'pfn' argument if it is
non-zero or can use follow_phys() to get the starting value of the pfn
range.

Also the non zero 'size' argument can be used instead of recomputing it
from vma.

This cleanup also prepares the ground for the track/untrack pfn vma
routines to take over the ownership of setting PAT specific vm_flag in the
'vma'.

[khlebnikov@openvz.org: Clear pfn to paddr conversion]
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff -puN arch/x86/mm/pat.c~x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines
+++ a/arch/x86/mm/pat.c
@@ -704,21 +704,18 @@ int track_pfn_vma_copy(struct vm_area_st
 int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t *prot,
 			unsigned long pfn, unsigned long size)
 {
+	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	unsigned long flags;
-	resource_size_t paddr;
-	unsigned long vma_size = vma->vm_end - vma->vm_start;
 
-	if (is_linear_pfn_mapping(vma)) {
-		/* reserve the whole chunk starting from vm_pgoff */
-		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot, 0);
-	}
+	/* reserve the whole chunk starting from paddr */
+	if (is_linear_pfn_mapping(vma))
+		return reserve_pfn_range(paddr, size, prot, 0);
 
 	if (!pat_enabled)
 		return 0;
 
 	/* for vm_insert_pfn and friends, we set prot based on lookup */
-	flags = lookup_memtype(pfn << PAGE_SHIFT);
+	flags = lookup_memtype(paddr);
 	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
 			 flags);
 
@@ -728,20 +725,28 @@ int track_pfn_vma_new(struct vm_area_str
 /*
  * untrack_pfn_vma is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
- * can be for the entire vma (in which case size can be zero).
+ * can be for the entire vma (in which case pfn, size are zero).
  */
 void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size)
 {
 	resource_size_t paddr;
-	unsigned long vma_size = vma->vm_end - vma->vm_start;
+	unsigned long prot;
 
-	if (is_linear_pfn_mapping(vma)) {
-		/* free the whole chunk starting from vm_pgoff */
-		paddr = (resource_size_t)vma->vm_pgoff << PAGE_SHIFT;
-		free_pfn_range(paddr, vma_size);
+	if (!is_linear_pfn_mapping(vma))
 		return;
+
+	/* free the chunk starting from pfn or the whole chunk */
+	paddr = (resource_size_t)pfn << PAGE_SHIFT;
+	if (!paddr && !size) {
+		if (follow_phys(vma, vma->vm_start, 0, &prot, &paddr)) {
+			WARN_ON_ONCE(1);
+			return;
+		}
+
+		size = vma->vm_end - vma->vm_start;
 	}
+	free_pfn_range(paddr, size);
 }
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch


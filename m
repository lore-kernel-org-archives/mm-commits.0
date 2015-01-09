From: akpm@linux-foundation.org
Subject: + mm-numa-add-paranoid-check-around-pte_protnone_numa.patch added to -mm tree
Date: Fri, 09 Jan 2015 14:59:18 -0800
Message-ID: <54b05d46.yiAMLOkphVcEibW5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbbAIW7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:59:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: add paranoid check around pte_protnone_numa
has been added to the -mm tree.  Its filename is
     mm-numa-add-paranoid-check-around-pte_protnone_numa.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-add-paranoid-check-around-pte_protnone_numa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: add paranoid check around pte_protnone_numa

pte_protnone_numa is only safe to use after VMA checks for PROT_NONE are
complete.  Treating a real PROT_NONE PTE as a NUMA hinting fault is going
to result in strangeness so add a check for it.  BUG_ON looks like
overkill but if this is hit then it's a serious bug that could result in
corruption so do not even try recovering.  It would have been more
comprehensive to check VMA flags in pte_protnone_numa but it would have
made the API ugly just for a debugging check.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 mm/memory.c      |    3 +++
 2 files changed, 6 insertions(+)

diff -puN mm/huge_memory.c~mm-numa-add-paranoid-check-around-pte_protnone_numa mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-add-paranoid-check-around-pte_protnone_numa
+++ a/mm/huge_memory.c
@@ -1268,6 +1268,9 @@ int do_huge_pmd_numa_page(struct mm_stru
 	bool migrated = false;
 	int flags = 0;
 
+	/* A PROT_NONE fault should not end up here */
+	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
+
 	ptl = pmd_lock(mm, pmdp);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
diff -puN mm/memory.c~mm-numa-add-paranoid-check-around-pte_protnone_numa mm/memory.c
--- a/mm/memory.c~mm-numa-add-paranoid-check-around-pte_protnone_numa
+++ a/mm/memory.c
@@ -3010,6 +3010,9 @@ static int do_numa_page(struct mm_struct
 	bool migrated = false;
 	int flags = 0;
 
+	/* A PROT_NONE fault should not end up here */
+	BUG_ON(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)));
+
 	/*
 	* The "pte" at this point cannot be used safely without
 	* validation through pte_unmap_same(). It's of NUMA type but
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
do_shared_fault-check-that-mmap_sem-is-held.patch


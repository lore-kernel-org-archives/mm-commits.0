From: akpm@linux-foundation.org
Subject: +
 mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch added to -mm tree
Date: Fri, 09 Jan 2015 14:59:20 -0800
Message-ID: <54b05d48.h7SooF9F0xlk1+Pi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbbAIW7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:59:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: avoid unnecessary TLB flushes when setting NUMA hinting entries
has been added to the -mm tree.  Its filename is
     mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch

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
Subject: mm: numa: avoid unnecessary TLB flushes when setting NUMA hinting entries

If a PTE or PMD is already marked NUMA when scanning to mark entries for
NUMA hinting then it is not necessary to update the entry and incur a TLB
flush penalty.  Avoid the avoidhead where possible.

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

 mm/huge_memory.c |   14 ++++++++------
 mm/mprotect.c    |    4 ++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries
+++ a/mm/huge_memory.c
@@ -1519,12 +1519,14 @@ int change_huge_pmd(struct vm_area_struc
 			return 0;
 		}
 
-		ret = 1;
-		entry = pmdp_get_and_clear_notify(mm, addr, pmd);
-		entry = pmd_modify(entry, newprot);
-		ret = HPAGE_PMD_NR;
-		set_pmd_at(mm, addr, pmd, entry);
-		BUG_ON(pmd_write(entry));
+		if (!prot_numa || !pmd_protnone(*pmd)) {
+			ret = 1;
+			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
+			entry = pmd_modify(entry, newprot);
+			ret = HPAGE_PMD_NR;
+			set_pmd_at(mm, addr, pmd, entry);
+			BUG_ON(pmd_write(entry));
+		}
 		spin_unlock(ptl);
 	}
 
diff -puN mm/mprotect.c~mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries
+++ a/mm/mprotect.c
@@ -86,6 +86,10 @@ static unsigned long change_pte_range(st
 				page = vm_normal_page(vma, addr, oldpte);
 				if (!page || PageKsm(page))
 					continue;
+
+				/* Avoid TLB flush if possible */
+				if (pte_protnone(oldpte))
+					continue;
 			}
 
 			ptent = ptep_modify_prot_start(mm, addr, pte);
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


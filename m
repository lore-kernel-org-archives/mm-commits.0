From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:19:39 -0800
Message-ID: <54de5c5b./4+mSweETKciJMIf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbBMUTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: avoid unnecessary TLB flushes when setting NUMA hinting entries
has been removed from the -mm tree.  Its filename was
     mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1493,12 +1493,14 @@ int change_huge_pmd(struct vm_area_struc
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

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
do_shared_fault-check-that-mmap_sem-is-held.patch


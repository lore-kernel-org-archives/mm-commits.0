From: akpm@linux-foundation.org
Subject: [merged] x86-mm-restore-original-pte_special-check.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:19:33 -0800
Message-ID: <54de5c55.SQ0avBDcCki0pzo9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbBMUTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: mm: restore original pte_special check
has been removed from the -mm tree.  Its filename was
     x86-mm-restore-original-pte_special-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: mm: restore original pte_special check

Commit b38af4721f59 ("x86,mm: fix pte_special versus pte_numa") adjusted
the pte_special check to take into account that a special pte had SPECIAL
and neither PRESENT nor PROTNONE.  Now that NUMA hinting PTEs are no
longer modifying _PAGE_PRESENT it should be safe to restore the original
pte_special behaviour.

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

 arch/x86/include/asm/pgtable.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~x86-mm-restore-original-pte_special-check arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-mm-restore-original-pte_special-check
+++ a/arch/x86/include/asm/pgtable.h
@@ -132,13 +132,7 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	/*
-	 * See CONFIG_NUMA_BALANCING pte_numa in include/asm-generic/pgtable.h.
-	 * On x86 we have _PAGE_BIT_NUMA == _PAGE_BIT_GLOBAL+1 ==
-	 * __PAGE_BIT_SOFTW1 == _PAGE_BIT_SPECIAL.
-	 */
-	return (pte_flags(pte) & _PAGE_SPECIAL) &&
-		(pte_flags(pte) & (_PAGE_PRESENT|_PAGE_PROTNONE));
+	return pte_flags(pte) & _PAGE_SPECIAL;
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
do_shared_fault-check-that-mmap_sem-is-held.patch


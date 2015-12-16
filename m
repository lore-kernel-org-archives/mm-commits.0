From: akpm@linux-foundation.org
Subject: +
 mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch added
 to -mm tree
Date: Tue, 15 Dec 2015 16:16:41 -0800
Message-ID: <5670ad69.EEAb6SeIeeanqg8w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbbLPAQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, jmoyer@redhat.com, toshi.kani@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: fix livelock, allow dax pmd mappings to become writeable
has been added to the -mm tree.  Its filename is
     mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: mm, dax: fix livelock, allow dax pmd mappings to become writeable

Prior to this change DAX PMD mappings that were made read-only were never
able to be made writable again.  This is because the code in
insert_pfn_pmd() that calls pmd_mkdirty() and pmd_mkwrite() would skip
these calls if the PMD already existed in the page table.

Instead, if we are doing a write always mark the PMD entry as dirty and
writeable.  Without this code we can get into a condition where we mark
the PMD as read-only, and then on a subsequent write fault we get into an
infinite loop of PMD faults where we try unsuccessfully to make the PMD
writeable.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/huge_memory.c~mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable
+++ a/mm/huge_memory.c
@@ -967,15 +967,13 @@ static void insert_pfn_pmd(struct vm_are
 	spinlock_t *ptl;
 
 	ptl = pmd_lock(mm, pmd);
-	if (pmd_none(*pmd)) {
-		entry = pmd_mkhuge(pfn_pmd(pfn, prot));
-		if (write) {
-			entry = pmd_mkyoung(pmd_mkdirty(entry));
-			entry = maybe_pmd_mkwrite(entry, vma);
-		}
-		set_pmd_at(mm, addr, pmd, entry);
-		update_mmu_cache_pmd(vma, addr, pmd);
+	entry = pmd_mkhuge(pfn_pmd(pfn, prot));
+	if (write) {
+		entry = pmd_mkyoung(pmd_mkdirty(entry));
+		entry = maybe_pmd_mkwrite(entry, vma);
 	}
+	set_pmd_at(mm, addr, pmd, entry);
+	update_mmu_cache_pmd(vma, addr, pmd);
 	spin_unlock(ptl);
 }
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch


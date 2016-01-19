From: akpm@linux-foundation.org
Subject: [merged]
 mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:14 -0800
Message-ID: <569e98da.gzW/Rja5oKFg/2hS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbcASUNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, jmoyer@redhat.com, toshi.kani@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: fix livelock, allow dax pmd mappings to become writeable
has been removed from the -mm tree.  Its filename was
     mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -938,15 +938,13 @@ static void insert_pfn_pmd(struct vm_are
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

dax-fix-null-pointer-dereference-in-__dax_dbg.patch
dax-fix-conversion-of-holes-to-pmds.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
pmem-add-wb_cache_pmem-to-the-pmem-api-v6.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
dax-support-dirty-dax-entries-in-radix-tree-v6.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
dax-add-support-for-fsync-sync-v6.patch
dax-add-support-for-fsync-msync-v7.patch
dax-add-support-for-fsync-msync-v8.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch


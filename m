From: akpm@linux-foundation.org
Subject: + mm-pagemap-fix-soft-dirty-marking-for-pmd-migration-entry.patch added to -mm tree
Date: Tue, 17 Oct 2017 15:35:36 -0700
Message-ID: <59e685b8.hEYf+yEC3FzoZIy0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935130AbdJQWfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, arnd@arndb.de, dancol@google.com, hughd@google.com, jglisse@redhat.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, /proc/pid/pagemap: fix soft dirty marking for PMD migration entry
has been added to the -mm tree.  Its filename is
     mm-pagemap-fix-soft-dirty-marking-for-pmd-migration-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagemap-fix-soft-dirty-marking-for-pmd-migration-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagemap-fix-soft-dirty-marking-for-pmd-migration-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, /proc/pid/pagemap: fix soft dirty marking for PMD migration entry

Now, when the page table is walked in the implementation of
/proc/<pid>/pagemap, pmd_soft_dirty() is used for both the PMD huge page
map and the PMD migration entries.  That is wrong, pmd_swp_soft_dirty()
should be used for the PMD migration entries instead because the different
page table entry flag is used.

As a result, /proc/pid/pagemap may report incorrect soft dirty information
for PMD migration entries.

Link: http://lkml.kernel.org/r/20171017081818.31795-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-pagemap-fix-soft-dirty-marking-for-pmd-migration-entry fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagemap-fix-soft-dirty-marking-for-pmd-migration-entry
+++ a/fs/proc/task_mmu.c
@@ -1310,13 +1310,15 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		pmd_t pmd = *pmdp;
 		struct page *page = NULL;
 
-		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(pmd))
+		if (vma->vm_flags & VM_SOFTDIRTY)
 			flags |= PM_SOFT_DIRTY;
 
 		if (pmd_present(pmd)) {
 			page = pmd_page(pmd);
 
 			flags |= PM_PRESENT;
+			if (pmd_soft_dirty(pmd))
+				flags |= PM_SOFT_DIRTY;
 			if (pm->show_pfn)
 				frame = pmd_pfn(pmd) +
 					((addr & ~PMD_MASK) >> PAGE_SHIFT);
@@ -1328,6 +1330,8 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			frame = swp_type(entry) |
 				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 			flags |= PM_SWAP;
+			if (pmd_swp_soft_dirty(pmd))
+				flags |= PM_SOFT_DIRTY;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
 			page = migration_entry_to_page(entry);
 		}
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-pagemap-fix-soft-dirty-marking-for-pmd-migration-entry.patch


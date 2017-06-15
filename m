From: akpm@linux-foundation.org
Subject: + mm-numa-avoid-waiting-on-freed-migrated-pages.patch added to
 -mm tree
Date: Thu, 15 Jun 2017 13:31:25 -0700
Message-ID: <5942ee9d.WEXupQ6mpkFleNjw%akpm__7001.37447934157$1497558705$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdFOUb0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:31:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.rutland@arm.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, stable@vger.kernel.org, steve.capper@arm.com, vbabka@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: avoid waiting on freed migrated pages
has been added to the -mm tree.  Its filename is
     mm-numa-avoid-waiting-on-freed-migrated-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-avoid-waiting-on-freed-migrated-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-avoid-waiting-on-freed-migrated-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: mm: numa: avoid waiting on freed migrated pages

In do_huge_pmd_numa_page(), we attempt to handle a migrating thp pmd by
waiting until the pmd is unlocked before we return and retry.  However, we
can race with migrate_misplaced_transhuge_page():

// do_huge_pmd_numa_page                // migrate_misplaced_transhuge_page()
// Holds 0 refs on page                 // Holds 2 refs on page

vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
/* ... */
if (pmd_trans_migrating(*vmf->pmd)) {
        page = pmd_page(*vmf->pmd);
        spin_unlock(vmf->ptl);
                                        ptl = pmd_lock(mm, pmd);
                                        if (page_count(page) != 2)) {
                                                /* roll back */
                                        }
                                        /* ... */
                                        mlock_migrate_page(new_page, page);
                                        /* ... */
                                        spin_unlock(ptl);
                                        put_page(page);
                                        put_page(page); // page freed here
        wait_on_page_locked(page);
        goto out;
}

This can result in the freed page having its waiters flag set
unexpectedly, which trips the PAGE_FLAGS_CHECK_AT_PREP checks in the page
alloc/free functions.  This has been observed on arm64 KVM guests.

We can avoid this by having do_huge_pmd_numa_page() take a reference on
the page before dropping the pmd lock, mirroring what we do in
__migration_entry_wait().

When we hit the race, migrate_misplaced_transhuge_page() will see the
reference and abort the migration, as it may do today in other cases.

Fixes: b8916634b77bffb2 ("mm: Prevent parallel splits during THP migration")
Link: http://lkml.kernel.org/r/1497349722-6731-2-git-send-email-will.deacon@arm.com
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-numa-avoid-waiting-on-freed-migrated-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-avoid-waiting-on-freed-migrated-pages
+++ a/mm/huge_memory.c
@@ -1426,8 +1426,11 @@ int do_huge_pmd_numa_page(struct vm_faul
 	 */
 	if (unlikely(pmd_trans_migrating(*vmf->pmd))) {
 		page = pmd_page(*vmf->pmd);
+		if (!get_page_unless_zero(page))
+			goto out_unlock;
 		spin_unlock(vmf->ptl);
 		wait_on_page_locked(page);
+		put_page(page);
 		goto out;
 	}
 
@@ -1459,9 +1462,12 @@ int do_huge_pmd_numa_page(struct vm_faul
 
 	/* Migration could have started since the pmd_trans_migrating check */
 	if (!page_locked) {
+		page_nid = -1;
+		if (!get_page_unless_zero(page))
+			goto out_unlock;
 		spin_unlock(vmf->ptl);
 		wait_on_page_locked(page);
-		page_nid = -1;
+		put_page(page);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from mark.rutland@arm.com are

mm-numa-avoid-waiting-on-freed-migrated-pages.patch


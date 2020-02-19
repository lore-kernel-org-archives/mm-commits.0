From: akpm@linux-foundation.org
Subject: +
 =?us-ascii?Q?mm-numa-fix-bad-pmd-by-atomically-check-for-pmd=5Ftrans=5Fh?=
 =?us-ascii?Q?uge-when-marking-page-tables-prot=5Fnuma-fix.patch?= added to
 -mm tree
Date: Wed, 19 Feb 2020 14:54:20 -0800
Message-ID: <20200219225420.PDeeZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbgBSWyV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 17:54:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zi.yan@cs.rutgers.edu, vbabka@suse.cz, mhocko@suse.com, mgorman@techsingularity.net, kirill.shutemov@linux.intel.com, aquini@redhat.com, akpm@linux-foundation.org


The patch titled
     Subject: mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix
has been added to the -mm tree.  Its filename is
     mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix

fix comment typo, per Rafael

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix
+++ a/mm/mprotect.c
@@ -209,7 +209,7 @@ static inline unsigned long change_pmd_r
 		 * held for read. It's possible a parallel update to occur
 		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
 		 * check leading to a false positive and clearing.
-		 * Hence, it's ecessary to atomically read the PMD value
+		 * Hence, it's necessary to atomically read the PMD value
 		 * for all the checks.
 		 */
 		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
linux-next-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch

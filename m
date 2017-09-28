From: akpm@linux-foundation.org
Subject: +
 mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level.patch added to -mm tree
Date: Thu, 28 Sep 2017 14:43:24 -0700
Message-ID: <59cd6cfc.gjq2hAb82xF6wYrU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdI1VnZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 17:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 00moses.alexander00@gmail.com, aneesh.kumar@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, khandual@linux.vnet.ibm.com, kirill@shutemov.name, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: enable soft offline of HugeTLB pages at PUD level
has been added to the -mm tree.  Its filename is
     mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandru Moise <00moses.alexander00@gmail.com>
Subject: mm/madvise: enable soft offline of HugeTLB pages at PUD level

Since 94310cbcaa3c2 ("mm/madvise: enable (soft|hard) offline of HugeTLB
pages at PGD level") we've been able to soft offline 1G hugepages at the
PGD level, however x86_64 gigantic hugepages are at the PUD level so we
should add an extra check to account for hstate order at PUD level.

I'm not sure if this also applies to 5 level page tables on x86_64
however. Tested with 4 level pagetable.

Link: http://lkml.kernel.org/r/20170913101047.GA13026@gmail.com
Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/hugetlb.h~mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level
+++ a/include/linux/hugetlb.h
@@ -480,6 +480,7 @@ static inline bool hugepage_migration_su
 {
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	if ((huge_page_shift(h) == PMD_SHIFT) ||
+		(huge_page_shift(h) == PUD_SHIFT) ||
 		(huge_page_shift(h) == PGDIR_SHIFT))
 		return true;
 	else
_

Patches currently in -mm which might be from 00moses.alexander00@gmail.com are

mm-hugetlb-soft_offline-save-compound-page-order-before-page-migration.patch
mm-madvise-enable-soft-offline-of-hugetlb-pages-at-pud-level.patch


From: akpm@linux-foundation.org
Subject: +
 hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix.patch
 added to -mm tree
Date: Mon, 20 Apr 2020 13:26:13 -0700
Message-ID: <20200420202613.5aptkxAAj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTU0R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 16:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, anders.roxell@linaro.org, aou@eecs.berkeley.edu, benh@kernel.crashing.org, borntraeger@de.ibm.com, cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr, corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, longpeng2@huawei.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, nitesh@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, peterx@redhat.com, rdunlap@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: arm64/hugetlb: fix hugetlb initialization
has been added to the -mm tree.  Its filename is
     hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: arm64/hugetlb: fix hugetlb initialization

When calling hugetlb_add_hstate() to initialize a new hugetlb size,
be sure to use correct huge pages size order.

Link: http://lkml.kernel.org/r/4c36c6ce-3774-78fa-abc4-b7346bf24348@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Longpeng <longpeng2@huawei.com>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -453,11 +453,11 @@ void huge_ptep_clear_flush(struct vm_are
 static int __init hugetlbpage_init(void)
 {
 #ifdef CONFIG_ARM64_4K_PAGES
-	hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate(ilog2(PUD_SIZE) - PAGE_SHIFT);
 #endif
-	hugetlb_add_hstate(CONT_PMD_SHIFT - PAGE_SHIFT);
-	hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
-	hugetlb_add_hstate(CONT_PTE_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate(ilog2(CONT_PMD_SIZE) - PAGE_SHIFT);
+	hugetlb_add_hstate(ilog2(PMD_SIZE) - PAGE_SHIFT);
+	hugetlb_add_hstate(ilog2(CONT_PTE_SIZE) - PAGE_SHIFT);
 
 	return 0;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-add-arch_hugetlb_valid_size.patch
hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code.patch
hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate.patch
hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix.patch
hugetlbfs-clean-up-command-line-processing.patch

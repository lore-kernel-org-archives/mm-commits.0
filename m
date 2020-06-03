From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix.patch
 removed from -mm tree
Date: Wed, 03 Jun 2020 15:15:14 -0700
Message-ID: <20200603221514.GkeytCP0l%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWPQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:15:16 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, anders.roxell@linaro.org, aneesh.kumar@linux.ibm.com, aou@eecs.berkeley.edu, benh@kernel.crashing.org, borntraeger@de.ibm.com, cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr, corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net, gerald.schaefer@de.ibm.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, longpeng2@huawei.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, nitesh@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, peterx@redhat.com, rdunlap@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: arm64/hugetlb: fix hugetlb initialization
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix.patch

This patch was dropped because it was folded into hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: arm64/hugetlb: fix hugetlb initialization

When calling hugetlb_add_hstate() to initialize a new hugetlb size,
be sure to use correct huge pages size order.

Link: http://lkml.kernel.org/r/4c36c6ce-3774-78fa-abc4-b7346bf24348@oracle.com
Link: http://lkml.kernel.org/r/20200428205614.246260-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>	[s390]
Acked-by: Will Deacon <will@kernel.org>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate-fix
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -448,9 +448,9 @@ static int __init hugetlbpage_init(void)
 #ifdef CONFIG_ARM64_4K_PAGES
 	hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 #endif
-	hugetlb_add_hstate(CONT_PMD_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate((CONT_PMD_SHIFT + PMD_SHIFT) - PAGE_SHIFT);
 	hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
-	hugetlb_add_hstate(CONT_PTE_SHIFT - PAGE_SHIFT);
+	hugetlb_add_hstate((CONT_PTE_SHIFT + PAGE_SHIFT) - PAGE_SHIFT);
 
 	return 0;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-add-arch_hugetlb_valid_size.patch
hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code.patch
hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate.patch
hugetlbfs-clean-up-command-line-processing.patch
hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code-fix.patch

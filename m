Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E973C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B9120767
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168340;
	bh=S/9d+wjPtW2lblFS6PeJIB1/kg1utC3Vkn82Tw0egq4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lUVA0cFtPdVFHUXJo5A0WDmNCvdW80hrB4jDAItucREHNmbcEWqjONR0bBmeXSw4V
	 o4TT1gVbrCnaF3THrElChwbV8feIGmYSrE+yCFsl+zu0u/D1FANnMZIrxoTJzFHfZY
	 JW69fol4KB8Bsp6pRq20vShqvV0IKLfr0Wt3Vvv4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgICVZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgICVZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:39 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 952E1206EF;
        Thu,  3 Sep 2020 21:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168338;
        bh=S/9d+wjPtW2lblFS6PeJIB1/kg1utC3Vkn82Tw0egq4=;
        h=Date:From:To:Subject:From;
        b=QkZVjmsb0ldIouHTnXAWQhFpl3SOkHMPm2Jd08CgcASy4CxPSlz498NRxrluC75oe
         XyzSFSHjfQJ01Aj4Ge8/Jmwkhl+f7ZiT5VeHJD6IVTMjWW40kHYihgLvOk0efoUWE0
         /xdJHabE7KZXypeOffptXhfY4nmgGoW2StPb3cXQ=
Date:   Thu, 03 Sep 2020 14:25:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch added
 to -mm tree
Message-ID: <20200903212538.pYv-u%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/ppc64: avoid setting top bits in radom value
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/ppc64: avoid setting top bits in radom value

ppc64 use bit 62 to indicate a pte entry (_PAGE_PTE).  Avoid setting that
bit in random value.

Link: https://lkml.kernel.org/r/20200902114222.181353-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value
+++ a/mm/debug_vm_pgtable.c
@@ -44,10 +44,17 @@
  * entry type. But these bits might affect the ability to clear entries with
  * pxx_clear() because of how dynamic page table folding works on s390. So
  * while loading up the entries do not change the lower 4 bits. It does not
- * have affect any other platform.
+ * have affect any other platform. Also avoid the 62nd bit on ppc64 that is
+ * used to mark a pte entry.
  */
-#define S390_MASK_BITS	4
-#define RANDOM_ORVALUE	GENMASK(BITS_PER_LONG - 1, S390_MASK_BITS)
+#define S390_SKIP_MASK		GENMASK(3, 0)
+#if __BITS_PER_LONG == 64
+#define PPC64_SKIP_MASK		GENMASK(62, 62)
+#else
+#define PPC64_SKIP_MASK		0x0
+#endif
+#define ARCH_SKIP_MASK (S390_SKIP_MASK | PPC64_SKIP_MASK)
+#define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
 static void __init pte_basic_tests(unsigned long pfn, pgprot_t prot)
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

powerpc-mm-add-debug_vm-warn-for-pmd_clear.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte.patch
mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value.patch
mm-debug_vm_pgtables-hugevmap-use-the-arch-helper-to-identify-huge-vmap-support.patch
mm-debug_vm_pgtable-savedwrite-enable-savedwrite-test-with-config_numa_balancing.patch
mm-debug_vm_pgtable-thp-mark-the-pte-entry-huge-before-using-set_pmd-pud_at.patch
mm-debug_vm_pgtable-set_pte-pmd-pud-dont-use-set__at-to-update-an-existing-pte-entry.patch
mm-debug_vm_pgtable-locks-move-non-page-table-modifying-test-together.patch
mm-debug_vm_pgtable-locks-take-correct-page-table-lock.patch
mm-debug_vm_pgtable-thp-use-page-table-depost-withdraw-with-thp.patch
mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch
mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch
mm-debug_vm_pgtable-avoid-none-pte-in-pte_clear_test.patch


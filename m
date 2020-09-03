Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04272C433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3590206CA
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168360;
	bh=NReKMLymysu4YgU8IBYt8zCGhkEJOdhrHuE9yB9e0UA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wtzWiEqg5kdc1XTE2DgIjtycuXDk9pD5DQCsMStlpoHln4cyOubMdISHf+b0itEUw
	 xflurqss15dPcXRjRx5zbVCfL7BiwXDWJEArfgRuNv4yWbtHh/82GJBDvq3Wmj7/it
	 GM00G33axb58pAnWiMjb151qp+6odSw124PI0P+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgICVZ6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgICVZ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:57 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 999B5206CA;
        Thu,  3 Sep 2020 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168356;
        bh=NReKMLymysu4YgU8IBYt8zCGhkEJOdhrHuE9yB9e0UA=;
        h=Date:From:To:Subject:From;
        b=OZMVW8gz6Hc7GpuXyLq1CeYo6JKCTnMXvkyXcwo5Xhr96j5PNlKC3NMJ9LExAs7ES
         xGrsjsk8aAfGjgnpIUFZ0SiWAb56I1aj+HrY4rl5FUCCl4SRUr2IwI/LINVbN4nn5y
         P/bJ8JaVDllAS10xehaoiZwDEXkfei8qzNs6XVLs=
Date:   Thu, 03 Sep 2020 14:25:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch added to -mm
 tree
Message-ID: <20200903212556.Z_-mb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/hugetlb: disable hugetlb test on ppc64
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64.patch

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
Subject: mm/debug_vm_pgtable/hugetlb: disable hugetlb test on ppc64

The seems to be missing quite a lot of details w.r.t allocating the
correct pgtable_t page (huge_pte_alloc()), holding the right lock
(huge_pte_lock()) etc.  The vma used is also not a hugetlb VMA.

ppc64 do have runtime checks within CONFIG_DEBUG_VM for most of these. 
Hence disable the test on ppc64.

Link: https://lkml.kernel.org/r/20200902114222.181353-13-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-hugetlb-disable-hugetlb-test-on-ppc64
+++ a/mm/debug_vm_pgtable.c
@@ -811,6 +811,7 @@ static void __init hugetlb_basic_tests(u
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
 
+#ifndef CONFIG_PPC_BOOK3S_64
 static void __init hugetlb_advanced_tests(struct mm_struct *mm,
 					  struct vm_area_struct *vma,
 					  pte_t *ptep, unsigned long pfn,
@@ -853,6 +854,7 @@ static void __init hugetlb_advanced_test
 	pte = huge_ptep_get(ptep);
 	WARN_ON(!(huge_pte_write(pte) && huge_pte_dirty(pte)));
 }
+#endif
 #else  /* !CONFIG_HUGETLB_PAGE */
 static void __init hugetlb_basic_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init hugetlb_advanced_tests(struct mm_struct *mm,
@@ -1065,7 +1067,9 @@ static int __init debug_vm_pgtable(void)
 	pud_populate_tests(mm, pudp, saved_pmdp);
 	spin_unlock(ptl);
 
+#ifndef CONFIG_PPC_BOOK3S_64
 	hugetlb_advanced_tests(mm, vma, ptep, pte_aligned, vaddr, prot);
+#endif
 
 	spin_lock(&mm->page_table_lock);
 	p4d_clear_tests(mm, p4dp);
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


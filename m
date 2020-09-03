Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA40C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E92DD206D4
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168356;
	bh=Ds4zZluGoug3StNQdlOkhstqyPswnjI07rHXfXS5pME=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VTZApi42IYc64AZXZ4ClX82I4e9X+uD1hIDp9oEAVNkpx8xNTrlQ1eOqUxpztZK08
	 mBfpokOVCMNABwyYwMbExREbH59WGfa7zwRfs12mIju75k4PmcG6ho3T+9mpPJ1nFV
	 uS2xBJB0v7GESUDI9pRxSPb8zQg/vDU2UZB0Q/OU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgICVZ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgICVZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:25:55 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DBC8206EF;
        Thu,  3 Sep 2020 21:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168354;
        bh=Ds4zZluGoug3StNQdlOkhstqyPswnjI07rHXfXS5pME=;
        h=Date:From:To:Subject:From;
        b=cSS4nkyMdRrc0qoXANDIDqT2q85ZlpGuP3k6QpL0mFeByYmjxGLAHanY68pDAJh8K
         ejBxPi+AIPBowBklfXqgnG26mt5UGa8sxeyh/T0XrLFPMTY2vA3S2+KYxSRkeh7izP
         KU0IMRbbDHdlmvoYDzy74Q9jq474OjE9mV4nlv70=
Date:   Thu, 03 Sep 2020 14:25:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com
Subject:  +
 mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch
 added to -mm tree
Message-ID: <20200903212554.MGXJa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable/pmd_clear: don't use pmd/pud_clear on pte entries
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries.patch

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
Subject: mm/debug_vm_pgtable/pmd_clear: don't use pmd/pud_clear on pte entries

pmd_clear() should not be used to clear pmd level pte entries.

Link: https://lkml.kernel.org/r/20200902114222.181353-12-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-pmd_clear-dont-use-pmd-pud_clear-on-pte-entries
+++ a/mm/debug_vm_pgtable.c
@@ -196,6 +196,8 @@ static void __init pmd_advanced_tests(st
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_young(pmd));
 
+	/*  Clear the pte entries  */
+	pmdp_huge_get_and_clear(mm, vaddr, pmdp);
 	pgtable = pgtable_trans_huge_withdraw(mm, pmdp);
 }
 
@@ -319,6 +321,8 @@ static void __init pud_advanced_tests(st
 	pudp_test_and_clear_young(vma, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_young(pud));
+
+	pudp_huge_get_and_clear(mm, vaddr, pudp);
 }
 
 static void __init pud_leaf_tests(unsigned long pfn, pgprot_t prot)
@@ -442,8 +446,6 @@ static void __init pud_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pud_bad().
 	 */
-	pmd_clear(pmdp);
-	pud_clear(pudp);
 	pud_populate(mm, pudp, pmdp);
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_bad(pud));
@@ -575,7 +577,6 @@ static void __init pmd_populate_tests(st
 	 * This entry points to next level page table page.
 	 * Hence this must not qualify as pmd_bad().
 	 */
-	pmd_clear(pmdp);
 	pmd_populate(mm, pmdp, pgtable);
 	pmd = READ_ONCE(*pmdp);
 	WARN_ON(pmd_bad(pmd));
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


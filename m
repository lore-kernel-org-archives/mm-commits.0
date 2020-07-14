Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308AEC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F98821655
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594690247;
	bh=VDxDiJWLrxSfTBV1rBkW5Uz/sZK/6a8D24Uj8XctstQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Cnm+qIcn+Z1yEM717NGx10jJHBPiRqMin2sv/EBMHfiBqSM/uMPrGopxtJvzG31SW
	 QfGkbzpkQj2dH9+n3BGC0MqtZ84Z0r4seS6lZ2oiwe7rLmyF88wTIsoY7PIkMHCu/r
	 TTQ9EBH9s649eMb1raqmJ3cVvKJMwjxGANMJfxLs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgGNBaq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNBaq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:30:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12C9921548;
        Tue, 14 Jul 2020 01:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594690245;
        bh=VDxDiJWLrxSfTBV1rBkW5Uz/sZK/6a8D24Uj8XctstQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sQ7xYsvmbFaFmzb5TpWDwwzo6c8P0ZeFXnIbCu2HmdhcN0kCI99Vm3vKEoG1blWwt
         mtyHEt8pUaI/z9Aq8V3kXPd+eK6HbIziuR8TdgexgMBT3pAhUj8JkPxPjvXM9im+uF
         S+u9EFQoq2Gh0QsZc6yI7g+hTPtDyHoAXaelx2O0=
Date:   Mon, 13 Jul 2020 18:30:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     anshuman.khandual@arm.com, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        corbet@lwn.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        hpa@zytor.com, kirill@shutemov.name, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, rppt@kernel.org,
        rppt@linux.ibm.com, tglx@linutronix.de, vgupta@synopsys.com,
        will@kernel.org, ziy@nvidia.com
Subject:  +
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-add-tests-validating-advanced-arch?=
 =?US-ASCII?Q?-page-table-helpers-v5.patch?= added to -mm tree
Message-ID: <20200714013044.Mi0RJmX09%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5

drop RANDOM_ORVALUE from hugetlb_advanced_tests()

Link: http://lkml.kernel.org/r/1594610587-4172-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Vineet Gupta <vgupta@synopsys.com>	[arc]
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5
+++ a/mm/debug_vm_pgtable.c
@@ -745,7 +745,7 @@ static void __init hugetlb_advanced_test
 {
 	struct page *page = pfn_to_page(pfn);
 	pte_t pte = ptep_get(ptep);
-	unsigned long paddr = (__pfn_to_phys(pfn) | RANDOM_ORVALUE) & PMD_MASK;
+	unsigned long paddr = __pfn_to_phys(pfn) & PMD_MASK;
 
 	pte = pte_mkhuge(mk_pte(pfn_to_page(PHYS_PFN(paddr)), prot));
 	set_huge_pte_at(mm, vaddr, ptep, pte);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers-v5.patch
mm-vmstat-add-events-for-thp-migration-without-split.patch


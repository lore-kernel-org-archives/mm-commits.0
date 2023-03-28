Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14206C77B6D
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjC1XWG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjC1XVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ED530DF
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 656C7618FE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD979C433D2;
        Tue, 28 Mar 2023 23:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045688;
        bh=b3VFLDzW1Jf4y9A0irb+6DNao/bCK5k/MifgN0BxzFM=;
        h=Date:To:From:Subject:From;
        b=IEKVfm/bH7j69xZYRbWKM/jxibUeNnSV9CgDvDESCfOtZe6o4Q5/22hfqSOfmacXN
         rxc54wX8TxOcaDM70aPnO6Ya0OQz1Im9LBOwChr4TxDlgv16Yy1NBQ57nIjhbxJj5V
         Qv1P54aN1cPekoP4Lln5SieAVTT105Leg2vvws3M=
Date:   Tue, 28 Mar 2023 16:21:28 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com, corbet@lwn.net,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte.patch removed from -mm tree
Message-Id: <20230328232128.BD979C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/debug_vm_pgtable: replace pte_mkhuge() with arch_make_huge_pte()
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: replace pte_mkhuge() with arch_make_huge_pte()
Date: Thu, 2 Mar 2023 17:18:45 +0530

Since the following commit arch_make_huge_pte() should be used directly in
generic memory subsystem as a platform provided page table helper, instead
of pte_mkhuge().  Change hugetlb_basic_tests() to call
arch_make_huge_pte() directly, and update its relevant documentation entry
as required.

'commit 16785bd77431 ("mm: merge pte_mkhuge() call into arch_make_huge_pte()")'

Link: https://lkml.kernel.org/r/20230302114845.421674-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
  Link: https://lore.kernel.org/all/1ea45095-0926-a56a-a273-816709e9075e@csgroup.eu/
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    2 +-
 mm/debug_vm_pgtable.c                     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/arch_pgtable_helpers.rst~mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -214,7 +214,7 @@ HugeTLB Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_huge                  | Tests a HugeTLB                                  |
 +---------------------------+--------------------------------------------------+
-| pte_mkhuge                | Creates a HugeTLB                                |
+| arch_make_huge_pte        | Creates a HugeTLB                                |
 +---------------------------+--------------------------------------------------+
 | huge_pte_dirty            | Tests a dirty HugeTLB                            |
 +---------------------------+--------------------------------------------------+
--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-replace-pte_mkhuge-with-arch_make_huge_pte
+++ a/mm/debug_vm_pgtable.c
@@ -934,7 +934,7 @@ static void __init hugetlb_basic_tests(s
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
 	pte = pfn_pte(args->fixed_pmd_pfn, args->page_prot);
 
-	WARN_ON(!pte_huge(pte_mkhuge(pte)));
+	WARN_ON(!pte_huge(arch_make_huge_pte(pte, PMD_SHIFT, VM_ACCESS_FLAGS)));
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 }
 #else  /* !CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



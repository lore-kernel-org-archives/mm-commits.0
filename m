Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A17C54EE9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 21:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiIGVVq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 17:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiIGVVq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 17:21:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9624494103
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 14:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F6B61A7B
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 21:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81596C433D6;
        Wed,  7 Sep 2022 21:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662585703;
        bh=XiyON4nNAqyzZKjH8yKZNDi9jCA2Mk5c0li9f3T83g4=;
        h=Date:To:From:Subject:From;
        b=0qpTeBsNUk6/BRFMnBE1ZsmLickc0OcEsb8mpPtu/XjCHzyQr/Yg0ictchkLOGpaP
         QOnTmLeHHg7ell4ZJUrYlVWQdlEGsv8mkao/g3SPKa7ujlXLNaYerGXStY7fd+wfYe
         gMKu/U8W7Ql8iH1VNMnAwAiT6lj7HbHWb3y/ecRc=
Date:   Wed, 07 Sep 2022 14:21:43 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch added to mm-hotfixes-unstable branch
Message-Id: <20220907212143.81596C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: powerpc/64s/radix: don't need to broadcast IPI for radix pmd collapse flush
Date: Wed, 7 Sep 2022 11:01:44 -0700

The IPI broadcast is used to serialize against fast-GUP, but fast-GUP will
move to use RCU instead of disabling local interrupts in fast-GUP.  Using
an IPI is the old-styled way of serializing against fast-GUP although it
still works as expected now.

And fast-GUP now fixed the potential race with THP collapse by checking
whether PMD is changed or not.  So IPI broadcast in radix pmd collapse
flush is not necessary anymore.  But it is still needed for hash TLB.

Link: https://lkml.kernel.org/r/20220907180144.555485-2-shy828301@gmail.com
Suggested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -937,15 +937,6 @@ pmd_t radix__pmdp_collapse_flush(struct
 	pmd = *pmdp;
 	pmd_clear(pmdp);
 
-	/*
-	 * pmdp collapse_flush need to ensure that there are no parallel gup
-	 * walk after this call. This is needed so that we can have stable
-	 * page ref count when collapsing a page. We don't allow a collapse page
-	 * if we have gup taken on the page. We can ensure that by sending IPI
-	 * because gup walk happens with IRQ disabled.
-	 */
-	serialize_against_pte_lookup(vma->vm_mm);
-
 	radix__flush_tlb_collapsed_pmd(vma->vm_mm, address);
 
 	return pmd;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-gup-fix-the-fast-gup-race-against-thp-collapse.patch
powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch
mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch
mm-memcg-export-workingset-refault-stats-for-cgroup-v1.patch


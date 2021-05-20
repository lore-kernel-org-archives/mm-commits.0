Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E0AC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F266611AD
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhETE7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 00:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhETE7l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 00:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD6A661074;
        Thu, 20 May 2021 04:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621486700;
        bh=fvtXnivH2Qyi6DhJ4lPlcpmUVnaBYTOzirAmD/lCcp0=;
        h=Date:From:To:Subject:From;
        b=dVKZLK66j7Zct7xLHZduib/apO43sv5gRogOI342hdyMiEHUC642pfrgI0vMlTjB6
         DYKcfvI3zhoxEVTfMwIaYxHGS3hcNZCGhj4ykSu35kbOofFYE7LOVPAlhOEy4BTGbz
         L4RVnpkYIM1L4uH0dPt7RKWYnadnyIky9Gnx5EWQ=
Date:   Wed, 19 May 2021 21:58:19 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, nathan@kernel.org,
        npiggin@gmail.com, peterx@redhat.com
Subject:  +
 mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch
 added to -mm tree
Message-ID: <20210520045819.iVHCUsfWv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix
has been added to the -mm tree.  Its filename is
     mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch

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
Subject: mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix

Link: https://lkml.kernel.org/r/87mtsrqqk0.fsf@linux.ibm.com
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Peter Xu <peterx@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix
+++ a/mm/mremap.c
@@ -258,7 +258,7 @@ static bool move_normal_pmd(struct vm_ar
 	pmd_clear(old_pmd);
 
 	VM_BUG_ON(!pmd_none(*new_pmd));
-	pmd_populate(mm, new_pmd, (pgtable_t)pmd_page_vaddr(pmd));
+	pmd_populate(mm, new_pmd, pmd_pgtable(pmd));
 
 	flush_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
 	if (new_ptl != old_ptl)
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch
powerpc-mm-book3s64-fix-possible-build-error.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch


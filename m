Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E82BC4743F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5F461185
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFGWiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhFGWiv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4197610E7;
        Mon,  7 Jun 2021 22:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623105403;
        bh=cFUxClH00DdOaSb2OANQa0z9sUlki1iJr/W6Frfz/Fg=;
        h=Date:From:To:Subject:From;
        b=RqTwyiF4cgNQ7P2Es89fJxeoRnLNX8ngJVIX/VvcbJqiItyG1V2XJQ+c6iV3HHNrH
         KtWOwiGj0oiVsHm0TSgNHyTmgVDqH115kv9SY43TWiwr22K3hWsU4oeoNHOPZwMQd6
         rsRJgc/seMfqPKw2vVfap11IIcQlEzDSEQSJoAv4=
Date:   Mon, 07 Jun 2021 15:36:43 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, nathan@kernel.org,
        npiggin@gmail.com, peterx@redhat.com
Subject:  [to-be-updated]
 mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch
 removed from -mm tree
Message-ID: <20210607223643.f2wxPNnnu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries-fix.patch

This patch was dropped because an updated version will be merged

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

powerpc-mm-book3s64-fix-possible-build-error.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch


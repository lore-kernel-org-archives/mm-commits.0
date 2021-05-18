Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0079CC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C927461353
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 22:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbhERWGG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 18:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236218AbhERWGG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 18:06:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A207361004;
        Tue, 18 May 2021 22:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621375486;
        bh=Fi6Qes1U2sH5SVHqWtdwRDqSFBEfFhRe8tRa/roVeJ0=;
        h=Date:From:To:Subject:From;
        b=SgV2lE1k9p0xv8wOU6EEpVUo+0B107GO+Jrj3PaaChEH5+JNrmWRw9FDjkARXIssk
         K47A/nG9CV5hNJqdSdwCxDaAVxoBjseuV170pOSSuK3TbDH1nb3D3jFCuh5gSqeolF
         x2XU9GN3+fhxHm+acJoviosO2ddS8F1ZCjVWmNdE=
Date:   Tue, 18 May 2021 15:04:46 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        ziy@nvidia.com
Subject:  +
 mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages.patch added
 to -mm tree
Message-ID: <20210518220446.4uDS43yu1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: update mm_struct's MM_ANONPAGES stat for huge zero pages
has been added to the -mm tree.  Its filename is
     mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages.patch

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
Subject: mm/thp: update mm_struct's MM_ANONPAGES stat for huge zero pages

Although the zero huge page is being shared across various processes, each
mapping needs to update its mm_struct's MM_ANONPAGES stat by HPAGE_PMD_NR
to be consistent.  This just updates the stats in set_huge_zero_page()
after the mapping gets created and in zap_huge_pmd() when mapping gets
destroyed.

Link: https://lkml.kernel.org/r/1621313300-1118-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Zi Yan<ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages
+++ a/mm/huge_memory.c
@@ -715,6 +715,7 @@ static void set_huge_zero_page(pgtable_t
 	if (pgtable)
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
+	add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(mm);
 }
 
@@ -1627,6 +1628,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		spin_unlock(ptl);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
 		zap_deposited_table(tlb->mm, pmd);
+		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		spin_unlock(ptl);
 	} else {
 		struct page *page = NULL;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages.patch
mm-define-default-value-for-first_user_address.patch


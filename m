Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1141C25B0E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 05:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbiHSFO4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiHSFOz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 01:14:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB2CD3E50
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBA44B82558
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640C9C433C1;
        Fri, 19 Aug 2022 05:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660886092;
        bh=L6NNlbrDK+fSUzatEctjyD6vY2UvdRvE5hU/PSSzawc=;
        h=Date:To:From:Subject:From;
        b=vcDkw1LzSseR7Mzdc0J7BjXLjUUQLwZSqLpe0s8XvsUkE4E6fJFzkcIFYH7hQCYGa
         k7ywIJ6HEDTwB2thPRUuXcUchNrXIvBF/lYARqHdTzOhwDgbrQLwtEAn49GCvrRvO0
         qeB5ZvkAFq8uRdNqV2Ux7fx0ZCDnlMtoigemgDQ8=
Date:   Thu, 18 Aug 2022 22:14:51 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch added to mm-unstable branch
Message-Id: <20220819051452.640C9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: remove redundant pgtable check in set_huge_zero_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch

This patch will later appear in the mm-unstable branch at
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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: thp: remove redundant pgtable check in set_huge_zero_page()
Date: Thu, 18 Aug 2022 16:27:48 +0800

When the pgtable is NULL in the set_huge_zero_page(), we should not
increment the count of PTE page table pages by calling mm_inc_nr_ptes(). 
Otherwise we may receive the following warning when the mm exits:

	BUG: non-zero pgtables_bytes on freeing mm

Now we can't observe the above warning since only
do_huge_pmd_anonymous_page() invokes set_huge_zero_page() and the pgtable
can not be NULL.

Therefore, instead of moving mm_inc_nr_ptes() to the non-NULL branch of
pgtable, it is better to remove the redundant pgtable check directly.

Link: https://lkml.kernel.org/r/20220818082748.40021-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page
+++ a/mm/huge_memory.c
@@ -771,8 +771,7 @@ static void set_huge_zero_page(pgtable_t
 		return;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
-	if (pgtable)
-		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	mm_inc_nr_ptes(mm);
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch


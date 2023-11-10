Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966F2C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 17:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbjKJRl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbjKJRli (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 12:41:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57715446CA
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 09:25:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71A9C433C7;
        Fri, 10 Nov 2023 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699637149;
        bh=exWkwQWJmiKewS8G/vv6QJkWguULhAfCibV0NoMT0Z0=;
        h=Date:To:From:Subject:From;
        b=Bwe0x/RJt8p9pwsP8CGR0F+9NiHOp1XLF3Y76auV1H8qtKS2HMz4dxcSnmU1syuZ7
         NpCnM2zRD1ZIZ7mEVXuuS2OJyoMunopsDzT1TzrIoudVUKWsaakeHLO7D0Hkac3p9p
         Bafg2yXLVcpRmjexG0AlxU83BAQTbMJetJpuJDao=
Date:   Fri, 10 Nov 2023 09:25:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch added to mm-unstable branch
Message-Id: <20231110172548.E71A9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
Date: Fri, 10 Nov 2023 11:33:21 +0800

Use more folio APIs to save six compound_head() calls in
__split_huge_page_tail().

Link: https://lkml.kernel.org/r/20231110033324.2455523-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail
+++ a/mm/huge_memory.c
@@ -2509,13 +2509,13 @@ static void __split_huge_page_tail(struc
 	clear_compound_head(page_tail);
 
 	/* Finally unfreeze refcount. Additional reference from page cache. */
-	page_ref_unfreeze(page_tail, 1 + (!PageAnon(head) ||
-					  PageSwapCache(head)));
+	page_ref_unfreeze(page_tail, 1 + (!folio_test_anon(folio) ||
+					  folio_test_swapcache(folio)));
 
-	if (page_is_young(head))
-		set_page_young(page_tail);
-	if (page_is_idle(head))
-		set_page_idle(page_tail);
+	if (folio_test_young(folio))
+		folio_set_young(new_folio);
+	if (folio_test_idle(folio))
+		folio_set_idle(new_folio);
 
 	folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch
fs-proc-page-use-a-folio-in-stable_page_flags.patch
fs-proc-page-respect-folio-head-page-flag-placement.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch
mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch


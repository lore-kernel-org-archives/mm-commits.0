Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79DBC10F04
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbjK3W0N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbjK3W0M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:26:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C7210DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:26:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167DAC433C7;
        Thu, 30 Nov 2023 22:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383179;
        bh=9BM38xwFRBT4o02536503sTdv8l2izwvNigXgt5zlLs=;
        h=Date:To:From:Subject:From;
        b=sa7yBzMh6HNYAnbspNMoEYg6q4DHxAIHZYv/KEeLM++z0+BG1BRGm8goiBY+gRYuF
         BH2dpdOwpboOtnfWBNi9ybO81iCtgtt/R7ujX6eVFf2iHlgjpko0YzYuMGEXpYXac7
         mX0tUy/GOzjzG9cihH3FC0yKB2iDzfi4DdiyO+OY=
Date:   Thu, 30 Nov 2023 14:26:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sidhartha.kumar@oracle.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-a-folio-in-validate_page_before_insert.patch added to mm-unstable branch
Message-Id: <20231130222619.167DAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: use a folio in validate_page_before_insert()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-a-folio-in-validate_page_before_insert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-a-folio-in-validate_page_before_insert.patch

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
Subject: mm: memory: use a folio in validate_page_before_insert()
Date: Sat, 18 Nov 2023 10:32:29 +0800

Use a folio in validate_page_before_insert() to save two compound_head()
calls.

Link: https://lkml.kernel.org/r/20231118023232.1409103-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-use-a-folio-in-validate_page_before_insert
+++ a/mm/memory.c
@@ -1842,9 +1842,12 @@ pte_t *__get_locked_pte(struct mm_struct
 
 static int validate_page_before_insert(struct page *page)
 {
-	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_anon(folio) || folio_test_slab(folio) ||
+	    page_has_type(page))
 		return -EINVAL;
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 	return 0;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch
mm-memory-use-a-folio-in-validate_page_before_insert.patch
mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch
mm-memory-use-a-folio-in-do_cow_fault.patch
mm-memory-use-folio_prealloc-in-wp_page_copy.patch


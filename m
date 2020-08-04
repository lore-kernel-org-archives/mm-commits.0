Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82638C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4FA206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511288;
	bh=DGvWtMHVV13r285rQ75il2fpSW8imLG6+YIiH+faDvk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dXQdCq1kWSq4+2oBRaZNI8Y85kIZghQ/9vFtNmRcV1IkDbxeXKr1t2MnYKl99z3h+
	 ZSkOhtoYoArLnjEmQBkd/CTIStdcWnXSGvKZW2r9ndarbEK1xvNDqFGdizcjG1SeAG
	 I/lNH61ekepn5pe/2LPUBVzyvIzP0mjmZAoEbNt0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgHDDV2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C7772068F;
        Tue,  4 Aug 2020 03:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511287;
        bh=DGvWtMHVV13r285rQ75il2fpSW8imLG6+YIiH+faDvk=;
        h=Date:From:To:Subject:From;
        b=EcV7qDRTz+eEuwYHbAmTvhPccQDEGb4KuosrtlfegUi+V0XKDPdBwUtnGgpb5JHs8
         F0uIoz94lvjC+SBz3ZUohd/zGfiFffqY8dF8lAzsUF8EGFdnpHQkAOw49yz/CO30vC
         6LJYSk2KoNqvkzOrY5qKJaAKLjgBvIRjcNzxetsw=
Date:   Mon, 03 Aug 2020 20:21:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-hugetlbc-delete-duplicated-words.patch added to -mm
 tree
Message-ID: <20200804032126.WA5efZyyv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: delete duplicated words
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-delete-duplicated-words.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-delete-duplicated-words.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-delete-duplicated-words.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/hugetlb.c: delete duplicated words

Drop the repeated word "the" in two places.

Link: http://lkml.kernel.org/r/20200801173822.14973-5-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-delete-duplicated-words
+++ a/mm/hugetlb.c
@@ -133,7 +133,7 @@ void hugepage_put_subpool(struct hugepag
 /*
  * Subpool accounting for allocating and reserving pages.
  * Return -ENOMEM if there are not enough resources to satisfy the
- * the request.  Otherwise, return the number of pages by which the
+ * request.  Otherwise, return the number of pages by which the
  * global pools must be adjusted (upward).  The returned value may
  * only be different than the passed value (delta) in the case where
  * a subpool minimum size must be maintained.
@@ -2167,7 +2167,7 @@ static void return_unused_surplus_pages(
 	 * evenly across all nodes with memory. Iterate across these nodes
 	 * until we can no longer free unreserved surplus pages. This occurs
 	 * when the nodes with surplus pages have no free pages.
-	 * free_pool_huge_page() will balance the the freed pages across the
+	 * free_pool_huge_page() will balance the freed pages across the
 	 * on-line nodes with memory and will handle the hstate accounting.
 	 *
 	 * Note that we decrement resv_huge_pages as we free the pages.  If
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
mm-compactionc-delete-duplicated-word.patch
mm-filemapc-delete-duplicated-word.patch
mm-hmmc-delete-duplicated-word.patch
mm-hugetlbc-delete-duplicated-words.patch
mm-memcontrolc-delete-duplicated-words.patch
mm-memoryc-delete-duplicated-words.patch
mm-migratec-delete-duplicated-word.patch
mm-nommuc-delete-duplicated-words.patch
mm-page_allocc-delete-or-fix-duplicated-words.patch
mm-shmemc-delete-duplicated-word.patch
mm-slab_commonc-delete-duplicated-word.patch
mm-usercopyc-delete-duplicated-word.patch
mm-vmscanc-delete-or-fix-duplicated-words.patch
mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
mm-zsmallocc-fix-duplicated-words.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch


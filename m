Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613AFEB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 19:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjGGTFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbjGGTFf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 15:05:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB94C2726
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 12:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 272A061A59
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 19:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAAFC433C9;
        Fri,  7 Jul 2023 19:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688756671;
        bh=k+Cvk+nTFUVBLOPxmRyrknPhv5qBQGc6vEqOkJksmhs=;
        h=Date:To:From:Subject:From;
        b=LUFmqQElWKErHatC1P+qTFQbzKdnI55Sexp+dIZhqJaKvruROfrIplhslq5B2Fv+6
         sOOpBxaARBaQhdXoQsCN3UqhJOUJmHeVZF7h9iRRUrrI35SCp7MRuQpMoI96URStZ5
         lMCLWgfcu9h4y/id6hmgpNF3HjaNZMvcAPOvyn0o=
Date:   Fri, 07 Jul 2023 12:04:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-stale-comment-of-function-check_pte.patch added to mm-unstable branch
Message-Id: <20230707190431.7AAAFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correct stale comment of function check_pte
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-stale-comment-of-function-check_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-stale-comment-of-function-check_pte.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: correct stale comment of function check_pte
Date: Fri, 7 Jul 2023 23:39:53 +0800

Commit 2aff7a4755bed ("mm: Convert page_vma_mapped_walk to work on PFNs")
replaced page with pfns in page_vma_mapped_walk structure and updated
"@pvmw->page" to "@pvmw->pfn" in comment of function page_vma_mapped_walk.

This patch update stale "page" to "pfn" in comment of check_pte.

Link: https://lkml.kernel.org/r/20230707153953.1380615-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/page_vma_mapped.c~mm-correct-stale-comment-of-function-check_pte
+++ a/mm/page_vma_mapped.c
@@ -73,20 +73,22 @@ static bool map_pte(struct page_vma_mapp
 }
 
 /**
- * check_pte - check if @pvmw->page is mapped at the @pvmw->pte
- * @pvmw: page_vma_mapped_walk struct, includes a pair pte and page for checking
+ * check_pte - check if [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages) is
+ * mapped at the @pvmw->pte
+ * @pvmw: page_vma_mapped_walk struct, includes a pair pte and pfn range
+ * for checking
  *
- * page_vma_mapped_walk() found a place where @pvmw->page is *potentially*
+ * page_vma_mapped_walk() found a place where pfn range is *potentially*
  * mapped. check_pte() has to validate this.
  *
  * pvmw->pte may point to empty PTE, swap PTE or PTE pointing to
  * arbitrary page.
  *
  * If PVMW_MIGRATION flag is set, returns true if @pvmw->pte contains migration
- * entry that points to @pvmw->page or any subpage in case of THP.
+ * entry that points to [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages)
  *
  * If PVMW_MIGRATION flag is not set, returns true if pvmw->pte points to
- * pvmw->page or any subpage in case of THP.
+ * [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages)
  *
  * Otherwise, return false.
  *
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch


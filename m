Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A30C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiJCVH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJCVFz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91827A1A0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2FA3CE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39F0C433D6;
        Mon,  3 Oct 2022 21:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831127;
        bh=TSU+gM35lglJ/GDvTzmUNTH9Hvi3UcB7Bqrn0Hn1w1E=;
        h=Date:To:From:Subject:From;
        b=1VPhV8JBiPyNnXpvU21B+IBd1YBl8dq103bDFJLo5YZr4TrEzzp0GDjtChK3Q8DyN
         6cyCJO8Hk6M5Tl4zi6RlQbTHk8zXV0zxEPPYZhwVu+2BjhtoKNOC+qVfuEgdHQ49tB
         sMPpaokRB63i6dbdKGNFtDtnyMciItLHExbD9YIA=
Date:   Mon, 03 Oct 2022 14:05:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-use-a-folio-in-replace_page.patch removed from -mm tree
Message-Id: <20221003210527.A39F0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: use a folio in replace_page()
has been removed from the -mm tree.  Its filename was
     ksm-use-a-folio-in-replace_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ksm: use a folio in replace_page()
Date: Fri, 2 Sep 2022 20:46:41 +0100

Replace three calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20220902194653.1739778-46-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~ksm-use-a-folio-in-replace_page
+++ a/mm/ksm.c
@@ -1110,6 +1110,7 @@ static int replace_page(struct vm_area_s
 			struct page *kpage, pte_t orig_pte)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio *folio;
 	pmd_t *pmd;
 	pmd_t pmde;
 	pte_t *ptep;
@@ -1178,10 +1179,11 @@ static int replace_page(struct vm_area_s
 	ptep_clear_flush(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, newpte);
 
+	folio = page_folio(page);
 	page_remove_rmap(page, vma, false);
-	if (!page_mapped(page))
-		try_to_free_swap(page);
-	put_page(page);
+	if (!folio_mapped(folio))
+		folio_free_swap(folio);
+	folio_put(folio);
 
 	pte_unmap_unlock(ptep, ptl);
 	err = 0;
_

Patches currently in -mm which might be from willy@infradead.org are



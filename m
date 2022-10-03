Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EB4C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJCVID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJCVGF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6584CA34
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB8C610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A422FC433D6;
        Mon,  3 Oct 2022 21:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831134;
        bh=w1Fs0+3rA0CSKNOQaxWHndxh8R7YfBN6lnFKSV6K7nQ=;
        h=Date:To:From:Subject:From;
        b=dbhqc6G2mBU7IPCE/v+gFF99E9lKO2rcWzZBS8ZycuNniNBIFY4LSY/cU/No+pUKZ
         32z0AM6wpYyjDk27x0FgsOtRlLoqUyXh5SN5AxyloMWVuHz8otuYxslXRPKlAEHCUF
         bA1q+EUpl6rc57iPSuMeP8ulPv5A3S7KxmM9KTdc=
Date:   Mon, 03 Oct 2022 14:05:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate-convert-unmap_and_move_huge_page-to-use-folios.patch removed from -mm tree
Message-Id: <20221003210534.A422FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate: convert unmap_and_move_huge_page() to use folios
has been removed from the -mm tree.  Its filename was
     migrate-convert-unmap_and_move_huge_page-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: migrate: convert unmap_and_move_huge_page() to use folios
Date: Fri, 2 Sep 2022 20:46:47 +0100

Saves several calls to compound_head() and removes a couple of uses of
page->lru.

Link: https://lkml.kernel.org/r/20220902194653.1739778-52-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/migrate.c~migrate-convert-unmap_and_move_huge_page-to-use-folios
+++ a/mm/migrate.c
@@ -1263,7 +1263,7 @@ static int unmap_and_move_huge_page(new_
 	if (!hugepage_migration_supported(page_hstate(hpage)))
 		return -ENOSYS;
 
-	if (page_count(hpage) == 1) {
+	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
 		putback_active_hugepage(hpage);
 		return MIGRATEPAGE_SUCCESS;
@@ -1274,7 +1274,7 @@ static int unmap_and_move_huge_page(new_
 		return -ENOMEM;
 	dst = page_folio(new_hpage);
 
-	if (!trylock_page(hpage)) {
+	if (!folio_trylock(src)) {
 		if (!force)
 			goto out;
 		switch (mode) {
@@ -1284,29 +1284,29 @@ static int unmap_and_move_huge_page(new_
 		default:
 			goto out;
 		}
-		lock_page(hpage);
+		folio_lock(src);
 	}
 
 	/*
 	 * Check for pages which are in the process of being freed.  Without
-	 * page_mapping() set, hugetlbfs specific move page routine will not
+	 * folio_mapping() set, hugetlbfs specific move page routine will not
 	 * be called and we could leak usage counts for subpools.
 	 */
-	if (hugetlb_page_subpool(hpage) && !page_mapping(hpage)) {
+	if (hugetlb_page_subpool(hpage) && !folio_mapping(src)) {
 		rc = -EBUSY;
 		goto out_unlock;
 	}
 
-	if (PageAnon(hpage))
-		anon_vma = page_get_anon_vma(hpage);
+	if (folio_test_anon(src))
+		anon_vma = page_get_anon_vma(&src->page);
 
-	if (unlikely(!trylock_page(new_hpage)))
+	if (unlikely(!folio_trylock(dst)))
 		goto put_anon;
 
-	if (page_mapped(hpage)) {
+	if (folio_mapped(src)) {
 		enum ttu_flags ttu = 0;
 
-		if (!PageAnon(hpage)) {
+		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
 			 * call huge_pmd_unshare.  Because of this, take
@@ -1327,7 +1327,7 @@ static int unmap_and_move_huge_page(new_
 			i_mmap_unlock_write(mapping);
 	}
 
-	if (!page_mapped(hpage))
+	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
@@ -1335,7 +1335,7 @@ static int unmap_and_move_huge_page(new_
 			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
 
 unlock_put_anon:
-	unlock_page(new_hpage);
+	folio_unlock(dst);
 
 put_anon:
 	if (anon_vma)
@@ -1347,12 +1347,12 @@ put_anon:
 	}
 
 out_unlock:
-	unlock_page(hpage);
+	folio_unlock(src);
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
 		putback_active_hugepage(hpage);
 	else if (rc != -EAGAIN)
-		list_move_tail(&hpage->lru, ret);
+		list_move_tail(&src->lru, ret);
 
 	/*
 	 * If migration was not successful and there's a freeing callback, use
_

Patches currently in -mm which might be from willy@infradead.org are



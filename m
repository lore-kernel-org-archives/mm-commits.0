Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85F0C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 00:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiCGARF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 19:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiCGARE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 19:17:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDA55D671
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 16:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D93E660FA7
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 00:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B187C340EC;
        Mon,  7 Mar 2022 00:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646612170;
        bh=7JB1eAP+XaxmDeO7P8zR/nWqLd2xak9dSqgaEKfNirY=;
        h=Date:To:From:Subject:From;
        b=LK1vpYHaKonAjZvvhQDqPtp/DpDKMC1D9+meKZs3YpEQrIEiwI/yGShrzFdZ2F+uo
         DyaNAFEkACCcNN2D/XMMyEOvlfYGdHeUNpVWX/DMx38RlEyRu8W0M7DjKzKyTJ8LTd
         Mp0ynQqyRFVafLyFM+qbgAXd8FAyks8G7RXA0gCk=
Date:   Sun, 06 Mar 2022 16:16:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch added to -mm tree
Message-Id: <20220307001610.3B187C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap_unaccount_folio() large skip mapcount fixup
has been added to the -mm tree.  Its filename is
     mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: filemap_unaccount_folio() large skip mapcount fixup

The page_mapcount_reset() when folio_mapped() while mapping_exiting() was
devised long before there were huge or compound pages in the cache.  It is
still valid for small pages, but not at all clear what's right to check
and reset on large pages.  Just don't try when folio_test_large().

Link: https://lkml.kernel.org/r/879c4426-4122-da9c-1a86-697f2c9a083@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/filemap.c~mm-filemap_unaccount_folio-large-skip-mapcount-fixup
+++ a/mm/filemap.c
@@ -152,25 +152,25 @@ static void filemap_unaccount_folio(stru
 
 	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
 	if (!IS_ENABLED(CONFIG_DEBUG_VM) && unlikely(folio_mapped(folio))) {
-		int mapcount;
-
 		pr_alert("BUG: Bad page cache in process %s  pfn:%05lx\n",
 			 current->comm, folio_pfn(folio));
 		dump_page(&folio->page, "still mapped when deleted");
 		dump_stack();
 		add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
-		mapcount = page_mapcount(&folio->page);
-		if (mapping_exiting(mapping) &&
-		    folio_ref_count(folio) >= mapcount + 2) {
-			/*
-			 * All vmas have already been torn down, so it's
-			 * a good bet that actually the folio is unmapped,
-			 * and we'd prefer not to leak it: if we're wrong,
-			 * some other bad page check should catch it later.
-			 */
-			page_mapcount_reset(&folio->page);
-			folio_ref_sub(folio, mapcount);
+		if (mapping_exiting(mapping) && !folio_test_large(folio)) {
+			int mapcount = page_mapcount(&folio->page);
+
+			if (folio_ref_count(folio) >= mapcount + 2) {
+				/*
+				 * All vmas have already been torn down, so it's
+				 * a good bet that actually the page is unmapped
+				 * and we'd rather not leak it: if we're wrong,
+				 * another bad page check should catch it later.
+				 */
+				page_mapcount_reset(&folio->page);
+				folio_ref_sub(folio, mapcount);
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-fs-delete-pf_swapwrite.patch
tmpfs-support-for-file-creation-time-fix.patch
shmem-mapping_set_exiting-to-help-mapped-resilience.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB2BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiCYWn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiCYWn1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C6C209A63
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B74F3B82A32
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594FAC340F0;
        Fri, 25 Mar 2022 22:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248110;
        bh=PBY+9dL3JLhNX/IbmPRuPC9e/ydGu/ccLb3SajYwmKs=;
        h=Date:To:From:Subject:From;
        b=a3l9fzjny2Y28dwO/XlItQxCXn5MCGM0+CZsiAbSLb/gIPkhl1TwhzXmbbGjUUgzd
         9t0RnqaIQIXaCeYjvoc+DRyEBuJKGxrWOVvcC/Mn7mdl0r0BVR6YXymE0ZWx2Lb80w
         nYT+4sYX+GuFpk7BuDQnsUd3O4v314LWflkn/Zug=
Date:   Fri, 25 Mar 2022 15:41:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch removed from -mm tree
Message-Id: <20220325224150.594FAC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap_unaccount_folio() large skip mapcount fixup
has been removed from the -mm tree.  Its filename was
     mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



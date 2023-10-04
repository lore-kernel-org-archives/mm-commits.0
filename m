Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9B0E7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbjJDURV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDURS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50526BF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11BFC433CA;
        Wed,  4 Oct 2023 20:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450635;
        bh=7GojFkXjkXK2KXupyd5QJzOgMEf3TWC1FyAy1Nuj1KM=;
        h=Date:To:From:Subject:From;
        b=lDWZxUPCty/lIZL6rPInS/MAdMBnzOCzTOoeQUuNrt0iRR6P3GuFBsYyjinUulrta
         ichOUFje0KhDPRqT5QPfozt+7mHsWVOF1QxiOkR9PqK1b/apzk3ih+sB5ImL83/SDG
         NJIrEGnWkq+Q2k7qb/JwB+ZTFdHPMkgRisDtF/hg=
Date:   Wed, 04 Oct 2023 13:17:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix.patch removed from -mm tree
Message-Id: <20231004201714.B11BFC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix.patch

This patch was dropped because it was folded into mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix
Date: Mon, 18 Sep 2023 11:16:57 +0200

While PTE-mapping a THP, we temporarily have an exclusive page of a THP
mapped by both, a PMD and a PTE at the same time.  Update our check to
allow for that combination.

Link: https://lkml.kernel.org/r/d8e5a093-2e22-c14b-7e64-6da280398d9f@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+6e4f59235036c3c2e296@syzkaller.appspotmail.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix
+++ a/mm/rmap.c
@@ -1249,8 +1249,10 @@ void page_add_anon_rmap(struct page *pag
 	}
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(page);
-	VM_WARN_ON_FOLIO(page_mapcount(page) > 1 && PageAnonExclusive(page),
-			 folio);
+	/* While PTE-mapping a THP we have a PMD and a PTE mapping. */
+	VM_WARN_ON_FOLIO((atomic_read(&page->_mapcount) > 0 ||
+			  (folio_test_large(folio) && folio_entire_mapcount(folio) > 1)) &&
+			 PageAnonExclusive(page), folio);
 
 	mlock_vma_folio(folio, vma, compound);
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch


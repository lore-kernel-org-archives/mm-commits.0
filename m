Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DA7EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjIMTsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbjIMTsS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:48:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97F419AD
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:48:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A3DC433C7;
        Wed, 13 Sep 2023 19:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694634494;
        bh=KM4xO2gK1+MJzRChJg8J+m9QFrBdi9ZBhduCPSGTqkQ=;
        h=Date:To:From:Subject:From;
        b=2cdcd9b8fYCyPcy32p2HtsJ9LepYLuQOXZ6cMF71VKUo5fjtlPJs30przF3Mqyu3w
         S3RMJSYYV8X/oFIzVySHmBghdKUrWKlxR5/FdzvV4oXw80Mr7UVriWYnAlFftj+lYj
         cTrdzGIbjCTF8s1/IR66sDdkxj5/Z/FfYerH2Y+4=
Date:   Wed, 13 Sep 2023 12:48:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch added to mm-unstable branch
Message-Id: <20230913194814.65A3DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: warn on new PTE-mapped folios in page_add_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: warn on new PTE-mapped folios in page_add_anon_rmap()
Date: Wed, 13 Sep 2023 14:51:11 +0200

If swapin code would ever decide to not use order-0 pages and supply a
PTE-mapped large folio, we will have to change how we call
__folio_set_anon() -- eventually with exclusive=false and an adjusted
address.  For now, let's add a VM_WARN_ON_FOLIO() with a comment about the
situation.

Link: https://lkml.kernel.org/r/20230913125113.313322-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/rmap.c~mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap
+++ a/mm/rmap.c
@@ -1238,6 +1238,13 @@ void page_add_anon_rmap(struct page *pag
 
 	if (unlikely(!folio_test_anon(folio))) {
 		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+		/*
+		 * For a PTE-mapped large folio, we only know that the single
+		 * PTE is exclusive. Further, __folio_set_anon() might not get
+		 * folio->index right when not given the address of the head
+		 * page.
+		 */
+		VM_WARN_ON_FOLIO(folio_test_large(folio) && !compound, folio);
 		__folio_set_anon(folio, vma, address,
 				 !!(flags & RMAP_EXCLUSIVE));
 	} else if (likely(!folio_test_ksm(folio))) {
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch


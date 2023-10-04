Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096F5E936E2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244111AbjJDUWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243761AbjJDUU6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:20:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B64A11B
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:20:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD5DC433AD;
        Wed,  4 Oct 2023 20:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450855;
        bh=DBg/6WKLsM6WRyh1ZmenaWUZl460SycqS1ni+67MOhA=;
        h=Date:To:From:Subject:From;
        b=IJIKbxJTIkOukzwS6biLMnfHz/dsqsiWpSbS52C9IddQKADXoRmWdqw1aiDmVDmcy
         3FNKe4fY0ZA3JjAhVA+09xVV/WiOw8BCcargUNlt9orrDuUKZU0Q0i5q3MkQ0gJEzw
         QP/26rTM/v5TypFQcjUzpCIbks+6WSIMt8l0iy54=
Date:   Wed, 04 Oct 2023 13:20:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch removed from -mm tree
Message-Id: <20231004202054.BDD5DC433AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: warn on new PTE-mapped folios in page_add_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-rmap-move-setpageanonexclusive-out-of-page_move_anon_rmap.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
memory-move-exclusivity-detection-in-do_wp_page-into-wp_can_reuse_anon_folio.patch


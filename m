Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951C2C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60BD1208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633319;
	bh=943Yce81344xiwv68aOa+Z0LXmd5VG2vt/OzNXPsdmU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GTV/ZrOFkP8f6bSBvQqyaA0MTaSEgffI3IpzG510Rq0AwklbAm2lN4aaU3sanjYb/
	 T7VShKVnDoIiXkXDhSi05AgkgwdB5SB5H42MIj5DlYkAaWoWDBVdNB7jihZdeuMAQg
	 NMlh5b1JbmpajEHg05KugEFQI+RJDcuy6sDEX2oo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbgJMXzT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388463AbgJMXzS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BEC722201;
        Tue, 13 Oct 2020 23:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633318;
        bh=943Yce81344xiwv68aOa+Z0LXmd5VG2vt/OzNXPsdmU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=monjVVVRDgCCaaCaqtY4qc9mADs2kxbqPv3IhgTloZ2+SEyEXEQ2QSNOVy5f5C3g6
         aqmaX3zfq2H9dNbCLgbuUf8YMun5RTfixHfDknI4YF0sIKAoUBiDyWSx8WmXhtW1yJ
         WsW6gXPa1Hvsw13dR8wygnv1zublra1xtmq966U8=
Date:   Tue, 13 Oct 2020 16:55:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, jasowang@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 125/181] mm/page_alloc: tweak comments in
 has_unmovable_pages()
Message-ID: <20201013235517.Z4ney0RQO%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: tweak comments in has_unmovable_pages()

Patch series "mm / virtio-mem: support ZONE_MOVABLE", v5.

When introducing virtio-mem, the semantics of ZONE_MOVABLE were rather
unclear, which is why we special-cased ZONE_MOVABLE such that partially
plugged blocks would never end up in ZONE_MOVABLE.

Now that the semantics are much clearer (and are documented in patch #6),
let's support partially plugged memory blocks in ZONE_MOVABLE, allowing
partially plugged memory blocks to be online to ZONE_MOVABLE and also
unplugging from such memory blocks.  This avoids surprises when onlining
of memory blocks suddenly fails, just because they are not completely
populated by virtio-mem (yet).

This is especially helpful for testing, but also paves the way for
virtio-mem optimizations, allowing more memory to get reliably unplugged.

Cleanup has_unmovable_pages() and set_migratetype_isolate(), providing
better documentation of how ZONE_MOVABLE interacts with different kind of
unmovable pages (memory offlining vs.  alloc_contig_range()).


This patch (of 6):

Let's move the split comment regarding bootmem allocations and memory
holes, especially in the context of ZONE_MOVABLE, to the PageReserved()
check.

Link: http://lkml.kernel.org/r/20200816125333.7434-1-david@redhat.com
Link: http://lkml.kernel.org/r/20200816125333.7434-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-tweak-comments-in-has_unmovable_pages
+++ a/mm/page_alloc.c
@@ -8235,14 +8235,6 @@ struct page *has_unmovable_pages(struct
 	unsigned long iter = 0;
 	unsigned long pfn = page_to_pfn(page);
 
-	/*
-	 * TODO we could make this much more efficient by not checking every
-	 * page in the range if we know all of them are in MOVABLE_ZONE and
-	 * that the movable zone guarantees that pages are migratable but
-	 * the later is not the case right now unfortunatelly. E.g. movablecore
-	 * can still lead to having bootmem allocations in zone_movable.
-	 */
-
 	if (is_migrate_cma_page(page)) {
 		/*
 		 * CMA allocations (alloc_contig_range) really need to mark
@@ -8261,6 +8253,12 @@ struct page *has_unmovable_pages(struct
 
 		page = pfn_to_page(pfn + iter);
 
+		/*
+		 * Both, bootmem allocations and memory holes are marked
+		 * PG_reserved and are unmovable. We can even have unmovable
+		 * allocations inside ZONE_MOVABLE, for example when
+		 * specifying "movablecore".
+		 */
 		if (PageReserved(page))
 			return page;
 
@@ -8334,14 +8332,6 @@ struct page *has_unmovable_pages(struct
 		 * it.  But now, memory offline itself doesn't call
 		 * shrink_node_slabs() and it still to be fixed.
 		 */
-		/*
-		 * If the page is not RAM, page_count()should be 0.
-		 * we don't need more check. This is an _used_ not-movable page.
-		 *
-		 * The problematic thing here is PG_reserved pages. PG_reserved
-		 * is set to both of a memory hole page and a _used_ kernel
-		 * page at boot.
-		 */
 		return page;
 	}
 	return NULL;
_

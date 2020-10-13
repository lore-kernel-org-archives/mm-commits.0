Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A15C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DAA322227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633327;
	bh=yu/DceDmp5i31UTmOfwgiA22IilT5cSSBYIfR/R+QYQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZLDHZsp+NFn9zUe+8GnLP21BPm4+LfMYHhbOsLPGPBht2CJODHYoQ2qUQfo2kschb
	 EYiPxUtvJPHw/3Ztdk45ouqNiY/rplWQiGd/oOuuldnKpj9C3OaBtJNt4TSX4ws5bv
	 sT5ptyfSvGSAxMuAQywaB97ObMns03zS0EpNDP5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388437AbgJMXz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388436AbgJMXz0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02A13221FF;
        Tue, 13 Oct 2020 23:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633325;
        bh=yu/DceDmp5i31UTmOfwgiA22IilT5cSSBYIfR/R+QYQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2gy5G6sPJjjB5+2W/q3mwgACdJNYCfWZtuOBHtriEaxY6wV2xb2nBCHQk06Ilmnsb
         xHTOCdMeGg2pvpmfSSTrvOPVY/2p+9uQstl7qbKk0SxP0/RqvnturQIL3ofG3Twcj/
         zBnOqy6a0zEkP2DqFzzIP7iu4iZf/tnoCkjJOtMI=
Date:   Tue, 13 Oct 2020 16:55:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, jasowang@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 127/181] mm/page_isolation: drop WARN_ON_ONCE() in
 set_migratetype_isolate()
Message-ID: <20201013235524.VLOo7GrME%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: drop WARN_ON_ONCE() in set_migratetype_isolate()

Inside has_unmovable_pages(), we have a comment describing how unmovable
data could end up in ZONE_MOVABLE - via "movablecore".  Also, besides
checking if the first page in the pageblock is reserved, we don't perform
any further checks in case of ZONE_MOVABLE.

In case of memory offlining, we set REPORT_FAILURE, properly dump_page()
the page and handle the error gracefully.  alloc_contig_pages() users
currently never allocate from ZONE_MOVABLE.  E.g., hugetlb uses
alloc_contig_pages() for the allocation of gigantic pages only, which will
never end up on the MOVABLE zone (see htlb_alloc_mask()).

Link: http://lkml.kernel.org/r/20200816125333.7434-4-david@redhat.com
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

 mm/page_isolation.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -57,15 +57,12 @@ static int set_migratetype_isolate(struc
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret) {
 		drain_all_pages(zone);
-	} else {
-		WARN_ON_ONCE(zone_idx(zone) == ZONE_MOVABLE);
-
-		if ((isol_flags & REPORT_FAILURE) && unmovable)
-			/*
-			 * printk() with zone->lock held will likely trigger a
-			 * lockdep splat, so defer it here.
-			 */
-			dump_page(unmovable, "unmovable page");
+	} else if ((isol_flags & REPORT_FAILURE) && unmovable) {
+		/*
+		 * printk() with zone->lock held will likely trigger a
+		 * lockdep splat, so defer it here.
+		 */
+		dump_page(unmovable, "unmovable page");
 	}
 
 	return ret;
_

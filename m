Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3852C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0E5207BB
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597805709;
	bh=h5PxZC+mHi/ej/0LBTAEYn3N06dF1At/izwgPpHzbLM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gAeCMnPzoc7ZlMakS58Vgc42QH57cl8xDZYEUhEcMSr00SqOcS5dqWP+qZKyGTlJI
	 wAj5NbDKqc0zHUrMIbK0zL34Q4W//jDz5z8SE3m7rify/mKN5gwlISLHeu9hkl6tVo
	 61uOPN5QIGaY5Ca1sU6d+Tis340hNMSpF03j7RLM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHSCzJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbgHSCzJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 22:55:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0BDF2078B;
        Wed, 19 Aug 2020 02:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597805708;
        bh=h5PxZC+mHi/ej/0LBTAEYn3N06dF1At/izwgPpHzbLM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qoa1OM0XN6j0MBWjlblCJFHUCAvPdC5Ovuo+jLxCpxJT/5t+XdRbfC988/dFWX0Tp
         CyNjzzehjIkcWnEVSlk77O2smObLZb1DSljU8bHLdrCsEMiSGpaW/sLS6gnCvd+rF/
         kD0QY3ppQQ6VcQmtjTs7XoZmVMJwOHoIQDDiLTII=
Date:   Tue, 18 Aug 2020 19:55:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org
Subject:  +
 mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch added
 to -mm tree
Message-ID: <20200819025507.zoNdJSnqu%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: drop WARN_ON_ONCE() in set_migratetype_isolate()
has been added to the -mm tree.  Its filename is
     mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch


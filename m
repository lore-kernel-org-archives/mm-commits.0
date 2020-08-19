Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB7DC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6996B2078B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597805713;
	bh=eDusqIZdVy/WhPk2IsvVn2+7VNdh/bkOynnEImt58pM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RIl4VDdC+ZEK8wv/ZVKAGtk+qz9dpzHYxhr5oBdSR9B9wfGb3qFPvrLSTNI5RaHwI
	 uz2DyLqBbJMz785R+/AmZEN0FkMIVtSYURJ2FfplDg5EGxtwHO9vuvBLQ1blc8fPww
	 ISNkR936o5d6E9zV2HNtiRaMBohwFv2aEY97/ahA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgHSCzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbgHSCzM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 22:55:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECAAB2076E;
        Wed, 19 Aug 2020 02:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597805711;
        bh=eDusqIZdVy/WhPk2IsvVn2+7VNdh/bkOynnEImt58pM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BCNOt7p32SHRhPN0IlJ8sEUK4GRMkXwTjgxa5y+N+n8eT8J2IipqiX2Cc97LpRDpd
         u27fpIQQfDPUIuKTV1Fj9BZj7qR0Tmu8A4h9uU4ERNm9JuBvQVRgPZoBIW9i39Bkqo
         J7lKnxHqwdEiz6N9pqHqLafCO2DoJgSKW6aOgT9s=
Date:   Tue, 18 Aug 2020 19:55:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org
Subject:  + mm-page_isolation-cleanup-set_migratetype_isolate.patch
 added to -mm tree
Message-ID: <20200819025510.LAcZ6fY0x%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: cleanup set_migratetype_isolate()
has been added to the -mm tree.  Its filename is
     mm-page_isolation-cleanup-set_migratetype_isolate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-cleanup-set_migratetype_isolate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-cleanup-set_migratetype_isolate.patch

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
Subject: mm/page_isolation: cleanup set_migratetype_isolate()

Let's clean it up a bit, simplifying the exit paths.

Link: http://lkml.kernel.org/r/20200816125333.7434-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-cleanup-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -17,12 +17,9 @@
 
 static int set_migratetype_isolate(struct page *page, int migratetype, int isol_flags)
 {
-	struct page *unmovable = NULL;
-	struct zone *zone;
+	struct zone *zone = page_zone(page);
+	struct page *unmovable;
 	unsigned long flags;
-	int ret = -EBUSY;
-
-	zone = page_zone(page);
 
 	spin_lock_irqsave(&zone->lock, flags);
 
@@ -51,13 +48,13 @@ static int set_migratetype_isolate(struc
 									NULL);
 
 		__mod_zone_freepage_state(zone, -nr_pages, mt);
-		ret = 0;
+		spin_unlock_irqrestore(&zone->lock, flags);
+		drain_all_pages(zone);
+		return 0;
 	}
 
 	spin_unlock_irqrestore(&zone->lock, flags);
-	if (!ret) {
-		drain_all_pages(zone);
-	} else if ((isol_flags & REPORT_FAILURE) && unmovable) {
+	if (isol_flags & REPORT_FAILURE) {
 		/*
 		 * printk() with zone->lock held will likely trigger a
 		 * lockdep splat, so defer it here.
@@ -65,7 +62,7 @@ static int set_migratetype_isolate(struc
 		dump_page(unmovable, "unmovable page");
 	}
 
-	return ret;
+	return -EBUSY;
 }
 
 static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch


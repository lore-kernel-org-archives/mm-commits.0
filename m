Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9938EC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6054722228
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633330;
	bh=NYGSj5K0+BNBYAwUmd40RYXR4tZPZOYWRbr72CT5MOc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FKi2olm9F8Au/W/XSdIDxlAxgj49ggj3ol/mr5TpI+12Uniwf6uDPkK3+XfDeF3TL
	 nMaMG4Te8U00ipmW2A8yyWwX50RX0V/K6u/CVpwH9FjW2+vJpGEPkdUoq/wR34rrc8
	 N4GC99hGCV3ZxMbGd93SG7ng/nlH1ExsBystAyVI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbgJMXza (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388436AbgJMXz3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E0021D7B;
        Tue, 13 Oct 2020 23:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633329;
        bh=NYGSj5K0+BNBYAwUmd40RYXR4tZPZOYWRbr72CT5MOc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C5XTOYt8JNbv+zzT0pGXk0kpt/HIj8cSiz+8i2/tIuicObAwukCSneqBqAuL8Nra8
         0guIW30OYAWfmiQcsrXIYECLBsdGlRz34hkktdJevnxMkvdKqH7MYsFeiNSYXSBRyz
         NLdH67rAorIVv434PeofKGSRycuW6jSNn1yfG5ik=
Date:   Tue, 13 Oct 2020 16:55:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        david@redhat.com, jasowang@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 128/181] mm/page_isolation: cleanup
 set_migratetype_isolate()
Message-ID: <20201013235528.XfHn5gcTU%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

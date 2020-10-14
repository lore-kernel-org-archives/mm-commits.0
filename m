Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C86EC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136D9206E5
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709361;
	bh=LVFeU45ThbpvlX0A7srqdXmzOIH7cQmtV42plyIRbH0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JA9BPRos5HoZskxUx3rH+A3O25apY+/+BiFdG2QoAivIdKo8MLPbLXHyy6nddWYjq
	 fMwXTctN/BD4jdLd4W139J1oqrH72RjPbi8rdZFVMw8NAgrnOIEs9VQOzmBs1sR0gw
	 oz1+5WKtb+Ya+IU/FjeQevtaJCU7OB54+NpZidss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbgJNVCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVCk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B97E206CB;
        Wed, 14 Oct 2020 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709359;
        bh=LVFeU45ThbpvlX0A7srqdXmzOIH7cQmtV42plyIRbH0=;
        h=Date:From:To:Subject:From;
        b=EgR/kDUGdMTv0DqgawvN4oDXO7Jz8IU9gdRW5K5v3yC3okglFa8Ww5pspgpFLzyCn
         rrd5k9NZohXFx6tMhNxqTW3EiCQxiOr+srGSmBeMTcOZTJBSy8mwo19Dte1mofClgQ
         6Fdu+W/JJ8dFtMd72ILzzPfmr+kfHzIh0bhy8Wuc=
Date:   Wed, 14 Oct 2020 14:02:39 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, lixinhai.lxh@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  [merged]
 mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch
 removed from -mm tree
Message-ID: <20201014210239.MZ4Wbsnjt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, isolation: avoid checking unmovable pages across pageblock boundary
has been removed from the -mm tree.  Its filename was
     mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm, isolation: avoid checking unmovable pages across pageblock boundary

In has_unmovable_pages(), the page parameter would not always be the first
page within a pageblock (see how the page pointer is passed in from
start_isolate_page_range() after call __first_valid_page()), so that would
cause checking unmovable pages span two pageblocks.

After this patch, the checking is enforced within one pageblock no matter
the page is first one or not, and obey the semantics of this function.

This issue is found by code inspection.

Michal said "this might lead to false negatives when an unrelated block
would cause an isolation failure".

Link: https://lkml.kernel.org/r/20200824065811.383266-1-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary
+++ a/mm/page_alloc.c
@@ -8234,6 +8234,7 @@ struct page *has_unmovable_pages(struct
 {
 	unsigned long iter = 0;
 	unsigned long pfn = page_to_pfn(page);
+	unsigned long offset = pfn % pageblock_nr_pages;
 
 	if (is_migrate_cma_page(page)) {
 		/*
@@ -8247,7 +8248,7 @@ struct page *has_unmovable_pages(struct
 		return page;
 	}
 
-	for (; iter < pageblock_nr_pages; iter++) {
+	for (; iter < pageblock_nr_pages - offset; iter++) {
 		if (!pfn_valid_within(pfn + iter))
 			continue;
 
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are



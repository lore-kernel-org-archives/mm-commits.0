Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C43C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF15C20738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598298634;
	bh=XqG/mH5zEXyAmgLJspX9mnhK8EsHaaNwpSbQAOQX250=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PfLEZpqf9vzfhSF64xwQEX8vNddyd12t8s008X2ly/Bf9aPgx1ygUoHz33fiHrmgJ
	 cSd2pZT65JDhjuVV+qQ+VWGWbarM2gZcKend/Z3LDv5scZcIIiSI+rIunPIytDUfSJ
	 nu+fu8gw730jzDX/+soJFRSS9CT7oZwGn75XUH2w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgHXTue (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXTud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 15:50:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DCA20706;
        Mon, 24 Aug 2020 19:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598298633;
        bh=XqG/mH5zEXyAmgLJspX9mnhK8EsHaaNwpSbQAOQX250=;
        h=Date:From:To:Subject:From;
        b=zu+HuPxIe3vI9uhU3k4tgTArVBobdwQCiufrZf4WBkRy9Kby6sq5pzzqnivH5MV5t
         7HQfz+8iftlorXqd8g9pFi8S4Br7xPBxYOmdG4sBSEeZlrB8et04NlPKePHo56rJx/
         49obBH1W/WqKUCv8+pIXb9QkbEaLlXNtCQvdxizk=
Date:   Mon, 24 Aug 2020 12:50:32 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, lixinhai.lxh@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  +
 mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch
 added to -mm tree
Message-ID: <20200824195032.ZKlhzaGg1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, isolation: avoid checking unmovable pages across pageblock boundary
has been added to the -mm tree.  Its filename is
     mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20200824065811.383266-1-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary
+++ a/mm/page_alloc.c
@@ -8218,6 +8218,7 @@ struct page *has_unmovable_pages(struct
 {
 	unsigned long iter = 0;
 	unsigned long pfn = page_to_pfn(page);
+	unsigned long offset = pfn % pageblock_nr_pages;
 
 	if (is_migrate_cma_page(page)) {
 		/*
@@ -8231,7 +8232,7 @@ struct page *has_unmovable_pages(struct
 		return page;
 	}
 
-	for (; iter < pageblock_nr_pages; iter++) {
+	for (; iter < pageblock_nr_pages - offset; iter++) {
 		if (!pfn_valid_within(pfn + iter))
 			continue;
 
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch


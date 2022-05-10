Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24BAC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiEJVpe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiEJVpd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:45:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC5025D10F
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AA7E6173F
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EAEC385CE;
        Tue, 10 May 2022 21:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652219131;
        bh=zILtjXPLRiAp8fISsFXDeyYUYfHItbHsmvemGIf/9Jk=;
        h=Date:To:From:Subject:From;
        b=1So97LqDSe9fpAxgNoJ79kh/NqP+9/Kkz8/8M5vLP74R1xxdN+7s1/XcMugNR5vpC
         DrtKJVt0hvIr/lCYXcl+HoLXXIC0xmr19xRvUJmtd/gZDQGZZcBUsMr6GJvtAZxQF2
         n+/AVFpWwKN6YTCZ5pIkF2En1N6OZMrSfhHCsxes=
Date:   Tue, 10 May 2022 14:45:30 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        joaodias@google.com, jhubbard@nvidia.com, david@redhat.com,
        minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-is_pinnable_page-against-on-cma-page.patch added to mm-unstable branch
Message-Id: <20220510214531.90EAEC385CE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix is_pinnable_page against on cma page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-is_pinnable_page-against-on-cma-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-is_pinnable_page-against-on-cma-page.patch

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
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix is_pinnable_page against on cma page

Pages on CMA area could have MIGRATE_ISOLATE as well as MIGRATE_CMA so
current is_pinnable_page could miss CMA pages which has MIGRATE_ ISOLATE. 
It ends up pinning CMA pages as longterm at pin_user_pages APIs so CMA
allocation keep failed until the pin is released.

     CPU 0                                   CPU 1 - Task B

cma_alloc
alloc_contig_range
					pin_user_pages_fast(FOLL_LONGTERM)
change pageblock as MIGRATE_ISOLATE
					internal_get_user_pages_fast
                                        lockless_pages_from_mm
                                        gup_pte_range
                                        try_grab_folio
                                        is_pinnable_page
                                          return true;
                                        So, pinned the page successfully.
page migration failure with pinned page
					..
                                        .. After 30 sec
					unpin_user_page(page)

CMA allocation succeeded after 30 sec.

The CMA allocation path protects the migration type change race using
zone->lock but what GUP path need to know is just whether the page is on
CMA area or not rather than exact migration type.  Thus, we don't need
zone->lock but just checks migration type in either of (MIGRATE_ISOLATE
and MIGRATE_CMA).

Adding the MIGRATE_ISOLATE check in is_pinnable_page could cause rejecting
of pinning pages on MIGRATE_ISOLATE pageblocks even though it's neither
CMA nor movable zone if the page is temporarily unmovable.  However, such
a migration failure by unexpected temporary refcount holding is a general
issue, not only coming from MIGRATE_ISOLATE and the MIGRATE_ISOLATE is
also a transient state like other temporarily elevated refcount problem.

Link: https://lkml.kernel.org/r/20220510211743.95831-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John Dias <joaodias@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page
+++ a/include/linux/mm.h
@@ -1625,8 +1625,19 @@ static inline bool page_needs_cow_for_dm
 #ifdef CONFIG_MIGRATION
 static inline bool is_pinnable_page(struct page *page)
 {
-	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
-		is_zero_pfn(page_to_pfn(page));
+#ifdef CONFIG_CMA
+	/*
+	 * use volatile to use local variable mt instead of
+	 * refetching mt value.
+	 */
+	int __mt = get_pageblock_migratetype(page);
+	int mt = __READ_ONCE(__mt);
+
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+		return false;
+#endif
+
+	return !(is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page)));
 }
 #else
 static inline bool is_pinnable_page(struct page *page)
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-is_pinnable_page-against-on-cma-page.patch


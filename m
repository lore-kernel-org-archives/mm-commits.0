Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54CDC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 22:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiAaWxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:53:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57384 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbiAaWxW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 17:53:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BFD3615A1
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 22:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B641EC340E8;
        Mon, 31 Jan 2022 22:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643669601;
        bh=35vQ2RutD98TX+KRA0EIdWTl8u4/UQV5gixWl7Sx5Ro=;
        h=Date:To:From:Subject:From;
        b=Re9OqfKJ6dzZRS9EY87HoRrJCFtgItaXPzt6Tw/zXX7MfbQL9XDLlR8NS7HxRc3qg
         BC5QFgwKOcECEeYPSaxsJ6cHz8EahZ5OWD1+ZVOUf7jiuUDUwtksY8GPYzYe3hiXn/
         IK25iXG0AzCp7DgeiOO4yyBsiOfHYIr8d98Dk1Eg=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 14:53:20 -0800
Date:   Mon, 31 Jan 2022 14:53:20 -0800
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-check-the-subpage-not-the-head-page.patch added to -mm tree
Message-Id: <20220131225320.B641EC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: check the subpage, not the head page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-check-the-subpage-not-the-head-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-check-the-subpage-not-the-head-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-check-the-subpage-not-the-head-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/hwpoison: check the subpage, not the head page

Hardware poison is tracked on a per-page basis, not on the head page.

Link: https://lkml.kernel.org/r/20220130013042.1906881-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-hwpoison-check-the-subpage-not-the-head-page
+++ a/mm/rmap.c
@@ -1553,7 +1553,7 @@ static bool try_to_unmap_one(struct page
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
+		if (PageHWPoison(subpage) && !(flags & TTU_IGNORE_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (PageHuge(page)) {
 				hugetlb_count_sub(compound_nr(page), mm);
@@ -1873,7 +1873,7 @@ static bool try_to_migrate_one(struct pa
 			 * memory are supported.
 			 */
 			subpage = page;
-		} else if (PageHWPoison(page)) {
+		} else if (PageHWPoison(subpage)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (PageHuge(page)) {
 				hugetlb_count_sub(compound_nr(page), mm);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-hwpoison-check-the-subpage-not-the-head-page.patch


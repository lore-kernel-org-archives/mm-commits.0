Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0879BC56201
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6B620829
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSlZCacI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKJT37 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJT37 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 14:29:59 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A1420656;
        Tue, 10 Nov 2020 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605036598;
        bh=PDt3nVmPC20OWGqWUBmPVxMC3I41v4gBVkWMC4eoXM8=;
        h=Date:From:To:Subject:From;
        b=KSlZCacIMCowVcE8n3ku8HtHsxOdPBsAFqCsWXDRSoatQuNaGBaGTo+rMHq8Tgoh/
         d0SXdo5gePTZjJpe9gU+sWQMUtZuA5sxw3fY6NbDYRitmwpQ3zwpottATEMeK51oFu
         FQbV5+zUJfFjq1sZXwkYzuuZJFIX6qI1thP3BgBc=
Date:   Tue, 10 Nov 2020 11:29:57 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  +
 mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch added
 to -mm tree
Message-ID: <20201110192957.P1WLB5AZK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: take free pages off the buddy freelists for hugetlb
has been added to the -mm tree.  Its filename is
     mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: take free pages off the buddy freelists for hugetlb

Currently, free hugetlb get dissolved, but we also need to make sure to
take the poisoned subpage off the buddy frelists, so no one stumbles upon
it (see previous patch for more information).

Link: https://lkml.kernel.org/r/20201013144447.6706-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb
+++ a/mm/memory-failure.c
@@ -809,7 +809,7 @@ static int me_swapcache_clean(struct pag
  */
 static int me_huge_page(struct page *p, unsigned long pfn)
 {
-	int res = 0;
+	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
 
@@ -820,6 +820,7 @@ static int me_huge_page(struct page *p,
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
 	} else {
+		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
 		 * migration entry prevents later access on error anonymous
@@ -828,8 +829,10 @@ static int me_huge_page(struct page *p,
 		 */
 		if (PageAnon(hpage))
 			put_page(hpage);
-		dissolve_free_huge_page(p);
-		res = MF_RECOVERED;
+		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
+		}
 		lock_page(hpage);
 	}
 
@@ -1196,9 +1199,13 @@ static int memory_failure_hugetlb(unsign
 			}
 		}
 		unlock_page(head);
-		dissolve_free_huge_page(p);
-		action_result(pfn, MF_MSG_FREE_HUGE, MF_DELAYED);
-		return 0;
+		res = MF_FAILED;
+		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
+		}
+		action_result(pfn, MF_MSG_FREE_HUGE, res);
+		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
 	lock_page(head);
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch


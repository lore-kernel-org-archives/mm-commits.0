Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932BBC433E6
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641BF64F3F
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbhBBTlu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233027AbhBBTlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 14:41:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5BE564E4D;
        Tue,  2 Feb 2021 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612294855;
        bh=uPLtDENQs9ZFMyFnmz1C6VqyV18bKx5M9CBsKadBiPY=;
        h=Date:From:To:Subject:From;
        b=2HinedIHVaQIQK6lPKDa7vn1SavxbGdF1lT7fTcYFnqIHdttoILDc6sgpPJ3KUS2g
         ReVn5WLMOmirgaxOn4Yv4CPLojGU1MgzRgpoVTXU0N74qSlYMHl3BD+mENYybUM5GQ
         6YYOubID7fcfbsIu58EMY+O2Bj2xkuZVM2482lAc=
Date:   Tue, 02 Feb 2021 11:40:55 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, yanfei.xu@windriver.com
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-remove-redundant-check-in-preparing-and-destro?=
 =?US-ASCII?Q?ying-gigantic-page.patch?= added to -mm tree
Message-ID: <20210202194055.sBOhdmAuf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove redundant check in preparing and destroying gigantic page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-redundant-check-in-preparing-and-destroying-gigantic-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-redundant-check-in-preparing-and-destroying-gigantic-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-redundant-check-in-preparing-and-destroying-gigantic-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/hugetlb: remove redundant check in preparing and destroying gigantic page

Gigantic page is a compound page and its order is more than 1.  Thus it
must be available for hpage_pincount.  Let's remove the redundant check
for gigantic page.

Link: https://lkml.kernel.org/r/20210202112002.73170-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-redundant-check-in-preparing-and-destroying-gigantic-page
+++ a/mm/hugetlb.c
@@ -1234,8 +1234,7 @@ static void destroy_compound_gigantic_pa
 	struct page *p = page + 1;
 
 	atomic_set(compound_mapcount_ptr(page), 0);
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(compound_pincount_ptr(page), 0);
 
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		clear_compound_head(p);
@@ -1563,9 +1562,7 @@ static void prep_compound_gigantic_page(
 		set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
-
-	if (hpage_pincount_available(page))
-		atomic_set(compound_pincount_ptr(page), 0);
+	atomic_set(compound_pincount_ptr(page), 0);
 }
 
 /*
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are

mm-hugetlb-remove-redundant-check-in-preparing-and-destroying-gigantic-page.patch


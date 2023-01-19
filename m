Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B62C46467
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 05:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjATFXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjATFXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 00:23:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD18518DA
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7F47B8275C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DF6C433EF;
        Thu, 19 Jan 2023 21:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674163662;
        bh=XJWAH4KsvhQBcClwCXwMVmHE7tT8ts00nnNX4rIcgGA=;
        h=Date:To:From:Subject:From;
        b=N6Uhrk9pJ1qS9pCvoLfJQ2ax2zIzt8MFSjGQ7RDtiZO87WvJkvglRnCY+flvCjaHj
         BHfwAHLaNHRDpFgiOyP5fMOWDusvdbBN8vjW9FK055jiCslJ636N+RUHQmyU4rPA8o
         kWPNT1Lrq2S5QoOvgHZokKGnlLgcq8iRTYVZaVjo=
Date:   Thu, 19 Jan 2023 13:27:41 -0800
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch added to mm-unstable branch
Message-Id: <20230119212742.50DF6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix get_hwpoison_hugetlb_folio() stub
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/hugetlb: fix get_hwpoison_hugetlb_folio() stub
Date: Thu, 19 Jan 2023 12:19:12 +0100

The folio conversion patch only changed one of the two implementations,
the empty stub one still needs the corresponding change:

mm/memory-failure.c: In function '__get_hwpoison_page':
mm/memory-failure.c:1335:15: error: implicit declaration of function 'get_hwpoison_hugetlb_folio'; did you mean 'get_hwpoison_huge_page'? [-Werror=implicit-function-declaration]
 1335 |         ret = get_hwpoison_hugetlb_folio(folio, &hugetlb, false);
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |               get_hwpoison_huge_page

Link: https://lkml.kernel.org/r/20230119111920.635260-1-arnd@kernel.org
Fixes: 92e109a2c5a7 ("mm/hugetlb: convert get_hwpoison_huge_page() to folios")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix
+++ a/include/linux/hugetlb.h
@@ -417,7 +417,7 @@ static inline int isolate_hugetlb(struct
 	return -EBUSY;
 }
 
-static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
+static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch


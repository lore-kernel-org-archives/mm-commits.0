Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3405DC25B06
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 23:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiHKXIC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 19:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiHKXIB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 19:08:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9644EA061B
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 16:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D85AB822F6
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 23:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E043CC433D6;
        Thu, 11 Aug 2022 23:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660259278;
        bh=1nLoFT0eORXl/o0D0yJYIfqLDhaDkMyUopMt+ERrnCg=;
        h=Date:To:From:Subject:From;
        b=DXewEi42g0UcfvfE/Q1rVGF8xOWCPafTMuuncqEJxB2C5HFpg+IUbfoGpFo1y+oSX
         p6/qo+0iN9J1FZDP1Jk87oVefIW6E4iqwyHPxneLNyGwH5jYy41vJw2Egz1Sv+eRdd
         /jI49nvlz/0Of0+AW1AY7YlLuRL/i07Oum9da3eY=
Date:   Thu, 11 Aug 2022 16:07:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-reduce-stack-usage-of-folio_mapcount.patch added to mm-unstable branch
Message-Id: <20220811230757.E043CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util: reduce stack usage of folio_mapcount
has been added to the -mm mm-unstable branch.  Its filename is
     mm-util-reduce-stack-usage-of-folio_mapcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-reduce-stack-usage-of-folio_mapcount.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/util: reduce stack usage of folio_mapcount
Date: Tue, 2 Aug 2022 01:31:55 +0800

folio_entire_mapcount() will call PageHeadHuge which is a function call,
and blocks the compiler from recognizing this redundant load.

After rearranging the code, stack usage is dropped from 32 to 24, and
the function size is smaller (tested on GCC 12):

Before:
Stack usage:
mm/util.c:845:5:folio_mapcount  32      static
Size:
0000000000000ea0 00000000000000c7 T folio_mapcount

After:
Stack usage:
mm/util.c:845:5:folio_mapcount  24      static
Size:
0000000000000ea0 00000000000000b0 T folio_mapcount

Link: https://lkml.kernel.org/r/20220801173155.92008-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-util-reduce-stack-usage-of-folio_mapcount
+++ a/mm/util.c
@@ -850,10 +850,10 @@ int folio_mapcount(struct folio *folio)
 		return atomic_read(&folio->_mapcount) + 1;
 
 	compound = folio_entire_mapcount(folio);
-	nr = folio_nr_pages(folio);
 	if (folio_test_hugetlb(folio))
 		return compound;
 	ret = compound;
+	nr = folio_nr_pages(folio);
 	for (i = 0; i < nr; i++)
 		ret += atomic_read(&folio_page(folio, i)->_mapcount) + 1;
 	/* File pages has compound_mapcount included in _mapcount */
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-util-reduce-stack-usage-of-folio_mapcount.patch


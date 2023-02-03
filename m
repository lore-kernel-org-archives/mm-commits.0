Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA10C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjBCFpr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBCFpp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:45:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C1360CA3
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:45:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9249361D68
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC172C433D2;
        Fri,  3 Feb 2023 05:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403144;
        bh=DfOlIAfOLtcVMtj7AYsSwuAnZLWsIL7UWZCnM6kBzMY=;
        h=Date:To:From:Subject:From;
        b=iX5YvQ2f8ZLZ4q5SWIxnbn/Ph+ygoPYTzSaKx4TBu4cwIvLenQ7Oc5Qw89kbgDFme
         6oShoAPVc5MkcjImlXLcikB1KESR0DAKnkPFIichlgu+sx8AirID+Gc8791koATfAx
         aNp5q4AWtNzs7ewEngtHRs12blw0VGUR+Vq+KQJM=
Date:   Thu, 02 Feb 2023 21:45:43 -0800
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch removed from -mm tree
Message-Id: <20230203054543.EC172C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix get_hwpoison_hugetlb_folio() stub
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-get_hwpoison_huge_page-to-folios-fix.patch

This patch was dropped because it was folded into mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch

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
@@ -418,7 +418,7 @@ static inline int isolate_hugetlb(struct
 	return -EBUSY;
 }
 
-static inline int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
+static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-extend-max-struct-page-size-for-kmsan.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch


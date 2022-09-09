Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E845ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 18:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIISzm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 14:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiIISzj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 14:55:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55236C04E3
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 11:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0F061FC2
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 18:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE0FC433C1;
        Fri,  9 Sep 2022 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662749736;
        bh=1H94VQg/fbx71XV2QwRBmkNnZ5q1q6TQdh37sTpQ2oc=;
        h=Date:To:From:Subject:From;
        b=wWkipP9qrvqM9cGqe843iYr43s9smUgxpyrzBPV8GbN6E4tdgjuLpX5/SISbCVsZu
         lpbBeyeYiXVm1Ff0VBp3peevsS5EK+f8FNbGv9vo+WRHxoYhqfld/wa2xRuooGpkEL
         RN2O8dcscQmIAK/dNzs6Dn/PyBegEu32NbCe4gyc=
Date:   Fri, 09 Sep 2022 11:55:35 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, david@redhat.com, apopple@nvidia.com,
        chenwandun@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch removed from -mm tree
Message-Id: <20220909185536.2DE0FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: avoid unnecessary page table walk for __get_user_pages
has been removed from the -mm tree.  Its filename was
     mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm: avoid unnecessary page table walk for __get_user_pages
Date: Tue, 6 Sep 2022 10:44:01 +0800

There is no need to walk page tables and find pages if faultin_page()
succeeds and __get_user_pages() doesn't care about populating the pages[]
array.  So directly go on to handle the next page.

Link: https://lkml.kernel.org/r/20220906024401.133336-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-avoid-unnecessary-page-table-walk-for-__get_user_pages
+++ a/mm/gup.c
@@ -1231,7 +1231,10 @@ retry:
 					   PTR_ERR(page) == -EMLINK, locked);
 			switch (ret) {
 			case 0:
-				goto retry;
+				if (pages)
+					goto retry;
+				else
+					goto next_page;
 			case -EBUSY:
 			case -EAGAIN:
 				ret = 0;
_

Patches currently in -mm which might be from chenwandun@huawei.com are



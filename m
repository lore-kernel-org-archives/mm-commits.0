Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDEEC49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 00:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 499E26008E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 00:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhFYAMJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 20:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233186AbhFYALd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 20:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81FE66008E;
        Fri, 25 Jun 2021 00:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624579751;
        bh=wC9nKRkL7ZyDPB6rF+tmbnIBi386vTOtSmAcxoo995w=;
        h=Date:From:To:Subject:From;
        b=mxu9L3nc+c5aWZ1m/XxtCdMHc/m1XuzPVXjYqhYu5GyRJPjozsLlk/pomm+sO2Mhu
         frM1DRaZRCAXs4TFvbz2f8i/hTYgvn9NTOc2OLwtvwstuvscx5DLn9dkl0qCERyEYM
         gR99/h+YBUep8e+JL8aa7s9L1lu0dllFthOiSoAw=
Date:   Thu, 24 Jun 2021 17:09:11 -0700
From:   akpm@linux-foundation.org
To:     alexanderduyck@fb.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, david@redhat.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, will@kernel.org
Subject:  [to-be-updated]
 mm-page_reporting-fix-code-style-in-__page_reporting_request.patch removed
 from -mm tree
Message-ID: <20210625000911.seIvbd0VX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: fix code style in __page_reporting_request()
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-fix-code-style-in-__page_reporting_request.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/page_reporting: fix code style in __page_reporting_request()

Patch series "mm/page_reporting: Make page reporting work on arm64 with 64KB page size", v3.

The page reporting threshold is currently equal to @pageblock_order, which
is 13 and 512MB on arm64 with 64KB base page size selected.  The page
reporting won't be triggered if the freeing page can't come up with a free
area like that huge.  The condition is hard to be met, especially when the
system memory becomes fragmented.

This series intends to solve the issue by having page reporting threshold
as 5 (2MB) on arm64 with 64KB base page size.  The patches are organized
as:

   PATCH[1/4] Fix some coding style in __page_reporting_request().
   PATCH[2/4] Represents page reporting order with variable so that it can
              be exported as module parameter.
   PATCH[3/4] Allows the device driver (e.g. virtio_balloon) to specify
              the page reporting order when the device info is registered.
   PATCH[4/4] Specifies the page reporting order to 5, corresponding to
              2MB in size on ARM64 when 64KB base page size is used.


This patch (of 4):

The lines of comments would be starting with one, instead two space.  This
corrects the style.

Link: https://lkml.kernel.org/r/20210623023418.350616-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20210623023418.350616-2-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_reporting.c~mm-page_reporting-fix-code-style-in-__page_reporting_request
+++ a/mm/page_reporting.c
@@ -31,8 +31,8 @@ __page_reporting_request(struct page_rep
 		return;
 
 	/*
-	 *  If reporting is already active there is nothing we need to do.
-	 *  Test against 0 as that represents PAGE_REPORTING_IDLE.
+	 * If reporting is already active there is nothing we need to do.
+	 * Test against 0 as that represents PAGE_REPORTING_IDLE.
 	 */
 	state = atomic_xchg(&prdev->state, PAGE_REPORTING_REQUESTED);
 	if (state != PAGE_REPORTING_IDLE)
_

Patches currently in -mm which might be from gshan@redhat.com are



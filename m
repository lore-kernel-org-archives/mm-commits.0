Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E50C49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 00:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC3A613B9
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 00:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhFYAOB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 20:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhFYAOB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 20:14:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F0361220;
        Fri, 25 Jun 2021 00:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624579900;
        bh=3zUOXy/d+/H+H5DRTvoviimVWxXF1YkW9F49LuP+etQ=;
        h=Date:From:To:Subject:From;
        b=CYm8gUwlIhfIs4yK3UKE/yGewieBYtX0mpa5zoXe52BUlUPbMdweIMbhwjnbzqZyo
         W7iz3zzuZhxwY9MAusF1/r55CnD9A3zYC7z3t34NsCPn4jANEESGS4MaGIpDdlCBe7
         DNM7j7VhaoE6RdN7Levhlg0IhNSBEW6nc5o+WXtc=
Date:   Thu, 24 Jun 2021 17:11:39 -0700
From:   akpm@linux-foundation.org
To:     alexanderduyck@fb.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, david@redhat.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, will@kernel.org
Subject:  +
 mm-page_reporting-fix-code-style-in-__page_reporting_request.patch added to
 -mm tree
Message-ID: <20210625001139.a5Qdn6S6Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: fix code style in __page_reporting_request()
has been added to the -mm tree.  Its filename is
     mm-page_reporting-fix-code-style-in-__page_reporting_request.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_reporting-fix-code-style-in-__page_reporting_request.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_reporting-fix-code-style-in-__page_reporting_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: mm/page_reporting: fix code style in __page_reporting_request()

Patch series "mm/page_reporting: Make page reporting work on arm64 with 64KB page size", v4.

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

Link: https://lkml.kernel.org/r/20210625014710.42954-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20210625014710.42954-2-gshan@redhat.com
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

mm-page_reporting-fix-code-style-in-__page_reporting_request.patch
mm-page_reporting-export-reporting-order-as-module-parameter.patch
mm-page_reporting-allow-driver-to-specify-reporting-order.patch
virtio_balloon-specify-page-reporting-order-if-needed.patch


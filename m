Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E0BC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 20:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbiHQU52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 16:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242064AbiHQU5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 16:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5E6AB419
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 13:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE4F615A6
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 20:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3BFC433C1;
        Wed, 17 Aug 2022 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769821;
        bh=Qplghk4/GZPBsvogn2Gq65cH1DnJQqFiW3TWlS6wrOE=;
        h=Date:To:From:Subject:From;
        b=elnUJbfbxlYd0+Wz6hJWQjy64l64Hxqie81GnIANlZV9m+VYv1Ft+ok50ANpyizww
         zuKpDXPm/kJu5sg2Qk26jmhZd18JBx+yN66vbaNSm5zkRcZY1QkbDAIDOwJ//bAGaa
         5ziHjDeq+onyILZMloXKpaZxTRrHV2G0cXXB/Q/Q=
Date:   Wed, 17 Aug 2022 13:57:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hch@lst.de,
        felix.kuehling@amd.com, david@redhat.com, apopple@nvidia.com,
        alex.sierra@amd.com, alex.williamson@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-re-allow-pinning-of-zero-pfns-again.patch removed from -mm tree
Message-Id: <20220817205701.3A3BFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: re-allow pinning of zero pfns (again)
has been removed from the -mm tree.  Its filename was
     mm-re-allow-pinning-of-zero-pfns-again.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Williamson <alex.williamson@redhat.com>
Subject: mm: re-allow pinning of zero pfns (again)
Date: Wed, 10 Aug 2022 10:53:59 -0600

The below referenced commit makes the same error as 1c563432588d ("mm: fix
is_pinnable_page against a cma page"), re-interpreting the logic to
exclude pinning of the zero page, which breaks device assignment with
vfio.

To avoid further subtle mistakes, split the logic into discrete tests.

Link: https://lkml.kernel.org/r/166015037385.760108.16881097713975517242.stgit@omen
Link: https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen
Fixes: f25cbb7a95a2 ("mm: add zone device coherent type memory support")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-re-allow-pinning-of-zero-pfns-again
+++ a/include/linux/mm.h
@@ -1544,9 +1544,8 @@ static inline bool is_longterm_pinnable_
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	return !(is_device_coherent_page(page) ||
-		 is_zone_movable_page(page) ||
-		 is_zero_pfn(page_to_pfn(page)));
+	return !(is_device_coherent_page(page) || is_zone_movable_page(page)) ||
+	       is_zero_pfn(page_to_pfn(page));
 }
 #else
 static inline bool is_longterm_pinnable_page(struct page *page)
_

Patches currently in -mm which might be from alex.williamson@redhat.com are



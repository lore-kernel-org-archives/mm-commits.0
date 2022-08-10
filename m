Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF02C19F2D
	for <mm-commits@archiver.kernel.org>; Wed, 10 Aug 2022 02:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiHJCOZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Aug 2022 22:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHJCOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2022 22:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A91D7E331
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 19:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE70612A8
        for <mm-commits@vger.kernel.org>; Wed, 10 Aug 2022 02:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDE2C433C1;
        Wed, 10 Aug 2022 02:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660097663;
        bh=tK556/FM5izFmY5bMc1e593a1H9/TgsJ3o5O9WkRxmo=;
        h=Date:To:From:Subject:From;
        b=u7Mw+zAM3tQuff5f9QPcRqB4PmCHoU6zYyM+xQvLJ7vGIIR8I3JObAgpRAgLjORqC
         SvzBIMbcjI56qYodTHJ9mrpa7equebBq8wP/MKzIFcf6TgyyT+GuE08ldKEfkb8nvk
         fsMNysZ5gT4M2PfN9UlZBrYc7p/KVRLi8w5/rdSU=
Date:   Tue, 09 Aug 2022 19:14:22 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, felix.kuehling@amd.com,
        david@redhat.com, apopple@nvidia.com, alex.sierra@amd.com,
        alex.williamson@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-re-allow-pinning-of-zero-pfns-again.patch added to mm-hotfixes-unstable branch
Message-Id: <20220810021423.2FDE2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: re-allow pinning of zero pfns (again)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-re-allow-pinning-of-zero-pfns-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-re-allow-pinning-of-zero-pfns-again.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alex Williamson <alex.williamson@redhat.com>
Subject: mm: re-allow pinning of zero pfns (again)
Date: Mon, 08 Aug 2022 22:42:24 -0600

The below referenced commit makes the same error as 1c563432588d ("mm: fix
is_pinnable_page against a cma page"), re-interpreting the logic to
exclude pinning of the zero page, which breaks device assignment with
vfio.

Link: https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen
Link: https://lkml.kernel.org/r/166002010021.381133.11357879752637949308.stgit@omen
Fixes: f25cbb7a95a2 ("mm: add zone device coherent type memory support")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
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

mm-re-allow-pinning-of-zero-pfns-again.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323B1ECAAD5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 21:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiH1VDi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiH1VD3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Aug 2022 17:03:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E7F3120C
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 14:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FC68B80BA8
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 21:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E05C433C1;
        Sun, 28 Aug 2022 21:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720606;
        bh=zFgw8HEqiDaiHxiScsAKup8lXL+9HhaX+U5qv8OuW+8=;
        h=Date:To:From:Subject:From;
        b=QSv/NQO5WhCt9wq5GxF7zqqNn5IvqomyjHcUqnmDHEZB2OsezEpKJwkZZtP8Q+nkC
         +eXRdCiLcX1VDIpV4Y5wtSNeqHVQK50c4KBDDc4bOnWThsmeAnjEwjEgdgojr/H835
         qNDOvh/P2ano0vYgyaXYGOfbCLmoSZzw1tCZ9gD4=
Date:   Sun, 28 Aug 2022 14:03:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        slawomirx.laba@intel.com, jhubbard@nvidia.com, hch@lst.de,
        felix.kuehling@amd.com, apopple@nvidia.com, alex.sierra@amd.com,
        alex.williamson@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-re-allow-pinning-of-zero-pfns-again.patch removed from -mm tree
Message-Id: <20220828210326.04E05C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: re-allow pinning of zero pfns (again)
has been removed from the -mm tree.  Its filename was
     mm-re-allow-pinning-of-zero-pfns-again.patch

This patch was dropped because it was merged into the mm-stable branch
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

[akpm@linux-foundation.org: simplify comment, per John]
Link: https://lkml.kernel.org/r/166015037385.760108.16881097713975517242.stgit@omen
Link: https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen
Fixes: f25cbb7a95a2 ("mm: add zone device coherent type memory support")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
Tested-by: Slawomir Laba <slawomirx.laba@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-re-allow-pinning-of-zero-pfns-again
+++ a/include/linux/mm.h
@@ -1544,9 +1544,16 @@ static inline bool is_longterm_pinnable_
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	return !(is_device_coherent_page(page) ||
-		 is_zone_movable_page(page) ||
-		 is_zero_pfn(page_to_pfn(page)));
+	/* The zero page may always be pinned */
+	if (is_zero_pfn(page_to_pfn(page)))
+		return true;
+
+	/* Coherent device memory must always allow eviction. */
+	if (is_device_coherent_page(page))
+		return false;
+
+	/* Otherwise, non-movable zone pages can be pinned. */
+	return !is_zone_movable_page(page);
 }
 #else
 static inline bool is_longterm_pinnable_page(struct page *page)
_

Patches currently in -mm which might be from alex.williamson@redhat.com are



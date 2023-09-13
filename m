Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41793EE0212
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjIMVRV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjIMVRS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:17:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012B21BCC;
        Wed, 13 Sep 2023 14:17:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B31FC433CA;
        Wed, 13 Sep 2023 21:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694639833;
        bh=3QQYX1SemYNiIBYOzQWPJ91tHubX4uy8BY445U1/wvc=;
        h=Date:To:From:Subject:From;
        b=Nx8A2EqbXvHZoPdLWgPFSMKhY87LvmsY87BfohhrAcSjTiOm8Glz01QdvdH+hk6iO
         TAWZe9Nt9+6om+ueVw1luavEGe+EqmuY3gcR5r/UoA0wGg5+ohe5sULAYi8PLYklUD
         iacvqlEybEPDFf/bbHJf5XeAXQbtzKE2h7s+h/5k=
Date:   Wed, 13 Sep 2023 14:17:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230913211713.8B31FC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: use nth_page() in place of direct struct page manipulation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: fs: use nth_page() in place of direct struct page manipulation
Date: Wed, 13 Sep 2023 16:12:47 -0400

When dealing with hugetlb pages, struct page is not guaranteed to be
contiguous on SPARSEMEM without VMEMMAP.  Use nth_page() to handle it
properly.

Link: https://lkml.kernel.org/r/20230913201248.452081-5-zi.yan@sent.com
Fixes: 38c1ddbde6c6 ("hugetlbfs: improve read HWPOISON hugepage")
Cc: <stable@vger.kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-use-nth_page-in-place-of-direct-struct-page-manipulation
+++ a/fs/hugetlbfs/inode.c
@@ -295,7 +295,7 @@ static size_t adjust_range_hwpoison(stru
 	size_t res = 0;
 
 	/* First subpage to start the loop. */
-	page += offset / PAGE_SIZE;
+	page = nth_page(page, offset / PAGE_SIZE);
 	offset %= PAGE_SIZE;
 	while (1) {
 		if (is_raw_hwpoison_page_in_hugepage(page))
@@ -309,7 +309,7 @@ static size_t adjust_range_hwpoison(stru
 			break;
 		offset += n;
 		if (offset == PAGE_SIZE) {
-			page++;
+			page = nth_page(page, 1);
 			offset = 0;
 		}
 	}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch
fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85665E7C4FE
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244919AbjJDUXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244961AbjJDUWa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015811982;
        Wed,  4 Oct 2023 13:21:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A922C433C8;
        Wed,  4 Oct 2023 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450914;
        bh=cRYSfJimCTCwZs7nFXQZEeEExX/dmX48HRwaEXnOdPg=;
        h=Date:To:From:Subject:From;
        b=0VFADzf+zd+4gBazVrW9t6zBgdYlQf9KF/gk9aGgfXfSpDn+zEqmYv4T2cbOS7O3l
         KizqguzTehgHthBc5wnni4HR8zFVftTCmg7V1Il5PXNSw6wY1AgZn1e60uFSFJEjXB
         E7B/ttYuCzDjqI7M/9OXN/EwgOJ6sGVAWNVWWvd4=
Date:   Wed, 04 Oct 2023 13:21:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch removed from -mm tree
Message-Id: <20231004202154.4A922C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/cma: use nth_page() in place of direct struct page manipulation
has been removed from the -mm tree.  Its filename was
     mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/cma: use nth_page() in place of direct struct page manipulation
Date: Wed, 13 Sep 2023 16:12:44 -0400

Patch series "Use nth_page() in place of direct struct page manipulation",
v3.

On SPARSEMEM without VMEMMAP, struct page is not guaranteed to be
contiguous, since each memory section's memmap might be allocated
independently.  hugetlb pages can go beyond a memory section size, thus
direct struct page manipulation on hugetlb pages/subpages might give wrong
struct page.  Kernel provides nth_page() to do the manipulation properly. 
Use that whenever code can see hugetlb pages.


This patch (of 5):

When dealing with hugetlb pages, manipulating struct page pointers
directly can get to wrong struct page, since struct page is not guaranteed
to be contiguous on SPARSEMEM without VMEMMAP.  Use nth_page() to handle
it properly.

Without the fix, page_kasan_tag_reset() could reset wrong page tags,
causing a wrong kasan result.  No related bug is reported.  The fix
comes from code inspection.

Link: https://lkml.kernel.org/r/20230913201248.452081-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20230913201248.452081-2-zi.yan@sent.com
Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation
+++ a/mm/cma.c
@@ -505,7 +505,7 @@ struct page *cma_alloc(struct cma *cma,
 	 */
 	if (page) {
 		for (i = 0; i < count; i++)
-			page_kasan_tag_reset(page + i);
+			page_kasan_tag_reset(nth_page(page, i));
 	}
 
 	if (ret && !no_warn) {
_

Patches currently in -mm which might be from ziy@nvidia.com are



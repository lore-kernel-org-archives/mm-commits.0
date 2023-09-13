Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEDDEE020F
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjIMVRN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjIMVRL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:17:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF6A1724;
        Wed, 13 Sep 2023 14:17:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B171C433C8;
        Wed, 13 Sep 2023 21:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694639827;
        bh=H0TKpNl9XZlMNNl1G3W0Oe8DUv7VG7Rk0sSlnPBW2Pk=;
        h=Date:To:From:Subject:From;
        b=J+2GGQlHJ4Pf01NfLIL645CM4xMzAh9nkoY3Ehd2lkiEMnGRDtgCwuAiDxHg1N7Ew
         8/eeQNZlP5G7TplRJ2ojfAUBWvVrNofcYf2b3voebz18SBxlQfIJRpdpw/TgoKyqhI
         Y669pDZ55SXfI4vI+huQLbVStZXcaK1VW6ib173s=
Date:   Wed, 13 Sep 2023 14:17:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230913211707.2B171C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use nth_page() in place of direct struct page manipulation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

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
Subject: mm/hugetlb: use nth_page() in place of direct struct page manipulation
Date: Wed, 13 Sep 2023 16:12:45 -0400

When dealing with hugetlb pages, manipulating struct page pointers
directly can get to wrong struct page, since struct page is not guaranteed
to be contiguous on SPARSEMEM without VMEMMAP.  Use nth_page() to handle
it properly.

Link: https://lkml.kernel.org/r/20230913201248.452081-3-zi.yan@sent.com
Fixes: 57a196a58421 ("hugetlb: simplify hugetlb handling in follow_page_mask")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation
+++ a/mm/hugetlb.c
@@ -6474,7 +6474,7 @@ struct page *hugetlb_follow_page_mask(st
 			}
 		}
 
-		page += ((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+		page = nth_page(page, ((address & ~huge_page_mask(h)) >> PAGE_SHIFT));
 
 		/*
 		 * Note that page may be a sub-page, and with vmemmap
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch
fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch


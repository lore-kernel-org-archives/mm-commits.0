Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723AAEE020F
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjIMVRS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjIMVRP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:17:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C154ECA;
        Wed, 13 Sep 2023 14:17:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A22AC433C7;
        Wed, 13 Sep 2023 21:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694639830;
        bh=jT/5Pk3B/rSv7hshz1AtgbdYJG6kKwiTwkn8uzqeSEs=;
        h=Date:To:From:Subject:From;
        b=gYWxJqZFt0r7TGvrBGtfSp/utzuCu4u1P9+ErwFz70qMxp57ru8wWw7R2YKqo+mLZ
         lAcKM6vh/BsEYKgpPIcDPIPDXlAlRtVg012omadnGEXQCNNnIeNRbqpl9/uwIScSJC
         YYlkGdhDcF0HkwmDxd3FblqYj/h6Hdm53O+TpjSQ=
Date:   Wed, 13 Sep 2023 14:17:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230913211710.5A22AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: use pfn math in place of direct struct page manipulation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch

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
Subject: mm/memory_hotplug: use pfn math in place of direct struct page manipulation
Date: Wed, 13 Sep 2023 16:12:46 -0400

When dealing with hugetlb pages, manipulating struct page pointers
directly can get to wrong struct page, since struct page is not guaranteed
to be contiguous on SPARSEMEM without VMEMMAP.  Use pfn calculation to
handle it properly.

Link: https://lkml.kernel.org/r/20230913201248.452081-4-zi.yan@sent.com
Fixes: eeb0efd071d8 ("mm,memory_hotplug: fix scan_movable_pages() for gigantic hugepages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation
+++ a/mm/memory_hotplug.c
@@ -1689,7 +1689,7 @@ static int scan_movable_pages(unsigned l
 		 */
 		if (HPageMigratable(head))
 			goto found;
-		skip = compound_nr(head) - (page - head);
+		skip = compound_nr(head) - (pfn - page_to_pfn(head));
 		pfn += skip - 1;
 	}
 	return -ENOENT;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch
fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch


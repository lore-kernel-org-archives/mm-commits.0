Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3ACEE020D
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjIMVRI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjIMVRI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:17:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886BAA8;
        Wed, 13 Sep 2023 14:17:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B88C433C7;
        Wed, 13 Sep 2023 21:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694639824;
        bh=xiqw6ojRwwG8/aLGVbRp+BWm66PtqW8UpY2wap9voX8=;
        h=Date:To:From:Subject:From;
        b=eBzNmoQITyu3KqSiBZnz9CYq0+1RyZHwUDNEla2TaCd0z5RmmshnPAQnAVXiDgP3v
         3aFtUbeaCuFuzbTmEBHSasexbtMYV6BXk9Bej2ZwrdxpRQzV/PKJ7r2d4fLlUmP7YM
         UjdA8NXGlrdzro9s12bzUmK4Ic5tH81asvgQpoCc=
Date:   Wed, 13 Sep 2023 14:17:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230913211704.13B88C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: use nth_page() in place of direct struct page manipulation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

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

mm-cma-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mm-memory_hotplug-use-pfn-math-in-place-of-direct-struct-page-manipulation.patch
fs-use-nth_page-in-place-of-direct-struct-page-manipulation.patch
mips-use-nth_page-in-place-of-direct-struct-page-manipulation.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD6DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F385D611C4
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhIPD1A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234037AbhIPD07 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 23:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8E6A60F70;
        Thu, 16 Sep 2021 03:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631762739;
        bh=r04VKdAoF6eA6S1Tw1QqpdHJmYG1DJ4X+3xtGdeuFrE=;
        h=Date:From:To:Subject:From;
        b=sQMib6RejsAdSlRyqqJXV1bm8blADNiGCU/0bfD1DD4jkN+hgZC3nLp3+Au2JrwBH
         4Ux0aK3HJbR1P6b2/HJFYL4KWm9JApJLxVLCACVXruOofaWcHGysx1XgC7iQVL6YKv
         hBRKVKAoFr2Z71twDJi0wHz5NNmNg4Y+dcPVVi4U=
Date:   Wed, 15 Sep 2021 20:25:39 -0700
From:   akpm@linux-foundation.org
To:     imbrenda@linux.ibm.com, jack@suse.cz, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  + mm-gup-further-simplify-__gup_device_huge.patch added
 to -mm tree
Message-ID: <20210916032539.jy9zBQH_K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: further simplify __gup_device_huge()
has been added to the -mm tree.  Its filename is
     mm-gup-further-simplify-__gup_device_huge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-further-simplify-__gup_device_huge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-further-simplify-__gup_device_huge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: further simplify __gup_device_huge()

commit 6401c4eb57f9 ("mm: gup: fix potential pgmap refcnt leak in
__gup_device_huge()") simplified the return paths, but didn't go quite far
enough, as discussed in [1].

Remove the "ret" variable entirely, because there is enough information
already available to provide the return value.

[1] https://lore.kernel.org/r/CAHk-=wgQTRX=5SkCmS+zfmpqubGHGJvXX_HgnPG8JSpHKHBMeg@mail.gmail.com

Link: https://lkml.kernel.org/r/20210904004224.86391-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-further-simplify-__gup_device_huge
+++ a/mm/gup.c
@@ -2228,7 +2228,6 @@ static int __gup_device_huge(unsigned lo
 {
 	int nr_start = *nr;
 	struct dev_pagemap *pgmap = NULL;
-	int ret = 1;
 
 	do {
 		struct page *page = pfn_to_page(pfn);
@@ -2236,14 +2235,12 @@ static int __gup_device_huge(unsigned lo
 		pgmap = get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
-			ret = 0;
 			break;
 		}
 		SetPageReferenced(page);
 		pages[*nr] = page;
 		if (unlikely(!try_grab_page(page, flags))) {
 			undo_dev_pagemap(nr, nr_start, flags, pages);
-			ret = 0;
 			break;
 		}
 		(*nr)++;
@@ -2251,7 +2248,7 @@ static int __gup_device_huge(unsigned lo
 	} while (addr += PAGE_SIZE, addr != end);
 
 	put_dev_pagemap(pgmap);
-	return ret;
+	return addr == end;
 }
 
 static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-further-simplify-__gup_device_huge.patch


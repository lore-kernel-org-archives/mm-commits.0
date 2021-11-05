Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379BBC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2429560EBD
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhKEUj5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC3360720;
        Fri,  5 Nov 2021 20:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144637;
        bh=pJI1XCeFCB/vXMFPBQdMc6D36Bo3BhS18WObboGfWDU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=S+toJuOPkUGoA+9iwLS85LuJroHnORqUC8emIDXSgQjt6IFSlxwXk5f0N6GX5jxW6
         xPtN6lqTUPDNIJlshS6jAW6FfUb55AiBMr9T11BgWs/eotbCqWOwjcbMCn5g7R/t7Y
         i6+N/GYCvu0fuB3Cs24Y/5Xzn/Q8BZkSeMcKx/JE=
Date:   Fri, 05 Nov 2021 13:37:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, imbrenda@linux.ibm.com, jack@suse.cz,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 050/262] mm/gup: further simplify
 __gup_device_huge()
Message-ID: <20211105203716.qKGfFlN1h%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

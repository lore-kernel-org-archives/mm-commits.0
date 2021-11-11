Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20327C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069186187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhKKCob (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234036AbhKKCob (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8893461284;
        Thu, 11 Nov 2021 02:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598502;
        bh=SRhiTwg1lwKOs/gF8T3skCBiLyCvqAlyazUNmOATzNQ=;
        h=Date:From:To:Subject:From;
        b=D7D2Iz79xGjdIxV+BxAzyqdWw7F7App/PKJEX+mdeWtkxz587DlczYhih8BWHDUnK
         5GdbpW+fSsYXBJblA0PT0N3VReiAMw1JPkYsrxn/8TL8dAlms9hcmeENG8kZ7xPWWA
         vUApizN6u3fop6vWilM/ooU0irEcrWUsMdrn4Tp8=
Date:   Wed, 10 Nov 2021 18:41:42 -0800
From:   akpm@linux-foundation.org
To:     imbrenda@linux.ibm.com, jack@suse.cz, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [merged] mm-gup-further-simplify-__gup_device_huge.patch
 removed from -mm tree
Message-ID: <20211111024142.uY9HZOhHP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: further simplify __gup_device_huge()
has been removed from the -mm tree.  Its filename was
     mm-gup-further-simplify-__gup_device_huge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from jhubbard@nvidia.com are



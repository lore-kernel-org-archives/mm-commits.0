Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8103CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiGRATU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiGRARv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C659013DC3
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6262D60F0B
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8CDC3411E;
        Mon, 18 Jul 2022 00:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103447;
        bh=ZVqJcjqMyRBEYo9dwAfB5KQXI2s/TKsLi2PQXCdRlfM=;
        h=Date:To:From:Subject:From;
        b=BCxkwlbHHCHnRjNmW8ko3flW43A89MBU5tNQlr1VblC5GqCQs1vsCoUqgbwMkCvSe
         6LC7kY0UyDREp2bVy4rBXQriZ77wj8uxS1iDEUeHuTGusj9W/QTZcRusui7VEfDJHa
         P6fq6m9gPDRbJ5dvOb/FaMv9iP8T3cpu4koHckoQ=
Date:   Sun, 17 Jul 2022 17:17:27 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-pass-a-pointer-to-virt_to_page.patch removed from -mm tree
Message-Id: <20220718001727.BA8CDC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: nommu: pass a pointer to virt_to_page()
has been removed from the -mm tree.  Its filename was
     mm-nommu-pass-a-pointer-to-virt_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: mm: nommu: pass a pointer to virt_to_page()
Date: Thu, 30 Jun 2022 10:41:24 +0200

Functions that work on a pointer to virtual memory such as virt_to_pfn()
and users of that function such as virt_to_page() are supposed to pass a
pointer to virtual memory, ideally a (void *) or other pointer.  However
since many architectures implement virt_to_pfn() as a macro, this function
becomes polymorphic and accepts both a (unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr) function the
following happens (occurred on arch/arm):

  mm/nommu.c: In function 'free_page_series':
  mm/nommu.c:501:50: warning: passing argument 1 of 'virt_to_pfn'
  makes pointer from integer without a cast [-Wint-conversion]
  struct page *page = virt_to_page(from);

Fix this with an explicit cast.

Link: https://lkml.kernel.org/r/20220630084124.691207-6-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~mm-nommu-pass-a-pointer-to-virt_to_page
+++ a/mm/nommu.c
@@ -500,7 +500,7 @@ static void delete_nommu_region(struct v
 static void free_page_series(unsigned long from, unsigned long to)
 {
 	for (; from < to; from += PAGE_SIZE) {
-		struct page *page = virt_to_page(from);
+		struct page *page = virt_to_page((void *)from);
 
 		atomic_long_dec(&mmap_pages_allocated);
 		put_page(page);
_

Patches currently in -mm which might be from linus.walleij@linaro.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49738CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGRATV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiGRARo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4125213D7E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAFF6B80EE6
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9411BC341C0;
        Mon, 18 Jul 2022 00:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103446;
        bh=DAhKcDxj8BDGV+PInYBl0CtJ6QRaaFjvXp1DiAPukt0=;
        h=Date:To:From:Subject:From;
        b=ET8t6noZm1tbbaNIfXs0/W1TfYwsCqioTtIs3+eXuCz/LpCeZ1xcQSV1P62+jcm6e
         8atxzeKX78ZQv9U1HrecC5oVy4QsgpMOcrygfaddqvGdkiUhnSW1HJ4PZXmItKnVl5
         79tj7eU5q4fU0TodLWKnoV39e6LmKNwv19g/lDec=
Date:   Sun, 17 Jul 2022 17:17:25 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, glider@google.com,
        elver@google.com, dvyukov@google.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-pass-a-pointer-to-virt_to_page.patch removed from -mm tree
Message-Id: <20220718001726.9411BC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: gup: pass a pointer to virt_to_page()
has been removed from the -mm tree.  Its filename was
     mm-gup-pass-a-pointer-to-virt_to_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: mm: gup: pass a pointer to virt_to_page()
Date: Thu, 30 Jun 2022 10:41:23 +0200

Functions that work on a pointer to virtual memory such as virt_to_pfn()
and users of that function such as virt_to_page() are supposed to pass a
pointer to virtual memory, ideally a (void *) or other pointer.  However
since many architectures implement virt_to_pfn() as a macro, this function
becomes polymorphic and accepts both a (unsigned long) and a (void *).

If we instead implement a proper virt_to_pfn(void *addr) function the
following happens (occurred on arch/arm):

  mm/gup.c: In function '__get_user_pages_locked':
  mm/gup.c:1599:49: warning: passing argument 1 of 'virt_to_pfn'
    makes pointer from integer without a cast [-Wint-conversion]
    pages[i] = virt_to_page(start);

Fix this with an explicit cast.

Link: https://lkml.kernel.org/r/20220630084124.691207-5-linus.walleij@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-pass-a-pointer-to-virt_to_page
+++ a/mm/gup.c
@@ -1704,7 +1704,7 @@ static long __get_user_pages_locked(stru
 			goto finish_or_fault;
 
 		if (pages) {
-			pages[i] = virt_to_page(start);
+			pages[i] = virt_to_page((void *)start);
 			if (pages[i])
 				get_page(pages[i]);
 		}
_

Patches currently in -mm which might be from linus.walleij@linaro.org are



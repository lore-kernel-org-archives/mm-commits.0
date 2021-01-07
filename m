Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A50C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B955A230FE
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbhAGAbs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:31:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAGAbs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 19:31:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC09F22EBD;
        Thu,  7 Jan 2021 00:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609979467;
        bh=LnGERbkA4u+GFJdQmftmpmEaBKIgs2R53ch0ouJLn6k=;
        h=Date:From:To:Subject:From;
        b=HyvRYNS7fNj1qrpnsJDCB6xQDdQ9+5xeY056Scf1EDwyMQQ6sNxZioo71UKNNT2CI
         c0oox84QU3w62MyPWRSOoO6dxvpOHl8UI+1SAWh1Ub/gs7Dofxqj6e+FhG/iNmD//v
         syhDvb9mbXYapoLk4T0VvdSthwOLqzUMNvxkmtYc=
Date:   Wed, 06 Jan 2021 16:31:07 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjhuang@iluvatar.ai
Subject:  +
 lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll.patch
 added to -mm tree
Message-ID: <20210107003107.mLWIizY1y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: change return type to unsigned long for bitmap_set_ll
has been added to the -mm tree.  Its filename is
     lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <sjhuang@iluvatar.ai>
Subject: lib/genalloc.c: change return type to unsigned long for bitmap_set_ll

Just as bitmap_clear_ll(), change return type to unsigned long
for bitmap_set_ll to avoid the possible overflow in future.

Link: https://lkml.kernel.org/r/20210105031644.2771-1-sjhuang@iluvatar.ai
Signed-off-by: Huang Shijie <sjhuang@iluvatar.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/genalloc.c~lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll
+++ a/lib/genalloc.c
@@ -81,7 +81,8 @@ static int clear_bits_ll(unsigned long *
  * users set the same bit, one user will return remain bits, otherwise
  * return 0.
  */
-static int bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
+static unsigned long
+bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
 	const unsigned long size = start + nr;
_

Patches currently in -mm which might be from sjhuang@iluvatar.ai are

lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll.patch


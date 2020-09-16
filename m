Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1DFC43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B7822208
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600299587;
	bh=yq08BQMlekXv6bczB7BSsYXpBHdhXlO3LYlXmGlDtP0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UhTYGKLVPf6zCQrqfzHX+h2UqEKuXzd9VT+IWs2W8ML6xbRBctVvMjFJaTVjLR7xn
	 lMtJLLlh61FmpjGuml4C/sOl9pNmrv/cfZLfoOcuk7XAAE94bE4vDWbDAdNy2sxKx6
	 H9mBYdEz8triYPz+1IrtQndU7r5iLFKmC9l6TNNE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgIPXjr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXjq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:39:46 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC1522209;
        Wed, 16 Sep 2020 23:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600299586;
        bh=yq08BQMlekXv6bczB7BSsYXpBHdhXlO3LYlXmGlDtP0=;
        h=Date:From:To:Subject:From;
        b=Oi2LzQE5tRJhkx4N5y3kI6KjzrJdSjUAqeoJzagc6aYmZ5C43eXQGUs84PeJ7wLea
         8WA8tq1NNsNwQ9Bg5yZbMFNiVt5S9qwg2yqVC0D+j6jZdXMdy7/Jw/Bsd35mRCAugc
         SBO+D1wDF5VW9+nNuBYw8qYJpu4l4leawpV1dkuo=
Date:   Wed, 16 Sep 2020 16:39:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tangjianqiang@xiaomi.com,
        jrdr.linux@gmail.com, wyqt1985@gmail.com
Subject:  + include-linux-slabh-fix-a-typo-error-in-comment.patch
 added to -mm tree
Message-ID: <20200916233945.iRnrQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/slab.h: fix a typo error in comment
has been added to the -mm tree.  Its filename is
     include-linux-slabh-fix-a-typo-error-in-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-slabh-fix-a-typo-error-in-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-slabh-fix-a-typo-error-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: tangjianqiang <wyqt1985@gmail.com>
Subject: include/linux/slab.h: fix a typo error in comment

fix a typo error in slab.h
"allocagtor" -> "allocator"

Link: https://lkml.kernel.org/r/1600230053-24303-1-git-send-email-tangjianqiang@xiaomi.com
Signed-off-by: tangjianqiang <tangjianqiang@xiaomi.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slab.h~include-linux-slabh-fix-a-typo-error-in-comment
+++ a/include/linux/slab.h
@@ -279,7 +279,7 @@ static inline void __check_heap_object(c
 #define KMALLOC_MAX_SIZE	(1UL << KMALLOC_SHIFT_MAX)
 /* Maximum size for which we actually use a slab cache */
 #define KMALLOC_MAX_CACHE_SIZE	(1UL << KMALLOC_SHIFT_HIGH)
-/* Maximum order allocatable via the slab allocagtor */
+/* Maximum order allocatable via the slab allocator */
 #define KMALLOC_MAX_ORDER	(KMALLOC_SHIFT_MAX - PAGE_SHIFT)
 
 /*
_

Patches currently in -mm which might be from wyqt1985@gmail.com are

include-linux-slabh-fix-a-typo-error-in-comment.patch


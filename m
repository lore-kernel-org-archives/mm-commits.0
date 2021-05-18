Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD38C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 19:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D4561261
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 19:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhERTJj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 15:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237963AbhERTJj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 15:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 535446112F;
        Tue, 18 May 2021 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621364900;
        bh=4NhB00UQjsiP9nxGUp84iJ4p32KrTg7aC6KCotmFmBA=;
        h=Date:From:To:Subject:From;
        b=ezwHd0PXpO8azTUvOM2lvO3efXAVXf2wyO3y65CMEMJJvLRupDw7f5bKdThfQY+r8
         mFjmov76aT2zvJXUy4kfKk3Pg7pR4fU+uJtwjNM0K/Xg6ekXN2gATQEvq1nfLWAV+P
         /x+Y6mjsBGZGYojm+NjPMpYNH5iUI83VTXIdEL8Y=
Date:   Tue, 18 May 2021 12:08:19 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, elver@google.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, nathan@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-slub-change-run-time-assertion-in-kmalloc=5Findex-to-comp?=
 =?US-ASCII?Q?ile-time-fix-2.patch?= added to -mm tree
Message-ID: <20210518190819.fZAGGtZep%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix support for clang 10
has been added to the -mm tree.  Its filename is
     mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm, slub: fix support for clang 10

Previously in 'commit ff3daafe3fd3 ("mm, slub: change run-time assertion
in kmalloc_index() to compile-time")', changed kmalloc_index's run-time
assertion to compile-time assertion.

But clang 10 has a bug misevaluating __builtin_constant_p() as true,
making it unable to compile. This bug was fixed in clang 11.

To support clang 10, introduce a macro to do run-time assertion if clang
version is less than 11, even if the size is constant. Might revert this
commit later if we choose not to support clang 10.

Link: https://lkml.kernel.org/r/20210518181247.GA10062@hyeyoo
Fixes: ff3daafe3fd3 ("mm, slub: change run-time assertion in kmalloc_index() to compile-time")
Link: https://lore.kernel.org/r/CA+G9fYvYxqVhUTkertjZjcrUq8LWPnO7qC==Wum3gYCwWF9D6Q@mail.gmail.com/
Link: https://lkml.org/lkml/2021/5/11/872
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slab.h~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-2
+++ a/include/linux/slab.h
@@ -389,7 +389,7 @@ static __always_inline unsigned int __km
 	if (size <=  16 * 1024 * 1024) return 24;
 	if (size <=  32 * 1024 * 1024) return 25;
 
-	if (size_is_constant)
+	if ((IS_ENABLED(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 110000) && size_is_constant)
 		BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
 	else
 		BUG();
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch
mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-2.patch
mm-fix-typos-and-grammar-error-in-comments.patch


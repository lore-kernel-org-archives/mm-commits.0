Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6E6C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 19:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiG1TBZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 15:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiG1TBW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 15:01:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA6A193E3
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 12:01:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A09E7B824FE
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 19:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D6EC433D6;
        Thu, 28 Jul 2022 19:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659034878;
        bh=TApIYMNiZ7XLSuByd9fc73TZ6ptZv67i06g33mHdsTk=;
        h=Date:To:From:Subject:From;
        b=BCmNqPsIu6DHxpK3k4khpLXkDuRcLvRhxtwQZHpGlcfPJwSHeW3nlwbnTyS5o1Uv3
         6x7QaLODetuwAPCk2s1BJ3dNCZW7IwdLsVatpaPbPbvApLPy5ZhqSKS0bhIHeykc21
         /7pzKOl3mfOR2s0VHJfKGG5y1MUUVwhpp8K1pEzE=
Date:   Thu, 28 Jul 2022 12:01:17 -0700
To:     mm-commits@vger.kernel.org, kuba@kernel.org, chen45464546@163.com,
        alexanderduyck@fb.com, mlombard@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-page_frag_alloc-from-corrupting-the-memory.patch added to mm-unstable branch
Message-Id: <20220728190118.44D6EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent page_frag_alloc() from corrupting the memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prevent-page_frag_alloc-from-corrupting-the-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-page_frag_alloc-from-corrupting-the-memory.patch

This patch will later appear in the mm-unstable branch at
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
From: Maurizio Lombardi <mlombard@redhat.com>
Subject: mm: prevent page_frag_alloc() from corrupting the memory
Date: Fri, 15 Jul 2022 14:50:13 +0200

A number of drivers call page_frag_alloc() with a fragment's size >
PAGE_SIZE.

In low memory conditions, __page_frag_cache_refill() may fail the order
3 cache allocation and fall back to order 0; In this case, the cache
will be smaller than the fragment, causing memory corruptions.

Prevent this from happening by checking if the newly allocated cache is
large enough for the fragment; if not, the allocation will fail and
page_frag_alloc() will return NULL.

Link: https://lkml.kernel.org/r/20220715125013.247085-1-mlombard@redhat.com
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Cc: Chen Lin <chen45464546@163.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/page_alloc.c~mm-prevent-page_frag_alloc-from-corrupting-the-memory
+++ a/mm/page_alloc.c
@@ -5697,6 +5697,18 @@ refill:
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = size - fragsz;
+		if (unlikely(offset < 0)) {
+			/*
+			 * The caller is trying to allocate a fragment
+			 * with fragsz > PAGE_SIZE but the cache isn't big
+			 * enough to satisfy the request, this may
+			 * happen in low memory conditions.
+			 * We don't release the cache page because
+			 * it could make memory pressure worse
+			 * so we simply return NULL here.
+			 */
+			return NULL;
+		}
 	}
 
 	nc->pagecnt_bias--;
_

Patches currently in -mm which might be from mlombard@redhat.com are

mm-prevent-page_frag_alloc-from-corrupting-the-memory.patch


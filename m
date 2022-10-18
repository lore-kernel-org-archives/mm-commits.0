Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FB6C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiJRWvw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJRWvs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:51:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A640BC629
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1FEBB820FF
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AEAC433C1;
        Tue, 18 Oct 2022 22:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666133504;
        bh=g/6hCvBXt/d2BvmXakg+tsl1hhVVIGsjRX0VhtM+z7I=;
        h=Date:To:From:Subject:From;
        b=fHG85F8BuGmTQEtfFnThINOi+eONPoUZ//G0HkyHSxWVLqwRalejzmalTkHJhxdMk
         r3RmkyugqWziz3hjFwFYTJFDbNwK3xPRlPyDFUXdoi+fg0yucx7yUoy3M6KnQR0G/3
         c0E908HUGvrAkxuiOT3f4NvxaXFnoPYysEYBdJWA=
Date:   Tue, 18 Oct 2022 15:51:43 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-use-kmalloc_size_roundup-to-match-ksize-usage.patch added to mm-unstable branch
Message-Id: <20221018225144.98AEAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempool: use kmalloc_size_roundup() to match ksize() usage
has been added to the -mm mm-unstable branch.  Its filename is
     mempool-use-kmalloc_size_roundup-to-match-ksize-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-use-kmalloc_size_roundup-to-match-ksize-usage.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: mempool: use kmalloc_size_roundup() to match ksize() usage
Date: Tue, 18 Oct 2022 02:03:29 -0700

Round up allocations with kmalloc_size_roundup() so that mempool's use of
ksize() is always accurate and no special handling of the memory is needed
by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Link: https://lkml.kernel.org/r/20221018090323.never.897-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempool.c~mempool-use-kmalloc_size_roundup-to-match-ksize-usage
+++ a/mm/mempool.c
@@ -526,7 +526,7 @@ EXPORT_SYMBOL(mempool_free_slab);
  */
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
 {
-	size_t size = (size_t)pool_data;
+	size_t size = kmalloc_size_roundup((size_t)pool_data);
 	return kmalloc(size, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_kmalloc);
_

Patches currently in -mm which might be from keescook@chromium.org are

mempool-use-kmalloc_size_roundup-to-match-ksize-usage.patch


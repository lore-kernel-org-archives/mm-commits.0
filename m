Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA8BC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiJCVJ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJCVHk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:07:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5F213FB2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B2D1CE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B297AC433D7;
        Mon,  3 Oct 2022 21:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831161;
        bh=UYXMMosqb8JoCjglsB2SBxV7bv75kNXlovx3dhBCTSA=;
        h=Date:To:From:Subject:From;
        b=Jc+FnEMMNGK/t9w7pZtALutPfQbvPqCH2tJtz8XtaNRBPHSM/J+Ks5PyBmzLdrw0t
         ISqwJHbIw754GRyFkRErztF9TK1XJ0ra4TWEE6TF0WxuKSmzrX93GzYeb0/GM3V1+z
         uS0G5jhv9tukQXs7MidsyQAYhQ//5Gy4LOIvxqo8=
Date:   Mon, 03 Oct 2022 14:06:00 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch removed from -mm tree
Message-Id: <20221003210601.B297AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: drop CONFIG_KASAN_GENERIC check from kasan_init_cache_meta
has been removed from the -mm tree.  Its filename was
     kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: drop CONFIG_KASAN_GENERIC check from kasan_init_cache_meta
Date: Mon, 5 Sep 2022 23:05:28 +0200

As kasan_init_cache_meta() is only defined for the Generic mode, it does
not require the CONFIG_KASAN_GENERIC check.

Link: https://lkml.kernel.org/r/211f8f2b213aa91e9148ca63342990b491c4917a.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/kasan/generic.c~kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta
+++ a/mm/kasan/generic.c
@@ -367,12 +367,6 @@ void kasan_init_cache_meta(struct kmem_c
 		/* Continue, since free meta might still fit. */
 	}
 
-	/* Only the generic mode uses free meta or flexible redzones. */
-	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
-		cache->kasan_info.free_meta_offset = KASAN_NO_FREE_META;
-		return;
-	}
-
 	/*
 	 * Add free meta into redzone when it's not possible to store
 	 * it in the object. This is the case when:
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


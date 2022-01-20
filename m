Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17AE7C43217
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358192AbiATCJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358196AbiATCJc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FEFC06161C
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54A63B81C96
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD854C004E1;
        Thu, 20 Jan 2022 02:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644569;
        bh=0sF5iacFD3zq/ccI2khSjBnlT3FvH3HLBtugO/zruNs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sJYk5J5cBiNgCZs+AAUpZ3dmd5jpKPyJyufL4o3J8n2jImBTXawyEqcLPaY9GnT3i
         7NvD4oZb1oVKHlw9wC9QD0E2otQvbTSqEveaYLGvfETz8FINIJW+gTEACTS9Fakrck
         D1jfkwWb7Oi03nsUEDiK6LVzSaVOh+SEnSw8BUGA=
Date:   Wed, 19 Jan 2022 18:09:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 33/55] lib/test_meminit: destroy cache in
 kmem_cache_alloc_bulk() test
Message-ID: <20220120020928.ied287stZ%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test

Make do_kmem_cache_size_bulk() destroy the cache it creates.

Link: https://lkml.kernel.org/r/aced20a94bf04159a139f0846e41d38a1537debb.1640018297.git.andreyknvl@google.com
Fixes: 03a9349ac0e0 ("lib/test_meminit: add a kmem_cache_alloc_bulk() test")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_meminit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_meminit.c~lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test
+++ a/lib/test_meminit.c
@@ -337,6 +337,7 @@ static int __init do_kmem_cache_size_bul
 		if (num)
 			kmem_cache_free_bulk(c, num, objects);
 	}
+	kmem_cache_destroy(c);
 	*total_failures += fail;
 	return 1;
 }
_

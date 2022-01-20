Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F92DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347803AbiATVa7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348004AbiATVa6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ED5C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 493D6618CC
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778B2C340E0;
        Thu, 20 Jan 2022 21:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714257;
        bh=bcav7QGgoJPDMMBrn/9z/W2oJtfq9sAi/zczO5HWO20=;
        h=Date:From:To:Subject:From;
        b=WCRYXblAOUIOyVxUST+P547aUhCg2KBpvRkwnBDaWRT7ck6jgybAI17HEfGFwd7iN
         MLjSuS85/GscV1kBu3Vmcoo3GYq778PDF6jrQiMDdCl9nIFMt2fp4VzZ9S3QMwtGws
         2ZDjfVrK1pOINJegUyPhGoxv6SdN/vGlSXF/16jE=
Date:   Thu, 20 Jan 2022 13:30:54 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com
Subject:  [merged]
 lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test.patch removed
 from -mm tree
Message-ID: <20220120213054.ArcSFePV6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test
has been removed from the -mm tree.  Its filename was
     lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are



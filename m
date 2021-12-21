Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2DAC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 23:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbhLUXLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 18:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbhLUXLp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 18:11:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3E5C061574
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 15:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8EB3617B8
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 23:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE59C36AE9;
        Tue, 21 Dec 2021 23:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640128304;
        bh=XqV2dcAA+jXLrSWgWqvQ1sUoipibXDxmOIxFn+e7tiI=;
        h=Date:From:To:Subject:From;
        b=0o/nPeK2pm40D+L1efM7VOE8KK37QD0EiAj2Wnns2hp/neUwb2uJe8opXZAROFUOg
         Yk7r3tlpacwb8y76HnzREevuntuOoSeSuTd59qj2/sUG/ioCoOIAKo3ehhE/tDVagp
         2vWrvr6rtj41KgutOymV+eyl/R726d9DvminToWk=
Date:   Tue, 21 Dec 2021 15:11:43 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com
Subject:  +
 lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test.patch added to
 -mm tree
Message-ID: <20211221231143.rM1ub%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_meminit: destroy cache in kmem_cache_alloc_bulk() test
has been added to the -mm tree.  Its filename is
     lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-fix-quarantine-conflicting-with-init_on_free.patch
lib-test_meminit-destroy-cache-in-kmem_cache_alloc_bulk-test.patch


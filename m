Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAE0EB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 17:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjGDRMH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 13:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjGDRMG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 13:12:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61C2E75;
        Tue,  4 Jul 2023 10:12:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B06661329;
        Tue,  4 Jul 2023 17:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E880C433C7;
        Tue,  4 Jul 2023 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688490722;
        bh=PIfZTDcLnlwKFoZ8bNlpOlu1mUDdM/k/1cXC4BzXGHM=;
        h=Date:To:From:Subject:From;
        b=IuNswrzYlOXPOqcHi7PZl7G6OGYukWIh9J4bZH18EsZDTpeOhTpqA4gHYR+dE9R8i
         qDSuLuu7OYPpqEYCvL6oLWV1eHAv/X0EbJgRGBybDah53wUSYx4M1r4TLzOYSYU3gp
         2W0DjxgCcqoly3h0WSOIMVDwdODuJPnfABg4wVz4=
Date:   Tue, 04 Jul 2023 10:12:01 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, arnd@arndb.de, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-type-cast-in-memory_is_poisoned_n.patch added to mm-hotfixes-unstable branch
Message-Id: <20230704171202.9E880C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix type cast in memory_is_poisoned_n
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-fix-type-cast-in-memory_is_poisoned_n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-type-cast-in-memory_is_poisoned_n.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix type cast in memory_is_poisoned_n
Date: Tue, 4 Jul 2023 02:52:05 +0200

Commit bb6e04a173f0 ("kasan: use internal prototypes matching gcc-13
builtins") introduced a bug into the memory_is_poisoned_n implementation:
it effectively removed the cast to a signed integer type after applying
KASAN_GRANULE_MASK.

As a result, KASAN started failing to properly check memset, memcpy, and
other similar functions.

Fix the bug by adding the cast back (through an additional signed integer
variable to make the code more readable).

Link: https://lkml.kernel.org/r/8c9e0251c2b8b81016255709d4ec42942dcaf018.1688431866.git.andreyknvl@google.com
Fixes: bb6e04a173f0 ("kasan: use internal prototypes matching gcc-13 builtins")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/generic.c~kasan-fix-type-cast-in-memory_is_poisoned_n
+++ a/mm/kasan/generic.c
@@ -130,9 +130,10 @@ static __always_inline bool memory_is_po
 	if (unlikely(ret)) {
 		const void *last_byte = addr + size - 1;
 		s8 *last_shadow = (s8 *)kasan_mem_to_shadow(last_byte);
+		s8 last_accessible_byte = (unsigned long)last_byte & KASAN_GRANULE_MASK;
 
 		if (unlikely(ret != (unsigned long)last_shadow ||
-			(((long)last_byte & KASAN_GRANULE_MASK) >= *last_shadow)))
+			     last_accessible_byte >= *last_shadow))
 			return true;
 	}
 	return false;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-type-cast-in-memory_is_poisoned_n.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2F5C00528
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjGIAaj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjGIAaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3A5E58;
        Sat,  8 Jul 2023 17:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB4960B62;
        Sun,  9 Jul 2023 00:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D220C433C7;
        Sun,  9 Jul 2023 00:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862629;
        bh=gM5k3tfuSs+XWS3CsJriy7uhzjGe2poHxBR1hp/dYkU=;
        h=Date:To:From:Subject:From;
        b=wM9K2RM7V4iiInpAaUYxUBQTzRIU6j9Won3fDcA18mSh/9gSY86qX+bTmuCwa+6fw
         rV+y7fsyKX5wTabPT/bMjodggk9TSfmjUgmyb7aQE1xMbjh34ctlBVm13r62Fsfyvd
         KAgS3MrW8rgHv1A0EAkddS1TZI5bWOhI579aGDFg=
Date:   Sat, 08 Jul 2023 17:30:28 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, arnd@arndb.de, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-fix-type-cast-in-memory_is_poisoned_n.patch removed from -mm tree
Message-Id: <20230709003029.3D220C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: fix type cast in memory_is_poisoned_n
has been removed from the -mm tree.  Its filename was
     kasan-fix-type-cast-in-memory_is_poisoned_n.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAAAC4332B
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DB8E22EBF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731606AbhAYWzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732351AbhAYWzU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 17:55:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7CF6221E7;
        Mon, 25 Jan 2021 22:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611615280;
        bh=+k7nQGdfNknTKoIc0ev2F2hU+dIn97Xw1I5/TRQZg7M=;
        h=Date:From:To:Subject:From;
        b=kSQnEv7yupp4phZ2kqi7wcW8rD485DTxqyCoM4K2FgeHd8u4PZHKYJ4jAK1kbxeLW
         nLwdqBKdpdbq/tBPpHuioyyb2yH95T4YyUBLC1cE0CPeBKtpyLKpRkqirWNU9AAL6h
         HOrn11vaF8jOjbwhTvhlDUvZLucW5NdqitazujW8=
Date:   Mon, 25 Jan 2021 14:54:39 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject:  + kasan-add-match-all-tag-tests-fix.patch added to -mm
 tree
Message-ID: <20210125225439.pNNi3p82q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: export kasan_poison
has been added to the -mm tree.  Its filename is
     kasan-add-match-all-tag-tests-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-match-all-tag-tests-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-match-all-tag-tests-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: export kasan_poison

The unit test module fails to build after adding a reference
to kasan_poison:

ERROR: modpost: "kasan_poison" [lib/test_kasan.ko] undefined!

Export this symbol to make it available to loadable modules.

Link: https://lkml.kernel.org/r/20210125112831.2156212-1-arnd@kernel.org
Fixes: b9b322c2bba9 ("kasan: add match-all tag tests")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/shadow.c~kasan-add-match-all-tag-tests-fix
+++ a/mm/kasan/shadow.c
@@ -89,6 +89,7 @@ void kasan_poison(const void *address, s
 
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
+EXPORT_SYMBOL_GPL(kasan_poison);
 
 void kasan_unpoison(const void *address, size_t size)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-add-match-all-tag-tests-fix.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix.patch


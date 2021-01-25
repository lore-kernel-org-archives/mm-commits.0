Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E28EC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50589221EB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbhAYWsE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732386AbhAYWrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 17:47:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23966221EB;
        Mon, 25 Jan 2021 22:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611614793;
        bh=9VhYy3Kdzg4cqr9EkvoBLEPUh2m1m2JHoym8mGx8MF8=;
        h=Date:From:To:Subject:From;
        b=ayv/0zMF4DKcRHW+Wcp+Wl63mi0Yb6CXmZWRQUZB+JlzbraFXhjcC2y+FxuoP8a18
         LyqB46PW6cE4HrdK02DB4PxBebRxuOmSps5bzvkrzAOyH802+E107Y0Xpd19uSDlk+
         zyyEVI0wgR+KUIF++UFkKJouD+nMht2HEaqPbTOQ=
Date:   Mon, 25 Jan 2021 14:46:32 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  +
 =?US-ASCII?Q?set=5Fmemory-allow-querying-whether-set=5Fdirect=5Fmap=5F-i?=
 =?US-ASCII?Q?s-actually-enabled-fix.patch?= added to -mm tree
Message-ID: <20210125224632.WBHDD1ECt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kfence: fix header inclusion
has been added to the -mm tree.  Its filename is
     set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix.patch

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
Subject: arm64: kfence: fix header inclusion

Randconfig builds started warning about a missing function declaration
after set_memory_valid() is moved to a new file:

In file included from mm/kfence/core.c:26:
arch/arm64/include/asm/kfence.h:17:2: error: implicit declaration of function 'set_memory_valid' [-Werror,-Wimplicit-function-declaration]

Include the correct header again.

Link: https://lkml.kernel.org/r/20210125125025.102381-1-arnd@kernel.org
Fixes: 9e18ec3cfabd ("set_memory: allow querying whether set_direct_map_*() is actually enabled")
Fixes: 204555ff8bd6 ("arm64, kfence: enable KFENCE for ARM64")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kfence.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/kfence.h~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix
+++ a/arch/arm64/include/asm/kfence.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_KFENCE_H
 #define __ASM_KFENCE_H
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 static inline bool arch_kfence_init_pool(void) { return true; }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix.patch


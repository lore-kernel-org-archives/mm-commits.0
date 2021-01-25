Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662FAC433DB
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35B0222202
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbhAYWbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:31:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732230AbhAYWbn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 17:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D90822202;
        Mon, 25 Jan 2021 22:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611613862;
        bh=t6Wc5FJnreeoEh/ZBka43KuLwM11AA31/F19KT6l3Ns=;
        h=Date:From:To:Subject:From;
        b=uPZBE329N8LdT2x9fkVVwfMjBdKdCyOVFmcGxTWMKppK2w4xnmegbltimJDBa/oza
         2Aj08OO2Q8SM9nKji0qEvrCsuDEhz599jvgEG2+DJej08qoCwrl5ojLxhtGC1TE+Dt
         RlY5zoEG49FQpExdPYwoxs7CrY2361SK8KIr5nxY=
Date:   Mon, 25 Jan 2021 14:31:01 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org
Subject:  + arm64-kfence-enable-kfence-for-arm64-fix-2.patch added
 to -mm tree
Message-ID: <20210125223101.e_-bMiyQy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kfence: fix header inclusion
has been added to the -mm tree.  Its filename is
     arm64-kfence-enable-kfence-for-arm64-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kfence-enable-kfence-for-arm64-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kfence-enable-kfence-for-arm64-fix-2.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kfence.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/kfence.h~arm64-kfence-enable-kfence-for-arm64-fix-2
+++ a/arch/arm64/include/asm/kfence.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_KFENCE_H
 #define __ASM_KFENCE_H
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 #define KFENCE_SKIP_ARCH_FAULT_HANDLER "el1_sync"
 
_

Patches currently in -mm which might be from arnd@arndb.de are

arm64-kfence-enable-kfence-for-arm64-fix-2.patch


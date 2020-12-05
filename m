Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9721DC433FE
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47B9122D70
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgLEBOu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 20:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLEBOu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 20:14:50 -0500
Date:   Fri, 04 Dec 2020 17:14:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607130850;
        bh=rZmrCdkr9b7O06fuUSB/rgpw5LqNP0TxgegaeWPzK60=;
        h=From:To:Subject:From;
        b=PEu3l72V6QrrDz0i7XBqzkymXy3QEBp8v8jme3RCCWwUzoepunEvllfq4/THff1Fg
         sIiyv5cfFq+5ZNvjVrH/UuLoBHe6uQwIveMnE1zMS7N4JIQx1bMYrXVuXgcKgrev6S
         3vvuu6eLGvwhhhkFfPTEHC+yrfwNYZ7KQrpMtCFg=
From:   akpm@linux-foundation.org
To:     anders.roxell@linaro.org, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, will@kernel.org
Subject:  +
 =?US-ASCII?Q?set=5Fmemory-allow-querying-whether-set=5Fdirect=5Fmap=5F-i?=
 =?US-ASCII?Q?s-actually-enabled-fix.patch?= added to -mm tree
Message-ID: <20201205011409.o9PNsRntR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: fix implicit function declaration
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
From: Anders Roxell <anders.roxell@linaro.org>
Subject: kfence: fix implicit function declaration

When building kfence the following error shows up:

In file included from mm/kfence/report.c:13:
arch/arm64/include/asm/kfence.h: In function `kfence_protect_page':
arch/arm64/include/asm/kfence.h:12:2: error: implicit declaration of function `set_memory_valid' [-Werror=implicit-function-declaration]
   12 |  set_memory_valid(addr, 1, !protect);
      |  ^~~~~~~~~~~~~~~~

Use the correct include both
f2b7c491916d ("set_memory: allow querying whether set_direct_map_*() is actually enabled")
and 4c4c75881536 ("arm64, kfence: enable KFENCE for ARM64") went in the
same day via different trees.

Link: https://lkml.kernel.org/r/20201204121804.1532849-1-anders.roxell@linaro.org
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kfence.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/kfence.h~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix
+++ a/arch/arm64/include/asm/kfence.h
@@ -3,7 +3,7 @@
 #ifndef __ASM_KFENCE_H
 #define __ASM_KFENCE_H
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 static inline bool arch_kfence_init_pool(void) { return true; }
 
_

Patches currently in -mm which might be from anders.roxell@linaro.org are

set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled-fix.patch


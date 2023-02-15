Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DD9C636D4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 20:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjBOUXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 15:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBOUXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 15:23:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FEA4203
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 12:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA87761D6F
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 20:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051CCC433EF;
        Wed, 15 Feb 2023 20:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676492585;
        bh=uf54wzC1LTbqMvNBzVTKiu0J76EUYdUE4pH9FfiQW78=;
        h=Date:To:From:Subject:From;
        b=qwcDDwYzqL3sdGKjVfZxVAwiJmveQYVUNPkqC/m3nHbVmjonAzJv9AgHr8lzYcTC1
         1Mosiq0dWOXyam73JgufJ6xTksQhOQYhK3X0iRp0k3Awscgf5MqX7xb5K9Pf0uTwE/
         eTaJwRMKPgvy43o8/E1FL7ECVUALvNVYgNfsLJho=
Date:   Wed, 15 Feb 2023 12:23:04 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, peterz@infradead.org,
        Kuan-Ying.Lee@mediatek.com, jpoimboe@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-mark-addr_has_metadata-__always_inline.patch added to mm-unstable branch
Message-Id: <20230215202305.051CCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: mark addr_has_metadata __always_inline
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-mark-addr_has_metadata-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-mark-addr_has_metadata-__always_inline.patch

This patch will later appear in the mm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: mark addr_has_metadata __always_inline
Date: Wed, 15 Feb 2023 14:00:56 +0100

Patch series "objtool warning fixes", v2.

These are three of the easier fixes for objtool warnings around
kasan/kmsan/kcsan.  I dropped one patch since Peter had come up with a
better fix, and adjusted the changelog text based on feedback.


This patch (of 3):

When the compiler decides not to inline this function, objtool complains
about incorrect UACCESS state:

mm/kasan/generic.o: warning: objtool: __asan_load2+0x11: call to addr_has_metadata() with UACCESS enabled

Link: https://lore.kernel.org/all/20230208164011.2287122-1-arnd@kernel.org/
Link: https://lkml.kernel.org/r/20230215130058.3836177-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan.h~kasan-mark-addr_has_metadata-__always_inline
+++ a/mm/kasan/kasan.h
@@ -297,7 +297,7 @@ static inline const void *kasan_shadow_t
 		<< KASAN_SHADOW_SCALE_SHIFT);
 }
 
-static inline bool addr_has_metadata(const void *addr)
+static __always_inline bool addr_has_metadata(const void *addr)
 {
 	return (kasan_reset_tag(addr) >=
 		kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
@@ -316,7 +316,7 @@ bool kasan_check_range(unsigned long add
 
 #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
-static inline bool addr_has_metadata(const void *addr)
+static __always_inline bool addr_has_metadata(const void *addr)
 {
 	return (is_vmalloc_addr(addr) || virt_addr_valid(addr));
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch
kasan-mark-addr_has_metadata-__always_inline.patch
kmsan-disable-ftrace-in-kmsan-core-code.patch
objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write.patch


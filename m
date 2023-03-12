Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15126C74A4B
	for <mm-commits@archiver.kernel.org>; Sun, 12 Mar 2023 20:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCLU2R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 16:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCLU2P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 16:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF34918164
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 13:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85BC260FCD
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 20:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C982BC433EF;
        Sun, 12 Mar 2023 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678652892;
        bh=DgWIRh2vmbl+x0R+cuG/VVB8m7C10bsC8gkbc8tVLg8=;
        h=Date:To:From:Subject:From;
        b=fGz6+58dRWFaErFvpLq2tWCac0cHugyaP1XQrfXE7GmRZxWBqGf31uuPbtiaanMTV
         sDbGpTbEb4RvV2CQniiZLdWusZOZWtMp/aU7M/58+WuXcYV697Vg6FuxrYT7kcpAyW
         uZ0wbgNgTgfAzBCvYpyT57Uz6IWl8vssYHGQW78E=
Date:   Sun, 12 Mar 2023 13:28:12 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        ouyangweizhao@zeku.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-drop-empty-tagging-related-defines.patch added to mm-unstable branch
Message-Id: <20230312202812.C982BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: drop empty tagging-related defines
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-drop-empty-tagging-related-defines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-drop-empty-tagging-related-defines.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: drop empty tagging-related defines
Date: Sat, 11 Mar 2023 00:43:29 +0100

mm/kasan/kasan.h provides a number of empty defines for a few
arch-specific tagging-related routines, in case the architecture code
didn't define them.

The original idea was to simplify integration in case another architecture
starts supporting memory tagging.  However, right now, if any of those
routines are not provided by an architecture, Hardware Tag-Based KASAN
won't work.

Drop the empty defines, as it would be better to get compiler errors
rather than runtime crashes when adding support for a new architecture.

Also drop empty hw_enable_tagging_sync/async/asymm defines for
!CONFIG_KASAN_HW_TAGS case, as those are only used in mm/kasan/hw_tags.c.

Link: https://lkml.kernel.org/r/bc919c144f8684a7fd9ba70c356ac2a75e775e29.1678491668.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com> [arm64]
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Weizhao Ouyang <ouyangweizhao@zeku.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/kasan.h~kasan-drop-empty-tagging-related-defines
+++ a/mm/kasan/kasan.h
@@ -395,28 +395,6 @@ static inline const void *arch_kasan_set
 
 #ifdef CONFIG_KASAN_HW_TAGS
 
-#ifndef arch_enable_tagging_sync
-#define arch_enable_tagging_sync()
-#endif
-#ifndef arch_enable_tagging_async
-#define arch_enable_tagging_async()
-#endif
-#ifndef arch_enable_tagging_asymm
-#define arch_enable_tagging_asymm()
-#endif
-#ifndef arch_force_async_tag_fault
-#define arch_force_async_tag_fault()
-#endif
-#ifndef arch_get_random_tag
-#define arch_get_random_tag()	(0xFF)
-#endif
-#ifndef arch_get_mem_tag
-#define arch_get_mem_tag(addr)	(0xFF)
-#endif
-#ifndef arch_set_mem_tag_range
-#define arch_set_mem_tag_range(addr, size, tag, init) ((void *)(addr))
-#endif
-
 #define hw_enable_tagging_sync()		arch_enable_tagging_sync()
 #define hw_enable_tagging_async()		arch_enable_tagging_async()
 #define hw_enable_tagging_asymm()		arch_enable_tagging_asymm()
@@ -430,10 +408,6 @@ void kasan_enable_tagging(void);
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
-#define hw_enable_tagging_sync()
-#define hw_enable_tagging_async()
-#define hw_enable_tagging_asymm()
-
 static inline void kasan_enable_tagging(void) { }
 
 #endif /* CONFIG_KASAN_HW_TAGS */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-empty-tagging-related-defines.patch
kasan-arm64-rename-tagging-related-routines.patch
kasan-arm64-add-arch_suppress_tag_checks_start-stop.patch
kasan-suppress-recursive-reports-for-hw_tags.patch
kcov-improve-documentation.patch
kcov-improve-documentation-v2.patch
kcov-improve-documentation-v3.patch


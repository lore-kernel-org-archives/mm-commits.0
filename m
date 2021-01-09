Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7C1C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 01:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98A5C23A04
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 01:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbhAIB2s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jan 2021 20:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbhAIB2s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 Jan 2021 20:28:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C38A423A03;
        Sat,  9 Jan 2021 01:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610155687;
        bh=vPsBdUzba8jiiO88+E1G/lTd8IMiXkZA0LHQ5naOKNE=;
        h=Date:From:To:Subject:From;
        b=Uho40QeIKAz2G6ILKaDdA7KOBO6GjEQX0uYtBxKhbBWjNHMrZUnUqZ2ck5Fsk4yDT
         OkGxFYDtGdw5hia+RqmGQ0U56gpJCOSixaH2AswZnN5Xa6rwT4X+z46OpVpuc1VuZf
         Nq9+FoAtjv6LaB/0wvcpCVmGduKL0Ts/dHAm1jk4=
Date:   Fri, 08 Jan 2021 17:28:06 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, aryabinin@virtuozzo.com,
        dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, walter-zh.wu@mediatek.com
Subject:  + kasan-remove-redundant-config-option-v3.patch added to
 -mm tree
Message-ID: <20210109012806.rcgWWOgn-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-remove-redundant-config-option-v3
has been added to the -mm tree.  Its filename is
     kasan-remove-redundant-config-option-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-redundant-config-option-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-redundant-config-option-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan-remove-redundant-config-option-v3

fix remaining the pre-processor syntax

Link: https://lkml.kernel.org/r/20210108040940.1138-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan         |    3 +--
 mm/kasan/common.c         |    2 +-
 mm/kasan/report_generic.c |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/lib/Kconfig.kasan~kasan-remove-redundant-config-option-v3
+++ a/lib/Kconfig.kasan
@@ -139,10 +139,9 @@ config KASAN_INLINE
 endchoice
 
 config KASAN_STACK
-	bool "Enable stack instrumentation (unsafe)"
+	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
 	default y if CC_IS_GCC
-	default n if CC_IS_CLANG
 	help
 	  The LLVM stack address sanitizer has a know problem that
 	  causes excessive stack usage in a lot of functions, see
--- a/mm/kasan/common.c~kasan-remove-redundant-config-option-v3
+++ a/mm/kasan/common.c
@@ -63,7 +63,7 @@ void __kasan_unpoison_range(const void *
 	kasan_unpoison(address, size);
 }
 
-#if defined(CONFIG_KASAN_STACK)
+#ifdef CONFIG_KASAN_STACK
 /* Unpoison the entire stack for a task. */
 void kasan_unpoison_task_stack(struct task_struct *task)
 {
--- a/mm/kasan/report_generic.c~kasan-remove-redundant-config-option-v3
+++ a/mm/kasan/report_generic.c
@@ -128,7 +128,7 @@ void kasan_metadata_fetch_row(char *buff
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
 }
 
-#if defined(CONFIG_KASAN_STACK)
+#ifdef CONFIG_KASAN_STACK
 static bool __must_check tokenize_frame_descr(const char **frame_descr,
 					      char *token, size_t max_tok_len,
 					      unsigned long *value)
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

kasan-remove-redundant-config-option.patch
kasan-remove-redundant-config-option-v3.patch


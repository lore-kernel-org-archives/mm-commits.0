Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7722BC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DB876056B
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhJTW3w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTW3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 18:29:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7882611CC;
        Wed, 20 Oct 2021 22:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634768857;
        bh=vFXtX4SVgNlzoOrAGg779gxSeVn2saMce01eJFqnOH8=;
        h=Date:From:To:Subject:From;
        b=RhnqXZ8/Mj/cvQTMCbrtYbCguBvI8dSNrl8jXxj/IQ6HNANpw+uRCSTggEXMHVQsA
         aH+55X2gJxKXiHlZx60O52RIKs56PwFErrLEUl0aGoLK6tQPvJHHBql5hVidUK/FEW
         01lJPBKNOSkyEhEiurluN1SMChiK144/7xdodPQs=
Date:   Wed, 20 Oct 2021 15:27:36 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dvyukov@google.com, elver@google.com,
        glider@google.com, Kuan-Ying.Lee@mediatek.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        nicholas.tang@mediatek.com, ryabinin.a.a@gmail.com,
        will@kernel.org, yee.lee@mediatek.com
Subject:  + kasan-add-kasan-mode-messages-when-kasan-init.patch
 added to -mm tree
Message-ID: <20211020222736.Rh38mgPZV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add kasan mode messages when kasan init
has been added to the -mm tree.  Its filename is
     kasan-add-kasan-mode-messages-when-kasan-init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-kasan-mode-messages-when-kasan-init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-kasan-mode-messages-when-kasan-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kasan: add kasan mode messages when kasan init

There are multiple kasan modes.  It makes sense that we add some messages
to know which kasan mode is when booting up.  see [1].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=212195 [1]
Link: https://lkml.kernel.org/r/20211020094850.4113-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Yee Lee <yee.lee@mediatek.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/kasan_init.c |    2 +-
 mm/kasan/hw_tags.c         |   14 +++++++++++++-
 mm/kasan/sw_tags.c         |    2 +-
 3 files changed, 15 insertions(+), 3 deletions(-)

--- a/arch/arm64/mm/kasan_init.c~kasan-add-kasan-mode-messages-when-kasan-init
+++ a/arch/arm64/mm/kasan_init.c
@@ -309,7 +309,7 @@ void __init kasan_init(void)
 	kasan_init_depth();
 #if defined(CONFIG_KASAN_GENERIC)
 	/* CONFIG_KASAN_SW_TAGS also requires kasan_init_sw_tags(). */
-	pr_info("KernelAddressSanitizer initialized\n");
+	pr_info("KernelAddressSanitizer initialized (generic)\n");
 #endif
 }
 
--- a/mm/kasan/hw_tags.c~kasan-add-kasan-mode-messages-when-kasan-init
+++ a/mm/kasan/hw_tags.c
@@ -106,6 +106,16 @@ static int __init early_kasan_flag_stack
 }
 early_param("kasan.stacktrace", early_kasan_flag_stacktrace);
 
+static inline const char *kasan_mode_info(void)
+{
+	if (kasan_mode == KASAN_MODE_ASYNC)
+		return "async";
+	else if (kasan_mode == KASAN_MODE_ASYMM)
+		return "asymm";
+	else
+		return "sync";
+}
+
 /* kasan_init_hw_tags_cpu() is called for each CPU. */
 void kasan_init_hw_tags_cpu(void)
 {
@@ -177,7 +187,9 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
-	pr_info("KernelAddressSanitizer initialized\n");
+	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, stacktrace=%s)\n",
+		kasan_mode_info(),
+		kasan_stack_collection_enabled() ? "on" : "off");
 }
 
 void kasan_alloc_pages(struct page *page, unsigned int order, gfp_t flags)
--- a/mm/kasan/sw_tags.c~kasan-add-kasan-mode-messages-when-kasan-init
+++ a/mm/kasan/sw_tags.c
@@ -42,7 +42,7 @@ void __init kasan_init_sw_tags(void)
 	for_each_possible_cpu(cpu)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
-	pr_info("KernelAddressSanitizer initialized\n");
+	pr_info("KernelAddressSanitizer initialized (sw-tags)\n");
 }
 
 /*
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

kasan-add-kasan-mode-messages-when-kasan-init.patch


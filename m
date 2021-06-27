Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C6CC48BC2
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BA4B61C2E
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhF0Vr7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhF0Vr6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B18619BF;
        Sun, 27 Jun 2021 21:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830333;
        bh=gjmw086za6ccNGKKb0KGcD79ZUAGi5oS+DJU81bJ86Q=;
        h=Date:From:To:Subject:From;
        b=OtVozTdUWAL+h18cDPUze374wFahHCDaXpGaszwDjRLqzwrdcVilm2YMEGDkAdeCY
         L2T5akA8eHUDdLQyDySaJdDnCBCiNlI6qxYFEDTezxvEEU90ycNpR4F7RHVzXVY/dF
         dr7BTD2XsIq7OBZCOkpdjtcGUU3L5C2BaJbpplXw=
Date:   Sun, 27 Jun 2021 14:45:32 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, chinwen.chang@mediatek.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, Kuan-Ying.Lee@mediatek.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        nicholas.tang@mediatek.com, ryabinin.a.a@gmail.com
Subject:  +
 =?US-ASCII?Q?kasan-rename-config=5Fkasan=5Fsw=5Ftags=5Fidentify-to-conf?=
 =?US-ASCII?Q?ig=5Fkasan=5Ftags=5Fidentify.patch?= added to -mm tree
Message-ID: <20210627214532.-ZB0S0PNL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename CONFIG_KASAN_SW_TAGS_IDENTIFY to CONFIG_KASAN_TAGS_IDENTIFY
has been added to the -mm tree.  Its filename is
     kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify.patch

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
Subject: kasan: rename CONFIG_KASAN_SW_TAGS_IDENTIFY to CONFIG_KASAN_TAGS_IDENTIFY

Patch series "kasan: add memory corruption identification support for hw tag-based kasan", v4.

Add memory corruption identification for hardware tag-based KASAN mode.


This patch (of 3):

Rename CONFIG_KASAN_SW_TAGS_IDENTIFY to CONFIG_KASAN_TAGS_IDENTIFY in
order to be compatible with hardware tag-based mode.

Link: https://lkml.kernel.org/r/20210626100931.22794-1-Kuan-Ying.Lee@mediatek.com
Link: https://lkml.kernel.org/r/20210626100931.22794-2-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan         |    2 +-
 mm/kasan/kasan.h          |    4 ++--
 mm/kasan/report_sw_tags.c |    2 +-
 mm/kasan/sw_tags.c        |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/lib/Kconfig.kasan~kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify
+++ a/lib/Kconfig.kasan
@@ -167,7 +167,7 @@ config KASAN_STACK
 	  instrumentation is also disabled as it adds inline-style
 	  instrumentation that is run unconditionally.
 
-config KASAN_SW_TAGS_IDENTIFY
+config KASAN_TAGS_IDENTIFY
 	bool "Enable memory corruption identification"
 	depends on KASAN_SW_TAGS
 	help
--- a/mm/kasan/kasan.h~kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify
+++ a/mm/kasan/kasan.h
@@ -153,7 +153,7 @@ struct kasan_track {
 	depot_stack_handle_t stack;
 };
 
-#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
+#ifdef CONFIG_KASAN_TAGS_IDENTIFY
 #define KASAN_NR_FREE_STACKS 5
 #else
 #define KASAN_NR_FREE_STACKS 1
@@ -170,7 +170,7 @@ struct kasan_alloc_meta {
 #else
 	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
 #endif
-#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
+#ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	u8 free_pointer_tag[KASAN_NR_FREE_STACKS];
 	u8 free_track_idx;
 #endif
--- a/mm/kasan/report_sw_tags.c~kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify
+++ a/mm/kasan/report_sw_tags.c
@@ -31,7 +31,7 @@
 
 const char *kasan_get_bug_type(struct kasan_access_info *info)
 {
-#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
+#ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
 	struct kmem_cache *cache;
 	struct page *page;
--- a/mm/kasan/sw_tags.c~kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify
+++ a/mm/kasan/sw_tags.c
@@ -177,7 +177,7 @@ void kasan_set_free_info(struct kmem_cac
 	if (!alloc_meta)
 		return;
 
-#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
+#ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	idx = alloc_meta->free_track_idx;
 	alloc_meta->free_pointer_tag[idx] = tag;
 	alloc_meta->free_track_idx = (idx + 1) % KASAN_NR_FREE_STACKS;
@@ -196,7 +196,7 @@ struct kasan_track *kasan_get_free_track
 	if (!alloc_meta)
 		return NULL;
 
-#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
+#ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	for (i = 0; i < KASAN_NR_FREE_STACKS; i++) {
 		if (alloc_meta->free_pointer_tag[i] == tag)
 			break;
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

kasan-rename-config_kasan_sw_tags_identify-to-config_kasan_tags_identify.patch
kasan-integrate-the-common-part-of-two-kasan-tag-based-modes.patch
kasan-add-memory-corruption-identification-support-for-hardware-tag-based-mode.patch


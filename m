Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B58C49EA6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 483D7613C3
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFXU4k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhFXU4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:56:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7EFB613C7;
        Thu, 24 Jun 2021 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624568060;
        bh=L0kUIGq1TjMz88Tvqg6kORw2N0R0XfIoXCOChFuvtek=;
        h=Date:From:To:Subject:From;
        b=oyi51mFOczuadCn/l7g/63GgvCNPUgOVTBF96ieV1cY0eltwbUtnZmW6MaIDWIJyC
         9aPHxE/sloE2dTl/9qxVtKAnD81eWCF9Ul+/06q60xEen0P18VPYijQtEam9lO/ToP
         DxKj22LxRQY6iDAK+/6jSebY8wI2IPDZpm66Llgo=
Date:   Thu, 24 Jun 2021 13:54:19 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, glider@google.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, yee.lee@mediatek.com
Subject:  +
 kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch added to
 -mm tree
Message-ID: <20210624205419.S-O4JsHNk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add memzero init for unaligned size under SLUB debug
has been added to the -mm tree.  Its filename is
     kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yee Lee <yee.lee@mediatek.com>
Subject: kasan: add memzero init for unaligned size under SLUB debug

Issue: when SLUB debug is on, hwtag kasan_unpoison() would overwrite the
redzone of object with unaligned size.

An additional memzero_explicit() path is added to replacing init by hwtag
instruction for those unaligned size at SLUB debug mode.

Link: https://lkml.kernel.org/r/20210624112624.31215-2-yee.lee@mediatek.com
Signed-off-by: Yee Lee <yee.lee@mediatek.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/kasan/kasan.h~kasan-add-memzero-init-for-unaligned-size-under-slub-debug
+++ a/mm/kasan/kasan.h
@@ -387,6 +387,12 @@ static inline void kasan_unpoison(const
 
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
+#if IS_ENABLED(CONFIG_SLUB_DEBUG)
+	if (init && ((unsigned long)size & KASAN_GRANULE_MASK)) {
+		init = false;
+		memzero_explicit((void *)addr, size);
+	}
+#endif
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
 	hw_set_mem_tag_range((void *)addr, size, tag, init);
_

Patches currently in -mm which might be from yee.lee@mediatek.com are

kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch


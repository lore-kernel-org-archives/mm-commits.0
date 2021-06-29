Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B29C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 18:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2645961DC0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 18:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhF2SuM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Jun 2021 14:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232615AbhF2SuL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Jun 2021 14:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B361261D0F;
        Tue, 29 Jun 2021 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624992462;
        bh=MSApD/a2u5w48W/wq19pKRcc9in7V9MPwSPOU5uBkco=;
        h=Date:From:To:Subject:From;
        b=tSOEo5DBPHMr5g7FshZi1J1ZD4GAeFUFmW9cnI8Ybk9RPZJs7u4OrMv+QwLryKAUt
         EeUNxfyXeYst6qpwTM6BI5nCgMPj5+TzsT8pbqDaPT7CacmtlWL2aejGJAE9z7vKA+
         UKrEBzUxxpGUdqyEs/ejgMhxFacCpzJbCIgBQLiU=
Date:   Tue, 29 Jun 2021 11:47:42 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, glider@google.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, yee.lee@mediatek.com
Subject:  [to-be-updated]
 kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch removed
 from -mm tree
Message-ID: <20210629184742.C82oEyipm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add memzero init for unaligned size under SLUB debug
has been removed from the -mm tree.  Its filename was
     kasan-add-memzero-init-for-unaligned-size-under-slub-debug.patch

This patch was dropped because an updated version will be merged

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



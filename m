Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F495C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5238D64F73
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhCLSbt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233222AbhCLSbk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:31:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11D564F69;
        Fri, 12 Mar 2021 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615573900;
        bh=X8G+Bak9/6OTW+S8stABkMsg2KqPOVhnMht7iKvuARc=;
        h=Date:From:To:Subject:From;
        b=KZhZplGXwX1mc/NmqHu7OltsRhQawb1sqBMPM6Ue+3hSDwS1ccrGkL9L3L+1vG80V
         5gbvW41hfLGj6DI6/8I8FX4v2i6LvCM1VI43MZEboc6KbAdGVs+zQdPwJ6AnEUpucZ
         uPeSZspJ4KRiCWxY0gGGYzENkBrpD0NzqrJsirBE=
Date:   Fri, 12 Mar 2021 10:31:39 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ryabinin.a.a@gmail.com,
        walter-zh.wu@mediatek.com
Subject:  + kasan-remove-redundant-config-option-fix.patch added to
 -mm tree
Message-ID: <20210312183139.v7M5UPlut%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-remove-redundant-config-option-fix
has been added to the -mm tree.  Its filename is
     kasan-remove-redundant-config-option-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-redundant-config-option-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-redundant-config-option-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-remove-redundant-config-option-fix

fix merge snafu

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |    6 ------
 1 file changed, 6 deletions(-)

--- a/lib/Kconfig.kasan~kasan-remove-redundant-config-option-fix
+++ a/lib/Kconfig.kasan
@@ -155,12 +155,6 @@ config KASAN_STACK
 	  CONFIG_COMPILE_TEST.	On gcc it is assumed to always be safe
 	  to use and enabled by default.
 
-config KASAN_STACK
-	bool
-	depends on KASAN_GENERIC || KASAN_SW_TAGS
-	default 1 if KASAN_STACK_ENABLE || CC_IS_GCC
-	default 0
-
 config KASAN_SW_TAGS_IDENTIFY
 	bool "Enable memory corruption identification"
 	depends on KASAN_SW_TAGS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627F8C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2162E61165
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhDIUHO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhDIUHO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:07:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698E561108;
        Fri,  9 Apr 2021 20:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617998820;
        bh=FMafFTtRyudqtf8QuL2ZNlNAzR7qEtY7d6WU5vVBLtk=;
        h=Date:From:To:Subject:From;
        b=CzGCwHfhMZ6jBuzF+KafmyJJM4r2pXEtHBcegy13LHC/fEXZGH3Bk747yYFb0YsWS
         IubLJ92JUGHaRoOySzCMewsiCGckMu93bwwGWKBeMxAHynJHxxTPofKe9B/TFjEnQn
         CfoxsmLoeBt8Mi+Bhwrw0HWF1GD9+mNmIINr439U=
Date:   Fri, 09 Apr 2021 13:06:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ryabinin.a.a@gmail.com,
        walter-zh.wu@mediatek.com
Subject:  [folded-merged]
 kasan-remove-redundant-config-option-fix.patch removed from -mm tree
Message-ID: <20210409200659.4w2iZ2ttb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-remove-redundant-config-option-fix
has been removed from the -mm tree.  Its filename was
     kasan-remove-redundant-config-option-fix.patch

This patch was dropped because it was folded into kasan-remove-redundant-config-option.patch

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

kasan-remove-redundant-config-option.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
lib-test_kasan_modulec-suppress-unused-var-warning.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


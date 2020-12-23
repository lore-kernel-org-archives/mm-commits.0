Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A23C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D380223DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgLWSaA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:30:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbgLWS35 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:29:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1A62251F;
        Wed, 23 Dec 2020 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748172;
        bh=dUQZuuz9+UV9MTpFzAohQiRbgFhznOPTs6iNsIJW52s=;
        h=Date:From:To:Subject:From;
        b=ZzKf6HPF2nMwiB0ngAClmnoEP9GvliqcdHSEWQyCbEiKetjAgU8uRL3l5FIahlJdy
         Y4EpfsrYqeE+oni4zMiJ3uUYB5li0TKiZBwxNGuJNPC+ofAy4sdb4e0FqIxlHTouJW
         uBc0dIS9RdmfxGSu2kMmyi85KWgVFl3TY6GLn0so=
Date:   Wed, 23 Dec 2020 10:29:31 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged] kasan-arm64-enable-config_kasan_hw_tags.patch
 removed from -mm tree
Message-ID: <20201223182931.3oOxL5Zis%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: enable CONFIG_KASAN_HW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-arm64-enable-config_kasan_hw_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: enable CONFIG_KASAN_HW_TAGS

Hardware tag-based KASAN is now ready, enable the configuration option.

Link: https://lkml.kernel.org/r/a6fa50d3bb6b318e05c6389a44095be96442b8b0.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig~kasan-arm64-enable-config_kasan_hw_tags
+++ a/arch/arm64/Kconfig
@@ -137,6 +137,7 @@ config ARM64
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN if !(ARM64_16K_PAGES && ARM64_VA_BITS_48)
 	select HAVE_ARCH_KASAN_SW_TAGS if HAVE_ARCH_KASAN
+	select HAVE_ARCH_KASAN_HW_TAGS if (HAVE_ARCH_KASAN && ARM64_MTE)
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
_

Patches currently in -mm which might be from andreyknvl@google.com are



Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A195C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D43522B3F
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596223469;
	bh=uYxRrmTAN6Kn24GqG9wHDv6+bBh+YNf5Xe0WUBylxn0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2Nsz6vr4DSbw7xjsVezEwiqH5PhO+3kkHCFcjHTUSlsDF9Bnk2bzoiao0SaoHO/GJ
	 1t/84lBZ3OdVUuChfjVAt1Stj2y3WswCt5E06hWn/zMar0aO+CHIdsVndUYFluty9M
	 lTzbgiwThKa+SxYci3k0LRrO+hHzB/K/CsYCs1K4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgGaTY3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 15:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgGaTY2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 15:24:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E19CB208E4;
        Fri, 31 Jul 2020 19:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596223468;
        bh=uYxRrmTAN6Kn24GqG9wHDv6+bBh+YNf5Xe0WUBylxn0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UchmqtPTlBCvs+IpzinhReW2LoKSXfJklztut3q4BnGQBsSEFX9BfDvkUWpi3XtnI
         bP33bV+bBYhzBy03iFGkMQhLx+M13Bobmbcl7De2ZZbmVmlCzWh5c3Tlfnuo1euVdB
         hqhnRklO9JkirjiHVyq9627GS30KvtbUMx6xWMYE=
Date:   Fri, 31 Jul 2020 12:24:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  +
 kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch added to -mm
 tree
Message-ID: <20200731192427.bCs4f5NdJ%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: allow enabling stack tagging for tag-based mode
has been added to the -mm tree.  Its filename is
     kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: allow enabling stack tagging for tag-based mode

Use CONFIG_KASAN_STACK to enable stack tagging.

Note, that HWASAN short granules [1] are disabled. Supporting those will
require more kernel changes.

[1] https://clang.llvm.org/docs/HardwareAssistedAddressSanitizerDesign.html

Link: http://lkml.kernel.org/r/e7febb907b539c3730780df587ce0b38dc558c3d.1596199677.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/Makefile.kasan~kasan-allow-enabling-stack-tagging-for-tag-based-mode
+++ a/scripts/Makefile.kasan
@@ -44,7 +44,8 @@ else
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
-		-mllvm -hwasan-instrument-stack=0 \
+		-mllvm -hwasan-instrument-stack=$(CONFIG_KASAN_STACK) \
+		-mllvm -hwasan-use-short-granules=0 \
 		$(instrumentation_flags)
 
 endif # CONFIG_KASAN_SW_TAGS
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-tag-stacks-allocated-with-pagealloc.patch
kasan-arm64-dont-instrument-functions-that-enable-kasan.patch
kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch


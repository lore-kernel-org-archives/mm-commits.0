Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF790C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A187322CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781512;
	bh=5VC9/nSDJz4iTSAcWPUj4TKuLdRWZPWrGmP6buxMQ5E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wQV7HXB4eK82yjzb0OrNG7xAlH95gG5hmlaP+uSw5J5ue243dUVVfBPp0xHkJN9e9
	 mBWJwcGgSQCOmkZx8PmN/iAaMpuvwOTdRl22KYZjGOVaWhrosICurts47V9ur/Cm6E
	 NsbwGQocQj+Lhs47lJbouFAOlhlERl2+q9VPSbAw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHGGZL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbgHGGZL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857CD221E5;
        Fri,  7 Aug 2020 06:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781510;
        bh=5VC9/nSDJz4iTSAcWPUj4TKuLdRWZPWrGmP6buxMQ5E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2CFEYREGfPiPWQyvJoZR4t6wkaW6zaYVipm3TDBFa0Ba3f/iOEGvrzDmdH9eYWLn0
         OhufT+b7rODl6ynrJS+ZQ3bTVt6ZyrtbSQNLhT9GR6A53gi2fwZLLeJX/Ht+Qe/hAs
         UBxPKeMmZ/FC8ocgNGnRA2YqeHfV8V6um958ghr4=
Date:   Thu, 06 Aug 2020 23:25:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ardb@kernel.org,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        lenaptr@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        walter-zh.wu@mediatek.com
Subject:  [patch 139/163] kasan: allow enabling stack tagging for
 tag-based mode
Message-ID: <20200807062508.9S89oRdQf%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: allow enabling stack tagging for tag-based mode

Use CONFIG_KASAN_STACK to enable stack tagging.

Note, that HWASAN short granules [1] are disabled. Supporting those will
require more kernel changes.

[1] https://clang.llvm.org/docs/HardwareAssistedAddressSanitizerDesign.html

Link: http://lkml.kernel.org/r/e7febb907b539c3730780df587ce0b38dc558c3d.1596199677.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/99f7d90a4237431bf5988599fb41358e92876eb0.1596544734.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
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

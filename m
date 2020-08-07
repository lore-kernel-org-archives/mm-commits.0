Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5E0C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 727BF2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779822;
	bh=3tDMxDeIeTNaPxkjguXZf7HkFLsYfCMkpe4FJoGRslk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VxCEX+UOcXIBrFciyenzGBJkdJxV5VNQvvm5+E+84umb6yxPwAUdpl6Xx7SJrZ86N
	 ebf+OuXcLTROLKUixbOalzLq4CrooZsod1CUagLf2UCk1Los0oCnb2tILaYcDmykuV
	 L372WxqYOkunXr5as0rYNZD4BdE/Rd9HP/gCU0jQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGF5C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGF5B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:57:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F36C721744;
        Fri,  7 Aug 2020 05:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779821;
        bh=3tDMxDeIeTNaPxkjguXZf7HkFLsYfCMkpe4FJoGRslk=;
        h=Date:From:To:Subject:From;
        b=VAecABuiIx8u2wbFqtz+u41jgkbU93QQZhpFMo9UgzokjyQYm9sTG+h4NTc8SFBhf
         O1MD5GPEDzEAtqD+pe9bMode+Xc820lVhCRwL6mTjwLTu5YneZwa37Ki+VtIO8Bfd0
         b6pt0I62QPpn1Aa1F4Y+XrNSuF2vNgInlrsMjtCc=
Date:   Thu, 06 Aug 2020 22:57:00 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  [folded-merged]
 kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch removed
 from -mm tree
Message-ID: <20200807055700.10uQAZI1H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: don't instrument functions that enable kasan
has been removed from the -mm tree.  Its filename was
     kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch

This patch was dropped because it was folded into kasan-arm64-dont-instrument-functions-that-enable-kasan.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: don't instrument functions that enable kasan

reorder attributes for start_kernel()

Link: http://lkml.kernel.org/r/26fb6165a17abcf61222eda5184c030fb6b133d1.1596544734.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~kasan-arm64-dont-instrument-functions-that-enable-kasan-v2
+++ a/init/main.c
@@ -827,7 +827,7 @@ void __init __weak arch_call_rest_init(v
 	rest_init();
 }
 
-asmlinkage __visible __no_sanitize_address void __init start_kernel(void)
+asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 {
 	char *command_line;
 	char *after_dashes;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-tag-stacks-allocated-with-pagealloc.patch
efi-provide-empty-efi_enter_virtual_mode-implementation.patch
kasan-arm64-dont-instrument-functions-that-enable-kasan.patch
kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch


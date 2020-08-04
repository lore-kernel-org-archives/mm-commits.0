Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC50C433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 19:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A3312076E
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596570305;
	bh=8hdbAR880Tapav5AtjRRTt2dTnScfvU5ZM1BZf3cvts=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ub02ZH3v6mDW445w+xCw/W7uNqPijB86c1s9Y4rIFenBVHpTNaLPdsx1yWTMe7WAh
	 WDBwp6xH2Dckrx9dSo/0WrUtawV9fbeiuB1oANS27Txc4phlzYQ46JD3R2MLNm/a+g
	 eL4bR4BF4FIB7GWuMurJ2ZdbrzTt8+iwa+b5+QvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgHDTpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Aug 2020 15:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHDTpE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Aug 2020 15:45:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D871207FC;
        Tue,  4 Aug 2020 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596570304;
        bh=8hdbAR880Tapav5AtjRRTt2dTnScfvU5ZM1BZf3cvts=;
        h=Date:From:To:Subject:From;
        b=Sm78XKsH4MkW7YhM+WwvxkUnfY8w3XbDo/wqWNCwBGnU6zSQDw6RDnDoteP1JgnUP
         2JunTb01UT6SPVKObVC8LJ5DCGOkITPHOURjwLNQTYuhtnl8ks4UGKRXUe/WEh0psR
         I1zMm1yKQjD3lOddnnRQBiE0I40uC1Sp9sl6d04o=
Date:   Tue, 04 Aug 2020 12:45:03 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  +
 kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch added to
 -mm tree
Message-ID: <20200804194503.kxkOrEQZ8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: don't instrument functions that enable kasan
has been added to the -mm tree.  Its filename is
     kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch

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
kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch
kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A2BC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A5E601FB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhBXTI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:08:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235946AbhBXTIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 300D6601FB;
        Wed, 24 Feb 2021 19:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193303;
        bh=yfoGQV9QXgd/S3nCUg8FYUojiemR8+rWxokDlkJISHc=;
        h=Date:From:To:Subject:From;
        b=u2CnlThJ9fgIvZ6DX3bMEA6WM2uL2P7GKxpV0Ec14staEmJnN8mfD1MuGuFoN0N06
         F2++3aMY3I//f+Vyp4WeArLGFmv/un/3VLuRenWG1uh2JmxsHODHU1gepuJ9hw57ni
         jyEC3ayW73p0gx4XLne6IW0ziz1VQHQhpm2E79Q4=
Date:   Wed, 24 Feb 2021 11:01:42 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject:  [folded-merged] kasan-add-match-all-tag-tests-fix.patch
 removed from -mm tree
Message-ID: <20210224190142.c5Q-39lNo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: export kasan_poison
has been removed from the -mm tree.  Its filename was
     kasan-add-match-all-tag-tests-fix.patch

This patch was dropped because it was folded into kasan-add-match-all-tag-tests.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: export kasan_poison

The unit test module fails to build after adding a reference
to kasan_poison:

ERROR: modpost: "kasan_poison" [lib/test_kasan.ko] undefined!

Export this symbol to make it available to loadable modules.

Link: https://lkml.kernel.org/r/20210125112831.2156212-1-arnd@kernel.org
Fixes: b9b322c2bba9 ("kasan: add match-all tag tests")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/shadow.c~kasan-add-match-all-tag-tests-fix
+++ a/mm/kasan/shadow.c
@@ -89,6 +89,7 @@ void kasan_poison(const void *address, s
 
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
+EXPORT_SYMBOL_GPL(kasan_poison);
 
 void kasan_unpoison(const void *address, size_t size)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-add-match-all-tag-tests.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2117C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE91F60E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347690AbhIBV6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347668AbhIBV6n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD3A86056B;
        Thu,  2 Sep 2021 21:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619865;
        bh=faqvaT+OtWaijztr6/+B5xpjvZVs0AYWxQVp+sdCfz8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lsJKYTGKUqXRcVlmpYAHPmysEzKrXiPcT/tVV/f8rQgr1QJZcbpV59XprfOwQdzAG
         dtFG/mdQ0q6veTZX/0mMFqgEMgUlT17yzVZYqH/Uv6UWVXP7Z1EbE+T3MFfwxNLRWl
         cbCC9d4uTbp9qtJvTvK2xdZY5+5uJMQ9AdK2DhUs=
Date:   Thu, 02 Sep 2021 14:57:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 146/212] kasan: test: only do kmalloc_uaf_memset
 for generic mode
Message-ID: <20210902215744.wv5bAMZa1%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: test: only do kmalloc_uaf_memset for generic mode

kmalloc_uaf_memset() writes to freed memory, which is only safe with the
GENERIC mode (as it uses quarantine).  For other modes, this test corrupts
kernel memory, which might result in a crash.

Only enable kmalloc_uaf_memset() for the GENERIC mode.

Link: https://lkml.kernel.org/r/2e1c87b607b1292556cde3cab2764f108542b60c.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/test_kasan.c~kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode
+++ a/lib/test_kasan.c
@@ -534,6 +534,12 @@ static void kmalloc_uaf_memset(struct ku
 	char *ptr;
 	size_t size = 33;
 
+	/*
+	 * Only generic KASAN uses quarantine, which is required to avoid a
+	 * kernel memory corruption this test causes.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA74BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F8B6113C
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhICVAV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239176AbhICVAU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C9AB610FD;
        Fri,  3 Sep 2021 20:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702760;
        bh=X/ZeRoS4O4dATu/cTqL0qIvzW/+xTZNZWAMDzpqobU4=;
        h=Date:From:To:Subject:From;
        b=Dou80X8WcFEJvuwt5ghU5EJkFvg3eZO9xaoNT7ieQ+vyfgMzkdxYS1PfAxcdow8f5
         B5sSbGipdGe2HmHvvONVrSQg7543ACrbW0G9hpiZDHzPrBWDn68vD2XxF3WTTaoMKr
         YU6Razwj2RPwuIvfzrOXs0Y4pEP5m/Hg4kD4vrTU=
Date:   Fri, 03 Sep 2021 13:59:20 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch removed from
 -mm tree
Message-ID: <20210903205920.9APhtuL2o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: only do kmalloc_uaf_memset for generic mode
has been removed from the -mm tree.  Its filename was
     kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@gmail.com are



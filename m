Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EE7C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A29DF61152
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbhIHDBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347430AbhIHDAx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8379061100;
        Wed,  8 Sep 2021 02:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069985;
        bh=PS4tHiTKFn0wNdq6Mh150/k9CtRDo9/C+JLfilCw+YM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KohyNMuFwtjsZKs2mgvGnGB8OMHY0PBpR/HzwJV7qQLwRmPnT9iv0lVUp8R9pxfIA
         M6kNXeImf0LoTu9+Bn5KuQJ3tpJqx1iFlbarfJd5jPk/Wbjcqtb18xR5G5fzWaQwDx
         5o7nComvmwx2D1221dq30zM6rDrx6lMB3R8fHwU0=
Date:   Tue, 07 Sep 2021 19:59:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 122/147] lib: bitmap: add performance test for
 bitmap_print_to_pagebuf
Message-ID: <20210908025945.OCX5dTlIj%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: lib: bitmap: add performance test for bitmap_print_to_pagebuf

Functional tests for bitmap_print_to_pagebuf() are provided in
lib/test_printf.c.  This patch adds performance test for a case of fully
set bitmap.

Link: https://lkml.kernel.org/r/20210814211713.180533-17-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/lib/test_bitmap.c~lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf
+++ a/lib/test_bitmap.c
@@ -430,6 +430,42 @@ static void __init test_bitmap_parselist
 	}
 }
 
+static void __init test_bitmap_printlist(void)
+{
+	unsigned long *bmap = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	char expected[256];
+	int ret, slen;
+	ktime_t time;
+
+	if (!buf || !bmap)
+		goto out;
+
+	memset(bmap, -1, PAGE_SIZE);
+	slen = snprintf(expected, 256, "0-%ld", PAGE_SIZE * 8 - 1);
+	if (slen < 0)
+		goto out;
+
+	time = ktime_get();
+	ret = bitmap_print_to_pagebuf(true, buf, bmap, PAGE_SIZE * 8);
+	time = ktime_get() - time;
+
+	if (ret != slen + 1) {
+		pr_err("bitmap_print_to_pagebuf: result is %d, expected %d\n", ret, slen);
+		goto out;
+	}
+
+	if (strncmp(buf, expected, slen)) {
+		pr_err("bitmap_print_to_pagebuf: result is %s, expected %s\n", buf, expected);
+		goto out;
+	}
+
+	pr_err("bitmap_print_to_pagebuf: input is '%s', Time: %llu\n", buf, time);
+out:
+	kfree(buf);
+	kfree(bmap);
+}
+
 static const unsigned long parse_test[] __initconst = {
 	BITMAP_FROM_U64(0),
 	BITMAP_FROM_U64(1),
@@ -669,6 +705,7 @@ static void __init selftest(void)
 	test_bitmap_arr32();
 	test_bitmap_parse();
 	test_bitmap_parselist();
+	test_bitmap_printlist();
 	test_mem_optimisations();
 	test_for_each_set_clump8();
 	test_bitmap_cut();
_

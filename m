Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A8EC4338F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C5C260F48
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhHNWSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233549AbhHNWSV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:18:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 938DB60F51;
        Sat, 14 Aug 2021 22:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979472;
        bh=mgzUXe2QEUUc1pAZHj1L/1fvIoWsAsGmq/2ZU38T1rM=;
        h=Date:From:To:Subject:From;
        b=bcRoNMyJ3SZPusb0iLK1cgeUgGkky+wBmi1N4vSfuENG38Suss3tojpeew1pouWhH
         HM672U9yF3z8vrRVJ/eyvD5C/VqDFFJfc9ImkfHV8/Tvfc2g1GfCCGm7WJT/LZt1mk
         DQYoGdKyxTZhkUgtIlTGLsKMdxIQcQAC9Irog1s8=
Date:   Sat, 14 Aug 2021 15:17:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  +
 lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch added to
 -mm tree
Message-ID: <20210814221752.BrIiN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: add performance test for bitmap_print_to_pagebuf
has been added to the -mm tree.  Its filename is
     lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: kernel test robot <lkp@intel.com>
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

Patches currently in -mm which might be from yury.norov@gmail.com are

bitops-protect-find_first_zero_bit-properly.patch
bitops-move-find_bit__le-functions-from-leh-to-findh.patch
include-move-findh-from-asm_generic-to-linux.patch
arch-remove-generic_find_first_bit-entirely.patch
lib-add-find_first_and_bit.patch
cpumask-use-find_first_and_bit.patch
all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch
find-micro-optimize-for_each_setclear_bit.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
bitmap-unify-find_bit-operations.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch


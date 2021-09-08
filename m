Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68F7C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1ACC61153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbhIHDBB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347322AbhIHDA5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B005361102;
        Wed,  8 Sep 2021 02:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069989;
        bh=LSZnqdKr26eTreoRKsmvAbakBcOQrQwUjMLtOIxvhd0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GNtKwPHejKgiZTQDsEow+krpINbSCSNS46HDhVEXLG0+FpVnQBJRoyVw5/5wjcm28
         rBywGPuhI81t8k9vSs3kcL9P0MWaasM3McBSvCsCEs3NXaE9k3WgjmSAsngHMOvQvd
         AnsgVSY79xeL4rGtKBshpLkLrpWkFsoKdnYh6g1E=
Date:   Tue, 07 Sep 2021 19:59:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 123/147] vsprintf: rework bitmap_list_string
Message-ID: <20210908025948.a-7N5QB_n%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: vsprintf: rework bitmap_list_string

bitmap_list_string() is very ineffective when printing bitmaps with long
ranges of set bits because it calls find_next_bit for each bit in the
bitmap.  We can do better by detecting ranges of set bits.

In my environment, before/after is 943008/31008 ns.

[yury.norov@gmail.com: don't increment buf in bitmap_list_string]
  Link: https://lkml.kernel.org/r/20210817193735.269942-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20210814211713.180533-18-yury.norov@gmail.com
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

 lib/vsprintf.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/lib/vsprintf.c~vsprintf-rework-bitmap_list_string
+++ a/lib/vsprintf.c
@@ -1241,20 +1241,13 @@ char *bitmap_list_string(char *buf, char
 			 struct printf_spec spec, const char *fmt)
 {
 	int nr_bits = max_t(int, spec.field_width, 0);
-	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
-	int cur, rbot, rtop;
 	bool first = true;
+	int rbot, rtop;
 
 	if (check_pointer(&buf, end, bitmap, spec))
 		return buf;
 
-	rbot = cur = find_first_bit(bitmap, nr_bits);
-	while (cur < nr_bits) {
-		rtop = cur;
-		cur = find_next_bit(bitmap, nr_bits, cur + 1);
-		if (cur < nr_bits && cur <= rtop + 1)
-			continue;
-
+	for_each_set_bitrange(rbot, rtop, bitmap, nr_bits) {
 		if (!first) {
 			if (buf < end)
 				*buf = ',';
@@ -1263,15 +1256,12 @@ char *bitmap_list_string(char *buf, char
 		first = false;
 
 		buf = number(buf, end, rbot, default_dec_spec);
-		if (rbot < rtop) {
-			if (buf < end)
-				*buf = '-';
-			buf++;
-
-			buf = number(buf, end, rtop, default_dec_spec);
-		}
+		if (rtop == rbot + 1)
+			continue;
 
-		rbot = cur;
+		if (buf < end)
+			*buf = '-';
+		buf = number(buf + 1, end, rtop - 1, default_dec_spec);
 	}
 	return buf;
 }
_

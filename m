Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0382DC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B986103E
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbhIIU6i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhIIU6h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 16:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99FA76113E;
        Thu,  9 Sep 2021 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221047;
        bh=hmN4W3ni+AUko1StD5AgXf8b5HN+/Zkfioo5Jm66jGs=;
        h=Date:From:To:Subject:From;
        b=ARzUA09vzRWGaFzgLIantJntQ/yNa8O13sLe8d17wJxaIx/fYIFkNvejp5+4ChN+g
         HXgKAk8nSroh1N6lJln/PbviM4V4vyhby1bDWPeSU8FbGlCSWg4PwNgj2FPoF7C/gG
         9RJb57MLdllx7lavNBFnUj7hVf6qpQyIvJDbMk5Q=
Date:   Thu, 09 Sep 2021 13:57:27 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [to-be-updated]
 mm-percpu-micro-optimize-pcpu_is_populated.patch removed from -mm tree
Message-ID: <20210909205727.K7Dg59TVB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu: micro-optimize pcpu_is_populated()
has been removed from the -mm tree.  Its filename was
     mm-percpu-micro-optimize-pcpu_is_populated.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: mm/percpu: micro-optimize pcpu_is_populated()

bitmap_next_clear_region() calls find_next_zero_bit() and find_next_bit()
sequentially to find a range of clear bits.  In case of
pcpu_is_populated() there's a chance to return earlier if bitmap has all
bits set.

Link: https://lkml.kernel.org/r/20210814211713.180533-15-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/percpu.c~mm-percpu-micro-optimize-pcpu_is_populated
+++ a/mm/percpu.c
@@ -1070,17 +1070,18 @@ static void pcpu_block_update_hint_free(
 static bool pcpu_is_populated(struct pcpu_chunk *chunk, int bit_off, int bits,
 			      int *next_off)
 {
-	unsigned int page_start, page_end, rs, re;
+	unsigned int start, end;
 
-	page_start = PFN_DOWN(bit_off * PCPU_MIN_ALLOC_SIZE);
-	page_end = PFN_UP((bit_off + bits) * PCPU_MIN_ALLOC_SIZE);
+	start = PFN_DOWN(bit_off * PCPU_MIN_ALLOC_SIZE);
+	end = PFN_UP((bit_off + bits) * PCPU_MIN_ALLOC_SIZE);
 
-	rs = page_start;
-	bitmap_next_clear_region(chunk->populated, &rs, &re, page_end);
-	if (rs >= page_end)
+	start = find_next_zero_bit(chunk->populated, end, start);
+	if (start >= end)
 		return true;
 
-	*next_off = re * PAGE_SIZE / PCPU_MIN_ALLOC_SIZE;
+	end = find_next_bit(chunk->populated, end, start + 1);
+
+	*next_off = end * PAGE_SIZE / PCPU_MIN_ALLOC_SIZE;
 	return false;
 }
 
_

Patches currently in -mm which might be from yury.norov@gmail.com are

lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch


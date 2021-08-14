Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30254C4338F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AC9560F4B
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhHNWST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233532AbhHNWSQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D2D060F4B;
        Sat, 14 Aug 2021 22:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979467;
        bh=zB/8YM5HeALHw1LofP9TRSwf63SzFwLXWFFPzziGnFk=;
        h=Date:From:To:Subject:From;
        b=H+WA9WfW3mkcOcPxK/1yLQeoY63Ngjk5GAP0Zum7jsN/MdiMWRWXwXijwY0OBvIQd
         IGxE6bAIs3R6y20n6R9yvuVDvqw7m5WJlOYfkZeQQAlgwgLfywOtuYTwddt2b/ET6h
         N8x0yrXnbhh5Y0QSBz2/vLbplvcsj1TgflXE0Nqw=
Date:   Sat, 14 Aug 2021 15:17:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  + mm-percpu-micro-optimize-pcpu_is_populated.patch added to
 -mm tree
Message-ID: <20210814221747.kv-WF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu: micro-optimize pcpu_is_populated()
has been added to the -mm tree.  Its filename is
     mm-percpu-micro-optimize-pcpu_is_populated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-percpu-micro-optimize-pcpu_is_populated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-percpu-micro-optimize-pcpu_is_populated.patch

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
Cc: kernel test robot <lkp@intel.com>
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


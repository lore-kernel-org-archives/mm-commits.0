Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6CEC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 975E2610E9
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347189AbhIHCWR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347014AbhIHCWQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1624061090;
        Wed,  8 Sep 2021 02:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067669;
        bh=MqcCkDP6lRRs0MLbTFwwBq7Hb/EW45jzDmaPSXMWPCQ=;
        h=Date:From:To:Subject:From;
        b=aDI+wjY7ZgVcvrSnKJ0zQEESJglnCN1JgSBl7V8+Ge7EWfuXbsWnNHgel20hPfuZZ
         8cFhIO7AkVfbcX7AHN+y037A34W/grQMBRDMAQNa2Y+bcyyFx/yhsefrMbLLglJxp5
         HA7swFIWHOoapjvwOxAi2nnXpML2hJq/U8db8ojI=
Date:   Tue, 07 Sep 2021 19:21:08 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me, andy.shevchenko@gmail.com,
        dennis@kernel.org, jolsa@redhat.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [folded-merged]
 vsprintf-rework-bitmap_list_string-fix.patch removed from -mm tree
Message-ID: <20210908022108.FdrbSdyfo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: don't increment buf in bitmap_list_string
has been removed from the -mm tree.  Its filename was
     vsprintf-rework-bitmap_list_string-fix.patch

This patch was dropped because it was folded into vsprintf-rework-bitmap_list_string.patch

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib/vsprintf: don't increment buf in bitmap_list_string

Increment is confusing as the buf is overritten at the same line.

Link: https://lkml.kernel.org/r/20210817193735.269942-1-yury.norov@gmail.com
Fixes: b1c4af4d3d6b (vsprintf: rework bitmap_list_string) (next-20210817)
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/vsprintf.c~vsprintf-rework-bitmap_list_string-fix
+++ a/lib/vsprintf.c
@@ -1261,7 +1261,7 @@ char *bitmap_list_string(char *buf, char
 
 		if (buf < end)
 			*buf = '-';
-		buf = number(++buf, end, rtop - 1, default_dec_spec);
+		buf = number(buf + 1, end, rtop - 1, default_dec_spec);
 	}
 	return buf;
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


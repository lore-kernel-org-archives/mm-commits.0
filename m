Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B89C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 20:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B0D610FE
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 20:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhHRUdb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 16:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhHRUda (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 16:33:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE75F610FA;
        Wed, 18 Aug 2021 20:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629318775;
        bh=bKSXFcPeGmKxrvX3DpfWBy8D7BAbVrC0ZIiTWUiSFK8=;
        h=Date:From:To:Subject:From;
        b=gQ01QGyvPiJwoz8ObX4ZMhVcu8vFCIxC6kU+gNcZaiszKyA52mJilzNMVjA32x5g4
         oCriQ6LxrQU+laWcd21kVImQjlVV3sE1bCsR8Fb8B3TRnRl5AYMPaCUrxrS5BJaJkv
         TCmpCJMzOsjvqkjMstG5QaFqPVRBfO4pvAp0UrS8=
Date:   Wed, 18 Aug 2021 13:32:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, jolsa@redhat.com,
        dennis@kernel.org, andy.shevchenko@gmail.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  + vsprintf-rework-bitmap_list_string-fix.patch added to -mm
 tree
Message-ID: <20210818203252.lR0q1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: don't increment buf in bitmap_list_string
has been added to the -mm tree.  Its filename is
     vsprintf-rework-bitmap_list_string-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vsprintf-rework-bitmap_list_string-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vsprintf-rework-bitmap_list_string-fix.patch

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
vsprintf-rework-bitmap_list_string-fix.patch


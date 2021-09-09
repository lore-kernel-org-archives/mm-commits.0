Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE4EC43219
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F43A611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346270AbhIIVGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346423AbhIIVFr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CBB8611AF;
        Thu,  9 Sep 2021 21:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221478;
        bh=6orakhKZ8BJWmX5BSXyNyn0U5oLONTQJwRNga/nA3Y4=;
        h=Date:From:To:Subject:From;
        b=OrI3jCG1A/egLUSm+XsdqQ8uh8gqyc+1fPV1Cy8oD+6jxDmrUZdWwEil0IHLZ81v2
         SjW+gUCnN0Df2pOO5UsLNcbVpotvI048oneUSQefyJAt4s+fmRUIbUK3URKTyu0Yyv
         b240OtjJqTce1qHrX4Yi1FV93ifPZ3Vcm706elZE=
Date:   Thu, 09 Sep 2021 14:04:37 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [merged] find-micro-optimize-for_each_setclear_bit.patch
 removed from -mm tree
Message-ID: <20210909210437.HEKN1UxCm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: find: micro-optimize for_each_{set,clear}_bit()
has been removed from the -mm tree.  Its filename was
     find-micro-optimize-for_each_setclear_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: find: micro-optimize for_each_{set,clear}_bit()

The macros iterate thru all set/clear bits in a bitmap.  They search a
first bit using find_first_bit(), and the rest bits using find_next_bit().

Since find_next_bit() is called shortly after find_first_bit(), we can
save few lines of I-cache by not using find_first_bit().

Link: https://lkml.kernel.org/r/20210814211713.180533-12-yury.norov@gmail.com
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

 include/linux/find.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/find.h~find-micro-optimize-for_each_setclear_bit
+++ a/include/linux/find.h
@@ -280,7 +280,7 @@ unsigned long find_next_bit_le(const voi
 #endif
 
 #define for_each_set_bit(bit, addr, size) \
-	for ((bit) = find_first_bit((addr), (size));		\
+	for ((bit) = find_next_bit((addr), (size), 0);		\
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
@@ -291,7 +291,7 @@ unsigned long find_next_bit_le(const voi
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
 #define for_each_clear_bit(bit, addr, size) \
-	for ((bit) = find_first_zero_bit((addr), (size));	\
+	for ((bit) = find_next_zero_bit((addr), (size), 0);	\
 	     (bit) < (size);					\
 	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
 
_

Patches currently in -mm which might be from yury.norov@gmail.com are



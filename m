Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA68C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D528E61131
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbhIHDAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347443AbhIHDAh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAF4661102;
        Wed,  8 Sep 2021 02:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069970;
        bh=8/SQZ5/8LLfnJpiPRt3YrTxLdgBm/edqjSBxOVyiGGo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vOvy8k32Chj1KL/iXrpSKBlB0uG07zhkh1Y8sfgONPzFh+HGs+grsipLLU2t3Ej6N
         +nLAXkbHIr0BiO+ZB36puhcXU/4195qguXaSpmLGRUkx5mW9CrggFuyk7pKQ75bCjX
         dfFLubQC5AV2atWwp7Dgr50GSsR0BwO3Hk+IiXKM=
Date:   Tue, 07 Sep 2021 19:59:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 117/147] find: micro-optimize
 for_each_{set,clear}_bit()
Message-ID: <20210908025929.aMnm6LmZI%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

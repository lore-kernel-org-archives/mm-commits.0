Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206FFC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D4F6115A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbhIHDAW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347231AbhIHDAV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14AB16113C;
        Wed,  8 Sep 2021 02:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069954;
        bh=IT922PgIv9S8UCSIAot2MPPvmcx6YWLGc3zj7DXQjQ4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kmRSb31i9AUkxlLQUNCBlbv0nnNvp8iajsno/zoh0YA9O9QxdKRbG7vk0md6QceVV
         flJ52kTjZyxlOtQYDbGiVJuUi4kzYxW3M5SeTkcWPiXwvoWWyKC2Ch9FVxbv9+R0nv
         /aopGQ6Xo4DMdGxB1kWl/8sobdgQfZEPgQwHP0NU=
Date:   Tue, 07 Sep 2021 19:59:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 112/147] cpumask: use find_first_and_bit()
Message-ID: <20210908025913.vhf6JYCU-%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: cpumask: use find_first_and_bit()

Now we have an efficient implementation for find_first_and_bit(), so
switch cpumask to use it where appropriate.

Link: https://lkml.kernel.org/r/20210814211713.180533-7-yury.norov@gmail.com
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

 include/linux/cpumask.h |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/include/linux/cpumask.h~cpumask-use-find_first_and_bit
+++ a/include/linux/cpumask.h
@@ -123,6 +123,12 @@ static inline unsigned int cpumask_first
 	return 0;
 }
 
+static inline unsigned int cpumask_first_and(const struct cpumask *srcp1,
+					     const struct cpumask *srcp2)
+{
+	return 0;
+}
+
 static inline unsigned int cpumask_last(const struct cpumask *srcp)
 {
 	return 0;
@@ -167,7 +173,7 @@ static inline unsigned int cpumask_local
 
 static inline int cpumask_any_and_distribute(const struct cpumask *src1p,
 					     const struct cpumask *src2p) {
-	return cpumask_next_and(-1, src1p, src2p);
+	return cpumask_first_and(src1p, src2p);
 }
 
 static inline int cpumask_any_distribute(const struct cpumask *srcp)
@@ -196,6 +202,19 @@ static inline unsigned int cpumask_first
 }
 
 /**
+ * cpumask_first_and - return the first cpu from *srcp1 & *srcp2
+ * @src1p: the first input
+ * @src2p: the second input
+ *
+ * Returns >= nr_cpu_ids if no cpus set in both.  See also cpumask_next_and().
+ */
+static inline
+unsigned int cpumask_first_and(const struct cpumask *srcp1, const struct cpumask *srcp2)
+{
+	return find_first_and_bit(cpumask_bits(srcp1), cpumask_bits(srcp2), nr_cpumask_bits);
+}
+
+/**
  * cpumask_last - get the last CPU in a cpumask
  * @srcp:	- the cpumask pointer
  *
@@ -586,15 +605,6 @@ static inline void cpumask_copy(struct c
 #define cpumask_any(srcp) cpumask_first(srcp)
 
 /**
- * cpumask_first_and - return the first cpu from *srcp1 & *srcp2
- * @src1p: the first input
- * @src2p: the second input
- *
- * Returns >= nr_cpu_ids if no cpus set in both.  See also cpumask_next_and().
- */
-#define cpumask_first_and(src1p, src2p) cpumask_next_and(-1, (src1p), (src2p))
-
-/**
  * cpumask_any_and - pick a "random" cpu from *mask1 & *mask2
  * @mask1: the first input cpumask
  * @mask2: the second input cpumask
_

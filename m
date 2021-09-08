Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1452C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A31F961131
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347390AbhIHDAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHDAF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4348D60E52;
        Wed,  8 Sep 2021 02:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069938;
        bh=6MnXxYIUWDtg0IGe5IuxtCv8ZrxNDexoYzuAJkxxQp0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wMlpbkLaw+1VXQ4aH72u8A4C8ONZGANhnEv9TbxPdK2puUP9FmsZOsAAn4T0oQ3/4
         YAnGEjcpJRne6FG5m8d1IuNxq3OItT7dAFWSWJKNI/EUNy8szOKLsMMIkNFSaBY69v
         DbBKN3ScpoM0uMO5eKvbQx9gcLhlfiVr/y0ZHoog=
Date:   Tue, 07 Sep 2021 19:58:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [patch 107/147] bitops: protect find_first_{,zero}_bit
 properly
Message-ID: <20210908025857.8qR6jzQxc%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: bitops: protect find_first_{,zero}_bit properly

Patch series "Resend bitmap patches".


This patch (of 17):

find_first_bit() and find_first_zero_bit() are not protected with ifdefs
as other functions in find.h.  It causes build errors on some platforms if
CONFIG_GENERIC_FIND_FIRST_BIT is enabled.

Link: https://lkml.kernel.org/r/20210814211713.180533-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20210814211713.180533-2-yury.norov@gmail.com
Fixes: 2cc7b6a44ac2 ("lib: add fast path for find_first_*_bit() and find_last_bit()")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
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

 include/asm-generic/bitops/find.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/asm-generic/bitops/find.h~bitops-protect-find_first_zero_bit-properly
+++ a/include/asm-generic/bitops/find.h
@@ -97,6 +97,7 @@ unsigned long find_next_zero_bit(const u
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
+#ifndef find_first_bit
 /**
  * find_first_bit - find the first set bit in a memory region
  * @addr: The address to start the search at
@@ -116,7 +117,9 @@ unsigned long find_first_bit(const unsig
 
 	return _find_first_bit(addr, size);
 }
+#endif
 
+#ifndef find_first_zero_bit
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
  * @addr: The address to start the search at
@@ -136,6 +139,8 @@ unsigned long find_first_zero_bit(const
 
 	return _find_first_zero_bit(addr, size);
 }
+#endif
+
 #else /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifndef find_first_bit
_

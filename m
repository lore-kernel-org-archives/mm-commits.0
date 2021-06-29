Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC87C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A720061CCA
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhF2CgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2CgG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B9461D03;
        Tue, 29 Jun 2021 02:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934019;
        bh=pmAPgXguSlXx54t2Mk6LYeFnAnAE4dIvaIITPnLybag=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IT7chqp3ctapHZfj9rtgpd3+wnwfXt/gr7sMTnJ74ZDGkyy+vLQ0M5JhWJzIeSszp
         r2x42q5sIanDPsS1nXXxWjNAlHKuXbCnQIn6UwOCTYmTtrS1bdpifJSYGEVe1ygVIe
         7rcADpOiZxoD+8fw/QhqNVyF76d6jXh691YXyMcs=
Date:   Mon, 28 Jun 2021 19:33:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fenghua.yu@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 006/192] ia64: headers: drop duplicated words
Message-ID: <20210629023338.feoSCxLVI%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: headers: drop duplicated words

Delete the repeated words "to" and "the".

Link: https://lkml.kernel.org/r/20210507184837.10754-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pal.h       |    2 +-
 arch/ia64/include/asm/spinlock.h  |    2 +-
 arch/ia64/include/asm/uv/uv_hub.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/ia64/include/asm/pal.h~ia64-headers-drop-duplicated-words
+++ a/arch/ia64/include/asm/pal.h
@@ -1086,7 +1086,7 @@ static inline long ia64_pal_freq_base(un
 
 /*
  * Get the ratios for processor frequency, bus frequency and interval timer to
- * to base frequency of the platform
+ * the base frequency of the platform
  */
 static inline s64
 ia64_pal_freq_ratios (struct pal_freq_ratio *proc_ratio, struct pal_freq_ratio *bus_ratio,
--- a/arch/ia64/include/asm/spinlock.h~ia64-headers-drop-duplicated-words
+++ a/arch/ia64/include/asm/spinlock.h
@@ -26,7 +26,7 @@
  * the queue, and the other indicating the current tail. The lock is acquired
  * by atomically noting the tail and incrementing it by one (thus adding
  * ourself to the queue and noting our position), then waiting until the head
- * becomes equal to the the initial value of the tail.
+ * becomes equal to the initial value of the tail.
  * The pad bits in the middle are used to prevent the next_ticket number
  * overflowing into the now_serving number.
  *
--- a/arch/ia64/include/asm/uv/uv_hub.h~ia64-headers-drop-duplicated-words
+++ a/arch/ia64/include/asm/uv/uv_hub.h
@@ -257,7 +257,7 @@ static inline int uv_numa_blade_id(void)
 	return 0;
 }
 
-/* Convert a cpu number to the the UV blade number */
+/* Convert a cpu number to the UV blade number */
 static inline int uv_cpu_to_blade_id(int cpu)
 {
 	return 0;
_

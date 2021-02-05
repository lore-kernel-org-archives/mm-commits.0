Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243DCC433E6
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBB3164FB6
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhBECen (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhBECdr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC56D64FB5;
        Fri,  5 Feb 2021 02:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492374;
        bh=jQ+DXJ4ZL2hgEpB00QbfV5p2Sb3FWJrL6IpfKeneeHI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YkjHqO0Yn4QekSMwSln1PfK7uwXoSRMBUklfLbBL8hZZuuAC3G/jPqDFZcCisDbal
         68GsGvm1OBqGWIW7lisSslG9ZLnyMyIn56VUYmnMp7T9SDeoskw3WuKswUUJ7xF3si
         p/94eFcoEXlnGfVbbpsKhypEsVybZ8PO0HMYEhjo=
Date:   Thu, 04 Feb 2021 18:32:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, glider@google.com, leonro@mellanox.com,
        linux-mm@kvack.org, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        paulmck@kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [patch 15/18] kasan: make addr_has_metadata() return true
 for valid addresses
Message-ID: <20210205023253.FkY5Q84ML%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: kasan: make addr_has_metadata() return true for valid addresses

Currently, addr_has_metadata() returns true for every address.  An invalid
address (e.g.  NULL) passed to the function when, KASAN_HW_TAGS is
enabled, leads to a kernel panic.

Make addr_has_metadata() return true for valid addresses only.

Note: KASAN_HW_TAGS support for vmalloc will be added with a future patch.

Link: https://lkml.kernel.org/r/20210126134409.47894-3-vincenzo.frascino@arm.com
Fixes: 2e903b91479782b7 ("kasan, arm64: implement HW_TAGS runtime")
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan.h~kasan-make-addr_has_metadata-return-true-for-valid-addresses
+++ a/mm/kasan/kasan.h
@@ -209,7 +209,7 @@ bool check_memory_region(unsigned long a
 
 static inline bool addr_has_metadata(const void *addr)
 {
-	return true;
+	return (is_vmalloc_addr(addr) || virt_addr_valid(addr));
 }
 
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
_

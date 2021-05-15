Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29325C43460
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C3361176
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhEOA2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 20:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 20:28:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F2161444;
        Sat, 15 May 2021 00:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038460;
        bh=VjUWfTBCFzF9lmlIYmiNHevJU4lCoP8bGWTtI4YuDK4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m90Z4OKx+YbuO4LUHnQhWXWSX2sKKxw+QfInffuAWAFbdOtAqlXhwRsYE1nX3hJyx
         xOvIGuXuuJiLbJ/sopW3B2ZkmuwHHqug+v8zGLjIlqLPEYc3CuPzcAPdiASbXi0Vue
         2oK8w/cFiYZtAuwUz3TDjkDII8woOHXteFKoUNYI=
Date:   Fri, 14 May 2021 17:27:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 13/13] mm/ioremap: fix iomap_max_page_shift
Message-ID: <20210515002739.KFnavN0-K%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/ioremap: fix iomap_max_page_shift

iomap_max_page_shift is expected to contain a page shift, so it can't be a
'bool', has to be an 'unsigned int'

And fix the default values: P4D_SHIFT is when huge iomap is allowed.

However, on some architectures (eg: powerpc book3s/64), P4D_SHIFT is not a
constant so it can't be used to initialise a static variable.  So,
initialise iomap_max_page_shift with a maximum shift supported by the
architecture, it is gated by P4D_SHIFT in vmap_try_huge_p4d() anyway.

Link: https://lkml.kernel.org/r/ad2d366015794a9f21320dcbdd0a8eb98979e9df.1620898113.git.christophe.leroy@csgroup.eu
Fixes: bbc180a5adb0 ("mm: HUGE_VMAP arch support cleanup")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ioremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ioremap.c~mm-ioremap-fix-iomap_max_page_shift
+++ a/mm/ioremap.c
@@ -16,16 +16,16 @@
 #include "pgalloc-track.h"
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-static bool __ro_after_init iomap_max_page_shift = PAGE_SHIFT;
+static unsigned int __ro_after_init iomap_max_page_shift = BITS_PER_LONG - 1;
 
 static int __init set_nohugeiomap(char *str)
 {
-	iomap_max_page_shift = P4D_SHIFT;
+	iomap_max_page_shift = PAGE_SHIFT;
 	return 0;
 }
 early_param("nohugeiomap", set_nohugeiomap);
 #else /* CONFIG_HAVE_ARCH_HUGE_VMAP */
-static const bool iomap_max_page_shift = PAGE_SHIFT;
+static const unsigned int iomap_max_page_shift = PAGE_SHIFT;
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 int ioremap_page_range(unsigned long addr,
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D46C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD6161D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhF2Cna (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cn3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BB27611AE;
        Tue, 29 Jun 2021 02:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934462;
        bh=Og8hvzmrqDGRHNjupM5x/PxRv81RzmSZ3EU0NZS3MXI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SRbfkvMSG8pFkndfT9sFqKfMBJC5FrL0jA2gVYO5A5hP2XlWSQey0scnz2SsVhPYQ
         WIJTxQsa58VfFM4at5x83XMPNNApoosI/JDKCpDf83yspapDlfJALFKVnWHr2RmSXN
         3mU7oFKrB3r7OJtk6PS9+WYVYuGgihe+DCuCi8c8=
Date:   Mon, 28 Jun 2021 19:41:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, js07.lee@samsung.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 148/192] mm: report which part of mem is being
 freed on initmem case
Message-ID: <20210629024102.5LVKYwTtW%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jungseung Lee <js07.lee@samsung.com>
Subject: mm: report which part of mem is being freed on initmem case

Add the details for figuring out which parts of the kernel image is being
freed on initmem case.

Before:
   Freeing unused kernel memory: 1024K

After:
   Freeing unused kernel image (initmem) memory: 1024K

Link: https://lkml.kernel.org/r/1622706274-4533-1-git-send-email-js07.lee@samsung.com
Signed-off-by: Jungseung Lee <js07.lee@samsung.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-report-which-part-of-mem-is-being-freed-on-initmem-case
+++ a/include/linux/mm.h
@@ -2416,7 +2416,7 @@ static inline unsigned long free_initmem
 	extern char __init_begin[], __init_end[];
 
 	return free_reserved_area(&__init_begin, &__init_end,
-				  poison, "unused kernel");
+				  poison, "unused kernel image (initmem)");
 }
 
 static inline unsigned long get_num_physpages(void)
_

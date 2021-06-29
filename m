Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB65C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E5561D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhF2CpB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhF2Co6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F0A5611AE;
        Tue, 29 Jun 2021 02:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934551;
        bh=K0TUEyUpM9OYJOvSl725rVPmP48ipCFE6nCKAfGMCT8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zPrfdRr3Is5ZsTTq9h2wql0yqR4KnwQuXvur5oYultPgIlZibIyGs22KDqIzWfR7G
         JZbXPy5pgK1Deq2Z0mGB+jWqhz36YqMcG4OKSrdRJTH7tns05kEIHIB08TzE8q7BKx
         KUiupm8xos7xGUb2ceFhq5HGi14hYnwuFlqFd0/g=
Date:   Mon, 28 Jun 2021 19:42:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aisheng.dong@nxp.com, akpm@linux-foundation.org, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 177/192] mm/page_alloc: improve memmap_pages dbg
 msg
Message-ID: <20210629024230.FI_MlnByL%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>
Subject: mm/page_alloc: improve memmap_pages dbg msg

Make debug message more accurate.

Link: https://lkml.kernel.org/r/20210531091908.1738465-6-aisheng.dong@nxp.com
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-improve-memmap_pages-dbg-msg
+++ a/mm/page_alloc.c
@@ -7383,7 +7383,7 @@ static void __init free_area_init_core(s
 					pr_debug("  %s zone: %lu pages used for memmap\n",
 						 zone_names[j], memmap_pages);
 			} else
-				pr_warn("  %s zone: %lu pages exceeds freesize %lu\n",
+				pr_warn("  %s zone: %lu memmap pages exceeds freesize %lu\n",
 					zone_names[j], memmap_pages, freesize);
 		}
 
_

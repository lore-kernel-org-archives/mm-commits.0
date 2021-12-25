Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E949C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 25 Dec 2021 05:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhLYFMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Dec 2021 00:12:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49936 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhLYFMy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Dec 2021 00:12:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3916B80B1E
        for <mm-commits@vger.kernel.org>; Sat, 25 Dec 2021 05:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBB7C36AE9;
        Sat, 25 Dec 2021 05:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409172;
        bh=jPUpNfcBmAylk47gLumr+4CKaHngBKm43WyY6AGe6sU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ALQmLvE6+9vYqf8bBBPI0u+9wYJD96dF5vTqgRHZvNbjNa5imDeIAb+edAmGqcEBC
         6QCuqqLue04Pdy0co/DRAXpNaBe0Mp6GfuPjZqvBi4Z63wcfr+chqCT6Zeq2KAKWg3
         UZJtVVVBIO0fFkeDzTypbxYxU0RHZpJcFwYmXsVg=
Date:   Fri, 24 Dec 2021 21:12:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, danielmicay@gmail.com,
        keescook@chromium.org, levente@leventepolyak.net,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        thibaut.sautereau@ssi.gouv.fr, torvalds@linux-foundation.org
Subject:  [patch 7/9] mm/page_alloc: fix __alloc_size attribute for
 alloc_pages_exact_nid
Message-ID: <20211225051251.h8Du-oj8Q%akpm@linux-foundation.org>
In-Reply-To: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Subject: mm/page_alloc: fix __alloc_size attribute for alloc_pages_exact_nid

The second parameter of alloc_pages_exact_nid is the one indicating the
size of memory pointed by the returned pointer.

Link: https://lkml.kernel.org/r/YbjEgwhn4bGblp//@coeus
Fixes: abd58f38dfb4 ("mm/page_alloc: add __alloc_size attributes for better bounds checking")
Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Levente Polyak <levente@leventepolyak.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-page_alloc-fix-__alloc_size-attribute-for-alloc_pages_exact_nid
+++ a/include/linux/gfp.h
@@ -624,7 +624,7 @@ extern unsigned long get_zeroed_page(gfp
 
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask) __alloc_size(1);
 void free_pages_exact(void *virt, size_t size);
-__meminit void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) __alloc_size(1);
+__meminit void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) __alloc_size(2);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0801CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E708761101
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhIJDLv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJDLv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 23:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD24610E8;
        Fri, 10 Sep 2021 03:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631243441;
        bh=nRwCPY2lF1nZAErck67FCTBZ1P81k5Nf/5UfP2Sy7ps=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I6VQuuCeFKeG1am1cdwjklw1ytTn2poAPaAIRdnUpmJT9kjklbyrHrrT/41UDz/du
         bAELk4zy6gb9toP6dZuwGE34KWgnFYpTrD/4u00E/Lbd4Zbu0DCiZLnMFuC0MjUs1o
         u09rGrI1Q8pSG+TMVbsUt7mR7PBU+IZ6wuTcfoqU=
Date:   Thu, 09 Sep 2021 20:10:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apw@canonical.com, cl@linux.com,
        danielmicay@gmail.com, dennis@kernel.org, dwaipayanray1@gmail.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, keescook@chromium.org,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rientjes@google.com, tj@kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 7/9] mm/page_alloc: add __alloc_size attributes
 for better bounds checking
Message-ID: <20210910031040.tyehRLbzL%akpm@linux-foundation.org>
In-Reply-To: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: mm/page_alloc: add __alloc_size attributes for better bounds checking

As already done in GrapheneOS, add the __alloc_size attribute for
appropriate page allocator interfaces, to provide additional hinting for
better bounds checking, assisting CONFIG_FORTIFY_SOURCE and other compiler
optimizations.

Link: https://lkml.kernel.org/r/20210818214021.2476230-6-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/gfp.h~mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking
+++ a/include/linux/gfp.h
@@ -608,8 +608,10 @@ static inline struct page *alloc_pages(g
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
+__alloc_size(1)
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
+__alloc_size(1)
 void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
_

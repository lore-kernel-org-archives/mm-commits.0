Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB8AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F8B610C8
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhIJDL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJDL6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 23:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4368E610E8;
        Fri, 10 Sep 2021 03:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631243447;
        bh=VLQQlpnW7pBMtKQj5tYD9NvaIoPnZhsXtdxLWRZ4hdo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=L/pggtVFVhMnO4372mdclBp3iFfZht86kO0l716xSY7iLnupFi22eJ3ZsN/YDXpWG
         g74o0MTcK82nDkvXJCaMEcCBG6NTQwhbjmheYgUrN/r31WqJwXi4q0j35B9sX8urQV
         iLCZC/xLzhLSSlAZhr8rGf+mvDb8HvlGqemSYQzQ=
Date:   Thu, 09 Sep 2021 20:10:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apw@canonical.com, cl@linux.com,
        danielmicay@gmail.com, dennis@kernel.org, dwaipayanray1@gmail.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, keescook@chromium.org,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rientjes@google.com, tj@kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 9/9] mm/vmalloc: add __alloc_size attributes for
 better bounds checking
Message-ID: <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
In-Reply-To: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: mm/vmalloc: add __alloc_size attributes for better bounds checking

As already done in GrapheneOS, add the __alloc_size attribute for
appropriate vmalloc allocator interfaces, to provide additional hinting
for better bounds checking, assisting CONFIG_FORTIFY_SOURCE and other
compiler optimizations.

Link: https://lkml.kernel.org/r/20210818214021.2476230-8-keescook@chromium.org
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

 include/linux/vmalloc.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/vmalloc.h~mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking
+++ a/include/linux/vmalloc.h
@@ -136,20 +136,31 @@ static inline void vmalloc_init(void)
 static inline unsigned long vmalloc_nr_pages(void) { return 0; }
 #endif
 
+__alloc_size(1)
 extern void *vmalloc(unsigned long size);
+__alloc_size(1)
 extern void *vzalloc(unsigned long size);
+__alloc_size(1)
 extern void *vmalloc_user(unsigned long size);
+__alloc_size(1)
 extern void *vmalloc_node(unsigned long size, int node);
+__alloc_size(1)
 extern void *vzalloc_node(unsigned long size, int node);
+__alloc_size(1)
 extern void *vmalloc_32(unsigned long size);
+__alloc_size(1)
 extern void *vmalloc_32_user(unsigned long size);
+__alloc_size(1)
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask);
+__alloc_size(1)
 extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
 			pgprot_t prot, unsigned long vm_flags, int node,
 			const void *caller);
+__alloc_size(1)
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller);
+__alloc_size(1)
 void *vmalloc_no_huge(unsigned long size);
 
 extern void vfree(const void *addr);
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDE5C432BE
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F72610CF
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhHRXTq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 19:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhHRXTq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 19:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F7CA610CE;
        Wed, 18 Aug 2021 23:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629328751;
        bh=PmvVOwkpqsrUHh4G9Ya7sR1DV5Bqki2pvTkrT7MA5f4=;
        h=Date:From:To:Subject:From;
        b=GwutqLvAXwxZ/3PPL1Ex+TUeKSF3XO2VUcbj879hQ7oW/iaUWRCpNTSR29YD8iaT0
         ji3ZfWqWdNZGZ9ElR7MsSADCLhh/lA/CMzymmMX4ACAzOaoFcc4GN1vUVS4S0Zp4Ev
         y1HVDtfSHjZCKKNoV5ke/HgeZ7R6+Laj5j/QijWw=
Date:   Wed, 18 Aug 2021 16:19:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org,
        rientjes@google.com, penberg@kernel.org, ojeda@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org,
        lukas.bulwahn@gmail.com, joe@perches.com, iamjoonsoo.kim@lge.com,
        dwaipayanray1@gmail.com, dennis@kernel.org, danielmicay@gmail.com,
        cl@linux.com, apw@canonical.com, keescook@chromium.org
Subject:  +
 mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
 added to -mm tree
Message-ID: <20210818231910.ogLKo%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add __alloc_size attributes for better bounds checking
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -618,8 +618,10 @@ static inline struct folio *folio_alloc(
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
+__alloc_size(1)
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
+__alloc_size(1)
 void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch


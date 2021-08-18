Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1DEC4320E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE29610FD
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhHRXTt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 19:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234794AbhHRXTs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 19:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD405610CF;
        Wed, 18 Aug 2021 23:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629328753;
        bh=+7pGpru1TKBQX66Hbbrrw7zWdRACrq3cf6zbd4C0f5s=;
        h=Date:From:To:Subject:From;
        b=gJFMP5IgzIrt138+vLDCjgvemBNXUsw46IpEo1csHQp7NOvHISYqDhdeNucQlSegW
         PH8RlYi3Q4X+P3UNGoL9ZdX5Mxj1dgv4xUMoZG50/gIF1uKSazBZykY2vJXOisyA29
         ZZGt9U4xOlUjc6O1P/EbC/cO2gBDyaB8+AlhqRZE=
Date:   Wed, 18 Aug 2021 16:19:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org,
        rientjes@google.com, penberg@kernel.org, ojeda@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org,
        lukas.bulwahn@gmail.com, joe@perches.com, iamjoonsoo.kim@lge.com,
        dwaipayanray1@gmail.com, dennis@kernel.org, danielmicay@gmail.com,
        cl@linux.com, apw@canonical.com, keescook@chromium.org
Subject:  +
 percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch added to
 -mm tree
Message-ID: <20210818231912.NNo0s%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: add __alloc_size attributes for better bounds checking
has been added to the -mm tree.  Its filename is
     percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch

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
Subject: percpu: add __alloc_size attributes for better bounds checking

As already done in GrapheneOS, add the __alloc_size attribute for
appropriate percpu allocator interfaces, to provide additional hinting for
better bounds checking, assisting CONFIG_FORTIFY_SOURCE and other compiler
optimizations.

Link: https://lkml.kernel.org/r/20210818214021.2476230-7-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/percpu.h~percpu-add-__alloc_size-attributes-for-better-bounds-checking
+++ a/include/linux/percpu.h
@@ -123,6 +123,7 @@ extern int __init pcpu_page_first_chunk(
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
+__alloc_size(1)
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
 extern bool __is_kernel_percpu_address(unsigned long addr, unsigned long *can_addr);
 extern bool is_kernel_percpu_address(unsigned long addr);
@@ -131,7 +132,9 @@ extern bool is_kernel_percpu_address(uns
 extern void __init setup_per_cpu_areas(void);
 #endif
 
+__alloc_size(1)
 extern void __percpu *__alloc_percpu_gfp(size_t size, size_t align, gfp_t gfp);
+__alloc_size(1)
 extern void __percpu *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void __percpu *__pdata);
 extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch


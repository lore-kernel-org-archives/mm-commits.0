Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2412BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A28D610E8
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhIJDLz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJDLy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 23:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D299C600CC;
        Fri, 10 Sep 2021 03:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631243444;
        bh=n0st8wU7IKqnWoY65vxwcP8njzLlt2JU12trBNPz95I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u2vuS37Zc9jQmrP6KqUkoUEirHJY3M/HkzeesvAx0rr4WQUkwESOiAAww7OZatUcM
         s0BJu628ZMTAvtR6eeWxHOIDdI/Zi1xnuxOIbjuWyJ4pKdMfBOmTBmlm9sNA3xWZ3t
         jtFNVaIqtuFv90l1bHr5rnMAgD1DPGZLKB3uWi/A=
Date:   Thu, 09 Sep 2021 20:10:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apw@canonical.com, cl@linux.com,
        danielmicay@gmail.com, dennis@kernel.org, dwaipayanray1@gmail.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, keescook@chromium.org,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rientjes@google.com, tj@kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 8/9] percpu: add __alloc_size attributes for
 better bounds checking
Message-ID: <20210910031043.GNMLvLlZC%akpm@linux-foundation.org>
In-Reply-To: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

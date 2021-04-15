Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60C2C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 18:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A17611BF
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 18:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhDOSRh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Apr 2021 14:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbhDOSRg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Apr 2021 14:17:36 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FEAC061574
        for <mm-commits@vger.kernel.org>; Thu, 15 Apr 2021 11:17:13 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id 6so20947414ilt.9
        for <mm-commits@vger.kernel.org>; Thu, 15 Apr 2021 11:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Bcw8jiZAV6GbKvb9bvtBJGal+yXM06T0JFlFG5o2+M=;
        b=iisCghM1TbHlV8cEtiZ0p5Ra1gmK1L+3GLoircOymvKTmDdcCfLWc+Z2/GIuoCA/V1
         EuC4dqv+HMqlCPulKD6jWqWE4lr52GJr/4G57NQ3NMCfoUCWMfe401k9N8Gl2GPW8RRi
         nop8BX2CyhWrSTg/xP+dBCfjpdoUAzx97tlKXDlgSJUOErdZUfRS7gWFvHS9yD067pFB
         bPud3y80HkmSbV8TII1o4nwF0j4eVFMdMUBYx4p4bn6moFRiHiT+fGOwPu5TrgLv/qdf
         uubZd+nNKT0d/5O+W/AciXoYHLYLWANDZiUgHGYg/cqlQn4LmVBBBDMO0+0yUkUcuW4U
         9k6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Bcw8jiZAV6GbKvb9bvtBJGal+yXM06T0JFlFG5o2+M=;
        b=Erjna7AB6Kv0GG4wNRk432EZsiPB4p6S75bI4W11/3FeVwE+3yHU8ML4B64DZYqAQ/
         LUiQEyLDjqvmwN2vLunYjQo2h0skImTOiSOO/+2ZeXL76Kh+hJvmPEaBkzIYjFIRVPkS
         8XRGZ60njxLXvlmftLEaEhQkxvusmCChX0hrdIhyyDyuzM+F4kohM/4Bt6jkjIX/429c
         vR7kQA9iDYFdi9c0XRHuQCfxqMrrIEgYPSnd+9WWrWL727Bpu8XBwEjeuzLa39X5jPdf
         911LJkDdi0McJ0aTXBSewQ+K7ARrWjBHTD4+S2pIbZpR5Vjyn44ReMQduc8NyPpJon5i
         zWKQ==
X-Gm-Message-State: AOAM532fDMfcbTwG54DxN5LVGAxwRTEecMe3BJ4/whIHFe7+wk83+eAu
        KfjVuZ5iYr0g0ZNaZuqtcWj3zdUhKLiJE72N0j3EHw==
X-Google-Smtp-Source: ABdhPJwE0HV6WWT+EaNdBpzTIKU+iTqtUSmcNB2xRQYbo+27m34XZ56uWF9K8gWJlny5AetQ9/kiYGds7ZV4szirYV4=
X-Received: by 2002:a92:1948:: with SMTP id e8mr3645294ilm.145.1618510632777;
 Thu, 15 Apr 2021 11:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210406014615.ccKage_oR%akpm@linux-foundation.org>
In-Reply-To: <20210406014615.ccKage_oR%akpm@linux-foundation.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 15 Apr 2021 11:17:01 -0700
Message-ID: <CAMn1gO5uTZ0ubXFpZBJTi+KaCmrrjHYrr1BhJQScEr=7WAUquw@mail.gmail.com>
Subject: Re: + kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Alexander Potapenko <glider@google.com>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Apr 5, 2021 at 6:46 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: kasan: fix kasan_byte_accessible() to be consistent with actual checks
> has been added to the -mm tree.  Its filename is
>      kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days

Hi Andrew,

Thanks for picking up this patch. It looks like you added it after the
"kasan: initialize shadow to TAG_INVALID for SW_TAGS" patch in your
series, but I think it would make more sense for it to appear before
that one, i.e. apply something like this patch to
https://www.ozlabs.org/~akpm/mmotm/series :

--- series.old 2021-04-15 11:07:39.998177270 -0700
+++ series 2021-04-15 11:08:15.765868715 -0700
@@ -565,6 +565,7 @@
 #mm/kasan
 mm-kasan-switch-from-strlcpy-to-strscpy.patch
 #
+kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
 kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
 mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
 #
@@ -594,7 +595,6 @@
 #
 irq_work-record-irq_work_queue-call-stack.patch
 #
-kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
 #
 #mm/initialization
 mm-move-mem_init_print_info-into-mm_init.patch

>
> ------------------------------------------------------
> From: Peter Collingbourne <pcc@google.com>
> Subject: kasan: fix kasan_byte_accessible() to be consistent with actual checks
>
> We can sometimes end up with kasan_byte_accessible() being called on
> non-slab memory.  For example ksize() and krealloc() may end up calling it
> on KFENCE allocated memory.  In this case the memory will be tagged with
> KASAN_SHADOW_INIT, which a subsequent patch ("kasan: initialize shadow to
> TAG_INVALID for SW_TAGS") will set to the same value as KASAN_TAG_INVALID,
> causing kasan_byte_accessible() to fail when called on non-slab memory.
>
> This highlighted the fact that the check in kasan_byte_accessible() was
> inconsistent with checks as implemented for loads and stores
> (kasan_check_range() in SW tags mode and hardware-implemented checks in HW
> tags mode).  kasan_check_range() does not have a check for
> KASAN_TAG_INVALID, and instead has a comparison against
> KASAN_SHADOW_START.  In HW tags mode, we do not have either, but we do set
> TCR_EL1.TCMA which corresponds with the comparison against
> KASAN_TAG_KERNEL.
>
> Therefore, update kasan_byte_accessible() for both SW and HW tags modes to
> correspond with the respective checks on loads and stores.
>
> Link: https://linux-review.googlesource.com/id/Ic6d40803c57dcc6331bd97fbb9a60b0d38a65a36
> Link: https://lkml.kernel.org/r/20210405220647.1965262-1-pcc@google.com
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Reviewed-by: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Peter Collingbourne <pcc@google.com>
> Cc: Evgenii Stepanov <eugenis@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/kasan/kasan.h   |    3 +--
>  mm/kasan/sw_tags.c |   10 +++++++---
>  2 files changed, 8 insertions(+), 5 deletions(-)
>
> --- a/mm/kasan/kasan.h~kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks
> +++ a/mm/kasan/kasan.h
> @@ -369,8 +369,7 @@ static inline bool kasan_byte_accessible
>         u8 ptr_tag = get_tag(addr);
>         u8 mem_tag = hw_get_mem_tag((void *)addr);
>
> -       return (mem_tag != KASAN_TAG_INVALID) &&
> -               (ptr_tag == KASAN_TAG_KERNEL || ptr_tag == mem_tag);
> +       return ptr_tag == KASAN_TAG_KERNEL || ptr_tag == mem_tag;
>  }
>
>  #else /* CONFIG_KASAN_HW_TAGS */
> --- a/mm/kasan/sw_tags.c~kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks
> +++ a/mm/kasan/sw_tags.c
> @@ -121,10 +121,14 @@ bool kasan_check_range(unsigned long add
>  bool kasan_byte_accessible(const void *addr)
>  {
>         u8 tag = get_tag(addr);
> -       u8 shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(kasan_reset_tag(addr)));
> +       void *untagged_addr = kasan_reset_tag(addr);
> +       u8 shadow_byte;
>
> -       return (shadow_byte != KASAN_TAG_INVALID) &&
> -               (tag == KASAN_TAG_KERNEL || tag == shadow_byte);
> +       if (untagged_addr < kasan_shadow_to_mem((void *)KASAN_SHADOW_START))
> +               return false;
> +
> +       shadow_byte = READ_ONCE(*(u8 *)kasan_mem_to_shadow(untagged_addr));
> +       return tag == KASAN_TAG_KERNEL || tag == shadow_byte;
>  }
>
>  #define DEFINE_HWASAN_LOAD_STORE(size)                                 \
> _
>
> Patches currently in -mm which might be from pcc@google.com are
>
> kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
>

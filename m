Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BCBC4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 14:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2655323A75
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 14:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgLHO7a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 09:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729587AbgLHO7a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2020 09:59:30 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA6FC061749
        for <mm-commits@vger.kernel.org>; Tue,  8 Dec 2020 06:58:49 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id a6so2309980wmc.2
        for <mm-commits@vger.kernel.org>; Tue, 08 Dec 2020 06:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=id4czk65q8My3F8R+5fDiap9nji0jsJdw6Ow+cR3Bbg=;
        b=dY/Erx3WmB95L0suqs8N/cXpr8p0ShNg5u9GkVclfUv3MVH5q5Aiq0iYP8RPAufU8c
         5g2dG+XXhi6tsRhflOjk2EeKfUmd7raDo7xF2Zzd5kuMJvbp6wIEm4ImgiZRxe4w976/
         a/2htfoqGYm34Fs9fa01/M5SDn7utxUCSSfzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=id4czk65q8My3F8R+5fDiap9nji0jsJdw6Ow+cR3Bbg=;
        b=ZOodasNw0bToHa602GsgWtT3/B5403TBnmB/98vXZF9+KbrgXbhU3ZGHvFORlT6Tem
         RzxRq+Cg/fHihRYJF0b7Wbe8EJAT1MElaLejMI7vD+WUscVNnvedwQayPabZ0ZaFFPVn
         p2guD+Gx7wUmfrOvgE9Bdykq33ep+N9GCZIASn8jkCxJGitm/gx5q5V3xvGA8Lex6vXB
         HB4u+mLoYurSzEU1kMs6dJ+VCURpwOBit7xkUEibn7lmmKNV11hkfrF6Yin9mZt3BF7p
         3ErNpr/LQAKNv5/iPhBAEIbNm0EwuGKNSWDo/84l0RdMaJEjNr3Hut1l4Tj88prtwsWl
         8pOQ==
X-Gm-Message-State: AOAM531k3tVkpvqCRgOJXcgwCrsHx5IqkMjZcPeKWObRbaVm7HbStI3E
        7loRhyVM4ERev8/p1CLYHarS+6/isINTVlRwY2GjnQ==
X-Google-Smtp-Source: ABdhPJwYCMbKhwnwI7uK5e4Q5pSc4fKYxuwOW9+DmIgJ4EjLQbbjD29J8xaqniikwPAPYvjTp4YOTGbBvrLytFwzkn4=
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr4109156wml.160.1607439528233;
 Tue, 08 Dec 2020 06:58:48 -0800 (PST)
MIME-Version: 1.0
References: <20201208034157.9KFja%akpm@linux-foundation.org>
In-Reply-To: <20201208034157.9KFja%akpm@linux-foundation.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 8 Dec 2020 08:58:37 -0600
Message-ID: <CAFxkdAoKYDbn35RzDY8nAwxqNdEFaVhcLQLt=PjVhuYAxxMdBw@mail.gmail.com>
Subject: Re: + revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 7, 2020 at 9:41 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"
> has been added to the -mm tree.  Its filename is
>      revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
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
>
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"
>
> Revert 3351b16af494 ("mm/filemap: add static for function
> __add_to_page_cache_locked") due to build issues with
> CONFIG_DEBUG_INFO_BTF=y.
>
> Link: https://lkml.kernel.org/r/CAADnVQJ6tmzBXvtroBuEH6QA0H+q7yaSKxrVvVxhqr3KBZdEXg@mail.gmail.com
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Cc: Justin Forbes <jmforbes@linuxtx.org>
> Cc: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This fixes it:

Tested-by: Justin Forbes <jmforbes@linuxtx.org>

> ---
>
>  mm/filemap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/mm/filemap.c~revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked
> +++ a/mm/filemap.c
> @@ -827,7 +827,7 @@ int replace_page_cache_page(struct page
>  }
>  EXPORT_SYMBOL_GPL(replace_page_cache_page);
>
> -static noinline int __add_to_page_cache_locked(struct page *page,
> +noinline int __add_to_page_cache_locked(struct page *page,
>                                         struct address_space *mapping,
>                                         pgoff_t offset, gfp_t gfp,
>                                         void **shadowp)
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
> kthread_worker-document-cpu-hotplug-handling-fix.patch
> mm.patch
> mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
> mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
> mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
> mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
> mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
> mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
> lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
> ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
> lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
> checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
> resource-fix-kernel-doc-markups-checkpatch-fixes.patch
> linux-next-rejects.patch
> kmap-stupid-hacks-to-make-it-compile.patch
> init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
> set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
> arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
>

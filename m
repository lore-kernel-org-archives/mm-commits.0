Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86186C197BF
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 07:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64AF223A6A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 07:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgLHHWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 02:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgLHHWL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2020 02:22:11 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E74AC061793
        for <mm-commits@vger.kernel.org>; Mon,  7 Dec 2020 23:21:25 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id e7so8870350qvw.9
        for <mm-commits@vger.kernel.org>; Mon, 07 Dec 2020 23:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to;
        bh=5FaheHz7vxhPJh5+cv83N5dJ1ZDX5NnpP7PL3kzvlXI=;
        b=UaObGW572S5cABuocxvccGtN+hEYLn84NAh7cRa/1ir/UOBVqu8Yh+TZ0KmXHKAd9h
         orTKXdrU5Xcodr/JiTGmGb9ad83G+Wdly3EnSHCjdspUkP2+TUwbPfriGDqUNT+zo6jD
         a+A1XV/n0FJ1dyYoq+XcuV+XjPRvQ8ju55AGF0orAiJ2DV3QWC0fqfrf2cfB5MHP57SM
         JYJ9WTl4+bVaR4wQT/HgPrrWLx9GS518wbNKeszhzecm4wUMzmlRrx6GQJr9xWsh4xT3
         fG10ntXz+tObbOdcvBX7hyKII5YYrvav0VpsbEZ0v+vHzV3bRJTmGXIYGDEymnU8Jt5h
         k88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to;
        bh=5FaheHz7vxhPJh5+cv83N5dJ1ZDX5NnpP7PL3kzvlXI=;
        b=V52kan0MFxEiLHmb+6L46Kadq+U4jB9AS5pUb6i4YUGss0wYBK4fFEGS0pJmd5OfbO
         KjjIxdS7c/G0fpM7v1in0fpGlQEFLTf/XLWGF2/x/ttBmvMd++2vUzLRYxa1lwhkBKZS
         yRk2RqCVbUQivnnBKva3iN5B/CQexqFHAFj2Y+oKrenQwVjumgpF7qG1mR+3/tbA2jey
         i0ojRyyJ5dT5T/CeBQD8ewE36TsulgGAIf9/ftZpsHyaB+Fn56PeUA8JuBF9Ub2BK4Om
         m9wo/QAxikTu7wcFeicISDKtS+fg9pKH97eveonw4oFoIwus+IqNCd4nIAuHO85Fpj60
         vZ4w==
X-Gm-Message-State: AOAM530JGUC9YYJjm7W30HWU7X88NAB+crJs1s+Q/Yq+zIiOk/XTtEkv
        daHgwgdCqbgYImrPvfqdv8mo0ybbDNch
X-Google-Smtp-Source: ABdhPJxPYBBQb4W2rVkhIhrfuaGMZIYqXpbnQdiz8G3Ue26WR8SLvGjTksb1IkNoUD/Tpb3dZF6aCp7LZj+q
Sender: "gthelen via sendgmr" <gthelen@gthelen.svl.corp.google.com>
X-Received: from gthelen.svl.corp.google.com ([2620:15c:2cd:202:8edc:d4ff:fe33:9605])
 (user=gthelen job=sendgmr) by 2002:a0c:8d47:: with SMTP id
 s7mr25470245qvb.17.1607412084369; Mon, 07 Dec 2020 23:21:24 -0800 (PST)
Date:   Mon, 07 Dec 2020 23:21:19 -0800
In-Reply-To: <20201208034157.9KFja%akpm@linux-foundation.org>
Message-Id: <xr93o8j4kbkg.fsf@gthelen.svl.corp.google.com>
Mime-Version: 1.0
References: <20201208034157.9KFja%akpm@linux-foundation.org>
Subject: Re: + revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
 added to -mm tree
From:   Greg Thelen <gthelen@google.com>
To:     linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        mkubecek@suse.cz, jrdr.linux@gmail.com, josef@toxicpanda.com,
        jmforbes@linuxtx.org, daniel@iogearbox.net, ast@kernel.org,
        alex.shi@linux.alibaba.com, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

akpm@linux-foundation.org wrote:

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

Thanks.

Tested-by: Greg Thelen <gthelen@google.com>

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
>  					struct address_space *mapping,
>  					pgoff_t offset, gfp_t gfp,
>  					void **shadowp)
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

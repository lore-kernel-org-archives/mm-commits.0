Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90ACC4743C
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 15:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 905DF61241
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 15:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhFNPme (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 11:42:34 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:36429 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhFNPma (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jun 2021 11:42:30 -0400
Received: by mail-pj1-f45.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so5164361pjn.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Jun 2021 08:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=myiX+BI18vE8D958dfduJf216/TpgEebV0P7oioGSms=;
        b=VlrAiuSeBfdNqoRhwlNwF9A5mP8cKFSdh8xrYle9ySgJlSbUagm2UtwFhbPI9Wj0rH
         zs3wpXN/iPFG/eLHWpoVIbzz5xTRpwzaMaJ8512qySnLC3iNgzjCbWLxozA7c4/UFipg
         267ogsOP+Wt7PY/DtNEQ/R1ng6F+F8m5uEFu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=myiX+BI18vE8D958dfduJf216/TpgEebV0P7oioGSms=;
        b=tKPptjZ6DUZg4igXtknVCVVWmCfWWPB/Fig3Zg7rxM3Me66HK2CesCOIE3O4QIKv9A
         QEpPcY5Z7TwVqrQHWXFA8oMBSU1zmB+9i/Ajc38J99B3mNug0cwxBYdeHI50Ip/oC1I4
         Z0bSs+IspEB1//IUul+aELVp0pu71zir4tYMkMFb3Qu4YT1GghmMdTRjEV3Mt0IXk/Er
         UU25yDibO2o8/wZiVGWcVBiDc4N5TGHUgbYM675wCU7dm4lphSv7FGI5ss+S8v3TBR8u
         YvaqojQoI4mpFwAlRKMmB8V3m6jeaRj+yQktscFPjtPV8Q8hIBEzLloxOBtR9WP63oyE
         iBtg==
X-Gm-Message-State: AOAM533R5c/Q+BAnKn2xHR6JhB3BJcOa/4H7G9C3NppYCrJcJgTwhIf1
        U++9eYSQydX27Kjwa4pN1n2sgQ==
X-Google-Smtp-Source: ABdhPJzoGJhC2Tfh146kvyqgs+MzIprVhd/CW8t+upyycnOzSLzm2wGuYBQ+AB8PeH5llvKODgR89g==
X-Received: by 2002:a17:90b:152:: with SMTP id em18mr19585420pjb.96.1623685155094;
        Mon, 14 Jun 2021 08:39:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t143sm14872018pgb.93.2021.06.14.08.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 08:39:14 -0700 (PDT)
Date:   Mon, 14 Jun 2021 08:39:13 -0700
From:   Kees Cook <keescook@chromium.org>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, vannguye@cisco.com
Subject: Re: + mm-slubc-include-swabh.patch added to -mm tree
Message-ID: <202106140837.C076D2A7@keescook>
References: <20210611222752.GTNGHyXTQ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611222752.GTNGHyXTQ%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jun 11, 2021 at 03:27:52PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/slub.c: include swab.h
> has been added to the -mm tree.  Its filename is
>      mm-slubc-include-swabh.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-include-swabh.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-include-swabh.patch
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
> Subject: mm/slub.c: include swab.h
> 
> Fixes build with CONFIG_SLAB_FREELIST_HARDENED=y.
> 
> Fixes: 1ad53d9fa3f61 ("slub: improve bit diffusion for freelist ptr obfuscation")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=213417
> Reported-by: <vannguye@cisco.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Is this for a backport in v4.18? Regardless, yes:

Acked-by: Kees Cook <keescook@chromium.org>

> ---
> 
>  mm/slub.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/mm/slub.c~mm-slubc-include-swabh
> +++ a/mm/slub.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/bit_spinlock.h>
>  #include <linux/interrupt.h>
> +#include <linux/swab.h>
>  #include <linux/bitops.h>
>  #include <linux/slab.h>
>  #include "slab.h"
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm-slubc-include-swabh.patch
> mm.patch
> mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
> slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
> mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
> mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
> binfmt-remove-in-tree-usage-of-map_executable-fix.patch
> mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
> lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
> mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
> mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
> mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
> nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
> mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
> mmmemory_hotplug-drop-unneeded-locking-fix.patch
> fs-proc-kcorec-add-mmap-interface-fix.patch
> kernelh-split-out-panic-and-oops-helpers-fix.patch
> lib-math-rational-add-kunit-test-cases-fix.patch
> lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
> ipc-utilc-use-binary-search-for-max_idx-fix.patch
> linux-next-pre.patch
> linux-next-post.patch
> linux-next-rejects.patch
> mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
> module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
> module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> 

-- 
Kees Cook

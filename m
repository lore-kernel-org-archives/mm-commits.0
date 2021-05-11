Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82231C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 02:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532BD61466
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 02:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhEKC1k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 22:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhEKC1j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 May 2021 22:27:39 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674A0C061574
        for <mm-commits@vger.kernel.org>; Mon, 10 May 2021 19:26:34 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id m37so14689900pgb.8
        for <mm-commits@vger.kernel.org>; Mon, 10 May 2021 19:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=impJFfchbTyquTMoHdJZIptfr5RDEL3phfl3SbtAbeI=;
        b=kKoK/KbPn9SlGtHJjnjUJ2NVchEpiv7jQg/lEWoeg1iJjZIAvkX+ImvHxBtc5CMjra
         q4lt3ghqWPNOVhNps5rh8wbzjLmeb+B0cqLwe6WgbHAXcBaONlTaYakgoIr9tadCtt6i
         N0PpD4e8tPWiH/mkHSihmcwo6cZF55zKKkViSyLlmEEKgpLWfllXKG03bhsVk+YRRipn
         dks2aLNxLS+/zcVSwDd0GFWVwSxz4EP3h4AiQYF3sBERR5IMeZavVh+fY74G/uhBSJcb
         d/U2HxPtn5CwEQ7BPMOG/JRFxi0+S7CgcppQ4C6di69OgZRl2CxAeNBHkSHgurMxM2SN
         hdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=impJFfchbTyquTMoHdJZIptfr5RDEL3phfl3SbtAbeI=;
        b=EyP1o6eRvgi3oQwePYvB0V32EUdbldykswCjmwo1cIIYcqc2MjkYkcm5XZL4r2Drl4
         GzFxIjAdeZFp/cS9EVDidXGf9dTuX9Pyeb6INp/xjdCYV+y/vVEDqUAUxWiPUI8OMH8J
         s6L6QTbbrw5puXO0TgIxzOQHPxVV0WE2sGfwDruOw6cJMlOLBxLFOLEE1tfhTaKFuzwS
         dj8BYrvXde3DYKaVqqXBhoF6ml69tL5DHIrLMEdjH7gSV7rFTP6uMsUf/Ns5jqE7tS0f
         pLCDT5Xfj9FU4w8z81jOI01lY+M5Sh1HHTUPdOgdSeqYBevP4T0/ToDofpS+BFeCRSzE
         rqZQ==
X-Gm-Message-State: AOAM5324YsoNJVQKpwPkqR4WEx7aHKssB6HyxbjgaoJe4EqVc/61cPPU
        PyeeuDNaZIZWt7Ix8ruU0i41pYHwjOYxEJWa+6LfGA==
X-Google-Smtp-Source: ABdhPJx78o3yGH3O/S6M9o/eTLg2xfmi5G/z++lxvvBIH35edyW1ROe+ZgP7awNQl1o0p5gke2X8MlDghfpZRuKW6js=
X-Received: by 2002:a05:6a00:8c7:b029:20f:1cf4:d02 with SMTP id
 s7-20020a056a0008c7b029020f1cf40d02mr28504107pfu.49.1620699993997; Mon, 10
 May 2021 19:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210511003615.QIPkGw1eH%akpm@linux-foundation.org>
In-Reply-To: <20210511003615.QIPkGw1eH%akpm@linux-foundation.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 11 May 2021 10:25:57 +0800
Message-ID: <CAMZfGtVknv7XpWzScibQOjAzvSUKoKfFNi6QzmR9=Wkk45-KCg@mail.gmail.com>
Subject: Re: [External] + mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Oscar Salvador <osalvador@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 11, 2021 at 8:36 AM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix
> has been added to the -mm tree.  Its filename is
>      mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
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
> Subject: mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix
>
> remove unneeded include, per Oscar
>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/acpi/acpi_memhotplug.c |    1 -
>  1 file changed, 1 deletion(-)
>
> --- a/drivers/acpi/acpi_memhotplug.c~mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix
> +++ a/drivers/acpi/acpi_memhotplug.c
> @@ -15,7 +15,6 @@
>  #include <linux/acpi.h>
>  #include <linux/memory.h>
>  #include <linux/memory_hotplug.h>
> -#include <linux/hugetlb.h>

Very thanks Andrew for doing this for me.

>
>  #include "internal.h"
>
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> mm.patch
> mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
> mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
> mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
> mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
> nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
> mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
>

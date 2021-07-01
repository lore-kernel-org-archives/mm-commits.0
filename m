Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32C7C11F67
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 03:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FD6610E5
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 03:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhGADff (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 23:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhGADff (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jun 2021 23:35:35 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5291BC061756
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 20:33:04 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id x20so6374550ljc.5
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 20:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NA9zaSPl39QWKkH0SVypcQLeEvnyIgsesumJ5nuFfg=;
        b=gOnY+vSX/LpwlpQfUXSi2tjk/3lMLVyLpz5na6UtYMWo7Yu1XjW9LZVuLlw8OpKMT/
         K4bBgRF0/fVRnClTkDLINLF1m6J+LO5PlAk/+IPJx0mmmwuHXcrgAn/GKI+qnuBBwBuO
         Avm9q0GjZb+7pnvYvKdkiQr7GBMsiAuJre8mA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NA9zaSPl39QWKkH0SVypcQLeEvnyIgsesumJ5nuFfg=;
        b=sQ87D5GVRFbM02kbchDnr+DkG6lX2/I2R9/zRxicQhZySsZDB2AXmVf8R6ibjXskGz
         Im5yzVAEWow5pKUhP8+R/3HbGdjviZhtcI/qU8L6ChEb+gOa2gug7h15T/rsc9budZsX
         PBItmZFQoWOPePU0ksLtdm4/SIBdWRwSZ/JyzTRHAZwmIc7ja43GvKxqa/wuBGwW4dw7
         6xBBwUOgwWKbD6llx5LQkZtD9ahGNYBn/UhLUexzxXqZM6QiaPLAu3i0C0bLr8NsEQXS
         SXh3qP5JhmaHXIoreJGs7/CAXDMz4ah4SasrZA7YhgGIWd3hbbXzrmfHOZ/U4huLFcDw
         a6YQ==
X-Gm-Message-State: AOAM532oOou92p7rxBk71BydnWcqtbwvlwx69T6aSL1jj5egiCU+tN0h
        VWYNqvJiCVooQBJH888sZ0b3eycWj3qDEm6x
X-Google-Smtp-Source: ABdhPJyRGmN4jxK+kO4k2xywWqCLCoIf32c3aQDwpLM5nBPT3xstkHCxNAnvZDB5R+C10fcDAgnWZw==
X-Received: by 2002:a05:651c:10a8:: with SMTP id k8mr10212850ljn.99.1625110382112;
        Wed, 30 Jun 2021 20:33:02 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id o14sm203509lfr.296.2021.06.30.20.33.01
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 20:33:01 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id a18so9095236lfs.10
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 20:33:01 -0700 (PDT)
X-Received: by 2002:ac2:4da3:: with SMTP id h3mr1773803lfe.487.1625110380767;
 Wed, 30 Jun 2021 20:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org> <20210701015441.snfkDnNcO%akpm@linux-foundation.org>
In-Reply-To: <20210701015441.snfkDnNcO%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Jun 2021 20:32:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh8=sukFB3J-4BbBYZPLYoFgkzAjCxU95LKJ831g8SRVA@mail.gmail.com>
Message-ID: <CAHk-=wh8=sukFB3J-4BbBYZPLYoFgkzAjCxU95LKJ831g8SRVA@mail.gmail.com>
Subject: Re: [patch 141/192] fs/proc/kcore.c: add mmap interface
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        chenying.kernel@bytedance.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 6:54 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> When we do the kernel monitor, use the DRGN
> (https://github.com/osandov/drgn) access to kernel data structures, found
> that the system calls a lot.  DRGN is implemented by reading /proc/kcore.
> After looking at the kcore code, it is found that kcore does not implement
> mmap, resulting in frequent context switching triggered by read.
> Therefore, we want to add mmap interface to optimize performance.

Ok, this is funky, but I'm going to drop this patch because I think
it's buggy as is.

 Since

> +static int mmap_kcore(struct file *file, struct vm_area_struct *vma)
> +{
> +       size_t size = vma->vm_end - vma->vm_start;

Ok.

But then:

> +       start = kc_offset_to_vaddr(((u64)vma->vm_pgoff << PAGE_SHIFT) -
> +               ((data_offset >> PAGE_SHIFT) << PAGE_SHIFT));

Not only is that

        ((data_offset >> PAGE_SHIFT) << PAGE_SHIFT)

a very strange calculation (did you mean "data_offset & PAGE_MASK"?),
but I don't see anything that protects against underflow in that
calculation. pg_off can easily be arbitrarily small (eg zero), so that
subtraction can underflow afaik.

So that needs a test, and return -EINVAL or whatever.

But even if that is fixed, this test is entirely broken:

> +       list_for_each_entry(m, &kclist_head, list) {
> +               if (start >= m->addr && size <= m->size)
> +                       break;
> +       }

No, that's wrong.

You allow 'size' to be as big as 'm->size', but you do that even if
'start' isn't 'm->start'.

The proper check would be something like

       u64 end = start + size;

        if (start >= m->addr && end <= m->addr+m->size) ..

or similar (and that should check that "start+size" hasn't overflowed).

So I see what appears to be multiple problems, and while I hand-waved
some fixes for them, those are very much "maybe something like this",
and I'm going to drop this patch. Not for 5.14.

           Linus

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC3CC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 16:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B38D613D9
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 16:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhD3Qvh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 12:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhD3Qvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Apr 2021 12:51:36 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1EAC06174A
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 09:50:48 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id j10so17935755lfb.12
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 09:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2mgGOD6DsCL1nEPbpxya30H86CQfb4AoFjQ0GL0EjuI=;
        b=Y5xPODzFA24qqFAWkpQEJN4NcIBUMU8RFQhSRbg/S7UJyEDBsTUIcC1t4vkqXJo82M
         NResZ6y5IN9593zNpRWllf0geGDAMsM3Lv0SHyZ8bAguSxaYCLaKmtVKxvJUOI4Ck99H
         dmKsNcwFDBOdcf7tiJ53ucsnmMuUC4eyfQ6sM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2mgGOD6DsCL1nEPbpxya30H86CQfb4AoFjQ0GL0EjuI=;
        b=e/ZC1ryvwzxdcMtTPomjTkRMvLgfmgujB+697PYhaadwA8nfM0K0QOu+KEKnBLKMUi
         YhPN3rNPVcDc0YvBMWBYw/cbvgz0SssOqUX8OEKyHzi4qzUvtn4dDvk5VJKAdOJqM0jG
         KI+JI7XKNz9GflqDTM4zad9NLmCvaXGpydJ+VB6dfZcpsNQgvUn4iQmIoQXAzMmqK3CT
         loLFdaCQ32WxrzhVprf3Fkms8pkzSajqLYPyCsHqWqYX/41zkfTD5zTReXOrE+wiipGG
         2K68kBaHRN/tjJ2svCBnGYzWssipLbSkAl2NSxd80fFz314GdfwKlVq+N2QkjEQlUjLW
         cdRg==
X-Gm-Message-State: AOAM533twwOU1UQQNpX2q5/Kjm6gWvh+D/0tdhLY2pS42CUoIwx0cTtc
        yRAuAigsJlY9a9PXSkAfICEIBFpdcSqRR3H8
X-Google-Smtp-Source: ABdhPJwfDY34IYO8t+pES8x7SAOLWuELKAIflDfqL0HVOyFeY6FzFbNjVW9G/WZxVCjkggWOUlTgpA==
X-Received: by 2002:ac2:5fc6:: with SMTP id q6mr3760112lfg.205.1619801446402;
        Fri, 30 Apr 2021 09:50:46 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id k20sm331478lfg.54.2021.04.30.09.50.45
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 09:50:45 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id z23so35090689lji.4
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 09:50:45 -0700 (PDT)
X-Received: by 2002:a2e:b4a2:: with SMTP id q2mr4280811ljm.61.1619801445412;
 Fri, 30 Apr 2021 09:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org> <20210430055518.KCtlWixJr%akpm@linux-foundation.org>
In-Reply-To: <20210430055518.KCtlWixJr%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Apr 2021 09:50:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_-EwefQ_3Osz4iJxTrTk3tfrV53Z7-jaGg=tm9i5TXg@mail.gmail.com>
Message-ID: <CAHk-=wg_-EwefQ_3Osz4iJxTrTk3tfrV53Z7-jaGg=tm9i5TXg@mail.gmail.com>
Subject: Re: [patch 041/178] mm: provide filemap_range_needs_writeback() helper
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Wait, what?

On Thu, Apr 29, 2021 at 10:55 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> +       if (!mapping_needs_writeback(mapping))
> +               return false;
> +       if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
> +           !mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> +               return false;
> +       if (end_byte < start_byte)
> +               return false;

Ok, good, get rid of the trivial cases first.

> +       rcu_read_lock();
> +       xas_for_each(&xas, page, max) {
> +               if (xas_retry(&xas, page))
> +                       continue;
> +               if (xa_is_value(page))
> +                       continue;
> +               if (PageDirty(page) || PageLocked(page) || PageWriteback(page))
> +                       break;
> +       }
> +       rcu_read_unlock();

Whee. This looks very very expensive indeed.

Why is is going to each page, why does it care about locked when the
simple early cases did not?

Why isn't this just using xas_for_each_marked(), or maybe even just a
single "xa_find()", since all it cares about is "is _any_ page.."

Maybe I'm missing something, but this really does look potentially
horrendously slow.

Jens/Willy?

                Linus

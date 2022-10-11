Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3F0C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 22:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJKWBJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 18:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJKWBI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 18:01:08 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0205814D24
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 15:01:05 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id g15-20020a4a894f000000b0047f8e899623so11003798ooi.5
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 15:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MLQ5H7VESPaoiRxKUhIPt15sPGVXkePVqvxi8nROcR0=;
        b=fJgT1fNJ1aTxX12kjM1cAQEVjPj1Z/0sqrF8ePDLrQC1i5KTJeRhzvI35WjgpWw2B5
         opEblo3/z61LnB0BaDA9P0Ne5irPXIaqnse07KrqhvExJrCKNJ+21uSW3qy55iQYqc6v
         q+uZmglxGfJw5SPfSGWM/NUXdTY+z/3jdUkJM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MLQ5H7VESPaoiRxKUhIPt15sPGVXkePVqvxi8nROcR0=;
        b=SS6L010sE4azNI6riRYvvCwZX2g/Kn+LyDt8kGcnHIddscekZlPZxdEtHh1nEW6JiW
         pVaLzXN2DGnm7fzPQQnwfaQIJr4zLAMc4DcKVu0Rn7EqW6PdgsBUmGd5I0Uy9wVD6bTS
         x4UaGjg+wRXF506GUZmUQBQKw7ydmVuRdOG3AwHXYOPejwWz/74+59OQExSLkkjbD4mt
         tVuq7BB17Vr/OTJHDHJy1nvzFUYQcZv3JTc6KtUjzIJCnjpNzLi3O3V9aOzEvwzzmZH/
         08yXXRMRFJYOmHOUY78W7YvHIIfYpc+/9CBKLfR5XKiUojPZw+lFh6ifGrC7ynu5agY5
         gpeg==
X-Gm-Message-State: ACrzQf2A1ibo5dQH9X/X/vVn1JvdgeFpr+k94MLw1sW6OHswAESrThJ1
        2koX8BgZfG6liDN76wjHolKd6539GTLI9g==
X-Google-Smtp-Source: AMsMyM6N6rr33eNhmxcwS9CbKZh2nVelMd0VjMgpajxl98gLvFuAxNge+N0Q5g/891PgrB6D0DyhYA==
X-Received: by 2002:a05:6830:b85:b0:655:d942:251c with SMTP id a5-20020a0568300b8500b00655d942251cmr11445886otv.195.1665525663412;
        Tue, 11 Oct 2022 15:01:03 -0700 (PDT)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com. [209.85.167.181])
        by smtp.gmail.com with ESMTPSA id q8-20020a4ad548000000b00475d676d2d4sm315483oos.16.2022.10.11.15.01.01
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 15:01:01 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id n130so1115581oia.6
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 15:01:01 -0700 (PDT)
X-Received: by 2002:aca:b957:0:b0:351:4ecf:477d with SMTP id
 j84-20020acab957000000b003514ecf477dmr627093oif.126.1665525661470; Tue, 11
 Oct 2022 15:01:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
 <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com>
 <Y0UoO2+NsJjbZtaf@hirez.programming.kicks-ass.net> <20221011184444.npthr2pmzqb32x6z@treble>
 <20221011185907.s3kakdlrxcqr6boh@treble> <20221011190548.blixlqj6dripitaf@treble>
In-Reply-To: <20221011190548.blixlqj6dripitaf@treble>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Oct 2022 15:00:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=whR5j7e0_w_9Ph9ctEnrYKn6tcPjQRHY=u5B+jxDwHvXQ@mail.gmail.com>
Message-ID: <CAHk-=whR5j7e0_w_9Ph9ctEnrYKn6tcPjQRHY=u5B+jxDwHvXQ@mail.gmail.com>
Subject: Re: [PATCH] kasan: disable stackleak plugin in report code
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Oct 11, 2022 at 12:05 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> kasan_report() has a uaccess critical section which can't have any
> instrumentation calls in the middle.  Disable the stackleak plugin for
> the report code.

I see Andrew already picked this up, but I can confirm that it
obviously fixes the problem here for me.

I'll get it the usual channels from Andrew.

Thanks,
            Linus

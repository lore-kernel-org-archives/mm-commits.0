Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB008C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E18D61A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCXWZ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbhCXWZy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Mar 2021 18:25:54 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D83CC06174A
        for <mm-commits@vger.kernel.org>; Wed, 24 Mar 2021 15:25:54 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id k8so23200317iop.12
        for <mm-commits@vger.kernel.org>; Wed, 24 Mar 2021 15:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3jeI/nhVmDYnyIX9MJaMP1KFxrzwxcr23eZIQpyrb6U=;
        b=yZ7/6n5WuFnWVIAr2YRkJy9OLDu8NSoJq8uCsCzvBjG0YqsbreelRkQkcQKf61CGvi
         HD3XNTlJpSpnCh6GQJIoLzjhVI5P0VKCjLaJw4xjglu0nVW656lEnF0QCEbO/p/RTdwu
         c1Kisg3+23Wck6bzRAwEclJDTJlSkgXbYc7gwy5gIKx9P+8LXoIAuoZaPDQGUu9OfFOR
         WKynh50ojeWKx7RxLEtdSsd1oU/sKI4akicf6/WA19wM1tfemE8kdOAbJLSPmksSJPJy
         nHB1aAM/ejcAo18F52UEIqL0MeewEjfMqfYSCQDHNYfhl/clnUjMy6Tu44Z4wBQtNJB3
         eqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3jeI/nhVmDYnyIX9MJaMP1KFxrzwxcr23eZIQpyrb6U=;
        b=eEbJQ9CLVFelckDZSMzH677qxGfbQo73Q9v0qWv8rrp52A/YfkIRipmOblixKnL6UW
         i1HJLdFFJMNuX381VFfldlK/CDvJpRo+jXXkcCZ5Gd70cIMiLm1qtChaih2wEA/iv7ra
         ew9WN8GMKC2bXZzuknTMyQFYIfxTY1M8EDyTbdvKNaoMfpUl9QZwz2YETK6b7cQUO8Dg
         SgmSF2qMZWAs/VAc2of3sR41cFWVSAmEBzLJpYbFA03KhFnxu1qI4PurXK4ft2U1ymwu
         PfGDJJJpE1NrNmyXuJ0vNpKZcaHMDalEwPStWCzbVlkeZiMeLc89h6tfHVXYe1VbjxMo
         pugA==
X-Gm-Message-State: AOAM530tsE1+QP7skuqM1Ko8JloD4u+/sFiGYvXahTjtAPfQ7dAy4QXT
        NR0FIJcg6k3JypEehOf6QwRsMw==
X-Google-Smtp-Source: ABdhPJwPtYyj2lMqRvOcw0tTNQecvW6rEoVEaBBuFuWEq9IGmauCCQMZ7NFkxD1EyKT2QZYYLf5F1g==
X-Received: by 2002:a6b:4109:: with SMTP id n9mr4014711ioa.43.1616624754070;
        Wed, 24 Mar 2021 15:25:54 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x20sm1721277ilc.88.2021.03.24.15.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 15:25:53 -0700 (PDT)
Subject: Re: + mm-provide-filemap_range_needs_writeback-helper.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jan Kara <jack@suse.cz>, mm-commits@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
References: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
 <9c04eafc-475d-31fc-e2cc-ea99aafd8972@kernel.dk>
 <20210324150218.bd9f1ebc4af58703ce001f77@linux-foundation.org>
 <a0d094d9-cf6b-8e27-d7f2-a6f86977bfa1@kernel.dk>
 <20210324151902.171d2a295bebc4e511c7e679@linux-foundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d90b8446-22dc-2821-a733-1911c7b0d47f@kernel.dk>
Date:   Wed, 24 Mar 2021 16:25:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210324151902.171d2a295bebc4e511c7e679@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 3/24/21 4:19 PM, Andrew Morton wrote:
> On Wed, 24 Mar 2021 16:13:48 -0600 Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 3/24/21 4:02 PM, Andrew Morton wrote:
>>> On Wed, 24 Mar 2021 13:48:08 -0600 Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On Tue, Mar 2, 2021 at 4:43 PM <akpm@linux-foundation.org> wrote:
>>>>>
>>>>>
>>>>> The patch titled
>>>>>      Subject: mm: provide filemap_range_needs_writeback() helper
>>>>> has been added to the -mm tree.  Its filename is
>>>>>      mm-provide-filemap_range_needs_writeback-helper.patch
>>>>
>>>> Are you still planning on flushing this out for 5.12??
>>>
>>> Oh.  No, I wasn't planning on that.  I saw nothing which made me think
>>> it was that urgent.
>>
>> Ehm ok, I think that was the plan though when we originally talked about
>> this series. At least that was what was in my original emails on this
>> topic :-)
>>
>>> What is the justification?  How much performance benefit are we talking
>>> here?
>>
>> Well it's pretty huge, since if we return "nope can't do this
>> non-blocking" it'll mean that io_uring has to bump the operation to an
>> async threads. So CPU cost goes way up, and latencies does too.
>>
>> Problem is, we're now at -rc4, and it was my understanding that we'd get
>> this in for 5.12, but obviously way sooner than this. But I kind of lost
>> track when it went into your tree, until I started thinking about it
>> earlier today. While it's not the end of the world to wait for 5.13,
>> though the current situation does suck a lot for certain workloads.
> 
> I'd be OK with sending it to Linus now, but we really should put some
> numbers behind "suck a lot" to justify it.  And a -stable backport
> might be justified if the benefit is large enough, and if "certain
> workloads" are common enough.
> 
> But with what have here, I and everyone else who considers these
> patches is going in blind!

The backstory is that an internal workload complained because it was
using too much CPU, and when I took a look, we had a lot of io_uring
workers going to town. For an async buffered read like workload, I am
normally expecting _zero_ offloads to a worker thread, but this one
had tons of them. I'd drop caches and things would look good again,
but then a minute later we'd regress back to using workers. Turns out
that every minute something was reading parts of the device, which
would add page cache for that inode. I put patches like these in for
our kernel, and the problem was solved.

Obviously that's not a great story since there are no hard numbers
there, and I'd have to generate those for you! Which I surely can.
While the original premise of the patches was fixing excessive CPU
usage, the general observation is that outside of just using a lot more
CPU, it'll also cause worse latencies as offload to a thread always adds
latency.

So let me know if you want me to generate some numbers. They will be
artificial, but at least it'll be something outside of a story.


-- 
Jens Axboe


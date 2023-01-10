Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BC2C63797
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 14:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbjAJO3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 09:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238642AbjAJO26 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 09:28:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4939A3AF
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 06:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673360889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZgOUw+Heih/nt8LD90i4ytf2X0K6elurC66Cg7Df3E=;
        b=jFFrKAh4sLTR69M8GDHtevxs6VoEGCN1yaSnyMLS7kpv7UdA+RBdbmXOshQd30IffNfhYm
        OnRAYxG+g3iLZcA1zDBsuYMK9qxsjo2huSxj40UYiMyUQpAZ0GO1wMPjhzf8RvrlGisbQ6
        aSARn65R2pDDRJ+fDUZCQ2ginh7THmo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-2-yyGQ5zMAWHoQx3XJ9SrQ-1; Tue, 10 Jan 2023 09:28:08 -0500
X-MC-Unique: 2-yyGQ5zMAWHoQx3XJ9SrQ-1
Received: by mail-wm1-f70.google.com with SMTP id n9-20020a05600c3b8900b003d9f14e904eso3113583wms.9
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 06:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZgOUw+Heih/nt8LD90i4ytf2X0K6elurC66Cg7Df3E=;
        b=lyxUOeewNdHahCJ/71GLP/PZ50BSD/J5YmPWLq8o9AtnFmVE0vsnsn+705sJcEPchU
         Y4MhPoSB3WVLvK//aKmaf+2zstMvJ+W0L/uciina7cXkTLW0dHMkDYKqRYpd0AhUyIGI
         dbeUY12xIGbeR8G5VkOOzDPMhDfarlu9K3Og8Y0FJOhr9Fnfy0HqGEi4/s1YluOMXSFu
         I4uDaC3X4oRVhPTa5k/3ry6ATZxFEmQvJfeLy0kBrH28uiSRQ5cRO0ysfUd/iDLpiUEz
         VNu1leqjTd0Qts0L5KIF/A6U+5AO3470RS1JEALJEpSVfyAlrENYlr2XFeq7TcVW3IDG
         RaEg==
X-Gm-Message-State: AFqh2kobPZX8hhhg044UthKFAtzDXXTeBfmIvfC3XisbfNmxmwjLgCyp
        oNZFocyT7+Jc8I7K26qtfZMBf4J2J+RGN8DYY7qV84YKmGx0zG6JPI8V7FCzHfO1sodsZT+K4wm
        W+Gf7hkSf3qcTwtzTYZGkjg==
X-Received: by 2002:adf:cd02:0:b0:2bd:bbf6:6adf with SMTP id w2-20020adfcd02000000b002bdbbf66adfmr1328628wrm.20.1673360887163;
        Tue, 10 Jan 2023 06:28:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv4tETBCFavZXzxdASzpKxqH6gUgftf1kvbG13JyzPYl7cq3KPjqmpTj6nF071ybuPkF01TcQ==
X-Received: by 2002:adf:cd02:0:b0:2bd:bbf6:6adf with SMTP id w2-20020adfcd02000000b002bdbbf66adfmr1328616wrm.20.1673360886875;
        Tue, 10 Jan 2023 06:28:06 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:4200:65d9:4d0d:bb61:14c8? (p200300cbc708420065d94d0dbb6114c8.dip0.t-ipconnect.de. [2003:cb:c708:4200:65d9:4d0d:bb61:14c8])
        by smtp.gmail.com with ESMTPSA id t14-20020adfeb8e000000b002baa780f0fasm11212749wrn.111.2023.01.10.06.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 06:28:06 -0800 (PST)
Message-ID: <286bd85a-6dfe-1390-8734-6b11594fc7de@redhat.com>
Date:   Tue, 10 Jan 2023 15:28:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: +
 selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shuah@kernel.org
References: <20230109233601.C4082C433EF@smtp.kernel.org>
 <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
 <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
 <edb402df-c0df-00d7-3bf4-884c5ba47ca9@alu.unizg.hr>
 <738e358a-5ef0-0981-ba02-8a25367b9bc9@redhat.com>
 <ac38396d-51df-fff0-5b4c-3defea67dbe3@alu.unizg.hr>
 <01dd090b-451f-f926-a6f3-1739f0ef688b@redhat.com>
 <01aa2810-68c9-c17e-850e-c0a141e462f5@alu.unizg.hr>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <01aa2810-68c9-c17e-850e-c0a141e462f5@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.01.23 15:24, Mirsad Todorovac wrote:
> On 1/10/23 15:04, David Hildenbrand wrote:
>>>
>>> Of course, we can easily test with "gcc -E" what exactly gets included.
>>>
>>> We don't seem to have a uniform way of handling MADV_PAGEOUT and
>>> MADV_POPULATE(READ|WRITE) even within different C sources within
>>> tools/testing/selftests/vm itself, so it means that we spread the spectrum
>>> of systems and compilations that we will break. :-/
>>>
>>> To repeat what is obvious, I am not an authority on the Linux kernel,
>>> but as I said, I have the benefit of a fresh perspective ...
>>>
>>> There was an open source proverb that "more eyes see more" :)
>>
>> The thing is: I don't lose sleeps about defines that will never change as long as it compiles. That's the most important part (for
>> me) with these tests. Even if it would change, and I don't see how, we'd get test failures and could fix it up.
>>
>> ... and I raised that I ran into issues with what you propose. That's really all I am saying :)
>>
>> And to repeat what I said: If we can find a cleanup for all these relevant "ifndef" in selftests/mm I'd be very happy. As long as it
>> compiles I'm all for cleanups. It would also be acceptable to say "what David tested was wrong" -- but that needs clear justification.
> 
> Then I rest my case.
> 
> Just to assert:
> 
> Probably if MADV_PAGEOUT or MADV_POPULATE_(READ|WRITE) isn't defined in in-tree
> includes, then also the kernel wouldn't support them.
> 
> #include <sys/mman.h>
> #include <linux/mman.h>
> 
> #ifdef MADV_PAGEOUT
>           if (swapout) {
>                   madvise(mem, pagesize, MADV_PAGEOUT);
>                   if (!pagemap_is_swapped(pagemap_fd, mem)) {
>                           ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
>                           goto munmap;
>                   }
>           }
> #endif /* MADV_PAGEOUT */
> 
> ... the above seems like the silver bullet that would catch all cases.

That wouldn't have allowed me to run the tests properly in the crazy 
sparc64 environment, where the kernel is new but the headers are old :)

> 
> I tend to sometimes OCD on detail and lose the big picture. That's why "the war is
> made by multitude of counselors".
> 
> I am not territorial about any of my patches, so what the community thinks its the
> best ... This is not my day job, but a pet project, and I like the way it makes my
> brain tick. :-)
> 

Again, I'd be very happy if we could just get the in-kernel headers 
considered properly. But I gave up on that and decided for the "easy" fixes.

-- 
Thanks,

David / dhildenb


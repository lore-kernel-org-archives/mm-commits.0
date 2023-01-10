Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB1CC54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 15:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjAJPoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238799AbjAJPnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 10:43:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58E1CE7
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 07:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673365390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psxkurlNWgJHqOKHfV/bHPSxw1IFjXV8L4wQ0X0YdWU=;
        b=AZLOVtfwjb7TTaoG834dP3LB7PN3zCwLgOZZ2DOKI2pQXVxnPS7mInibPzWcv8ZVyLehTg
        OfGEXivxCM47MfDebNhgDio9NzmXsPuSC54snU7kZXv5nT6JJsoge64Rq+cDCPZerqQlgC
        SgL19P38aLHbqMKHYDJ6e4oZZk0Wjdc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-435-cSmInbsPPBWB6FYtmUDWkA-1; Tue, 10 Jan 2023 10:43:09 -0500
X-MC-Unique: cSmInbsPPBWB6FYtmUDWkA-1
Received: by mail-wr1-f69.google.com with SMTP id o14-20020adfa10e000000b002631c56fe26so2077381wro.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 07:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psxkurlNWgJHqOKHfV/bHPSxw1IFjXV8L4wQ0X0YdWU=;
        b=4yM3DsfvluoboOXzBbq+wG3xuxewofVJeLQtErDuZXS++kZHynHpygDUCP8exJtLF5
         Ns/cVfRFiaVTBoMYrbskUTRzxKG2eEi7Hj59ue/8x8bZUMpR+UXWNzCBmQeh4naIUN9y
         0E7pgOnsYRlWLC4FZ0QtFV+Gr0EGWt+kyZ/otFsC4MEFFbS2noNu8HKY5ZWi20NxJZBQ
         zmLtnP6ofvcVefoPFAFEsdIQoL54F80ZHJ/thzEVnnyWf9eLpQec4LufJwD7nSSB5xxc
         jOCCL5XQZe7HufmILSnAVLhsUWcgpZ9rZpvQGZo7dUbMtH2/TN0FF5kZ5PNsH4QgGepk
         HKkg==
X-Gm-Message-State: AFqh2koOj9w85fwTU25EJia0YrsHUldf89EK468jg1VntrQgCixqG0co
        7iViZoZRH0epAqQBFqbKMIG9vC35coUq7FXEIB0eKnAZNwF/+4Z6Oy9D5MIDkMifQSqKLBI5Fzo
        d33+qYrGYBBUU4cicV2Sw9w==
X-Received: by 2002:a05:600c:1f11:b0:3d0:57ea:319c with SMTP id bd17-20020a05600c1f1100b003d057ea319cmr49566433wmb.13.1673365388338;
        Tue, 10 Jan 2023 07:43:08 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu7pZqSLszhxOuI0hCQSl5UsdvtiYvPha/erOlXj730nJjKnPaz0oIWvJeiphOJSGZY3pxg7w==
X-Received: by 2002:a05:600c:1f11:b0:3d0:57ea:319c with SMTP id bd17-20020a05600c1f1100b003d057ea319cmr49566419wmb.13.1673365387981;
        Tue, 10 Jan 2023 07:43:07 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:4200:65d9:4d0d:bb61:14c8? (p200300cbc708420065d94d0dbb6114c8.dip0.t-ipconnect.de. [2003:cb:c708:4200:65d9:4d0d:bb61:14c8])
        by smtp.gmail.com with ESMTPSA id l1-20020adfe9c1000000b00289bdda07b7sm11249599wrn.92.2023.01.10.07.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 07:43:07 -0800 (PST)
Message-ID: <cfead557-970f-90a8-1184-f4125645bad4@redhat.com>
Date:   Tue, 10 Jan 2023 16:43:06 +0100
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
 <286bd85a-6dfe-1390-8734-6b11594fc7de@redhat.com>
 <edcd1c84-9cee-a507-21df-039f3379fa4a@alu.unizg.hr>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <edcd1c84-9cee-a507-21df-039f3379fa4a@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.01.23 16:06, Mirsad Todorovac wrote:
> On 1/10/23 15:28, David Hildenbrand wrote:
>> On 10.01.23 15:24, Mirsad Todorovac wrote:
>>> On 1/10/23 15:04, David Hildenbrand wrote:
>>>>>
>>>>> Of course, we can easily test with "gcc -E" what exactly gets included.
>>>>>
>>>>> We don't seem to have a uniform way of handling MADV_PAGEOUT and
>>>>> MADV_POPULATE(READ|WRITE) even within different C sources within
>>>>> tools/testing/selftests/vm itself, so it means that we spread the spectrum
>>>>> of systems and compilations that we will break. :-/
>>>>>
>>>>> To repeat what is obvious, I am not an authority on the Linux kernel,
>>>>> but as I said, I have the benefit of a fresh perspective ...
>>>>>
>>>>> There was an open source proverb that "more eyes see more" :)
>>>>
>>>> The thing is: I don't lose sleeps about defines that will never change as long as it compiles. That's the most important part (for
>>>> me) with these tests. Even if it would change, and I don't see how, we'd get test failures and could fix it up.
>>>>
>>>> ... and I raised that I ran into issues with what you propose. That's really all I am saying :)
>>>>
>>>> And to repeat what I said: If we can find a cleanup for all these relevant "ifndef" in selftests/mm I'd be very happy. As long as it
>>>> compiles I'm all for cleanups. It would also be acceptable to say "what David tested was wrong" -- but that needs clear
>>>> justification.
>>>
>>> Then I rest my case.
>>>
>>> Just to assert:
>>>
>>> Probably if MADV_PAGEOUT or MADV_POPULATE_(READ|WRITE) isn't defined in in-tree
>>> includes, then also the kernel wouldn't support them.
>>>
>>> #include <sys/mman.h>
>>> #include <linux/mman.h>
>>>
>>> #ifdef MADV_PAGEOUT
>>>            if (swapout) {
>>>                    madvise(mem, pagesize, MADV_PAGEOUT);
>>>                    if (!pagemap_is_swapped(pagemap_fd, mem)) {
>>>                            ksft_test_result_skip("MADV_PAGEOUT did not work, is swap enabled?\n");
>>>                            goto munmap;
>>>                    }
>>>            }
>>> #endif /* MADV_PAGEOUT */
>>>
>>> ... the above seems like the silver bullet that would catch all cases.
>>
>> That wouldn't have allowed me to run the tests properly in the crazy sparc64 environment, where the kernel is new but the headers
>> are old :)
> 
> Didn't see that one coming :-/
> 
> I don't have a sparc64 box available for testing. Or at all.

Me neither, I was using a qemu-system-sparc64 to test some of my 
adventurous changes like :

https://lkml.kernel.org/r/20221212130213.136267-1-david@redhat.com

and

https://lkml.kernel.org/r/20221206144730.163732-1-david@redhat.com

> 
>>> I tend to sometimes OCD on detail and lose the big picture. That's why "the war is
>>> made by multitude of counselors".
>>>
>>> I am not territorial about any of my patches, so what the community thinks its the
>>> best ... This is not my day job, but a pet project, and I like the way it makes my
>>> brain tick. :-)
>>>
>>
>> Again, I'd be very happy if we could just get the in-kernel headers considered properly. But I gave up on that and decided for the
>> "easy" fixes.
> 
> Actually, I admire your work on THP and I won't use more of your time in vain.
> 

I appreciate your review :)

> Just to remind you of the advice Yitro gave to Moses: "Don't judge 2,000,000 people by
> yourself - delegate some less important work!" :-)

so ... you're going to make it work with the in-tree kernel headers? :P

-- 
Thanks,

David / dhildenb


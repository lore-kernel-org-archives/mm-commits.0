Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32814C43462
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 15:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2779619C3
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 15:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhELPKz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 11:10:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233344AbhELPIh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 11:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620832048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n82irjIhe0eF7j91gjE3MGjiXR1yJN3bFoEkSd04KR4=;
        b=Rnchenv87cZP0cB2CqXxx5WCQ4rPMn7xV6QzeLxtWj8T2S6NMvN7IAtx3UujFhJpfV45ZP
        HOckOWX2YHWPej7Ap0uVwIbcj7hQMSZ5ix9ObPBrzG9xbNwOlk+91A9XmBA4hoHCTOevNL
        vP0jlbFX/hNwAWO5rk3OmKNaZtfEYd0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-b9xXw6_EPuu4ewKw8yyCBA-1; Wed, 12 May 2021 11:07:25 -0400
X-MC-Unique: b9xXw6_EPuu4ewKw8yyCBA-1
Received: by mail-wm1-f72.google.com with SMTP id l185-20020a1c25c20000b029014b0624775eso680250wml.6
        for <mm-commits@vger.kernel.org>; Wed, 12 May 2021 08:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=n82irjIhe0eF7j91gjE3MGjiXR1yJN3bFoEkSd04KR4=;
        b=jmmrpRII7hGu0bcrlX9wGBygaXGq3NGEH/W/bBVa8qCFaXE36nYj76JuZk2xYpo05/
         eypMxL3/2+WbGYhsSHOCkj7elfrhQFgGwfkx+v8Lmeo2HOvNXkgFfL2HVfuYPDcHInch
         VXNO/7p6d4tlQywDe4YJcNM1GEuN9XP2doR3lCXwnTMnBEQRrGNHwb0QCvL/yN+koUWO
         ZSJRIIqAdO8iELEMSHXwPmPgoMs7H17bQ97b6cxu8MeQAW1zNG5abdRCoRRTxcYD889b
         6XRxad25z2hmG2L+76qpinuDS2/Etld7o0hcG1MGm8yDZL1kXdQZrK78tNXCo0kJHpCq
         A4pA==
X-Gm-Message-State: AOAM532BA4YVJZYwc7cxVaupFwDMFXcwfHNFdY0LlOeGAdn6OejJyzqr
        8zq25jn87P4FTu5pRt4kfMvVgKcFEZXbddKEW+bs0tWYH5cxUGNbM4QBRMArnMVWLjZKtruXj8o
        bCYiL6ntw5bK5/TpRa+B9UQ==
X-Received: by 2002:a5d:5109:: with SMTP id s9mr9698186wrt.231.1620832044257;
        Wed, 12 May 2021 08:07:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2PLH0xzVUydBEr2/P4vHtfcE2tTQpXMKD1PLnuaHaRml6a+zgDXSWu17dUqyh+Wp8oiNE3Q==
X-Received: by 2002:a5d:5109:: with SMTP id s9mr9698110wrt.231.1620832043796;
        Wed, 12 May 2021 08:07:23 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c65ab.dip0.t-ipconnect.de. [91.12.101.171])
        by smtp.gmail.com with ESMTPSA id x10sm3864681wro.66.2021.05.12.08.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 08:07:23 -0700 (PDT)
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
To:     Baoquan He <bhe@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>, Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, frederic@kernel.org, gpiccoli@canonical.com,
        john.p.donnelly@oracle.com, jpoimboe@redhat.com,
        keescook@chromium.org, linux-mm@kvack.org, masahiroy@kernel.org,
        mchehab+huawei@kernel.org, mike.kravetz@oracle.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        saeed.mirzamohammadi@oracle.com, samitolvanen@google.com,
        sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu, Michal Hocko <mhocko@kernel.org>,
        kasong@redhat.com
References: <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
 <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
 <20210511133641.GE2834@localhost.localdomain> <YJqxWy63cokQZ4jQ@kernel.org>
 <c990270c-30a0-0913-df5a-2c73eb66a436@redhat.com>
 <20210512145150.GG2834@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <3897d7a7-1120-4445-c297-e1cb7ac99f43@redhat.com>
Date:   Wed, 12 May 2021 17:07:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512145150.GG2834@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 12.05.21 16:51, Baoquan He wrote:
> On 05/11/21 at 07:07pm, David Hildenbrand wrote:
>>>> If the way adding default value into kernel config is disliked,
>>>> this a) option looks good. We can get value with x% of system RAM, but
>>>> clamp it with CRASH_KERNEL_MIN/MAX. The CRASH_KERNEL_MIN/MAX may need be
>>>> defined with a default value for different ARCHes. It's very close to
>>>> our current implementation, and handling 'auto' in kernel.
>>>>
>>>> And kernel config provided so that people can tune the MIN/MAX value,
>>>> but no need to post patch to do the tuning each time if have to?
>>> Maybe I'm missing something, but the whole point is to avoid kernel
>>> configuration option at all. If the crashkernel=auto works good for 99% of
>>> the cases, there is no need to provide build time configuration along with
>>> it. There are plenty of ways users can control crashkernel reservations
>>> with the existing 2-4 (depending on architecture) command line options.
>>>
>>> Simply hard coding a reasonable defaults (e.g.
>>> "1G-64G:128M,64G-1T:256M,1T-:512M"), and using these defaults when
>>> crashkernel=auto is set would cover the same 99% of users you referred to.
>>
>> Right, and we can easily allocate a bit more as a safety net temporarily
>> when we can actually shrink the area later.
>>
>>>
>>> If we can resize the reservation later during boot this will also address
>>> David's concern about the wasted memory.
>>>
>>
>> Yes.
>>
>>> You mentioned that amount of memory that is required for crash kernel
>>> reservation depends on the devices present on the system. Is is possible to
>>> detect how much memory is required at late stages of boot?
>>
>> Here is my thinking:
>>
>> There seems to be some kind of formula we can roughly use to come up with
>> the final crashkernel size. Baoquan for sure knows all the dirty details, I
>> assume it's roughly "core kernel + drivers + user space".
>>
>> In the kernel, we can only come up with "core kernel + drivers" expecting
>> that we will run
>>
>> a) roughly the same kernel
>> b) with roughly the same drivers
> 
> As replied to Mike, kernel size is undecided for different kernel with
> different configs. We can define a default minimal size to cover kernel
> and driver on systems with not many devices, but hardcoding the size

I never talked about hardcoding, did I?

> into upstream is not helpful. If the size is big, users will be asked to
> check and shrink always. If the size is too small, a new value need be
> got and added to cmdline and reboot.


-- 
Thanks,

David / dhildenb


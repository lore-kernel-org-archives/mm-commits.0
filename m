Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBBAC43460
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 17:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05FA8613C5
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 17:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhEKRId (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 13:08:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231769AbhEKRIc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 13:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620752845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9EbRT7m80ia45DWilFnPXJ2jbo6G+WKu1DAYy3qgx7c=;
        b=FzyFCN4uA2L9yATTx38Hoz7b+qOtPJaJlCgxeGz5EOdNysrMSojYFZiRZeBm8Q9f1MMimk
        KiKYdLkqOZghNnZ/oy5gRUhKM2k/LaTJO4/5nT59Bi95AmHCc2i2gwR7D+05u668HuxvRh
        sS2dTPSwmZUxlF9DDmM0B2a/5H9V0po=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-1MGbyKjHP1qY2GyWAO_m-w-1; Tue, 11 May 2021 13:07:24 -0400
X-MC-Unique: 1MGbyKjHP1qY2GyWAO_m-w-1
Received: by mail-wm1-f69.google.com with SMTP id z9-20020a1c65090000b029014b497b2d98so2528964wmb.8
        for <mm-commits@vger.kernel.org>; Tue, 11 May 2021 10:07:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9EbRT7m80ia45DWilFnPXJ2jbo6G+WKu1DAYy3qgx7c=;
        b=eVYYNtYaptWQGrS40QPzOiTx9TB0uOadwpX00j8p2QPWx8F8JIJ+LeLVawwK3mD+33
         cq7/oSAG6n0lF6g4s8vjAVVy1EDxUNo8ceSh7STqR2au1ygRMgHVWgLupx0EKn7n9zhF
         DQrhfWcHRGdQHnJxUG96S2AVX1ji6daD4CBvQ4Hjb+7ETHFWsfJRopzfZ974mz5mrtqk
         McE7GT2cFfBET123zkYtRYgl+KALyaMo+eobkgxQEZojuoM5DDE05ZRD0CN0gjQhb32R
         GO6XriQ2Zef/Fm77PVTXFF5VfS1lxDpS7bpvVHMJQTi4FBuC84jDHqhX33FP+vCpIlho
         kRvw==
X-Gm-Message-State: AOAM532BthAPTtg81xLkiLfq4610866VTPwA6klFHMraP1gS2TG3H6vb
        P2YWczHPBPPoYjh3yAu2MIKpm/+wxX5egFls70W6yfQTbTrRw/XKf4SeWzNQu6HWUKO/quwB7uH
        YJ2D5SY6fc6uh34c4eezTEA==
X-Received: by 2002:a5d:64eb:: with SMTP id g11mr40054309wri.260.1620752842095;
        Tue, 11 May 2021 10:07:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvLJLtAPwugWbhm7GJO/QnAAcrCFtXbccBplHV6OpS/TrRD7fjbJjpSzy2gRAvKbm9mKAFqg==
X-Received: by 2002:a5d:64eb:: with SMTP id g11mr40054275wri.260.1620752841830;
        Tue, 11 May 2021 10:07:21 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6329.dip0.t-ipconnect.de. [91.12.99.41])
        by smtp.gmail.com with ESMTPSA id d15sm27843323wrw.71.2021.05.11.10.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 10:07:21 -0700 (PDT)
To:     Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>
Cc:     Dave Young <dyoung@redhat.com>,
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
References: <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
 <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
 <20210511133641.GE2834@localhost.localdomain> <YJqxWy63cokQZ4jQ@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <c990270c-30a0-0913-df5a-2c73eb66a436@redhat.com>
Date:   Tue, 11 May 2021 19:07:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJqxWy63cokQZ4jQ@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

>> If the way adding default value into kernel config is disliked,
>> this a) option looks good. We can get value with x% of system RAM, but
>> clamp it with CRASH_KERNEL_MIN/MAX. The CRASH_KERNEL_MIN/MAX may need be
>> defined with a default value for different ARCHes. It's very close to
>> our current implementation, and handling 'auto' in kernel.
>>
>> And kernel config provided so that people can tune the MIN/MAX value,
>> but no need to post patch to do the tuning each time if have to?
>   
> Maybe I'm missing something, but the whole point is to avoid kernel
> configuration option at all. If the crashkernel=auto works good for 99% of
> the cases, there is no need to provide build time configuration along with
> it. There are plenty of ways users can control crashkernel reservations
> with the existing 2-4 (depending on architecture) command line options.
> 
> Simply hard coding a reasonable defaults (e.g.
> "1G-64G:128M,64G-1T:256M,1T-:512M"), and using these defaults when
> crashkernel=auto is set would cover the same 99% of users you referred to.

Right, and we can easily allocate a bit more as a safety net temporarily 
when we can actually shrink the area later.

> 
> If we can resize the reservation later during boot this will also address
> David's concern about the wasted memory.
> 

Yes.

> You mentioned that amount of memory that is required for crash kernel
> reservation depends on the devices present on the system. Is is possible to
> detect how much memory is required at late stages of boot?

Here is my thinking:

There seems to be some kind of formula we can roughly use to come up 
with the final crashkernel size. Baoquan for sure knows all the dirty 
details, I assume it's roughly "core kernel + drivers + user space".

In the kernel, we can only come up with "core kernel + drivers" 
expecting that we will run

a) roughly the same kernel
b) with roughly the same drivers

The "user space" part is completely under user space control, depending 
on what application will be run after kexec.

So I wonder if something like

crashkernel=auto,100M

whereby "100M" corresponds to user space demands in addition to the 
variable part depend on the current kernel + drivers.

would already be somewhat sufficient for main use cases I guess.

Of course, that approach will get more complicated if the user space 
portion heavily depends on the drivers etc. Then we need more tunables.

-- 
Thanks,

David / dhildenb


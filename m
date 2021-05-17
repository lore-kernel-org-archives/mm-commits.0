Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75599C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 08:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54A5B6121F
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 08:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhEQIYJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 May 2021 04:24:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhEQIYI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 17 May 2021 04:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621239772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dr+J0Dxpisr6jrG1Ah8gcgPpGfwRCikgsb5tMsnVjcI=;
        b=MgR0jy3NChSbDMzZhD091U5EPY5Q/6PaXGyp4NYGJCcYt6IppnED4N55mCP5moM1gfBrHh
        mLC4Zsr+cPUPVXkgU0mk5KgRH7qnbNg25Ix8pGlZ0007bGXB66JhUfHb/pkSl0MDyKO9co
        3VMUxPBeaqJLb+lXI1mNnwpH8DU4lk8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-xrFrX-27Pkac6FArf3cbgA-1; Mon, 17 May 2021 04:22:50 -0400
X-MC-Unique: xrFrX-27Pkac6FArf3cbgA-1
Received: by mail-wm1-f70.google.com with SMTP id 12-20020a1c010c0000b0290176491efde9so504680wmb.4
        for <mm-commits@vger.kernel.org>; Mon, 17 May 2021 01:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dr+J0Dxpisr6jrG1Ah8gcgPpGfwRCikgsb5tMsnVjcI=;
        b=JW58iIxQsgYNY7FBc+HwdyIij6wE23N368mvMogkEKxCWWZg2FAkx7s1EiGWrCDsGA
         sSDCUjUYgXU2nNEjrAonKbgIeomah8aLWu4QeahXnTzzaaoaenkM8sc3RwAlyVMpcMBp
         ZXaYGoQWo7usS0BNoH0M/3Nnn9RXmWfDAWmDhGcPtg3JrDPCZZATqC4bqMm/WXBh+ylQ
         AiJqnhQOdFn/lvRMVBWmbR/sG892FW0bzRli2//GvLdNwM8HMdfHjtQQR5zlsiyU+oZe
         oKqYOnCTQDbXjZgrtySEWrwPFaugfyZpq/by22adMPEGLw+WRJXrbskoE/1SQr9TuCA7
         TT/w==
X-Gm-Message-State: AOAM530BRm8RggR0h9jJht5oRdtF+HXyS90lHcgIBeFmOxx7qN0kUVTl
        fl8K2afGpH13FUY86meAgk/8Id5M35K27WnTHTXiUmCzTdLk63y/tvBIWtYMJuXs/z1bDvorJG3
        Pz+tDNAJZmEQqZ8yoNfL8kg==
X-Received: by 2002:adf:f10c:: with SMTP id r12mr5993773wro.26.1621239769059;
        Mon, 17 May 2021 01:22:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZxi28kWl7YCjnitNIN7mJcuwRpwxRMDF3SKncZqYsivaeGfX0tohQDSOKYKB11G5PqKO12Q==
X-Received: by 2002:adf:f10c:: with SMTP id r12mr5993735wro.26.1621239768799;
        Mon, 17 May 2021 01:22:48 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6833.dip0.t-ipconnect.de. [91.12.104.51])
        by smtp.gmail.com with ESMTPSA id b12sm16787985wro.28.2021.05.17.01.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 01:22:48 -0700 (PDT)
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
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <0ef02343-390b-9815-1666-24de4911c0b7@redhat.com>
Date:   Mon, 17 May 2021 10:22:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512145150.GG2834@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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
> into upstream is not helpful. If the size is big, users will be asked to
> check and shrink always. If the size is too small, a new value need be
> got and added to cmdline and reboot.
> 

Hi Baoquan, Kairui, Dave,

so IIUC now, our "old" kernel cannot actually tell us any reliable 
"crashkernel area size" because

a) it has no idea with which cmdline parameters the crashkernel will be
    started with, and these can have a big impact.
b) it has no idea which driver will be loaded in the crashkernel.
c) It has no idea what will be running in the crashkernel user space.


AFAIKS, best we can do without further information is, therefore, use 
some heuristic to a) allocate some memory early during boot in the 
kernel and b) later refine our allocation, triggered by user space (-> 
shrink the crashkernel area).

I dislike calling a) "auto". It provides a default based on some 
heuristic (boot memory size), and that default might be very unfortunate 
in some scenarios (-> waste memory).

While we could discuss calling the current approach ( a) 
)"crashkernel=default", whereby the default is encoded at compile time 
as determined by a distributor, I still still quite don't like it 
because it feels like this is not necessary. We have a way to pass 
something like that via the cmdline, so it's just a matter of properly 
using that feature from user space.


AFAIKS, all you want is most probably a more dynamic way to construct a 
kernel cmdline, with some properties specific to a kernel.

Let's assume the following:

a) When a distributor ships a kernel, he also ships some kind of 
defaults file. Let's assume for simplicity

/lib/modules/5.11.19-200.fc33.x86_64/defaults.conf

The file might contain

CRASHKERNEL_DEFAULT=WHATEVER


b) When generating the cmdline for e.g., 
/boot/loader/entries/XXX-5.11.19-200.fc33.x86_64.conf we run some script 
that consult that file in addition to /etc/default/grub. For example, if 
the kdump service was installed and /etc/default/grub does not contain 
"crashkernel=" (except when we encounter "crashkernel=auto" for compat 
handling), we add "crashkernel=WHATEVER". Of course, we might do more 
involved stuff based on the current setup, user config, etc.


c) When we install the kdump service, all we have to do is re-generate 
the boot entries AFAIKS. Just like we would when adding 
"crashkernel=auto" right now.


The end result would also allow for having per-kernel defaults and 
change them on kernel updates. Would require some thought on how to make 
it fly in user space, how to "ship" the defaults etc.

-- 
Thanks,

David / dhildenb


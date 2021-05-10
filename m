Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4D3C4708A
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 11:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED3861026
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 11:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhEJLVv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 07:21:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234131AbhEJLCV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 07:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620644476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w7cGyd0ydkGYOI9NO4YUbRdiftLG90cTynQXzUsFrrc=;
        b=Hzx3YzWE2l5QUxTPWJPny/cT6ZDff7Z0gbgp6voMjBMXzZAN0YeaHTFChrwGtDEA2CzFRO
        yQa9q0XPzrX425NHzG+LsQ8QzkU6dg9ohvfSdLkbFDbzmHdiAB6x0cwNyqZy1gBRYyJFpP
        RHs2RtxoNlhD5jwdEcqfHXxSHICbe+M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-jtSuSZgLM8ytELuI45ZBLg-1; Mon, 10 May 2021 07:01:14 -0400
X-MC-Unique: jtSuSZgLM8ytELuI45ZBLg-1
Received: by mail-wm1-f72.google.com with SMTP id s66-20020a1ca9450000b0290149fce15f03so6842671wme.9
        for <mm-commits@vger.kernel.org>; Mon, 10 May 2021 04:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=w7cGyd0ydkGYOI9NO4YUbRdiftLG90cTynQXzUsFrrc=;
        b=HpbRwd6A6maFiCZLQ4/1npUHKCu/E4qAcNvtK+wf3KJVO88wj8HIBFmsI1J3u/XLrb
         H6dcMsXVpfjelP6yT9dogeDvJ3qbol2bEsemRTmuGzAnHHqGfmObDpPPP4jvbH4wB+wC
         zERiS0YNu9JTsB3Ikve1fiPWG2rukDLDFRHsAGYNwX6eUN4shZH6HtzUlH31fIHKdCD0
         3y+RsLT0M4q+ojespHJQ/dM/7C8VC74w/Ti0p5/xMVnN6B4Zt9eyKdyis5Msi4GIrrYk
         bdjLDtC7YxEE8l8YW6ujtxdh+v5f0jMLOBLX8cqId2Tj7FH0PqiLAHALQY3RlnyvyrLe
         IgIg==
X-Gm-Message-State: AOAM53370TcFdVGqE71DbqCfOjcxLTeFYoyu+3fEQoaMPO/r/iYXQcNx
        itVl7JE1IKxtvClQfHsppTcQ1ER503DLcq7LecIodyB4VsfZUHcpvXfrPJ3riPTZYcc3ucDzrwD
        kFAemQ8rj1HXNeHb/3QzmNw==
X-Received: by 2002:a5d:524f:: with SMTP id k15mr29763761wrc.412.1620644470505;
        Mon, 10 May 2021 04:01:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrecxsXYNUfJFvVustsnaL5jztCalPy4k4RkykElhHdG0tCg9zx7Umh+KpnO61hu5+yM0SdA==
X-Received: by 2002:a5d:524f:: with SMTP id k15mr29763697wrc.412.1620644470000;
        Mon, 10 May 2021 04:01:10 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c676a.dip0.t-ipconnect.de. [91.12.103.106])
        by smtp.gmail.com with ESMTPSA id n6sm22726262wro.23.2021.05.10.04.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 04:01:09 -0700 (PDT)
To:     Baoquan He <bhe@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, andreyknvl@google.com,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, dyoung@redhat.com, frederic@kernel.org,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        jpoimboe@redhat.com, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mike.kravetz@oracle.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu, Michal Hocko <mhocko@kernel.org>
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
Date:   Mon, 10 May 2021 13:01:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510104359.GC2946@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


>> I can understand the reasoning of "using a fraction of the memory size" when
>> booting up just to be on the safe side as we don't know", and that
>> motivation is much better than what I read so far. But then I wonder if we
>> cannot handle that any better? Because this feels very suboptimal to me and
>> I feel like there can be cases where the heuristic is just wrong.
> 
> Yes, I understand what you said. Our headache is mainly from bare metal
> system worrying the reservation is not enough becuase of many devices.
> 
> On VM, it is truly different. With much less devices, it does waste some
> memory. Usually a fixed minimal size can cover 99.9% of system unless
> too many devices attached/added to VM, I am not sure what's the
> probability it could happen. While, by the help of /sys/kernel/kexec_crash_size,
> you can shrink it to an small enough but available size. Just you may
> need to reload kdump kernel because the loaded kernel should have been
> erazed and out of control. The shrinking should be done at early stage of
> kernel running, I would say, lest crash may happen during that period.
> 
> We ever tried several different ways to enlarge the crashkernel size
> dynamically, but didn't think of a good way.

Yes, enlarging it at runtime much more difficult than shrinking.

[...]

>> A kernel early during boot can only guess. A kernel late during boot knows.
>> Please correct me if I'm wrong.
> 
> Well, I would not say it's guess, and would like to call them experical
> values from statistical data. With a priori vlaue given by 'auto',
> basically normal users of kdump don't need to care about the setting.
> E.g on Fedora, 'auto' can cover all systems, assume nobody would deploy
> it on a high end server. Everything we do is to make thing simple enough.
> If you don't know how to set, just add 'crashkernel=auto' to cmdline,
> then everything is done. I believe you agree that not everybody would
> like to dig into kexec/kdump just for getting how big crashkernel size
> need be set when they want to use kdump functionality.

Oh absolutely. But OTOH, most users will leave the value untouched if it 
works -- and complain at least in the VM environment to me about 
surpises waste of system RAM with "crashkernel=auto".

[...]

>> I know how helpful "crashkernel=auto" was so far, but I am also aware that
>> there was strong pushback in the past, and I remember for the reasons I
>> gave. IMHO we should refine that approach instead of trying to push the same
>> thing upstream every couple of years.
>>
>> I ran into the "512MB crashkernel" on a 64G VM with memory ballooning issue
>> already but didn't report a BZ, because so far, I was under the impression
>> that more memory means more crashkernel. But you explained to me that I was
>> just running into a (for my use case) bad heuristic.
> 
> I re-read the old posts, didn't see strong push-back. People just gave
> some different ideas instead. When we were silent, we tried different
> way, e.g the enlarging crashkernel at run time as told at above, but
> failed. Reusing free pages and user space pages of 1st kernel in kdump
> kernel, also failed. We also talked with people to consult if it's

Thanks for an insight into the history.

> doable to remove 'auto' support, nobody would like to give an affirmative
> answer. I know SUSE is using the way you mentioned to get a recommended
> size for long time, but it needs severeal more steps and need reboot. We
> prefer to take that way too as an improvement. The simpler, the better.

At least I'm happy to hear that other people had the same idea as me ;)

I can understand the desire for simplicity. it would be great to hear 
SUSEs perception of the problem and how they would ideally want to move 
forward with this.

[...]

>> I'll be happy to help looking into dynamic shrinking of the crashkernel size
>> if that approach makes sense. We could even let user space trigger that
>> resizing -- without a reboot.
> 
> Don't reply each inline comment since I believe they have been covered
> by the earlier reply. Thanks for looking to this and telling your
> thought, to let us know that in fact you really care about the extra
> memory on VMs which we have realized, but didn't realized it really cause
> issue.

I mess with dynamic resizing of VMs, that's why I usually take a closer 
look at all things that do stuff based on the initial VM size; yes, 
there is still a lot other such things out there.

It also bugged me for quite a bit that we don't have a sane way to 
achieve what we're doing here upstream. It somewhat feels like "this 
doesn't belong in the kernel and is user policy" but then, the existing 
kernel support is suboptimal.

Maybe reserving some "maybe too big but okayish to boot the system in a 
sane environment -- e.g., X% of system RAM and at least Y" size first 
and shrinking it later as triggered by user space early (where we do 
seem to have a way to pre-calculate things now) might actually be a good 
direction to look into.

-- 
Thanks,

David / dhildenb


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75BAC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 09:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BEE6128D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 09:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhEHJXa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 05:23:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhEHJX3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 May 2021 05:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620465748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMbRCZNa+Z/dbR5dpohB9L4zU+l12hVm7EkhqNpUKbo=;
        b=ONCVYZrWNMxzY+WUVPkxZ8YRjJAZPasK+VF96nOGFHQxRVQR1ClwiCDl36iRvhuN5XspK4
        KI39gm9E7sqTKfZGZrspqO9gPX+F0pq6b8XWLVe+8ldGlw1bIcsZsMmuwJd2gSY300jF1r
        qJUvsaephhAJ87MSwEJ/8W9xaxqQ0ms=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-bQ_hWDIHMLK2RHuW-1XbTw-1; Sat, 08 May 2021 05:22:22 -0400
X-MC-Unique: bQ_hWDIHMLK2RHuW-1XbTw-1
Received: by mail-wr1-f71.google.com with SMTP id v5-20020adf9e450000b029010e708f05b3so456619wre.6
        for <mm-commits@vger.kernel.org>; Sat, 08 May 2021 02:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qMbRCZNa+Z/dbR5dpohB9L4zU+l12hVm7EkhqNpUKbo=;
        b=gFR/xIr+t5t8SVTFeIjL1uolDIfyZyDoV4P7j7zTRKutPB9tDmX5CaPxv02OAx2eOm
         zBueA+k30NjK6J0WOMea6rI1xVscuS5YNE0etFW0g3A4cYLZrVCRTcGPbzW38YbSRW1j
         XfX1jnsnHuyfLCMbF9GFkhmrd9yxF7H8MrsgH937qaSaoTOEeoj44hp9aalw67umtgf4
         w/k4p+FoHZCVRkV0xcgHqLm1wjchgG361v5FOeLys4MsixzRZ7fbDF5y4zPjMI/GT4yW
         MXQwcy91eUqRcqDln8CZiO2jOj+K5XXgR6hLAzBKZy5En03JqzWxv1cRcxjOR9FIbUwb
         wIGQ==
X-Gm-Message-State: AOAM5321YjzyWRf2su9i9jf40EjUXy8hWLKtCXbVFE2rzmR7sFx2FIYU
        dJhn4AheiOiHPng+EUSgtNijeQQ4WguYALO7yVfKQB1rQ3kPNxzuE02BodMoH8DLX2/l0dszE0y
        UbcrnrpuyKBMeuu6xiSjGJQ==
X-Received: by 2002:a5d:4d52:: with SMTP id a18mr18167259wru.45.1620465741023;
        Sat, 08 May 2021 02:22:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMxatA9BKPUWc8GIPc6HWhf7+XknNHfMTIwxF3Bxpxi3T4Tk57QjPf9MeC+9QDis6+u+KYkQ==
X-Received: by 2002:a5d:4d52:: with SMTP id a18mr18167226wru.45.1620465740703;
        Sat, 08 May 2021 02:22:20 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c60de.dip0.t-ipconnect.de. [91.12.96.222])
        by smtp.gmail.com with ESMTPSA id n124sm17455782wmn.40.2021.05.08.02.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 02:22:20 -0700 (PDT)
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
        yifeifz2@illinois.edu
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
Date:   Sat, 8 May 2021 11:22:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210508085133.GA2946@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

>> Let me take a look .... oh, there it is from 2009
>>
>> https://marc.info/?t=125006512600002&r=1&w=2
>>
>> and then we had it in 2018
>>
>> https://lkml.org/lkml/2018/5/20/262
> 
> Thanks for digging these two out, otherwise I may need do for people to
> know the history better.

Sure, I stumbled over this myself recently when wondering about what 
fadump is.


>> The issue I have with this: it's just plain wrong when you take memory
>> hotplug into serious account as we see it quite heavily in VMs. You don't
>> know what you'll need when building a kernel. Just pass it via the cmdline
> 
> Hmm, kdump may have no issue with memory hotplug in crashkernel
> reservation aspect. The system RAM size is not correlated to
> crashkernel size directly, that's why the default value in this patch is

"Not correlated directly" ...

"1G-64G:128M,64G-1T:256M,1T-:512M"

Am I still asleep and dreaming? :)


> not linear related to system RAM size. The proportion of crashkernel
> size to the total RAM size is thing we take into account. Usually
> crashkernel 160M is enough on most of systems. If system RAM size is
> larger, extra memory can be added just in case, and not bring much
> impact to system.

So, all the rules we have are essentially broken because they rely 
completely on the system RAM during boot.

> 
> With our investigation, PCIe devices impact the crashkernel size, and
> cpu number. There are always pci devices which driver require tens of KB
> meomry, even MB. E.g in below patch, my colleague Coiby found out the
> i40e network card even cost 1.5G memory to initialize its ringbuffer on
> ppc, and 85M on x86_64.
> 
> [PATCH v1 0/3] Reducing memory usage of i40e for kdump
> http://lists.infradead.org/pipermail/kexec/2021-March/022117.html
> 
> Even though not all pci devices need surprisingly large memory like
> i40e, system with hundreds of pci devices can also cost more memory than
> expected. This kind of system usually is high end server, specified
> crashkernel value need be set manually.
> 
> So system RAM size is the least important part to influence crashkernel

Aehm, not with fadump, no?

> costing. Say my x1 laptop, even though I extended the RAM to 100TB, 160M
> crashkernel is still enough. Just we would like to get a tiny extra part
> to add to crashkernel if the total RAM is very large, that's the rule
> for crashkernel=auto. As for VMs, given their very few devices, virtio
> disk, NAT nic, etc, no matter how much memory is deployed and hot
> added/removed, crashkernel size won't be influenced very much. My
> personal understanding about it.

That's an interesting observation. But you're telling me that we end up 
wasting memory for the crashkernel because "crashkernel=auto" which is 
supposed to do something magical good automatically does something very 
suboptimal? Oh my ... this is broken.

Long story short: crashkernel=auto is pure ugliness.


Why can't we construct a crashkernel in user space when 
installing/activating kdump and requiring a reboot for kdump to be 
active as long as that crashkernel setting is not properly respected?

Just have a look at the system properties (is_qemu(), #PCI, ...) and 
propose a value for "crashkernel=". Check that that value is at least 
active when activating kdump. Otherwise don't enable kdump and fail.

Yes, it can be difficult with some newer/older kernels having some 
different demands, but things should change drastically, and a distro 
can always update its advises along with the kernel, no?

You could even have a kernel interface that gives you the current 
crashkernel size (maybe already there) vs. the recommended crashkernel 
size. Make kdump or *whoever* activate that in the cmdline and let kdump 
check if both values are satisfied when booting up.

Also: this approach here doesn't make any sense when you want to do 
something dependent on other cmdline parameters. Take "fadump=on" vs 
"fadump=off" as an example. You just cannot handle it properly as 
proposed in this patch. To me the approach in this patch makes least 
sense TBH.

-- 
Thanks,

David / dhildenb


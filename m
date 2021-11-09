Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FA0C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 06:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E8A4611C4
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 06:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbhKIGnO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:43:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240679AbhKIGnM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2021 01:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636440026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lMewzJa6v7wv4Nf0ITz1xf4YASeaxZhdGf3FfutlQg0=;
        b=SQ2u3v0T+J48TSwxcVeXZ6QmbdDuJDJZzR0SkpWjaxTagUh27zvLM4v0e4cdeXuVKXieTK
        5QbNiKzWisJ2MdfXn96ehwpj8wWXiUh54/rwIMtg4ca4MeBdeu+Tu0uefQqfSPzVBWb5AZ
        WAJqosZMGObUTSVdNJ9ybAOtygPak7U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-eBopfDqBNUSX6x4PxlmbZQ-1; Tue, 09 Nov 2021 01:40:25 -0500
X-MC-Unique: eBopfDqBNUSX6x4PxlmbZQ-1
Received: by mail-wm1-f71.google.com with SMTP id z137-20020a1c7e8f000000b0030cd1800d86so7241823wmc.2
        for <mm-commits@vger.kernel.org>; Mon, 08 Nov 2021 22:40:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=lMewzJa6v7wv4Nf0ITz1xf4YASeaxZhdGf3FfutlQg0=;
        b=qYCFB3LnI/DcmQSmnKGsdNq/SLbYzLiJUK/bfoPpJJRb7IAfmf3MivPvRzjM3l2n3L
         fHDeUypJ0VXEXAgx4jhubwZ0ALFGfe5LL48S6W7V9A8vc0LS9qsarS6+y7G1TiuSJmEn
         ZZsNHTjnnyatP90N33+MKEsxbk+A8M/JqaCT2/ZF20Pgo4IHx2fu9gpT8Hs28MRQtRPF
         xATnFmovtjpEbioST8FouQHglHLpKTs0UURDm0C8iKcEmcLPrJ2FHngBy14xlwGD8VGI
         NxLasWrwfXKa3FfZRWh/dX2xn1Sy+2Pm/Gprg1aHNjgEjnfJRCzO9iSHVm+ulAhE0Kqy
         kZ9w==
X-Gm-Message-State: AOAM530ICgxAQOESZ/wi+chZp9B8BO9nuqJ55qffMRzxWrWrqT+dG5F0
        sk1GU7MuTzxZxrM8NZ0EyajVVv/CzRnD/1Xs+SK9NnEyjxxH5KGdqqGMNzHZLzlZGPQx25tNJSI
        jv8t2dwSAz2sZq5Sh2IklFg==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr4818732wme.188.1636440024435;
        Mon, 08 Nov 2021 22:40:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsEX2/Nwtg13zHzfWa1LeKJsNsbgxl1yry1CHytm+1UPD6zmBNqiPeqK90Z0hor57hPb+n0A==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr4818703wme.188.1636440024194;
        Mon, 08 Nov 2021 22:40:24 -0800 (PST)
Received: from [192.168.3.132] (p4ff23c2b.dip0.t-ipconnect.de. [79.242.60.43])
        by smtp.gmail.com with ESMTPSA id l124sm1542245wml.8.2021.11.08.22.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 22:40:23 -0800 (PST)
Message-ID: <1d2642e6-8251-2b82-7afe-842d60ec099d@redhat.com>
Date:   Tue, 9 Nov 2021 07:40:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     bhe@redhat.com, boris.ostrovsky@oracle.com, bp@alien8.de,
        hpa@zytor.com, jasowang@redhat.com, jgross@suse.com,
        linux-mm@kvack.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
References: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
 <20211109023148.b1OlyuiXG%akpm@linux-foundation.org>
 <YYnyOQ2BkxNAUon1@dhcp-128-65.nay.redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 08/87] proc/vmcore: convert oldmem_pfn_is_ram callback to
 more generic vmcore callbacks
In-Reply-To: <YYnyOQ2BkxNAUon1@dhcp-128-65.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 09.11.21 04:59, Dave Young wrote:
> Hi Andrew,
> On 11/08/21 at 06:31pm, Andrew Morton wrote:
>> From: David Hildenbrand <david@redhat.com>
>> Subject: proc/vmcore: convert oldmem_pfn_is_ram callback to more generic vmcore callbacks
>>
>> Let's support multiple registered callbacks, making sure that registering
>> vmcore callbacks cannot fail.  Make the callback return a bool instead of
>> an int, handling how to deal with errors internally.  Drop unused
>> HAVE_OLDMEM_PFN_IS_RAM.
>>
>> We soon want to make use of this infrastructure from other drivers:
>> virtio-mem, registering one callback for each virtio-mem device, to
>> prevent reading unplugged virtio-mem memory.
>>
>> Handle it via a generic vmcore_cb structure, prepared for future
>> extensions: for example, once we support virtio-mem on s390x where the
>> vmcore is completely constructed in the second kernel, we want to detect
>> and add plugged virtio-mem memory ranges to the vmcore in order for them
>> to get dumped properly.
>>
>> Handle corner cases that are unexpected and shouldn't happen in sane
>> setups: registering a callback after the vmcore has already been opened
>> (warn only) and unregistering a callback after the vmcore has already been
>> opened (warn and essentially read only zeroes from that point on).
> 
> This is a nice improvement, thanks David.  But I did not get time to
> review it yet.  The overall idea is good, I would prefer to hold on the
> patches for some time and waiting for more review.
> 
> Sorry for jumping in late.

I really want this in v5.16. Please see the comment in

https://lkml.kernel.org/r/20211006122709.27885-1-david@redhat.com

Can we just fix any fallout (if any) as usual after the merge window?

-- 
Thanks,

David / dhildenb


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF10C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 11:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 236D561055
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 11:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhKJLY1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:24:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhKJLY1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 06:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636543299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3cfEC9aiivP2bx7O5xROQIw7YWNfjoAbKFhm+axhP4=;
        b=dC3l8tSssRi3tqCTvQGAYEQlKAU9qUtH4xjaHB1KrvRbtwphCw3atXHBOcIlz81EWFJkpr
        agVdmZ501s3ilDEXrjfMW2DEBI1FaYb6rsWWDSDoZfLrDKUozLTKuNNLIu6n9d88HqbqPp
        uOR5j88/MPu1HDuNDyf1bp4oX/8ryBY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-2xOgisoSNA2-wDz270QKjQ-1; Wed, 10 Nov 2021 06:21:38 -0500
X-MC-Unique: 2xOgisoSNA2-wDz270QKjQ-1
Received: by mail-wm1-f72.google.com with SMTP id g80-20020a1c2053000000b003331a764709so2953074wmg.2
        for <mm-commits@vger.kernel.org>; Wed, 10 Nov 2021 03:21:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=/3cfEC9aiivP2bx7O5xROQIw7YWNfjoAbKFhm+axhP4=;
        b=2WI7O8Cx/z5vZdOXJ+jtjnmaudJAHBnex04u59k4njFCQFU5gTdkauiyjjkpKPxqPK
         ystQdVzL0OwWEpKNzLGYcRLmiR7OiMTjQzZIJYEGisKXUNt8qR27/7avd3s64FuMGdje
         osvW9FnPkTktGEq11tfn4Y9ptw5cVdk+tlE957aaP2Wjx8TZeXoKuk6XzQy6c+0+ipyY
         LZx58gFsQd9EkIWxkeL84jgVAWXtd6qVo4ZBb4ulvY6s6QUFdt5DFuMymjpgsUG2umMd
         NV36uOKtz8h+a5KiLGdCuTr6syVcaR7EcXzwHXkhaN8PX2wqMb6yk1HBpuaugSVgznRe
         hwsQ==
X-Gm-Message-State: AOAM532cFhX9GDBp/iVZP5ah4T3PKVSpxmUEXyHx4ezm0pmyRXV+2VMm
        Q2DwItsUTvZBfbGM2642UJ6o0qeYUUYIY4khn35FlyY7tzwK1ehU5n+tdhdONysKzBznVxIDhlZ
        Frw7CbXsZKrZ97076hk/8ig==
X-Received: by 2002:adf:ce8b:: with SMTP id r11mr18892060wrn.294.1636543297178;
        Wed, 10 Nov 2021 03:21:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzICESowAidUawEb3N55qUG2NJVnuv8Dn3U4BY1k74xFI+2SU+f/eT2ffnmDJWOIOi0xf8+yg==
X-Received: by 2002:adf:ce8b:: with SMTP id r11mr18892018wrn.294.1636543296977;
        Wed, 10 Nov 2021 03:21:36 -0800 (PST)
Received: from [192.168.3.132] (p5b0c604f.dip0.t-ipconnect.de. [91.12.96.79])
        by smtp.gmail.com with ESMTPSA id z12sm22060569wrv.78.2021.11.10.03.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 03:21:36 -0800 (PST)
Message-ID: <1cbc6332-8a45-3af1-c648-99437819bb5a@redhat.com>
Date:   Wed, 10 Nov 2021 12:21:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Dave Young <dyoung@redhat.com>
Cc:     Baoquan He <bhe@redhat.com>, boris.ostrovsky@oracle.com,
        bp@alien8.de, Andrew Morton <akpm@linux-foundation.org>,
        hpa@zytor.com, jasowang@redhat.com, jgross@suse.com,
        linux-mm@kvack.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
References: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
 <20211109023148.b1OlyuiXG%akpm@linux-foundation.org>
 <20211110072225.GA18768@MiWiFi-R3L-srv>
 <0c68b366-38f4-94fd-da11-57e40a44cb48@redhat.com>
 <YYuoxJ2BHv8PZi78@dhcp-128-65.nay.redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 08/87] proc/vmcore: convert oldmem_pfn_is_ram callback to
 more generic vmcore callbacks
In-Reply-To: <YYuoxJ2BHv8PZi78@dhcp-128-65.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.11.21 12:11, Dave Young wrote:
> Hi David,
> On 11/10/21 at 09:10am, David Hildenbrand wrote:
>> On 10.11.21 08:22, Baoquan He wrote:
>>> On 11/08/21 at 06:31pm, Andrew Morton wrote:
>>>> From: David Hildenbrand <david@redhat.com>
>>>> Subject: proc/vmcore: convert oldmem_pfn_is_ram callback to more generic vmcore callbacks
>>>>
>>>> Let's support multiple registered callbacks, making sure that registering
>>>> vmcore callbacks cannot fail.  Make the callback return a bool instead of
>>>> an int, handling how to deal with errors internally.  Drop unused
>>>> HAVE_OLDMEM_PFN_IS_RAM.
>>>>
>>>> We soon want to make use of this infrastructure from other drivers:
>>>> virtio-mem, registering one callback for each virtio-mem device, to
>>>> prevent reading unplugged virtio-mem memory.
>>>>
>>>> Handle it via a generic vmcore_cb structure, prepared for future
>>>> extensions: for example, once we support virtio-mem on s390x where the
>>>> vmcore is completely constructed in the second kernel, we want to detect
>>>> and add plugged virtio-mem memory ranges to the vmcore in order for them
>>>> to get dumped properly.
>>>>
>>>> Handle corner cases that are unexpected and shouldn't happen in sane
>>>> setups: registering a callback after the vmcore has already been opened
>>>> (warn only) and unregistering a callback after the vmcore has already been
>>>> opened (warn and essentially read only zeroes from that point on).
>>>                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>
>>> I am fine with the whole patch except of one concern. As above sentence
>>> underscored states, if a callback is unregistered when vmcore has been
>>> opened, it will read out zeros from that point on. And it's done by
>>> judging global variable 'vmcore_cb_unstable' in pfn_is_ram(). This will
>>> cause vmcore dumping in makedumpfile only being able to read out zero
>>> page since then, and may cost long extra time to finish.
>>>
>>> Please see remap_oldmem_pfn_checked(). In makedumpfile, we default to
>>> mmap 4M memory region at one time, then copy out. With this patch, and if
>>> vmcore_cb_unstable is true, kernel will mmap page by page. The extra
>>> time could be huge, e.g on machine with TBs memory, and we only get a
>>> useless vmcore because of loss of core data with high probability.
>>
>> Thanks Baoquan for the quick review!
>>
>> This code is really just to handle the unlikely case of a driver getting
>> unbound from a device that has a callback registered (e.g., a
>> virtio-mem-pci device). Something like this will never happen in
>> practice in a *sane* environment.
>>
>> The only known way I know is if userspace manually unbinds the driver
>> from a virtio-mem-pci device -- which is possible but especially in a
>> kdump environment something without any sane use case. In that case, we'll
>>
>> pr_warn_once("Unexpected vmcore callback unregistration\n");
>>
>> to let user space know that something weird/unsupported is going on.
>>
>> Long story short: if user space does something nasty, I don't see a
>> problem in some action taking a little longer.
>>
>>
>>>
>>> I am thinking if we can simply panic in the case, since the left dumping
>>> are all zeroed, very likely the vmcore is unavailable any more.
>>
>> IMHO panic() is a little bit too much. Instead of returning zeroes, we
>> could fail the read/mmap operation -- I considered that as an option
>> when I crafted/tested this patch, however, this approach here turned out
>> to be the easiest way to handle something that's really not
>> supported/advised and won't really happen in a sane environment.
> 
> I would still say that the most important task for kdump is to save the
> vmcore successfully.  Even the above issue is not a common case it could
> cause the vmcore to be useless.  It is understandable if the zeroed part
> is only the virtio-mem part, but if all the remaining vmcore is zeroed
> that it is bad and not acceptable for kdump. 

Again, in a sane environment this will never happen.

Why are we discussing on how to optimize a scenario where user space
does something that's clearly unsupported and will not happen in real life?

My take is to warn and fail as simple as possible, without hacking
around the issue (like blocking driver unloading while user space has
/proc/vmcore opened.

"remaining vmcore is zeroed that it is bad and not acceptable for kdump."

Which scenario are you concerned about? User space plays stupid games
(unbining a driver from a virtio-mem device in a *kdump kernel* after
opening /proc/vmcore) and wins stupid prices (a warning and a vmcore
filled (partially) with zeroes). Why isn't a warning sufficient for
something like that?

I appreciate all the feedback (even if it comes in late :) ), but I'm
missing why we are trying to optimize something here.

I'm happy to send a patch that does whatever we decide to do, but I
really don't see the need for a change. Most probably I'm missing
something important?

(the patch landed mainline in the meantime)

-- 
Thanks,

David / dhildenb


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AE7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 12:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2D861247
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 12:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhKJMJR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 07:09:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231911AbhKJMIv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 07:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636545964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJti6YTXwzSdmRtUdfCdrEUOOwHBKjcMSceqtv5gbd4=;
        b=Cz5xL5yvGGV2+VHNei5CEPE7pbx37cOoLJRr4og1QoRBUHTHtZPgBqHUffw3HB7RG5uXQB
        lVFqS5SjSgDt0UufSASo/20NI6kV7K5ziX36FsxF5vKCO7LbdwialrFi3zgQwnJIbpuAil
        5LlgQ4L36y4VkCu6AnEYiLTq9L6ig/M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-CNOnvThGNWKauQiDLoyJag-1; Wed, 10 Nov 2021 07:06:02 -0500
X-MC-Unique: CNOnvThGNWKauQiDLoyJag-1
Received: by mail-wr1-f70.google.com with SMTP id r12-20020adfdc8c000000b0017d703c07c0so389726wrj.0
        for <mm-commits@vger.kernel.org>; Wed, 10 Nov 2021 04:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=GJti6YTXwzSdmRtUdfCdrEUOOwHBKjcMSceqtv5gbd4=;
        b=kUuVGZBlwdfTMFUNk/EvvypB8VNDsRdE83tDkhcwDGVKBJ+29xIA3NsTWsT6G90i4m
         4A/FrZ4PaRTZJJaHpuhCBJhAzk9NgWRr7MxljzX2B5WbdU9feBXoQEjcYYs/+AXU/1Wl
         bcM5sfnNJoOTA3dB2WV4bFAo+DQcyPfR0VKSB4RoVEleLg75/3/vd8taNl6IMiYzI64t
         JLPPtGrhEmF7Yi5K4VNY1g4HxULfM0Uk236ev/U/7KekT+FDzpgiYcceMtLl27SZkBDv
         sp1IcPOfOrLvd5UcfprjHYs/67kLfix61hzzcGHTRJtVp6m019GLziOXsBJTUwGGzuqW
         MRMQ==
X-Gm-Message-State: AOAM533nKeZz4DV7rnYnTfOSJnWg/qEV8JihmjCJEPEntAzFmpxCD4Rm
        HxpKpCXhWWjB82XtzG1QuJXeod3zlU6UFmBUab4bipsLLnffl19520pCWtyAmEFvPGkYPZwHVXV
        bvS6wmrBQMpny4jDwIDdnkQ==
X-Received: by 2002:adf:e78c:: with SMTP id n12mr19011319wrm.83.1636545961711;
        Wed, 10 Nov 2021 04:06:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEcRyg9FrnXNxxKvjSKAzxVbukmqesRvVHyR22T35GZHU30Y7sLqr+vCuZAKlzoj/WR8KtiA==
X-Received: by 2002:adf:e78c:: with SMTP id n12mr19011265wrm.83.1636545961442;
        Wed, 10 Nov 2021 04:06:01 -0800 (PST)
Received: from [192.168.3.132] (p5b0c604f.dip0.t-ipconnect.de. [91.12.96.79])
        by smtp.gmail.com with ESMTPSA id p12sm27279180wrr.10.2021.11.10.04.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 04:05:55 -0800 (PST)
Message-ID: <0c83cb5b-20e0-31cb-b3bf-82d3ca30e08b@redhat.com>
Date:   Wed, 10 Nov 2021 13:05:54 +0100
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
 <1cbc6332-8a45-3af1-c648-99437819bb5a@redhat.com>
 <YYus5ftQiJtYivRZ@dhcp-128-65.nay.redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 08/87] proc/vmcore: convert oldmem_pfn_is_ram callback to
 more generic vmcore callbacks
In-Reply-To: <YYus5ftQiJtYivRZ@dhcp-128-65.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

>> "remaining vmcore is zeroed that it is bad and not acceptable for kdump."
>>
>> Which scenario are you concerned about? User space plays stupid games
>> (unbining a driver from a virtio-mem device in a *kdump kernel* after
>> opening /proc/vmcore) and wins stupid prices (a warning and a vmcore
>> filled (partially) with zeroes). Why isn't a warning sufficient for
>> something like that?
> 
> Hi David,
> 
> Suppose we have the use case below:
> 

Hi Dave,

thanks for elaborating, it helps a lot to understand your concerns.

> A user plays with the game (Probably in hypervisor part, but the user is
> not aware that the guest panicked and in a kdump kernel), then we get a
> zeroed vmcore.   But the panic can not be easily reproduced any more,
> then the warning is not useful.

I can only speak about virtio-mem (well, that's the only current known
"dynamic vmcore_cb registration" user :) ).

virtio-mem devices cannot get hotunplugged in the hypervisor (i.e.,
QEMU)-- you can only hot(un)plug device memory, but not the device
itself, it will stick around. Hotunplugging the device is completely
blocked and not supported.

The reason is simple: unplugging a virtio-mem device will also remove
the device memory. It's similar to other memory devices, such as DIMMs
-- I would not recommend forced, physical removal of a DIMM to anybody
-- not while the OS is running and not while kdump is saving
/proc/vmcore. Which is also the reason why hypervisors don't generally
support forced removal of such devices. :)

So for the currently known vmcore_cb users, hypervisor action cannot
result in driver unbinding and consequently vmcore_cb changes.

Note: virtio-mem-pci devices might eventually get hotplugged while kdump
is active. I assume we don't disable PCI hotplug in kdump kernels. While
this will trigger a warning ("Unexpected vmcore callback registration"),
the vmcore will not be affected and be complete.

> 
> But if you think user is playing the game in kdump kernel, eg. in guest
> os while kdump is saving vmcore then it is nearly not possible to happen
> I agree with you it is a very trival problem.

Yes, that's the only thing I consider can happen. For example, doing a:

# echo 1 > /sys/devices/pci0000\:00/0000\:00\:03.0/remove

in a kdump kernel after opening the vmcore.

> 
> Probably we have some misunderstanding, but it would be good to make it
> clear :)

Understanding your concern, it could be future proof (for future
vmcore_cb users?) to fail the ioctls instead of returning 0. But even
for new memory devices, unplug is usually something to be fenced off by
the hypervisor, just like not allowing forced DIMM removal.

The only think I could imagine is having e.g., virtio-balloon device
register a vmcore_cb dynamically and providing a new mechanism to query
if a page is backed by a real page in the hypervisor (similar to XENs
hypercall). Such a device could be unplugged without harm, as it doesn't
actually provide device memory.

-- 
Thanks,

David / dhildenb


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DE7C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 08:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A40261052
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 08:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhKJINO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 03:13:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhKJINO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 03:13:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636531826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RYU0qEZT/fDbRdYvdmH1fDufqSqdn55jv1jkSYCFEeM=;
        b=DUYl2yEey5iSXmNrd3ALq25XcvCyR8++BYSX3Rd/VDYZISmADjOby2QESm1zFcGsRpKEaW
        uv0FmKKzt4lYwYERpLSW7NvxJe/ZF9wC1eP9X6UCREZsjHVpQphJ1ZJ8C3LuYwrKz6XBaY
        Yw+D79vD/UMwYJu4mBj+yoaxa08+dVo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-i9VOhQmZNEiy9HZacokb8A-1; Wed, 10 Nov 2021 03:10:25 -0500
X-MC-Unique: i9VOhQmZNEiy9HZacokb8A-1
Received: by mail-wm1-f72.google.com with SMTP id 128-20020a1c0486000000b0030dcd45476aso788767wme.0
        for <mm-commits@vger.kernel.org>; Wed, 10 Nov 2021 00:10:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=RYU0qEZT/fDbRdYvdmH1fDufqSqdn55jv1jkSYCFEeM=;
        b=xgsC7JO8jntK7bczxoYlN4ZZZGpmNrhElli0oh2Jv/E1Kp3+9F0+WfusJ10ehBbgO6
         i+P0fIhSP7nOuJ1FKBPSPDtD9pwesQQjBxiM1I7xXrKXgw/MaQDWZAQTfR8rvpCB0vl0
         zFf2sAfqFK4pddRbuyoIChTpjgEtoN2qrfPNwG0F/d9JD2+jDtmtpnt2W6l5eIrTU9zH
         Ppa+UU9QBnomIwkBXjX2bttYyH8Nad1oWS1ovfJBly32+7gepR3qcx3PIx4gqwapcUBu
         C77pObydwYAvj7kU+3h5Lu1ExI/ZXQVFJWiUH5hG7BZPvF/msGut7Ly/LhEwovSW6ztL
         CSjQ==
X-Gm-Message-State: AOAM532usFs79xFDmbYIPkPzZ8uqYRsPly/QBGF295NRY9PdJm6fbVCq
        Gz3vYpCabhze4x/OJ82fuyAnNnlEOqprnCMcomds7WzadHk0zEF3283gNzFbddp2LjUJwCS49Aj
        K0eXmePoIQl7bRc5uSMFzBw==
X-Received: by 2002:a5d:4411:: with SMTP id z17mr16957744wrq.59.1636531824086;
        Wed, 10 Nov 2021 00:10:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpGKiHsebg1C7WcrJxd78Q4PUsjBiNMRA5HfzoU8b0qvs/dNWNzwHAAHvscsds6ojRfHHgSw==
X-Received: by 2002:a5d:4411:: with SMTP id z17mr16957705wrq.59.1636531823797;
        Wed, 10 Nov 2021 00:10:23 -0800 (PST)
Received: from [192.168.3.132] (p5b0c604f.dip0.t-ipconnect.de. [91.12.96.79])
        by smtp.gmail.com with ESMTPSA id i15sm4778576wmb.20.2021.11.10.00.10.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 00:10:23 -0800 (PST)
Message-ID: <0c68b366-38f4-94fd-da11-57e40a44cb48@redhat.com>
Date:   Wed, 10 Nov 2021 09:10:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Baoquan He <bhe@redhat.com>
Cc:     boris.ostrovsky@oracle.com, bp@alien8.de,
        Andrew Morton <akpm@linux-foundation.org>, dyoung@redhat.com,
        hpa@zytor.com, jasowang@redhat.com, jgross@suse.com,
        linux-mm@kvack.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
References: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
 <20211109023148.b1OlyuiXG%akpm@linux-foundation.org>
 <20211110072225.GA18768@MiWiFi-R3L-srv>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 08/87] proc/vmcore: convert oldmem_pfn_is_ram callback to
 more generic vmcore callbacks
In-Reply-To: <20211110072225.GA18768@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.11.21 08:22, Baoquan He wrote:
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
>                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> I am fine with the whole patch except of one concern. As above sentence
> underscored states, if a callback is unregistered when vmcore has been
> opened, it will read out zeros from that point on. And it's done by
> judging global variable 'vmcore_cb_unstable' in pfn_is_ram(). This will
> cause vmcore dumping in makedumpfile only being able to read out zero
> page since then, and may cost long extra time to finish.
> 
> Please see remap_oldmem_pfn_checked(). In makedumpfile, we default to
> mmap 4M memory region at one time, then copy out. With this patch, and if
> vmcore_cb_unstable is true, kernel will mmap page by page. The extra
> time could be huge, e.g on machine with TBs memory, and we only get a
> useless vmcore because of loss of core data with high probability.

Thanks Baoquan for the quick review!

This code is really just to handle the unlikely case of a driver getting
unbound from a device that has a callback registered (e.g., a
virtio-mem-pci device). Something like this will never happen in
practice in a *sane* environment.

The only known way I know is if userspace manually unbinds the driver
from a virtio-mem-pci device -- which is possible but especially in a
kdump environment something without any sane use case. In that case, we'll

pr_warn_once("Unexpected vmcore callback unregistration\n");

to let user space know that something weird/unsupported is going on.

Long story short: if user space does something nasty, I don't see a
problem in some action taking a little longer.


> 
> I am thinking if we can simply panic in the case, since the left dumping
> are all zeroed, very likely the vmcore is unavailable any more.

IMHO panic() is a little bit too much. Instead of returning zeroes, we
could fail the read/mmap operation -- I considered that as an option
when I crafted/tested this patch, however, this approach here turned out
to be the easiest way to handle something that's really not
supported/advised and won't really happen in a sane environment.

-- 
Thanks,

David / dhildenb


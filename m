Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF67EE94101
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjJFTHg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjJFTHf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6617F2
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696619188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KC73a7WHNTluF0mnJqYMYK5CmV1mC6BQPNdKi5laAFU=;
        b=HdfTPVK48AlN+ig5wthc0LJOr6I9a5QPLs0AfB6SSkstW2PqlIVXvmnZV+lR6g+zEsmd+Y
        8N7rBSlsFuBOJGBhhNl1DFNVvO162T+e0VX1VPdbXa6hV+0dWqEd60t1VXy+4KBk3rIGcV
        lGspQNrXjD2lXQLavWHx2f7ITvWJiB8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-PcLNxNI6Py6qV7_pN-NUQQ-1; Fri, 06 Oct 2023 15:06:27 -0400
X-MC-Unique: PcLNxNI6Py6qV7_pN-NUQQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-327b5f2235aso1782015f8f.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Oct 2023 12:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696619186; x=1697223986;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KC73a7WHNTluF0mnJqYMYK5CmV1mC6BQPNdKi5laAFU=;
        b=WPZOCD+hIRC5keVe0s2Z18+ycCuyXs72nNPhYf/JT0PFV6/AIX/CQyknZCxFIWJtNa
         9raF/Gln5UFQmSPzwgD/zJ7DY4+pWHi2F5vxsyk9PLo1BHU5LA/Hd0TorOgm2tUgWf/X
         na9QlbnFbG4+RqJOSibfUdVbi/hq20QfoAT8yRi3+jfjvBhY+Fg1h5gKZTwA3AotLM/i
         GyhZT2b5TU9vVvJ53XtgIRvl4jFEzPoXhTNoVk2ROwH7rbYHpgSzQ5sgYJVN3XAcpHv4
         TUUAwuFlCWEjFAIBKzO7bxnRFUekdmi41/K1ktS1kSnIqhcEKnsHvqvQ1Q+qibq7lmpC
         bKmA==
X-Gm-Message-State: AOJu0YxBTWzZjcQ/n7RbrAubDszb45KFFybSmwaCYpGwY3l88+k2FVIG
        rnCl8m78ZtGet1cbGuSJ6cuHgVUyH8uHcl7Es44bHxBI7Ag3VPtIgITOGpFIvJlKHpHPOLZbkXm
        sJ8ZVeP3RcLi9FahZLDheQA==
X-Received: by 2002:adf:ec03:0:b0:319:7b66:7803 with SMTP id x3-20020adfec03000000b003197b667803mr7946965wrn.55.1696619186039;
        Fri, 06 Oct 2023 12:06:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1WRp/Q/i/CQTEy1aAZfzZjTldnHZlnKr6T6ZUf8HHq8BgkAOVJmujt6wokB0WeSWbuODreA==
X-Received: by 2002:adf:ec03:0:b0:319:7b66:7803 with SMTP id x3-20020adfec03000000b003197b667803mr7946939wrn.55.1696619185541;
        Fri, 06 Oct 2023 12:06:25 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:ee00:4e24:cf8e:3de0:8819? (p200300cbc715ee004e24cf8e3de08819.dip0.t-ipconnect.de. [2003:cb:c715:ee00:4e24:cf8e:3de0:8819])
        by smtp.gmail.com with ESMTPSA id c6-20020adfed86000000b003279518f51dsm2265351wro.2.2023.10.06.12.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Oct 2023 12:06:25 -0700 (PDT)
Message-ID: <c0729adb-414b-68e9-3f02-02f393ca985a@redhat.com>
Date:   Fri, 6 Oct 2023 21:06:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     Yu Zhao <yuzhao@google.com>, ryan.roberts@arm.com,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com
References: <20230929190832.CBFFBC433C7@smtp.kernel.org>
 <63426190-5865-970f-773f-cce33a8209d1@redhat.com>
 <CAOUHufabXCBdrybKUzYVvHQExocj=XiNT8mYDxejt18vhMYr_A@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: +
 mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch added to
 mm-unstable branch
In-Reply-To: <CAOUHufabXCBdrybKUzYVvHQExocj=XiNT8mYDxejt18vhMYr_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05.10.23 21:23, Yu Zhao wrote:
> On Thu, Oct 5, 2023 at 2:12 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 29.09.23 21:08, Andrew Morton wrote:
>>>
>>> The patch titled
>>>        Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>        mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
>>>
>>
>> Andrew, please don't move these patches to stable before we have a
>> couple of acks from people involved in the discussions.
>>
>> I'm confident that we'll get them into 6.8.
> 
> I am not :)

Well, there is still quite some time for 6.8, not so much for 6.7 :) 
Even if we end up with something minimal.

But I'm afraid (and previously expressed) a pure kconfig won't be 
sufficient, at least not for distributions.

I did not look into the details of the latest proposal, unfortunately, 
but I'll spoiler that exposing orders and bitmaps to users is not what I 
would immediately classify as a nice interface :)

Anyhow, let's not get distracted ...

> 
> As I repeated, the priorities seem wrong to me. There are many pending
> work items that don't involve any ABI changes, and IMO, we should
> focus on them before we even start discussing ABI changes.

I tend to agree: part of me being slower on feedback to the latest 
series is that I rather spent time trying to sort out some of the 
pending work items -- well, one, to be precise, which is challenging enough.

That's also one of the reason I don't see a need to rush this in: it 
would be in a state where no distribution could consider enabling it. So 
as a distribution guy, I don't see that much value in that ;)

One could certainly say that some of the pending items are not relevant 
for this to get merged and used to some degree. But again, from a 
distribution aspect, I think some of the pending items are a *requirement*.

> 
> I've been quiet  because I don't think opinion based discussions are
> essential to nailing down ABIs. As I suggested, I prefer a Kconfig

Please don't be quiet.

> option as the first step so that people can play with it. After we
> have collected field data, then we'd be better at coming up with
> suitable ABIs.

As I expressed, for me a magical toggle to enable/disable it (and if 
enabled, obey the existing THP rules) would be good enough for the first 
shot. It won't be sufficient for some workloads we discussed in the 
meetings, though.

So I see how Ryan tried to find something that is more configurable. 
Ideally, we'd probably have something that easily lets one enable a sane 
default (which we can tweak as we go), but still let people that want to 
configure it, just configure it. IMHO, nothing wrong with that. I might 
have some ideas, but again, lower priority for me at this point.

-- 
Cheers,

David / dhildenb


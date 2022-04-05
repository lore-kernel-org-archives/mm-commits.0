Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9BAC41535
	for <mm-commits@archiver.kernel.org>; Tue,  5 Apr 2022 12:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbiDEMVK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380500AbiDELmi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 07:42:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C12B10C535
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 04:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649156821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OWHWeMjAyv8V/f+MhcP3+MuBmAEWYAxIABD+m5vUXZc=;
        b=itrMNDS5lJrAUh8B+ZAGjmqDNHIVcq7G14pX07jbj6uVJGehdulzXEAmOQB+9LoWMSQCWq
        jgdAnQeqJpusUEiXnhJ6xQ77KqS17tgHZqUZm4A+nu1Bx+es/OkCLpvmCjefkNSkfi1dNo
        SKWkBMnG8VDytQBAu0K078CVbpiJC+M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-VdSw94hIMHuae3JN6Ec6BQ-1; Tue, 05 Apr 2022 07:07:00 -0400
X-MC-Unique: VdSw94hIMHuae3JN6Ec6BQ-1
Received: by mail-wr1-f72.google.com with SMTP id h33-20020adf9024000000b00203fcba8aadso2381423wrh.15
        for <mm-commits@vger.kernel.org>; Tue, 05 Apr 2022 04:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=OWHWeMjAyv8V/f+MhcP3+MuBmAEWYAxIABD+m5vUXZc=;
        b=jcIRAtRRPO9JKatAITFB5OCSQSKyNM1yUFOHTql90tzZXy9n8XhkhbFQxMc0ef5o/Q
         2wo/V1004drWL+eVyY48553hFRLRMtbnqc8TW7iPQMxVhMqRyWfBliXDyS4LBVu4sL22
         rIe2BXwWElDeKQ+Sp3epfOuU0tTfYWoKIoBDidZviZIPY2tdd101RWoSSqpw2xE/sz/S
         rpY/0Ub7iLwT0wgsnWCIJuiCi1W9INjNN24cg6xms4uoW9VNadWd0AtVy9F31ZYDxywJ
         2Er8qoTBGZ6yOQ4AZInWHqg7z+/4/r6qCo6Ua4gaSM4NmJe19ST5akSCf97h7rq0JC6k
         J+2g==
X-Gm-Message-State: AOAM530qa08LyPtSzI65nq/aSEk/745OhAW523Dpz8l1Pg6QGPwl5Y4u
        DNX7fg1HLMMTK+gkpq/wrHh5bvFS/0WrYIEig51RsbpDni4/ExNO9llgunnERTPQkhLr+fe7Vau
        MJow7CO+qXq55rGfQYzaXbQ==
X-Received: by 2002:a05:600c:20d3:b0:38e:7c77:58c1 with SMTP id y19-20020a05600c20d300b0038e7c7758c1mr2591312wmm.135.1649156819238;
        Tue, 05 Apr 2022 04:06:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUnsMbjq7Issxa9WQ3M0ZHN7GGmiE9XKL/Q8Wq+d3FzYhNfAI+O0hv7V6fC1zf2eRdP8jqEg==
X-Received: by 2002:a05:600c:20d3:b0:38e:7c77:58c1 with SMTP id y19-20020a05600c20d300b0038e7c7758c1mr2591285wmm.135.1649156818959;
        Tue, 05 Apr 2022 04:06:58 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:c900:f06e:62c8:b5ce:6d27? (p200300cbc707c900f06e62c8b5ce6d27.dip0.t-ipconnect.de. [2003:cb:c707:c900:f06e:62c8:b5ce:6d27])
        by smtp.gmail.com with ESMTPSA id n8-20020a7bcbc8000000b0038ca55f9bcasm1777084wmi.42.2022.04.05.04.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 04:06:58 -0700 (PDT)
Message-ID: <44c74067-7acc-906a-798a-5ca95f1d1e14@redhat.com>
Date:   Tue, 5 Apr 2022 13:06:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: +
 mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch added
 to -mm tree
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        rppt@kernel.org, rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, ziy@nvidia.com
References: <20220404215048.01A9AC2BBE4@smtp.kernel.org>
 <a4256d36-6f6d-82d7-38a3-1af6f9b2457d@redhat.com>
 <b5d3b61a-02bc-0b46-95dc-bd99ec3d759a@suse.cz>
 <604fd8fb-50df-dafe-14bd-640aa991d4cf@redhat.com>
Organization: Red Hat
In-Reply-To: <604fd8fb-50df-dafe-14bd-640aa991d4cf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05.04.22 12:52, David Hildenbrand wrote:
> On 05.04.22 12:42, Vlastimil Babka wrote:
>> On 4/5/22 12:29, David Hildenbrand wrote:
>>>> +
>>>> +/*
>>>> + * This function checks whether a page is free && is the buddy
>>>> + * we can coalesce a page and its buddy if
>>>> + * (a) the buddy is not in a hole (check before calling!) &&
>>>> + * (b) the buddy is in the buddy system &&
>>>> + * (c) a page and its buddy have the same order &&
>>>> + * (d) a page and its buddy are in the same zone.
>>>> + *
>>>> + * For recording whether a page is in the buddy system, we set PageBuddy.
>>>> + * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
>>>> + *
>>>> + * For recording page's order, we use page_private(page).
>>>> + */
>>>> +static inline bool page_is_buddy(struct page *page, struct page *buddy,
>>>> +							unsigned int order)
>>>
>>> Nit: Strange indentation of the last parameter. But it's already in the
>>> code you're moving, so ...
>>>
>>>> +{
>>>> +	if (!page_is_guard(buddy) && !PageBuddy(buddy))
>>>> +		return false;
>>>> +
>>>> +	if (buddy_order(buddy) != order)
>>>> +		return false;
>>>> +
>>>> +	/*
>>>> +	 * zone check is done late to avoid uselessly calculating
>>>> +	 * zone/node ids for pages that could never merge.
>>>
>>> I know, this is from existing code. But there really isn't a node check
>>> when relying on the zone id. I hope we are not missing a node check :)
>>
>> AFAIK "zone_id" is in fact the combination of node+zone (or section+zone),
>> so it works as long as in config where it's a section
>> (NODE_NOT_IN_PAGE_FLAGS is defined) then there can't be multiple nodes in a
>> single section.
> 
> Oh, okay. I was reading "We are not really identifying the zone since we
> could be using the section number id if we do not have node id available
> in page flags.. We only guarantee that it will return the same value for
> two combinable pages in a zone."
> 
> an naturally wondered if this could be problematic. Thanks for clarifying.
> 
> (once we would support MAX_ORDER-1 exceed a single memory section this
> could be problematic)

Looking once more, I think the section check might be sufficient. I
wasn't aware that we'll always have the NODE id stored in page->flags
with vmemmap. (hopefully with more page->flags users like mglru that
won't change)

-- 
Thanks,

David / dhildenb


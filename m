Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2639C4167D
	for <mm-commits@archiver.kernel.org>; Tue,  5 Apr 2022 12:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbiDEMUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377166AbiDEL2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 07:28:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80AE7100E18
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 03:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649155957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+IbO55JgTbA7qmBYsmHbTOudLNRP0+ByNvdEd65vNk=;
        b=T7SXxbM0jCbkz8WNxwrzSC1POfzLPcpCjDwzxw7lTRfRov0Lnju3DYFxIZB+X4gy6EuPyP
        TWKv/sMVRNt5k4K4XU+6ulb/Ry8HZvaAq5PKZ2pHY+999VbZ0PA4WWPZ76ewDYJvh/Me9n
        PdYTjSxNjJIAV/7uW59ZQgOYlccpU+A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-HgALuDLxP--GCEhUMlLgXw-1; Tue, 05 Apr 2022 06:52:34 -0400
X-MC-Unique: HgALuDLxP--GCEhUMlLgXw-1
Received: by mail-wr1-f72.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so2365160wrg.20
        for <mm-commits@vger.kernel.org>; Tue, 05 Apr 2022 03:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=n+IbO55JgTbA7qmBYsmHbTOudLNRP0+ByNvdEd65vNk=;
        b=gF7v4i1uAUZ3TJdGDqb4tc0HKxLewoCknZ2YV3ScfqkQOYU8vIBLtVgcQFjdad37U0
         o8rPy2yfhcPw6lG8fGSi5UgeN4GWZJ6x16TRAcR09MMm8d7Ko8PjMrg3U+xjCcWvwyT/
         wBe8e+atijUkr2i5Vb9eevXzGATlPynsEDyT7njTmgwMs9RtZGJtTd+a2CFN2kWmVBrh
         SWKnIjH03Vqlas0vEQ3noGUjWcGPkh3pcnTlb0aVCbBaI9tRzqVSY5uCvTA2noZfZ3Ex
         /cK6JTznHgl+IFU6+l+ZkuVqLl7aU/nFURBHvbhPRpo1booDKWfDW6h382ELVWNDqm6V
         KRhg==
X-Gm-Message-State: AOAM531A7IJWJkKjJgEUhrqawgeQyKNPbExCD+XtT2wRGVzwcxGbQQSv
        qTR3TUun6lf2N931sZeTDEHnFmJDiTVjsC0e7iramKsDwJMjSs8sCmjReVeRDi4Qzs/IT13P3DK
        723Tym9tYjjwy9uz2w9w3hA==
X-Received: by 2002:adf:f94d:0:b0:1e5:5ca1:2b80 with SMTP id q13-20020adff94d000000b001e55ca12b80mr2276248wrr.323.1649155952903;
        Tue, 05 Apr 2022 03:52:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQVzXdUg6KBwfgHKpUxLNxWGoAlsnsxafbEnL3nsJMXS5L/x5mV7wkO3+w2kUtbZ+Rk6o7zw==
X-Received: by 2002:adf:f94d:0:b0:1e5:5ca1:2b80 with SMTP id q13-20020adff94d000000b001e55ca12b80mr2276230wrr.323.1649155952638;
        Tue, 05 Apr 2022 03:52:32 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:c900:f06e:62c8:b5ce:6d27? (p200300cbc707c900f06e62c8b5ce6d27.dip0.t-ipconnect.de. [2003:cb:c707:c900:f06e:62c8:b5ce:6d27])
        by smtp.gmail.com with ESMTPSA id o9-20020a056000010900b00206186ac25esm3320112wrx.12.2022.04.05.03.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 03:52:32 -0700 (PDT)
Message-ID: <604fd8fb-50df-dafe-14bd-640aa991d4cf@redhat.com>
Date:   Tue, 5 Apr 2022 12:52:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        rppt@kernel.org, rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, ziy@nvidia.com
References: <20220404215048.01A9AC2BBE4@smtp.kernel.org>
 <a4256d36-6f6d-82d7-38a3-1af6f9b2457d@redhat.com>
 <b5d3b61a-02bc-0b46-95dc-bd99ec3d759a@suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: +
 mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch added
 to -mm tree
In-Reply-To: <b5d3b61a-02bc-0b46-95dc-bd99ec3d759a@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05.04.22 12:42, Vlastimil Babka wrote:
> On 4/5/22 12:29, David Hildenbrand wrote:
>>> +
>>> +/*
>>> + * This function checks whether a page is free && is the buddy
>>> + * we can coalesce a page and its buddy if
>>> + * (a) the buddy is not in a hole (check before calling!) &&
>>> + * (b) the buddy is in the buddy system &&
>>> + * (c) a page and its buddy have the same order &&
>>> + * (d) a page and its buddy are in the same zone.
>>> + *
>>> + * For recording whether a page is in the buddy system, we set PageBuddy.
>>> + * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
>>> + *
>>> + * For recording page's order, we use page_private(page).
>>> + */
>>> +static inline bool page_is_buddy(struct page *page, struct page *buddy,
>>> +							unsigned int order)
>>
>> Nit: Strange indentation of the last parameter. But it's already in the
>> code you're moving, so ...
>>
>>> +{
>>> +	if (!page_is_guard(buddy) && !PageBuddy(buddy))
>>> +		return false;
>>> +
>>> +	if (buddy_order(buddy) != order)
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * zone check is done late to avoid uselessly calculating
>>> +	 * zone/node ids for pages that could never merge.
>>
>> I know, this is from existing code. But there really isn't a node check
>> when relying on the zone id. I hope we are not missing a node check :)
> 
> AFAIK "zone_id" is in fact the combination of node+zone (or section+zone),
> so it works as long as in config where it's a section
> (NODE_NOT_IN_PAGE_FLAGS is defined) then there can't be multiple nodes in a
> single section.

Oh, okay. I was reading "We are not really identifying the zone since we
could be using the section number id if we do not have node id available
in page flags.. We only guarantee that it will return the same value for
two combinable pages in a zone."

an naturally wondered if this could be problematic. Thanks for clarifying.

(once we would support MAX_ORDER-1 exceed a single memory section this
could be problematic)

> 
>>> +	 */
>>> +	if (page_zone_id(page) != page_zone_id(buddy))
>>> +		return false;
>>> +
>>> +	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
>>> +
>>> +	return true;
>>> +}
>>> +
>>> +/*
>>>   * Locate the struct page for both the matching buddy in our
>>>   * pair (buddy1) and the combined O(n+1) page they form (page).
>>>   *
>>> @@ -234,6 +295,35 @@ __find_buddy_pfn(unsigned long page_pfn,
>>>  	return page_pfn ^ (1 << order);
>>>  }
>>>  
>>> +/*
>>> + * Find the buddy of @page and validate it.
>>> + * @page: The input page
>>> + * @pfn: The pfn of the page, it saves a call to page_to_pfn() when the
>>> + *       function is used in the performance-critical __free_one_page().
>>> + * @order: The order of the page
>>> + * @buddy_pfn: The output pointer to the buddy pfn, it also saves a call to
>>> + *             page_to_pfn().
>>> + *
>>> + * The found buddy can be a non PageBuddy, out of @page's zone, or its order is
>>> + * not the same as @page. The validation is necessary before use it.
>>> + *
>>> + * Return: the found buddy page or NULL if not found.
>>> + */
>>> +static inline struct page *find_buddy_page_pfn(struct page *page,
>>> +			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
>>> +{
>>> +	struct page *buddy;
>>> +	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
>>
>> Nit: reverse christmas tree
> 
> Was ever reverse xmas tree part of mm/ style or whole Linux styel outside of
> net?

I assume it's used fairly inconsistently.

-- 
Thanks,

David / dhildenb


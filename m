Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF149C4167E
	for <mm-commits@archiver.kernel.org>; Tue,  5 Apr 2022 12:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbiDEMVA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345944AbiDELBC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 07:01:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01240BF031
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 03:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649154569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IjvL5jEi+L+FZTJ2kONdoOby4M5pXDGldA2R8cTzEFE=;
        b=Lg/LCCdR065OOluSymMEchoNF8MMVP0i5Ol+O97kejcxNKXCqrSSE8ka1eT34HPSDSIrOL
        sUQiegeCyaTxn48/SmN7+fLOufkdoiU9HloOLzBVp7B9gcyTOcBk5RGuO6yUjf5AOuHTzo
        NPXO0IPsjeaqjupTfAkEOc+F1bRG6uY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-9EM1Vzu7MwiJTvq2BxrYiw-1; Tue, 05 Apr 2022 06:29:28 -0400
X-MC-Unique: 9EM1Vzu7MwiJTvq2BxrYiw-1
Received: by mail-wm1-f72.google.com with SMTP id c19-20020a05600c4a1300b0038e6b4a104cso1120059wmp.9
        for <mm-commits@vger.kernel.org>; Tue, 05 Apr 2022 03:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=IjvL5jEi+L+FZTJ2kONdoOby4M5pXDGldA2R8cTzEFE=;
        b=4rcHo50+MJPImse8eP7jUnzlufqO2KeIbwxuQn75EgZytQLLoEfXiuA91Z4pH4QVqX
         Q3UGYQtIwXux308XILdATdKgvL9IiDzhOo63TyhfxuBVzyj5jsTNzIZnHKKNTgMQDf3c
         ESWl8UKXW0zHrfuNqD+JN5crT+WM33ilEyqH6N0Cu/CM29DnucQi6YzPR6E6bX816ZFj
         p7fONJaUciwE0Hhu1HG8QtubA8NX9YDauFARlolvqci60kk3+zh1IlAvAHsvGJJ967xM
         V+1njgDOXGTmSeR36zvJ8SV/UfnwNX/v/0BRci4W90LmZF9J+DV3MpZnhIyL5Wrr99eD
         E3ZQ==
X-Gm-Message-State: AOAM533anv4zq4g7WVoYFfzWyJn/588zHjnNsVSTSmP77g0cbuIKk8Sb
        tWrgFLcZ/ZP4tQsucX6nYr+zA0ElhYpuQuUhZ62G/XG01X3zaS93GNMfpl/Aq/OK7s7EguuH4sk
        Alwvxl3qiHSObLwzIDRbi/g==
X-Received: by 2002:adf:e19d:0:b0:206:1568:9240 with SMTP id az29-20020adfe19d000000b0020615689240mr2097393wrb.286.1649154567444;
        Tue, 05 Apr 2022 03:29:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG2V5AImv2vLwwSFh7aU461GrhDgNteARph/fA/xpIBWPKsH50rgM4PCOXIT5RxYib6iqdrw==
X-Received: by 2002:adf:e19d:0:b0:206:1568:9240 with SMTP id az29-20020adfe19d000000b0020615689240mr2097367wrb.286.1649154567157;
        Tue, 05 Apr 2022 03:29:27 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:c900:f06e:62c8:b5ce:6d27? (p200300cbc707c900f06e62c8b5ce6d27.dip0.t-ipconnect.de. [2003:cb:c707:c900:f06e:62c8:b5ce:6d27])
        by smtp.gmail.com with ESMTPSA id q187-20020a1c43c4000000b0038e70f4f42dsm1706335wma.47.2022.04.05.03.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 03:29:26 -0700 (PDT)
Message-ID: <a4256d36-6f6d-82d7-38a3-1af6f9b2457d@redhat.com>
Date:   Tue, 5 Apr 2022 12:29:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, ziy@nvidia.com
References: <20220404215048.01A9AC2BBE4@smtp.kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: +
 mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch added
 to -mm tree
In-Reply-To: <20220404215048.01A9AC2BBE4@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

> From: Zi Yan <ziy@nvidia.com>
> Subject: mm: wrap __find_buddy_pfn() with a necessary buddy page validation
> 
> Whenever the buddy of a page is found from __find_buddy_pfn(),
> page_is_buddy() should be used to check its validity. Add a helper
> function find_buddy_page_pfn() to find the buddy page and do the check
> together.
> 
> Link: https://lkml.kernel.org/r/20220401230804.1658207-2-zi.yan@sent.com
> Link: https://lore.kernel.org/linux-mm/CAHk-=wji_AmYygZMTsPMdJ7XksMt7kOur8oDfDdniBRMjm4VkQ@mail.gmail.com/
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Sorry for replying here, I hope Mimecast stops messing up my mailbox
soon. Only some nits.

In general, LGTM

Acked-by: David Hildenbrand <david@redhat.com>



> ---
> 
>  mm/internal.h       |  117 ++++++++++++++++++++++++++++++++----------
>  mm/page_alloc.c     |   52 ++----------------
>  mm/page_isolation.c |    9 +--
>  3 files changed, 101 insertions(+), 77 deletions(-)
> 
> --- a/mm/internal.h~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation
> +++ a/mm/internal.h
> @@ -212,6 +212,67 @@ struct alloc_context {
>  };
>  
>  /*
> + * This function returns the order of a free page in the buddy system. In
> + * general, page_zone(page)->lock must be held by the caller to prevent the
> + * page from being allocated in parallel and returning garbage as the order.
> + * If a caller does not hold page_zone(page)->lock, it must guarantee that the
> + * page cannot be allocated or merged in parallel. Alternatively, it must
> + * handle invalid values gracefully, and use buddy_order_unsafe() below.
> + */
> +static inline unsigned int buddy_order(struct page *page)
> +{
> +	/* PageBuddy() must be checked by the caller */
> +	return page_private(page);
> +}
> +
> +/*
> + * Like buddy_order(), but for callers who cannot afford to hold the zone lock.
> + * PageBuddy() should be checked first by the caller to minimize race window,
> + * and invalid values must be handled gracefully.
> + *
> + * READ_ONCE is used so that if the caller assigns the result into a local
> + * variable and e.g. tests it for valid range before using, the compiler cannot
> + * decide to remove the variable and inline the page_private(page) multiple
> + * times, potentially observing different values in the tests and the actual
> + * use of the result.
> + */
> +#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
> +
> +/*
> + * This function checks whether a page is free && is the buddy
> + * we can coalesce a page and its buddy if
> + * (a) the buddy is not in a hole (check before calling!) &&
> + * (b) the buddy is in the buddy system &&
> + * (c) a page and its buddy have the same order &&
> + * (d) a page and its buddy are in the same zone.
> + *
> + * For recording whether a page is in the buddy system, we set PageBuddy.
> + * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
> + *
> + * For recording page's order, we use page_private(page).
> + */
> +static inline bool page_is_buddy(struct page *page, struct page *buddy,
> +							unsigned int order)

Nit: Strange indentation of the last parameter. But it's already in the
code you're moving, so ...

> +{
> +	if (!page_is_guard(buddy) && !PageBuddy(buddy))
> +		return false;
> +
> +	if (buddy_order(buddy) != order)
> +		return false;
> +
> +	/*
> +	 * zone check is done late to avoid uselessly calculating
> +	 * zone/node ids for pages that could never merge.

I know, this is from existing code. But there really isn't a node check
when relying on the zone id. I hope we are not missing a node check :)

> +	 */
> +	if (page_zone_id(page) != page_zone_id(buddy))
> +		return false;
> +
> +	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
> +
> +	return true;
> +}
> +
> +/*
>   * Locate the struct page for both the matching buddy in our
>   * pair (buddy1) and the combined O(n+1) page they form (page).
>   *
> @@ -234,6 +295,35 @@ __find_buddy_pfn(unsigned long page_pfn,
>  	return page_pfn ^ (1 << order);
>  }
>  
> +/*
> + * Find the buddy of @page and validate it.
> + * @page: The input page
> + * @pfn: The pfn of the page, it saves a call to page_to_pfn() when the
> + *       function is used in the performance-critical __free_one_page().
> + * @order: The order of the page
> + * @buddy_pfn: The output pointer to the buddy pfn, it also saves a call to
> + *             page_to_pfn().
> + *
> + * The found buddy can be a non PageBuddy, out of @page's zone, or its order is
> + * not the same as @page. The validation is necessary before use it.
> + *
> + * Return: the found buddy page or NULL if not found.
> + */
> +static inline struct page *find_buddy_page_pfn(struct page *page,
> +			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
> +{
> +	struct page *buddy;
> +	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);

Nit: reverse christmas tree

> +
> +	buddy = page + (__buddy_pfn - pfn);
> +	if (buddy_pfn)
> +		*buddy_pfn = __buddy_pfn;
> +
> +	if (page_is_buddy(page, buddy, order))
> +		return buddy;
> +	return NULL;
> +}
> +

[...]
>  #ifdef CONFIG_COMPACTION
>  static inline struct capture_control *task_capc(struct zone *zone)
>  {
> @@ -1010,18 +976,17 @@ static inline bool
>  buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
>  		   struct page *page, unsigned int order)
>  {
> -	struct page *higher_page, *higher_buddy;
> -	unsigned long combined_pfn;
> +	struct page *higher_page;
> +	unsigned long higher_page_pfn;

Nit: reverse christmas tree



-- 
Thanks,

David / dhildenb


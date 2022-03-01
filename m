Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB892C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 03:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiCADlL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 22:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiCADlJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 22:41:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2BB5D65D
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:40:30 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id bx5so12969915pjb.3
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uJXCxea30Bsg5XNB0xGdDXX9/yiUrTO+STHdcBruhsY=;
        b=h58S9m0o4YjhHhJuuwLVN///UGYry2wjSNYblnKFZqBeO1KuLIbV9lmA2hJMMuTpW0
         Lpsxp4xlDuy7lmnTqKuihTnFv1fEMG/RUwrwvapGEKChtZJ917M+jmKFVnqvgTPVK19a
         lItruImv1LUpW7/nWtpeq993NzFhvLOvtldEuLeLNMMwmTSLOm5fUuYaUZmC/fE5Lywf
         qyTX468Li7tb2EzwgXBVE60VZv5U/EIxL6hj/GjGLn2COuE9AGUo0jLb1l6xfxNHi15P
         2WVPcDnvITot/BADr8rRsUQaxQs81TbOAQFCqyQRF+GJ7P0LKlbicoSOu+LchDZZfP1X
         8png==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uJXCxea30Bsg5XNB0xGdDXX9/yiUrTO+STHdcBruhsY=;
        b=P+1328NakwzINphnailOaP6m5EuCr9qA9dFLtSYtYdMCrFby97fSvKNYYhiVncysEP
         YNrPlT/eyT1TnHAbz204idNcsrW0z8B/oeI7wdJdVEn82whgF/Y5UEebVuW4jlGP0cOs
         VLmAnnLkkhxotU13FV/9dW1MUSBkCoQ6Z8Qotta+iTlFVfuvRwmKxfYGwe+OSgo0EYL9
         4H1oTxwySyXX7wqYkWnzUCFsJEkZlU2NG+PBIn/Omqr4xAVIYrHj5Ux+IhkUTkQ9Pddx
         tZPM8TLtjPv8/80AeMU8Ona1ugsNwUa3IOHHr7mO+7KfC3kJQhBXGUdr/1LJCJrHzJBw
         UqZQ==
X-Gm-Message-State: AOAM531qaO6IkhwCuNkUsmbyo2L3DRwHk8O3JM0XFWljNIjHlvyiOYtE
        tSNjkHiG6f4nwiIDJEJh8LA=
X-Google-Smtp-Source: ABdhPJxmX8hPoA0trFHw0duZD2FrWM4EI/B0AzCFa3/8Xi5FuNfpSv9zGSp8BStwm0IpiwMJYs7Ehw==
X-Received: by 2002:a17:90a:24f:b0:1bc:ba37:ae4 with SMTP id t15-20020a17090a024f00b001bcba370ae4mr19719309pje.30.1646106029515;
        Mon, 28 Feb 2022 19:40:29 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id a11-20020a63cd4b000000b00378b9167493sm3340095pgj.52.2022.02.28.19.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 19:40:29 -0800 (PST)
Date:   Tue, 1 Mar 2022 03:40:22 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yury.norov@gmail.com, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com,
        qiang.zhang@windriver.com, penberg@kernel.org,
        mcroce@microsoft.com, johannes.berg@intel.com, jarkko@kernel.org,
        James.Bottomley@hansenpartnership.com, imran.f.khan@oracle.com,
        iamjoonsoo.kim@lge.com, glittao@gmail.com, faiyazm@codeaurora.org,
        elver@google.com, edumazet@google.com, dvyukov@google.com,
        cl@linux.com, arnd@arndb.de, andreyknvl@gmail.com
Subject: Re: +
 lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable.patch
 added to -mm tree
Message-ID: <Yh2VpskKGOSTv86U@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220228051029.300C8C340E7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228051029.300C8C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Feb 27, 2022 at 09:10:28PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: lib/stackdepot: use page allocator if both slab and memblock is unavailable
> has been added to the -mm tree.  Its filename is
>      lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>

Andrew, would you please drop this?
I fixed this using another approach that Marco and Vlastimil suggested.

https://lore.kernel.org/linux-mm/Yh2Uxh9DMndwjGcb@ip-172-31-19-208.ap-northeast-1.compute.internal/T/#u

Thanks!

> ------------------------------------------------------
> From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Subject: lib/stackdepot: use page allocator if both slab and memblock is unavailable
> 
> After commit 2dba5eb1c73b ("lib/stackdepot: allow optional init and
> stack_table allocation by kvmalloc()"), stack_depot_init() is called later
> if CONFIG_STACKDEPOT_ALWAYS_INIT=n to remove unnecessary memory usage.  It
> allocates stack_table using memblock_alloc() or kvmalloc() depending on
> availability of slab allocator.
> 
> But when stack_depot_init() is called while creating boot slab caches,
> both slab allocator and memblock is not available.  So kernel crashes. 
> Allocate stack_table from page allocator when both slab allocator and
> memblock is unavailable.
> 
> Limit size of stack_table when using page allocator because vmalloc() is
> also unavailable in kmem_cache_init().  It must not be larger than
> (PAGE_SIZE << (MAX_ORDER - 1)).
> 
> This patch was tested on both CONFIG_STACKDEPOT_ALWAYS_INIT=y and n.
> 
> [lkp@intel.com: fix W=1 build warning]
> Link: https://lkml.kernel.org/r/YhtDCoHWsF11rwze@ip-172-31-19-208.ap-northeast-1.compute.internal
> Fixes: 2dba5eb1c73b ("lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()")
> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Oliver Glitta <glittao@gmail.com>
> Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Cc: Matteo Croce <mcroce@microsoft.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Imran Khan <imran.f.khan@oracle.com>
> Cc: Zqiang <qiang.zhang@windriver.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/stackdepot.c |   28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> --- a/lib/stackdepot.c~lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable
> +++ a/lib/stackdepot.c
> @@ -73,6 +73,14 @@ static int next_slab_inited;
>  static size_t depot_offset;
>  static DEFINE_RAW_SPINLOCK(depot_lock);
>  
> +static size_t stack_hash_size = (1 << CONFIG_STACK_HASH_ORDER);
> +static inline size_t stack_hash_mask(void)
> +{
> +	return stack_hash_size - 1;
> +}
> +
> +#define STACK_HASH_SEED 0x9747b28c
> +
>  static bool init_stack_slab(void **prealloc)
>  {
>  	if (!*prealloc)
> @@ -142,10 +150,6 @@ depot_alloc_stack(unsigned long *entries
>  	return stack;
>  }
>  
> -#define STACK_HASH_SIZE (1L << CONFIG_STACK_HASH_ORDER)
> -#define STACK_HASH_MASK (STACK_HASH_SIZE - 1)
> -#define STACK_HASH_SEED 0x9747b28c
> -
>  static bool stack_depot_disable;
>  static struct stack_record **stack_table;
>  
> @@ -172,18 +176,28 @@ __ref int stack_depot_init(void)
>  
>  	mutex_lock(&stack_depot_init_mutex);
>  	if (!stack_depot_disable && !stack_table) {
> -		size_t size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
> +		size_t size = (stack_hash_size * sizeof(struct stack_record *));
>  		int i;
>  
>  		if (slab_is_available()) {
>  			pr_info("Stack Depot allocating hash table with kvmalloc\n");
>  			stack_table = kvmalloc(size, GFP_KERNEL);
> +		} else if (totalram_pages() > 0) {
> +			/* Reduce size because vmalloc may be unavailable */
> +			size = min_t(size_t, size, PAGE_SIZE << (MAX_ORDER - 1));
> +			stack_hash_size = size / sizeof(struct stack_record *);
> +
> +			pr_info("Stack Depot allocating hash table with __get_free_pages\n");
> +			stack_table = (struct stack_record **)
> +				      __get_free_pages(GFP_KERNEL, get_order(size));
>  		} else {
>  			pr_info("Stack Depot allocating hash table with memblock_alloc\n");
>  			stack_table = memblock_alloc(size, SMP_CACHE_BYTES);
>  		}
> +
>  		if (stack_table) {
> -			for (i = 0; i < STACK_HASH_SIZE;  i++)
> +			pr_info("Stack Depot hash table size=%zu\n", stack_hash_size);
> +			for (i = 0; i < stack_hash_size;  i++)
>  				stack_table[i] = NULL;
>  		} else {
>  			pr_err("Stack Depot hash table allocation failed, disabling\n");
> @@ -363,7 +377,7 @@ depot_stack_handle_t __stack_depot_save(
>  		goto fast_exit;
>  
>  	hash = hash_stack(entries, nr_entries);
> -	bucket = &stack_table[hash & STACK_HASH_MASK];
> +	bucket = &stack_table[hash & stack_hash_mask()];
>  
>  	/*
>  	 * Fast path: look the stack trace up without locking.
> _
> 
> Patches currently in -mm which might be from 42.hyeyoo@gmail.com are
> 
> lib-stackdepot-use-page-allocator-if-both-slab-and-memblock-is-unavailable.patch
> 

-- 
Thank you, You are awesome!
Hyeonggon :-)

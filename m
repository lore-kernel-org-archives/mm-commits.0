Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E35AC43460
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 13:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A4896143B
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 13:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhEMNs7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 09:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234185AbhEMNsu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 09:48:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620913660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oKkhQfbs6s+NSAwmvIzN8lzAUaCiZWrHf4VmOkzQ9cI=;
        b=aXl4M19ymRbFZGRF0drgzzd0pZRojQhG4X6HKrUuL6LE/S3TTFSeMNHwxio2xuozc1CkR7
        MHgiLzBxtGj4KiqJZSCiezOUAQ5EkI6NNvVtqU+YbiHc/WYAxEDfQvddmVneVLXhh4D4kX
        ysJY4qnCUW1kDAyoNoDefwwZ3u/q/7c=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-iJ8DKpJFN0eU6MOlB6MEfA-1; Thu, 13 May 2021 09:47:39 -0400
X-MC-Unique: iJ8DKpJFN0eU6MOlB6MEfA-1
Received: by mail-qt1-f198.google.com with SMTP id g13-20020ac8580d0000b02901e117526d0fso2808329qtg.5
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 06:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oKkhQfbs6s+NSAwmvIzN8lzAUaCiZWrHf4VmOkzQ9cI=;
        b=c9mTVsuc2MKeUrGZ0resM71VeITjoBsft76dJGmVE+3jMhJqWqpu/UZ96vHtyd7cZk
         FRxv1fIIu9UqQh9O1Cy3+H4FzTxXehb/ZvzV/auzi4ota4rt83vIWSUCKVjOvOSmdn3J
         9ni5RondA6uobymRftfsRn9y+gtGA06hQBIa5aPthhp/23zVUXX9JBsBIk92P14ao2Hy
         3Grg1AzkLCFZQUFYSMsQDgHAJxi4tLj5GqjCvkLnkp6ZIbPmYhKCQrcgR+55EWHr5xRi
         6nXB3yp4A/z37UEOSHDvra3pocj/yYYqVYkmulJwpaSgHwq4eMOaOgFBlEePgYMY9ro9
         O3UQ==
X-Gm-Message-State: AOAM531sEJoF5XSKUJTiA4m2PY9RboJ/J7pPvgtBXBSk28ElAi5YP32K
        5V6nzHLRjt6r5wYZL2OR3IIQ+zq8b6xf3a9uSqcdkW0vBsfFnMkvolvW8uHf//0y9Nrq8fbMyXF
        Fj+f6KIMaMT+SSpKhJf+TjQ==
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr17073146qtd.173.1620913658359;
        Thu, 13 May 2021 06:47:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbyoggC6NLaG5OCmXrUAolaSq/4DR8Uijoj2znlUvVoDzvp/MLizfAKluC71PBObHnIZG2pQ==
X-Received: by 2002:ac8:5ac7:: with SMTP id d7mr17073128qtd.173.1620913658125;
        Thu, 13 May 2021 06:47:38 -0700 (PDT)
Received: from llong.remote.csb ([2601:191:8500:76c0::cdbc])
        by smtp.gmail.com with ESMTPSA id u9sm2424249qtf.76.2021.05.13.06.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 06:47:37 -0700 (PDT)
From:   Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Subject: Re: + mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch
 added to -mm tree
To:     Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        vdavydov.dev@gmail.com
References: <20210513003326.ZvcnI0LXP%akpm@linux-foundation.org>
 <2903d6df-b89a-d93b-546d-4944210a6fd8@suse.cz>
Message-ID: <3f7573fe-4053-e927-1de4-3b710d37234e@redhat.com>
Date:   Thu, 13 May 2021 09:47:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <2903d6df-b89a-d93b-546d-4944210a6fd8@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 5/13/21 7:44 AM, Vlastimil Babka wrote:
> On 5/13/21 2:33 AM, akpm@linux-foundation.org wrote:
>> --- a/mm/internal.h~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
>> +++ a/mm/internal.h
>> @@ -116,11 +116,6 @@ extern void putback_lru_page(struct page
>>   extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>>   
>>   /*
>> - * in mm/memcontrol.c:
>> - */
>> -extern bool cgroup_memory_nokmem;
>> -
>> -/*
> This...
>
>>    * in mm/page_alloc.c
>>    */
>>   
>> --- a/mm/memcontrol.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
>> +++ a/mm/memcontrol.c
>> @@ -83,7 +83,7 @@ DEFINE_PER_CPU(struct mem_cgroup *, int_
>>   static bool cgroup_memory_nosocket;
>>   
>>   /* Kernel memory accounting disabled? */
>> -bool cgroup_memory_nokmem;
>> +static bool cgroup_memory_nokmem;
> ...
>
>>   
>>   /* Whether the swap controller is active */
>>   #ifdef CONFIG_MEMCG_SWAP
>> --- a/mm/slab_common.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
>> +++ a/mm/slab_common.c
>> @@ -841,15 +841,10 @@ void __init setup_kmalloc_cache_index_ta
>>   static void __init
>>   new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
>>   {
>> -	if (type == KMALLOC_RECLAIM) {
>> +	if (type == KMALLOC_RECLAIM)
>>   		flags |= SLAB_RECLAIM_ACCOUNT;
>> -	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
>> -		if (cgroup_memory_nokmem) {
>> -			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
>> -			return;
>> -		}
> ... and this is undoing
> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch
>
> I guess that wasn't intended?
>
>> +	else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP))
>>   		flags |= SLAB_ACCOUNT;
>> -	}
>>   
>>   	kmalloc_caches[type][idx] = create_kmalloc_cache(
>>   					kmalloc_info[idx].name[type],
>> _
>>
>> Patches currently in -mm which might be from longman@redhat.com are
>>
>> mm-memcg-move-mod_objcg_state-to-memcontrolc.patch
>> mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
>> mm-memcg-improve-refill_obj_stock-performance.patch
>> mm-memcg-optimize-user-context-object-stock-access.patch
>> mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
>> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch
>> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch
>> mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch
>>
I have the same question. Only the first hunk is relevant. The rests are 
the revert of Vlastimil's patch.

Thanks,
Longman


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2A4C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 11:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B4636143F
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 11:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhEMLqQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 07:46:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:48254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233569AbhEMLpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 07:45:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 84617B04C;
        Thu, 13 May 2021 11:44:30 +0000 (UTC)
Subject: Re: + mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch
 added to -mm tree
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, longman@redhat.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        vdavydov.dev@gmail.com
References: <20210513003326.ZvcnI0LXP%akpm@linux-foundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <2903d6df-b89a-d93b-546d-4944210a6fd8@suse.cz>
Date:   Thu, 13 May 2021 13:44:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210513003326.ZvcnI0LXP%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 5/13/21 2:33 AM, akpm@linux-foundation.org wrote:
> --- a/mm/internal.h~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
> +++ a/mm/internal.h
> @@ -116,11 +116,6 @@ extern void putback_lru_page(struct page
>  extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>  
>  /*
> - * in mm/memcontrol.c:
> - */
> -extern bool cgroup_memory_nokmem;
> -
> -/*

This...

>   * in mm/page_alloc.c
>   */
>  
> --- a/mm/memcontrol.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
> +++ a/mm/memcontrol.c
> @@ -83,7 +83,7 @@ DEFINE_PER_CPU(struct mem_cgroup *, int_
>  static bool cgroup_memory_nosocket;
>  
>  /* Kernel memory accounting disabled? */
> -bool cgroup_memory_nokmem;
> +static bool cgroup_memory_nokmem;

...

>  
>  /* Whether the swap controller is active */
>  #ifdef CONFIG_MEMCG_SWAP
> --- a/mm/slab_common.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
> +++ a/mm/slab_common.c
> @@ -841,15 +841,10 @@ void __init setup_kmalloc_cache_index_ta
>  static void __init
>  new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
>  {
> -	if (type == KMALLOC_RECLAIM) {
> +	if (type == KMALLOC_RECLAIM)
>  		flags |= SLAB_RECLAIM_ACCOUNT;
> -	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
> -		if (cgroup_memory_nokmem) {
> -			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
> -			return;
> -		}

... and this is undoing
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch

I guess that wasn't intended?

> +	else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP))
>  		flags |= SLAB_ACCOUNT;
> -	}
>  
>  	kmalloc_caches[type][idx] = create_kmalloc_cache(
>  					kmalloc_info[idx].name[type],
> _
> 
> Patches currently in -mm which might be from longman@redhat.com are
> 
> mm-memcg-move-mod_objcg_state-to-memcontrolc.patch
> mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
> mm-memcg-improve-refill_obj_stock-performance.patch
> mm-memcg-optimize-user-context-object-stock-access.patch
> mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch
> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch
> mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch
> 


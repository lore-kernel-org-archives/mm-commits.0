Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF6EC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 02:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243754AbhK2DC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Nov 2021 22:02:59 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:44738 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241563AbhK2DA7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Nov 2021 22:00:59 -0500
Received: by mail-qk1-f173.google.com with SMTP id 132so21316312qkj.11
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 18:57:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rpmaYpaSjBcSTElaAApAgOy+ILRBu1AaOUZQ0RqWA1o=;
        b=SCAbKSoVDZKpRcdtTWjY2Z5i53jLRE3w2AZHU0Ie22K7L2umvtWEB9+DfU8hHk6NVx
         5crw4ZhyFQ4bO8AFX+r7KodV1sUxGDF9JQ6RIvRTxgJl7jljuW49OiaMW+XF4i8ME8w8
         uW49XxAuxVk8wLwvm8BwqsH+oRgeS7/hy6WO0HEovYNG5J4IysHJqAx7C1CsMT/aJiDM
         kniW/GFIK51dzkd0DVLDhMBKNiGR7J5YYea+VsRmIKwNmI6gsC7PoMeGcOciqc6TFhKl
         3rpor/ht6LWkX0NruwZxG2VwTRXelWN5Cnyf8fnx3YgGbqDvnC0iAxDl9Vtjwlmq0xa0
         0T3Q==
X-Gm-Message-State: AOAM531ClBH4/iL62BJRPR6jdKX8l/K4yVevMBL+F3B3rSb+Z+engAwS
        D9XNnUeGP75XBumTCC8jQu8=
X-Google-Smtp-Source: ABdhPJz88HB29iF40KH2Huh9GfP6GKlmiczYOZCbXqNZlb4KWrD2HQ/UYvml0Qjjr95tTEPIgRFnMg==
X-Received: by 2002:a37:6103:: with SMTP id v3mr27235274qkb.694.1638154661644;
        Sun, 28 Nov 2021 18:57:41 -0800 (PST)
Received: from fedora (pool-173-68-57-129.nycmny.fios.verizon.net. [173.68.57.129])
        by smtp.gmail.com with ESMTPSA id f11sm7504399qko.84.2021.11.28.18.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 18:57:41 -0800 (PST)
Date:   Sun, 28 Nov 2021 21:57:39 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     akpm@linux-foundation.org
Cc:     cl@linux.com, mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        tj@kernel.org, zhengqi.arch@bytedance.com
Subject: Re: +
 mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch added to
 -mm tree
Message-ID: <YaRBo5kyc7dLJPtc@fedora>
References: <20211128000426.z-EdzU3AU%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128000426.z-EdzU3AU%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Nov 27, 2021 at 04:04:26PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: memcg/percpu: account extra objcg space to memory cgroups
> has been added to the -mm tree.  Its filename is
>      mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch
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
> ------------------------------------------------------
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> Subject: mm: memcg/percpu: account extra objcg space to memory cgroups
> 
> Similar to slab memory allocator, for each accounted percpu object there
> is an extra space which is used to store obj_cgroup membership.  Charge it
> too.
> 
> Link: https://lkml.kernel.org/r/20211126040606.97836-1-zhengqi.arch@bytedance.com
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/percpu-internal.h |   17 +++++++++++++++++
>  mm/percpu.c          |   10 +++++-----
>  2 files changed, 22 insertions(+), 5 deletions(-)
> 
> --- a/mm/percpu.c~mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups
> +++ a/mm/percpu.c
> @@ -1635,7 +1635,7 @@ static bool pcpu_memcg_pre_alloc_hook(si
>  	if (!objcg)
>  		return true;
>  
> -	if (obj_cgroup_charge(objcg, gfp, size * num_possible_cpus())) {
> +	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size))) {
>  		obj_cgroup_put(objcg);
>  		return false;
>  	}
> @@ -1656,10 +1656,10 @@ static void pcpu_memcg_post_alloc_hook(s
>  
>  		rcu_read_lock();
>  		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
> -				size * num_possible_cpus());
> +				pcpu_obj_full_size(size));
>  		rcu_read_unlock();
>  	} else {
> -		obj_cgroup_uncharge(objcg, size * num_possible_cpus());
> +		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
>  		obj_cgroup_put(objcg);
>  	}
>  }
> @@ -1676,11 +1676,11 @@ static void pcpu_memcg_free_hook(struct
>  		return;
>  	chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = NULL;
>  
> -	obj_cgroup_uncharge(objcg, size * num_possible_cpus());
> +	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
>  
>  	rcu_read_lock();
>  	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
> -			-(size * num_possible_cpus()));
> +			-pcpu_obj_full_size(size));
>  	rcu_read_unlock();
>  
>  	obj_cgroup_put(objcg);
> --- a/mm/percpu-internal.h~mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups
> +++ a/mm/percpu-internal.h
> @@ -113,6 +113,23 @@ static inline int pcpu_chunk_map_bits(st
>  	return pcpu_nr_pages_to_map_bits(chunk->nr_pages);
>  }
>  
> +#ifdef CONFIG_MEMCG_KMEM
> +/**
> + * pcpu_obj_full_size - helper to calculate size of each accounted object
> + * @size: size of area to allocate in bytes
> + *
> + * For each accounted object there is an extra space which is used to store
> + * obj_cgroup membership. Charge it too.
> + */
> +static inline size_t pcpu_obj_full_size(size_t size)
> +{
> +	size_t extra_size =
> +		size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
> +
> +	return size * num_possible_cpus() + extra_size;
> +}
> +#endif /* CONFIG_MEMCG_KMEM */
> +
>  #ifdef CONFIG_PERCPU_STATS
>  
>  #include <linux/spinlock.h>
> _
> 
> Patches currently in -mm which might be from zhengqi.arch@bytedance.com are
> 
> mm-remove-redundant-check-about-fault_flag_allow_retry-bit.patch
> mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups.patch
> 

Hi Andrew,

I understand I've been a bit slow and it's easy for you to pull
relatively small changes, so please add:

Acked-by: Dennis Zhou <dennis@kernel.org>

But I don't think I've gotten resolution on what's going on with mm/cpu
hotplug in [1]. Can we continue that conversation over there?

[1] https://lore.kernel.org/mm-commits/20211108205031.UxDPHBZWa%25akpm@linux-foundation.org/

Thanks,
Dennis

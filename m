Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D42214AD0A
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 06:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719382355; cv=none; b=NTzytOfa9EBJBQv/8dxtbrS5lvhE/T9d0AEEb2I957f2LiTf3a/W8z+ILSLANT7ndUickqj4j2vMpjqi/y2QDCvZ+PhUgiLGdLg/9cglz2tr2ySxd7lMCOA5EW6xbi+F0VnZCmU2OylrGv3xYWKemXEy9RI+sl0XUFEQnHH6mIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719382355; c=relaxed/simple;
	bh=yRWVWtvqVRtp9IFT1i2uXJzhhsFc6pMscyV+6rydZKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H5VLNh8RR3KwDWV9G/2a8MouVKcyjTv0Jv2qrXKy2k1vl1pFVFXnpk6d35i1JR5gIf9BEEcS46W0Tzr2k6/Get2JaVWju+Qigil5DZavA+TZrlXfvSDLAEQaAcSJphwzkPd4DbnqnI+S6p38EiBa0bXtmhaZdvdpmnsiSrip6c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Jth1Yzul; arc=none smtp.client-ip=209.85.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Jth1Yzul"
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-57cbc2a2496so7417485a12.0
        for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 23:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719382350; x=1719987150; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oUk92CQ6uyglDlLtk58815oLVnZmh9FmlJic83vZ+EM=;
        b=Jth1YzulGD1uYGEmP/V4b3oOYzuhDTVAV2kEzlzRfRHXbpmyIiaRpRAdQSxZlGy6gh
         Z0SwFMzy7fumKAw40G6inWzViXGcaPOJqKU4BDDhZuBAZ2rU7g29vjHEXRSe3ya3mhZi
         qzQaM97ZS9rFaOHh/8mtVM/a+z9JFdn4MzBipn716YtiXJQOFTx0rRuqxF1afXk92OXy
         leZkyiOqJrFpqk289jI2SBLIyGsjb339U/jlyr3Ol57Y4PXPWZsBJ6PzCE8nNXqyqDIG
         ijWY6a48N1Uu5mS2N+KP4pHQnmh4xWd6oIpUVlJU2AqDF4b+GC6ysurrztntFy7cjsMb
         FMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719382350; x=1719987150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUk92CQ6uyglDlLtk58815oLVnZmh9FmlJic83vZ+EM=;
        b=qH8kD0GO7VSr/kiSqS4coEKSh26igB87gLPtUXN7xovAj9BXKXAhq0xyug8lmdcOJb
         xfwuCI+PTYbnuQVcrcMoO6oyiAzFwucNUWOIkEtApkF218BFdZ5Vz+VwhxLFU1c0O++M
         vvN3pQUAuT0x6d6vi9p3ripxEMxitpuREgFri6Swxcy9YDQR/HuKD1dd3mnY21v8lWe7
         5ZyxAnXETufipfM9ZArtE3WCgJwLaXe0QesDHF7U5kHxHjriZre3Kld3/VRMLIqtO+mz
         MnTkoFdOmKt9pFPXZoxKmM4TkEnwl1O3qSIzqJMQipTfsqyHGLcvAIz2g/TrynWizBb0
         0V3g==
X-Gm-Message-State: AOJu0Yx3pjWqJJrJhnL9wNAd8uGYis7X6sETi1CBHR12e7NLIShTuvtF
	9pwmPyBPvG2WwXDTzsSONVtPcLPghx92fgRbjsMyv+xBw+XehKf3oPx0d+yRd3o3VawPLp2X41N
	EiSE=
X-Google-Smtp-Source: AGHT+IFJbpgGRpy1dEtvwE4S31/3CrxxoMl1j28ruhT25kaC7adkugG88u8S1OPhiiTPKYT+GV+3/g==
X-Received: by 2002:a50:a455:0:b0:57c:c2b6:176d with SMTP id 4fb4d7f45d1cf-57d4bdbe7dbmr8850513a12.32.1719382350187;
        Tue, 25 Jun 2024 23:12:30 -0700 (PDT)
Received: from localhost (109-81-95-13.rct.o2.cz. [109.81.95.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d30534e35sm6733537a12.62.2024.06.25.23.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 23:12:29 -0700 (PDT)
Date: Wed, 26 Jun 2024 08:12:28 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com, willy@infradead.org,
	wangkefeng.wang@huawei.com, tj@kernel.org, shakeel.butt@linux.dev,
	shakeelb@google.com, roman.gushchin@linux.dev, rientjes@google.com,
	nphamcs@gmail.com, muchun.song@linux.dev, lizefan.x@bytedance.com,
	hughd@google.com, hannes@cmpxchg.org, findns94@gmail.com,
	david@redhat.com, corbet@lwn.net, chrisl@kernel.org,
	schatzberg.dan@gmail.com
Subject: Re: [nacked] mm-add-swapiness=-arg-to-memoryreclaim.patch removed
 from -mm tree
Message-ID: <ZnuxTAcFbW0mI5uD@tiehlicka>
References: <20240625210334.0BCA0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625210334.0BCA0C32781@smtp.kernel.org>

On Tue 25-06-24 14:03:33, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: mm: add swappiness= arg to memory.reclaim
> has been removed from the -mm tree.  Its filename was
>      mm-add-swapiness=-arg-to-memoryreclaim.patch
> 
> This patch was dropped because it was nacked

I do not see this being nacked in the original email thread.

> ------------------------------------------------------
> From: Dan Schatzberg <schatzberg.dan@gmail.com>
> Subject: mm: add swappiness= arg to memory.reclaim
> Date: Wed, 3 Jan 2024 08:48:37 -0800
> 
> Allow proactive reclaimers to submit an additional swappiness=<val>
> argument to memory.reclaim.  This overrides the global or per-memcg
> swappiness setting for that reclaim attempt.
> 
> For example:
> 
> echo "2M swappiness=0" > /sys/fs/cgroup/memory.reclaim
> 
> will perform reclaim on the rootcg with a swappiness setting of 0 (no
> swap) regardless of the vm.swappiness sysctl setting.
> 
> Userspace proactive reclaimers use the memory.reclaim interface to trigger
> reclaim.  The memory.reclaim interface does not allow for any way to
> effect the balance of file vs anon during proactive reclaim.  The only
> approach is to adjust the vm.swappiness setting.  However, there are a few
> reasons we look to control the balance of file vs anon during proactive
> reclaim, separately from reactive reclaim:
> 
> * Swapout should be limited to manage SSD write endurance.  In near-OOM
>   situations we are fine with lots of swap-out to avoid OOMs.  As these
>   are typically rare events, they have relatively little impact on write
>   endurance.  However, proactive reclaim runs continuously and so its
>   impact on SSD write endurance is more significant.  Therefore it is
>   desireable to control swap-out for proactive reclaim separately from
>   reactive reclaim
> 
> * Some userspace OOM killers like systemd-oomd[1] support OOM killing on
>   swap exhaustion.  This makes sense if the swap exhaustion is triggered
>   due to reactive reclaim but less so if it is triggered due to proactive
>   reclaim (e.g.  one could see OOMs when free memory is ample but anon is
>   just particularly cold).  Therefore, it's desireable to have proactive
>   reclaim reduce or stop swap-out before the threshold at which OOM
>   killing occurs.
> 
> In the case of Meta's Senpai proactive reclaimer, we adjust vm.swappiness
> before writes to memory.reclaim[2].  This has been in production for
> nearly two years and has addressed our needs to control proactive vs
> reactive reclaim behavior but is still not ideal for a number of reasons:
> 
> * vm.swappiness is a global setting, adjusting it can race/interfere
>   with other system administration that wishes to control vm.swappiness. 
>   In our case, we need to disable Senpai before adjusting vm.swappiness.
> 
> * vm.swappiness is stateful - so a crash or restart of Senpai can leave
>   a misconfigured setting.  This requires some additional management to
>   record the "desired" setting and ensure Senpai always adjusts to it.
> 
> With this patch, we avoid these downsides of adjusting vm.swappiness
> globally.
> 
> [1]https://www.freedesktop.org/software/systemd/man/latest/systemd-oomd.service.html
> [2]https://github.com/facebookincubator/oomd/blob/main/src/oomd/plugins/Senpai.cpp#L585-L598
> 
> Link: https://lkml.kernel.org/r/20240103164841.2800183-3-schatzberg.dan@gmail.com
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
> Suggested-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yue Zhao <findns94@gmail.com>
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/admin-guide/cgroup-v2.rst |   18 ++++--
>  include/linux/swap.h                    |    3 -
>  mm/memcontrol.c                         |   57 +++++++++++++++++-----
>  mm/vmscan.c                             |   25 ++++++++-
>  4 files changed, 81 insertions(+), 22 deletions(-)
> 
> --- a/Documentation/admin-guide/cgroup-v2.rst~mm-add-swapiness=-arg-to-memoryreclaim
> +++ a/Documentation/admin-guide/cgroup-v2.rst
> @@ -1299,17 +1299,10 @@ PAGE_SIZE multiple when read back.
>  	This is a simple interface to trigger memory reclaim in the
>  	target cgroup.
>  
> -	This file accepts a single key, the number of bytes to reclaim.
> -	No nested keys are currently supported.
> -
>  	Example::
>  
>  	  echo "1G" > memory.reclaim
>  
> -	The interface can be later extended with nested keys to
> -	configure the reclaim behavior. For example, specify the
> -	type of memory to reclaim from (anon, file, ..).
> -
>  	Please note that the kernel can over or under reclaim from
>  	the target cgroup. If less bytes are reclaimed than the
>  	specified amount, -EAGAIN is returned.
> @@ -1321,6 +1314,17 @@ PAGE_SIZE multiple when read back.
>  	This means that the networking layer will not adapt based on
>  	reclaim induced by memory.reclaim.
>  
> +The following nested keys are defined.
> +
> +	  ==========            ================================
> +	  swappiness            Swappiness value to reclaim with
> +	  ==========            ================================
> +
> +	Specifying a swappiness value instructs the kernel to perform
> +	the reclaim with that swappiness value. Note that this has the
> +	same semantics as vm.swappiness applied to memcg reclaim with
> +	all the existing limitations and potential future extensions.
> +
>    memory.peak
>  	A read-only single value file which exists on non-root
>  	cgroups.
> --- a/include/linux/swap.h~mm-add-swapiness=-arg-to-memoryreclaim
> +++ a/include/linux/swap.h
> @@ -410,7 +410,8 @@ extern unsigned long try_to_free_pages(s
>  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  						  unsigned long nr_pages,
>  						  gfp_t gfp_mask,
> -						  unsigned int reclaim_options);
> +						  unsigned int reclaim_options,
> +						  int *swappiness);
>  extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
>  						gfp_t gfp_mask, bool noswap,
>  						pg_data_t *pgdat,
> --- a/mm/memcontrol.c~mm-add-swapiness=-arg-to-memoryreclaim
> +++ a/mm/memcontrol.c
> @@ -53,6 +53,7 @@
>  #include <linux/sort.h>
>  #include <linux/fs.h>
>  #include <linux/seq_file.h>
> +#include <linux/parser.h>
>  #include <linux/vmpressure.h>
>  #include <linux/memremap.h>
>  #include <linux/mm_inline.h>
> @@ -2636,7 +2637,8 @@ static unsigned long reclaim_high(struct
>  		psi_memstall_enter(&pflags);
>  		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
>  							gfp_mask,
> -							MEMCG_RECLAIM_MAY_SWAP);
> +							MEMCG_RECLAIM_MAY_SWAP,
> +							NULL);
>  		psi_memstall_leave(&pflags);
>  	} while ((memcg = parent_mem_cgroup(memcg)) &&
>  		 !mem_cgroup_is_root(memcg));
> @@ -2942,7 +2944,7 @@ retry:
>  
>  	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> -						    gfp_mask, reclaim_options);
> +						    gfp_mask, reclaim_options, NULL);
>  	psi_memstall_leave(&pflags);
>  
>  	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> @@ -3911,7 +3913,7 @@ static int mem_cgroup_resize_max(struct
>  		}
>  
>  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> -					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
> +					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
>  			ret = -EBUSY;
>  			break;
>  		}
> @@ -4025,7 +4027,7 @@ static int mem_cgroup_force_empty(struct
>  			return -EINTR;
>  
>  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> -						  MEMCG_RECLAIM_MAY_SWAP))
> +						  MEMCG_RECLAIM_MAY_SWAP, NULL))
>  			nr_retries--;
>  	}
>  
> @@ -7000,7 +7002,7 @@ static ssize_t memory_high_write(struct
>  		}
>  
>  		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP);
> +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
>  
>  		if (!reclaimed && !nr_retries--)
>  			break;
> @@ -7049,7 +7051,7 @@ static ssize_t memory_max_write(struct k
>  
>  		if (nr_reclaims) {
>  			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
> -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP))
> +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
>  				nr_reclaims--;
>  			continue;
>  		}
> @@ -7179,19 +7181,50 @@ static ssize_t memory_oom_group_write(st
>  	return nbytes;
>  }
>  
> +enum {
> +	MEMORY_RECLAIM_SWAPPINESS = 0,
> +	MEMORY_RECLAIM_NULL,
> +};
> +
> +static const match_table_t tokens = {
> +	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
> +	{ MEMORY_RECLAIM_NULL, NULL },
> +};
> +
>  static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
>  			      size_t nbytes, loff_t off)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>  	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
>  	unsigned long nr_to_reclaim, nr_reclaimed = 0;
> +	int swappiness = -1;
>  	unsigned int reclaim_options;
> -	int err;
> +	char *old_buf, *start;
> +	substring_t args[MAX_OPT_ARGS];
>  
>  	buf = strstrip(buf);
> -	err = page_counter_memparse(buf, "", &nr_to_reclaim);
> -	if (err)
> -		return err;
> +
> +	old_buf = buf;
> +	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
> +	if (buf == old_buf)
> +		return -EINVAL;
> +
> +	buf = strstrip(buf);
> +
> +	while ((start = strsep(&buf, " ")) != NULL) {
> +		if (!strlen(start))
> +			continue;
> +		switch (match_token(start, tokens, args)) {
> +		case MEMORY_RECLAIM_SWAPPINESS:
> +			if (match_int(&args[0], &swappiness))
> +				return -EINVAL;
> +			if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
> +				return -EINVAL;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
>  
>  	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
>  	while (nr_reclaimed < nr_to_reclaim) {
> @@ -7211,7 +7244,9 @@ static ssize_t memory_reclaim(struct ker
>  			lru_add_drain_all();
>  
>  		reclaimed = try_to_free_mem_cgroup_pages(memcg,
> -					batch_size, GFP_KERNEL, reclaim_options);
> +					batch_size, GFP_KERNEL,
> +					reclaim_options,
> +					swappiness == -1 ? NULL : &swappiness);
>  
>  		if (!reclaimed && !nr_retries--)
>  			return -EAGAIN;
> --- a/mm/vmscan.c~mm-add-swapiness=-arg-to-memoryreclaim
> +++ a/mm/vmscan.c
> @@ -92,6 +92,11 @@ struct scan_control {
>  	unsigned long	anon_cost;
>  	unsigned long	file_cost;
>  
> +#ifdef CONFIG_MEMCG
> +	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
> +	int *proactive_swappiness;
> +#endif
> +
>  	/* Can active folios be deactivated as part of reclaim? */
>  #define DEACTIVATE_ANON 1
>  #define DEACTIVATE_FILE 2
> @@ -236,6 +241,13 @@ static bool writeback_throttling_sane(st
>  #endif
>  	return false;
>  }
> +
> +static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
> +{
> +	if (sc->proactive && sc->proactive_swappiness)
> +		return *sc->proactive_swappiness;
> +	return mem_cgroup_swappiness(memcg);
> +}
>  #else
>  static bool cgroup_reclaim(struct scan_control *sc)
>  {
> @@ -251,6 +263,11 @@ static bool writeback_throttling_sane(st
>  {
>  	return true;
>  }
> +
> +static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
> +{
> +	return READ_ONCE(vm_swappiness);
> +}
>  #endif
>  
>  static void set_task_reclaim_state(struct task_struct *task,
> @@ -2351,7 +2368,7 @@ static void get_scan_count(struct lruvec
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  	unsigned long anon_cost, file_cost, total_cost;
> -	int swappiness = mem_cgroup_swappiness(memcg);
> +	int swappiness = sc_swappiness(sc, memcg);
>  	u64 fraction[ANON_AND_FILE];
>  	u64 denominator = 0;	/* gcc */
>  	enum scan_balance scan_balance;
> @@ -2632,7 +2649,7 @@ static int get_swappiness(struct lruvec
>  	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
>  		return 0;
>  
> -	return mem_cgroup_swappiness(memcg);
> +	return sc_swappiness(sc, memcg);
>  }
>  
>  static int get_nr_gens(struct lruvec *lruvec, int type)
> @@ -6549,12 +6566,14 @@ unsigned long mem_cgroup_shrink_node(str
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
> -					   unsigned int reclaim_options)
> +					   unsigned int reclaim_options,
> +					   int *swappiness)
>  {
>  	unsigned long nr_reclaimed;
>  	unsigned int noreclaim_flag;
>  	struct scan_control sc = {
>  		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
> +		.proactive_swappiness = swappiness,
>  		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
>  				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
>  		.reclaim_idx = MAX_NR_ZONES - 1,
> _
> 
> Patches currently in -mm which might be from schatzberg.dan@gmail.com are
> 
> 

-- 
Michal Hocko
SUSE Labs

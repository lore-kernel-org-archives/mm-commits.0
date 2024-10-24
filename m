Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE262FC52
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 09:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729761022; cv=none; b=C/EL0VZZqKlWWU5tXbCvfxb3QmZc/xTZ6x4NHzUfrBVhUd9AKPPNHz9W4Y1m/x9JNkHXy7uXDk0GI5gNxxxGvEyS28M4/YBRxBDCsp5g+zxQTJR/Ymq8UryAvc9UD0sZ1CXwiDIqXXmqtgDdpzBUCJ3EUfv97VdrDvasLY6Z95I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729761022; c=relaxed/simple;
	bh=kF0owm5ghlXcyHKXDz2YYlI3bQaPzE7ESh0MNMU2Ioc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEy+kEEAoGtJ+tGoooFdcQoFBsTdRrQnBr+IMfNlfKrBQZy27EzS00tlWleruNFC7q+HkAFdgXWPbeA17Nozp4DrWhMCsE0QFGSvFXooq1jXTuJQwZwH5jN/wJTlOf8tNn2xUSFVnyUtPmS3lR1jx6Ql3siDgVdigrDK+E1WjAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IWf+Uuew; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IWf+Uuew"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-37d43a9bc03so449466f8f.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729761018; x=1730365818; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X9LoXdthvwTdUdvUT8FIZ+lOtep4g0DZCjOS42GSTK8=;
        b=IWf+UuewMoLceSq/LTu5x41BJ4IkXjlrFpMnd0Ev/YMAq7xhaADeWmwp7JLGVmOxoB
         ICcvm0CoTfj197XAXK5At+jWbyQkRjflkbpbuLQShtHHI0KAi7Sf882ps28mna66I/AY
         e+I3gg5UhARw27QenIJOv9KmzLyGUoFSiO/WPk6w9y7UKxA/pscDli8Pwv2NSIEMWZEz
         4r7/BL2eETU1/DSO2832UtON2ZdFFL2+UXo/1X6wEpL6iMWUPD4Ut35vygVaoVKo2P54
         Fmz5wZe8+VpxB4RMPfzLsQoirkZuHjndqUoKh1JLuqi7/0jQaQ+VT1VatbcuE0QdhUjw
         wdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729761018; x=1730365818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9LoXdthvwTdUdvUT8FIZ+lOtep4g0DZCjOS42GSTK8=;
        b=Avp8RlMxZmx3X35aJpDllruvFZa/ISQrcgcYSLeSyCBL7N6NIk73O0l15pQrzwWbgp
         D7X6PwwAHsKj7Rb9fYMwx8L8l5Ce8yttO2f7q+pnsviPmVzwEjyGL9JJiWbcHc5bgSU1
         tU2phIltZGGgUZDl/Ue4yqG3tS96t62BLI/qQ6yt0yFcN7fClbnG3VcQBn4yqc6C0fCM
         ykqkVlecurZeaglGBayzl5fQV9x++7FHqdjyv+fHcR2FLIXhQoxz+D8hpx7Txv4+Kf8H
         pX/dSRDWYo6RTTe5XOcONF+xk75iuB3lFDcSERkpRAHoubEnHwCa7B+zqTSdLm1s+ybe
         M1jg==
X-Gm-Message-State: AOJu0YwaTCE2nP7p4ozsd79Rbloax+t9MBwnAz8ZqJ3EM61BShVk4KPs
	HcsZs0jg9lFgGIvs9jR4TVQdz5SLmEhk3B13wt8hIx4l0Ane8kE7+o3ml1wx8rA=
X-Google-Smtp-Source: AGHT+IEs87YGRH3B9ZpyIa05wUtX3bTwEGoWK0QtKbsJSeSxfZItVEg1D+ggmRTUb+ZG3oPRZ/wJaA==
X-Received: by 2002:a5d:6048:0:b0:37d:3973:cb8d with SMTP id ffacd0b85a97d-37efcf18c21mr3567583f8f.24.1729761018211;
        Thu, 24 Oct 2024 02:10:18 -0700 (PDT)
Received: from localhost (109-81-81-105.rct.o2.cz. [109.81.81.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a37df9sm10806887f8f.19.2024.10.24.02.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 02:10:17 -0700 (PDT)
Date: Thu, 24 Oct 2024 11:10:16 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, nifan@outlook.com,
	dave@stgolabs.net, dan.j.williams@intel.com,
	a.manzanares@samsung.com, dongjoo.linux.dev@gmail.com
Subject: Re: + mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch
 added to mm-hotfixes-unstable branch
Message-ID: <ZxoO-NEVYaZQbpxN@tiehlicka>
References: <20241023204125.C4DFBC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023204125.C4DFBC4CECC@smtp.kernel.org>

I believe this patch should be dropped. Not only it doesn't really
describes an actual problem I believe it is indeed incorrect as
explained https://lore.kernel.org/all/ZxoEWBakAv64wfhD@tiehlicka/T/#u

On Wed 23-10-24 13:41:25, Andrew Morton wrote:
> From: Dongjoo Seo <dongjoo.linux.dev@gmail.com>
> Subject: mm/page_alloc: fix NUMA stats update for cpu-less nodes
> Date: Wed, 23 Oct 2024 10:50:37 -0700
> 
> In the case of memoryless node, when a process prefers a node with no
> memory(e.g., because it is running on a CPU local to that node), the
> kernel treats a nearby node with memory as the preferred node.  As a
> result, such allocations do not increment the numa_foreign counter on the
> memoryless node, leading to skewed NUMA_HIT, NUMA_MISS, and NUMA_FOREIGN
> stats for the nearest node.
> 
> This patch corrects this issue by:
> 1. Checking if the zone or preferred zone is CPU-less before updating
>    the NUMA stats.
> 2. Ensuring NUMA_HIT is only updated if the zone is not CPU-less.
> 3. Ensuring NUMA_FOREIGN is only updated if the preferred zone is not
>    CPU-less.
> 
> Example Before and After Patch:
> - Before Patch:
>  node0                   node1           node2
>  numa_hit                86333181       114338269            5108
>  numa_miss                5199455               0        56844591
>  numa_foreign            32281033        29763013               0
>  interleave_hit                91              91               0
>  local_node              86326417       114288458               0
>  other_node               5206219           49768        56849702
> 
> - After Patch:
>                             node0           node1           node2
>  numa_hit                 2523058         9225528               0
>  numa_miss                 150213           10226        21495942
>  numa_foreign            17144215         4501270               0
>  interleave_hit                91              94               0
>  local_node               2493918         9208226               0
>  other_node                179351           27528        21495942
> 
> Similarly, in the context of cpuless nodes, this patch ensures that NUMA
> statistics are accurately updated by adding checks to prevent the
> miscounting of memory allocations when the involved nodes have no CPUs. 
> This ensures more precise tracking of memory access patterns accross all
> nodes, regardless of whether they have CPUs or not, improving the overall
> reliability of NUMA stat.  The reason is that page allocation from
> dev_dax, cpuset, memcg ..  comes with preferred allocating zone in cpuless
> node and its hard to track the zone info for miss information.
> 
> Link: https://lkml.kernel.org/r/20241023175037.9125-1-dongjoo.linux.dev@gmail.com
> Signed-off-by: Dongjoo Seo <dongjoo.linux.dev@gmail.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Fan Ni <nifan@outlook.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Adam Manzanares <a.manzanares@samsung.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/page_alloc.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> --- a/mm/page_alloc.c~mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes
> +++ a/mm/page_alloc.c
> @@ -2858,19 +2858,21 @@ static inline void zone_statistics(struc
>  {
>  #ifdef CONFIG_NUMA
>  	enum numa_stat_item local_stat = NUMA_LOCAL;
> +	bool z_is_cpuless = !node_state(zone_to_nid(z), N_CPU);
> +	bool pref_is_cpuless = !node_state(zone_to_nid(preferred_zone), N_CPU);
>  
> -	/* skip numa counters update if numa stats is disabled */
>  	if (!static_branch_likely(&vm_numa_stat_key))
>  		return;
>  
> -	if (zone_to_nid(z) != numa_node_id())
> +	if (zone_to_nid(z) != numa_node_id() || z_is_cpuless)
>  		local_stat = NUMA_OTHER;
>  
> -	if (zone_to_nid(z) == zone_to_nid(preferred_zone))
> +	if (zone_to_nid(z) == zone_to_nid(preferred_zone) && !z_is_cpuless)
>  		__count_numa_events(z, NUMA_HIT, nr_account);
>  	else {
>  		__count_numa_events(z, NUMA_MISS, nr_account);
> -		__count_numa_events(preferred_zone, NUMA_FOREIGN, nr_account);
> +		if (!pref_is_cpuless)
> +			__count_numa_events(preferred_zone, NUMA_FOREIGN, nr_account);
>  	}
>  	__count_numa_events(z, local_stat, nr_account);
>  #endif
> _
> 
> Patches currently in -mm which might be from dongjoo.linux.dev@gmail.com are
> 
> mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch

-- 
Michal Hocko
SUSE Labs

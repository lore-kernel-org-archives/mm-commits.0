Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8986979B87
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717196076; cv=none; b=MsTZ0CAPmeRbi73Zf9rPqyO6jDWtbghZJL33yXLU0rS12VKZ8JNO89B8Hmy0jRAZhvOJbdM7VgEzvd307+yB7jcTE9+fm4SWsM/xbCb5hVFOXLxnPx9hz82O4pRGq5yWwKu7ZMcBPSsnVIPCoRLLQvys5MLOcC0wlQu+WY63CHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717196076; c=relaxed/simple;
	bh=gYvAdNg7s/VUiQlUzAqVC6eRJyjhAfatHVJtjdbrFxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTMI/wgkf4cgJaPdA/AfrYKwBkM+botMRocBERL8y0007DEz3jcFE653Y7WpszV3gaBgQMTDwCFGkAq1inkwOtwjlSJRcFVbFXBo/jEq1PsQFhkIYjQBgBZcCW7JkisBlSGixfQXPGRu8KyCrg0RIVMM/XA2RqUOq+1uMW6g4G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lRrEP4Na; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lRrEP4Na"
X-Envelope-To: akpm@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717196072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx6kKrH2QkxIQrEmfjKk7lchN0Iu7Mr7wWj+gNwo81g=;
	b=lRrEP4NaPrb7a7MOUkknHal/nvbvm1cWAQ250WXSj7fIPJoG008mBm98fwHUW923pKm/f3
	clkw1GBW93K1QTS4J9BtsfFpgAgndkJzUwz+Sz8DoH77JEdNdESk/czHK8QKsomHO/HcZK
	m1GyfCT0osTbrGx0iEcGTrcFcKIjpNo=
X-Envelope-To: mm-commits@vger.kernel.org
X-Envelope-To: yosryahmed@google.com
X-Envelope-To: ying.huang@intel.com
X-Envelope-To: roman.gushchin@linux.dev
X-Envelope-To: oliver.sang@intel.com
X-Envelope-To: muchun.song@linux.dev
X-Envelope-To: mhocko@kernel.org
X-Envelope-To: hannes@cmpxchg.org
X-Envelope-To: fengwei.yin@intel.com
X-Envelope-To: feng.tang@intel.com
Date: Fri, 31 May 2024 15:54:28 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com, 
	ying.huang@intel.com, roman.gushchin@linux.dev, oliver.sang@intel.com, 
	muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org, fengwei.yin@intel.com, 
	feng.tang@intel.com
Subject: Re: + memcg-rearrange-fields-of-mem_cgroup_per_node.patch added to
 mm-unstable branch
Message-ID: <umreni7kauetfdtiwte4fy7w3bgduq4f7sdv7vunl56x36yofu@vipxht5mgmmo>
References: <20240528190057.A650FC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528190057.A650FC3277B@smtp.kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi Andrew,

I couldn't find the following patch in the mm-tree yet. Does this patch
somehow fall through the cracks?

Shakeel

On Tue, May 28, 2024 at 12:00:57PM GMT, Andrew Morton wrote:
> 
> The patch titled
>      Subject: memcg: rearrange fields of mem_cgroup_per_node
> has been added to the -mm mm-unstable branch.  Its filename is
>      memcg-rearrange-fields-of-mem_cgroup_per_node.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-rearrange-fields-of-mem_cgroup_per_node.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Subject: memcg: rearrange fields of mem_cgroup_per_node
> Date: Tue, 28 May 2024 09:40:50 -0700
> 
> Kernel test robot reported [1] performance regression for will-it-scale
> test suite's page_fault2 test case for the commit 70a64b7919cb ("memcg:
> dynamically allocate lruvec_stats").  After inspection it seems like the
> commit has unintentionally introduced false cache sharing.
> 
> After the commit the fields of mem_cgroup_per_node which get read on the
> performance critical path share the cacheline with the fields which get
> updated often on LRU page allocations or deallocations.  This has caused
> contention on that cacheline and the workloads which manipulates a lot of
> LRU pages are regressed as reported by the test report.
> 
> The solution is to rearrange the fields of mem_cgroup_per_node such that
> the false sharing is eliminated.  Let's move all the read only pointers at
> the start of the struct, followed by memcg-v1 only fields and at the end
> fields which get updated often.
> 
> Experiment setup: Ran fallocate1, fallocate2, page_fault1, page_fault2 and
> page_fault3 from the will-it-scale test suite inside a three level memcg
> with /tmp mounted as tmpfs on two different machines, one a single numa
> node and the other one, two node machine.
> 
>  $ ./[testcase]_processes -t $NR_CPUS -s 50
> 
> Results for single node, 52 CPU machine:
> 
> Testcase        base        with-patch
> 
> fallocate1      1031081     1431291  (38.80 %)
> fallocate2      1029993     1421421  (38.00 %)
> page_fault1     2269440     3405788  (50.07 %)
> page_fault2     2375799     3572868  (50.30 %)
> page_fault3     28641143    28673950 ( 0.11 %)
> 
> Results for dual node, 80 CPU machine:
> 
> Testcase        base        with-patch
> 
> fallocate1      2976288     3641185  (22.33 %)
> fallocate2      2979366     3638181  (22.11 %)
> page_fault1     6221790     7748245  (24.53 %)
> page_fault2     6482854     7847698  (21.05 %)
> page_fault3     28804324    28991870 ( 0.65 %)
> 
> Link: https://lkml.kernel.org/r/20240528164050.2625718-1-shakeel.butt@linux.dev
> Fixes: 70a64b7919cb ("memcg: dynamically allocate lruvec_stats")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Yin Fengwei <fengwei.yin@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/memcontrol.h |   22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> --- a/include/linux/memcontrol.h~memcg-rearrange-fields-of-mem_cgroup_per_node
> +++ a/include/linux/memcontrol.h
> @@ -96,23 +96,29 @@ struct mem_cgroup_reclaim_iter {
>   * per-node information in memory controller.
>   */
>  struct mem_cgroup_per_node {
> -	struct lruvec		lruvec;
> +	/* Keep the read-only fields at the start */
> +	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
> +						/* use container_of	   */
>  
>  	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
>  	struct lruvec_stats			*lruvec_stats;
> -
> -	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> -
> -	struct mem_cgroup_reclaim_iter	iter;
> -
>  	struct shrinker_info __rcu	*shrinker_info;
>  
> +	/*
> +	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
> +	 * and update often fields to avoid false sharing. Once v1 stuff is
> +	 * moved in a separate struct, an explicit padding is needed.
> +	 */
> +
>  	struct rb_node		tree_node;	/* RB tree node */
>  	unsigned long		usage_in_excess;/* Set to the value by which */
>  						/* the soft limit is exceeded*/
>  	bool			on_tree;
> -	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
> -						/* use container_of	   */
> +
> +	/* Fields which get updated often at the end. */
> +	struct lruvec		lruvec;
> +	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> +	struct mem_cgroup_reclaim_iter	iter;
>  };
>  
>  struct mem_cgroup_threshold {
> _
> 
> Patches currently in -mm which might be from shakeel.butt@linux.dev are
> 
> memcg-rearrange-fields-of-mem_cgroup_per_node.patch
> 

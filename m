Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615693BB4A
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 07:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782630367; cv=none; b=L7bOsd8lr0+1gqo8SrQj7a+cydlT+8dQgRKUR5+67khpaGAW7l2aEn7DtQ8i3e5JZ+PhCoZsn9jbc1vS2BAmLQtzeNekKCKUBCxYkIb3qN45HGkgAQDRHfLj3LqlYEoILAnpn5Ub69Z/5oBB5QG+NbSL/UAm8WtdnyEmebxWR+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782630367; c=relaxed/simple;
	bh=tVcIf2KTccjOfGiIgWh+53lG+XaRlyAGd0HKzm/evus=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bgnKhT0iKQk5ntcNeWPZNm11/gNsDhXHg8B9gxk6HuDRGI8Px4f/M8PoyzYD/FqJJUFgVRNHVby90+DvioXiiiGNIvOy7cSKSSFScJsNzWswJCvBJ4+54++3UFwm7F5MYQu9bb0Q0hy3Ng1kPMXh39fTCe5cY0GEG9rDeoQzrbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGI5Rk8f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGI5Rk8f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782630364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OupMv3gVdZud0PAPKqKneHQo+lLYHmMMU5DGES05Avc=;
	b=cGI5Rk8f5EBfgft3bReqbvtqsmsihmTfM2kdxMNa3psJ/7mQOq9fpY5esVUiibF9x3Sme/
	82ShaaHjVhGlVhYgjrLJX8QRmDY9iff0LqRqnTfqG5IM6YPYN9Rgh4cF4GqSD08of/nhFN
	FVb4xwHyxaeG9dbjrSlyHsMmO8cUsCI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-lhVajgX-Mny4uSRf--BwQQ-1; Sun,
 28 Jun 2026 03:05:59 -0400
X-MC-Unique: lhVajgX-Mny4uSRf--BwQQ-1
X-Mimecast-MFC-AGG-ID: lhVajgX-Mny4uSRf--BwQQ_1782630356
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41810195609E;
	Sun, 28 Jun 2026 07:05:55 +0000 (UTC)
Received: from [10.2.16.22] (unknown [10.2.16.22])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 02507195608E;
	Sun, 28 Jun 2026 07:05:47 +0000 (UTC)
Message-ID: <5e86b222-1c57-4d9d-8a0a-dfba18eac457@redhat.com>
Date: Sun, 28 Jun 2026 03:05:46 -0400
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch added
 to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, yuanchu@google.com, weixugc@google.com, vbabka@kernel.org,
 tj@kernel.org, surenb@google.com, sj@kernel.org, shikemeng@huaweicloud.com,
 shakeel.butt@linux.dev, rppt@kernel.org, rientjes@google.com,
 nphamcs@gmail.com, mkoutny@suse.com, mhocko@suse.com, ljs@kernel.org,
 liam@infradead.org, kasong@tencent.com, jackmanb@google.com,
 hannes@cmpxchg.org, david@kernel.org, chrisl@kernel.org,
 baoquan.he@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 gourry@gourry.net
References: <20260628063113.99A031F000E9@smtp.kernel.org>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260628063113.99A031F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


On 6/28/26 2:31 AM, Andrew Morton wrote:
> The patch titled
>       Subject: mm: constify oom_control, scan_control, and alloc_context nodemask
> has been added to the -mm mm-new branch.  Its filename is
>       mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
>
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
>
> This patch will later appear in the mm-new branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
>
> The mm-new branch of mm.git is not included in linux-next
>
> If a few days of testing in mm-new is successful, the patch will me moved
> into mm.git's mm-unstable branch, which is included in linux-next
>
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>
> ------------------------------------------------------
> From: Gregory Price <gourry@gourry.net>
> Subject: mm: constify oom_control, scan_control, and alloc_context nodemask
> Date: Mon, 8 Jun 2026 20:29:19 -0400
>
> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
>
> Link: https://lore.kernel.org/20260609002919.3967782-1-gourry@gourry.net
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Tested-by: SeongJae Park <sj@kernel.org>
> Acked-by: SeongJae Park <sj@kernel.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michal KoutnÃ½ <mkoutny@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   include/linux/cpuset.h |    4 ++--
>   include/linux/mm.h     |    4 ++--
>   include/linux/mmzone.h |    6 +++---
>   include/linux/oom.h    |    2 +-
>   include/linux/swap.h   |    2 +-
>   kernel/cgroup/cpuset.c |    2 +-
>   mm/internal.h          |    2 +-
>   mm/mmzone.c            |    5 +++--
>   mm/page_alloc.c        |    6 +++---
>   mm/show_mem.c          |    9 ++++++---
>   mm/vmscan.c            |    6 +++---
>   11 files changed, 26 insertions(+), 22 deletions(-)
>
> --- a/include/linux/cpuset.h~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/include/linux/cpuset.h
> @@ -83,7 +83,7 @@ extern bool cpuset_cpus_allowed_fallback
>   extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>   #define cpuset_current_mems_allowed (current->mems_allowed)
>   void cpuset_init_current_mems_allowed(void);
> -int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
> +int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask);
>   
>   extern bool cpuset_current_node_allowed(int node, gfp_t gfp_mask);
>   
> @@ -224,7 +224,7 @@ static inline nodemask_t cpuset_mems_all
>   #define cpuset_current_mems_allowed (node_states[N_MEMORY])
>   static inline void cpuset_init_current_mems_allowed(void) {}
>   
> -static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
> +static inline int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>   {
>   	return 1;
>   }
> --- a/include/linux/mm.h~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/include/linux/mm.h
> @@ -4043,7 +4043,7 @@ extern int __meminit early_pfn_to_nid(un
>   extern void mem_init(void);
>   extern void __init mmap_init(void);
>   
> -extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
> +extern void __show_mem(unsigned int flags, const nodemask_t *nodemask, int max_zone_idx);
>   static inline void show_mem(void)
>   {
>   	__show_mem(0, NULL, MAX_NR_ZONES - 1);
> @@ -4053,7 +4053,7 @@ extern void si_meminfo(struct sysinfo *
>   extern void si_meminfo_node(struct sysinfo *val, int nid);
>   
>   extern __printf(3, 4)
> -void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
> +void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...);
>   
>   extern void setup_per_cpu_pageset(void);
>   
> --- a/include/linux/mmzone.h~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/include/linux/mmzone.h
> @@ -1815,7 +1815,7 @@ static inline int zonelist_node_idx(cons
>   
>   struct zoneref *__next_zones_zonelist(struct zoneref *z,
>   					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes);
> +					const nodemask_t *nodes);
>   
>   /**
>    * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
> @@ -1834,7 +1834,7 @@ struct zoneref *__next_zones_zonelist(st
>    */
>   static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
>   					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes)
> +					const nodemask_t *nodes)
>   {
>   	if (likely(!nodes && zonelist_zone_idx(z) <= highest_zoneidx))
>   		return z;
> @@ -1860,7 +1860,7 @@ static __always_inline struct zoneref *n
>    */
>   static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
>   					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes)
> +					const nodemask_t *nodes)
>   {
>   	return next_zones_zonelist(zonelist->_zonerefs,
>   							highest_zoneidx, nodes);
> --- a/include/linux/oom.h~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/include/linux/oom.h
> @@ -30,7 +30,7 @@ struct oom_control {
>   	struct zonelist *zonelist;
>   
>   	/* Used to determine mempolicy */
> -	nodemask_t *nodemask;
> +	const nodemask_t *nodemask;
>   
>   	/* Memory cgroup in which oom is invoked, or NULL for global oom */
>   	struct mem_cgroup *memcg;
> --- a/include/linux/swap.h~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/include/linux/swap.h
> @@ -345,7 +345,7 @@ extern void swap_setup(void);
>   /* linux/mm/vmscan.c */
>   extern unsigned long zone_reclaimable_pages(struct zone *zone);
>   extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> -					gfp_t gfp_mask, nodemask_t *mask);
> +					gfp_t gfp_mask, const nodemask_t *mask);
>   unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
>   
>   #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
> --- a/kernel/cgroup/cpuset.c~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/kernel/cgroup/cpuset.c
> @@ -4157,7 +4157,7 @@ nodemask_t cpuset_mems_allowed(struct ta
>    *
>    * Are any of the nodes in the nodemask allowed in current->mems_allowed?
>    */
> -int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
> +int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>   {
>   	return nodes_intersects(*nodemask, current->mems_allowed);
>   }
> --- a/mm/internal.h~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/mm/internal.h
> @@ -675,7 +675,7 @@ void page_alloc_sysctl_init(void);
>    */
>   struct alloc_context {
>   	struct zonelist *zonelist;
> -	nodemask_t *nodemask;
> +	const nodemask_t *nodemask;
>   	struct zoneref *preferred_zoneref;
>   	int migratetype;
>   
> --- a/mm/mmzone.c~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/mm/mmzone.c
> @@ -43,7 +43,8 @@ struct zone *next_zone(struct zone *zone
>   	return zone;
>   }
>   
> -static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
> +static inline int zref_in_nodemask(struct zoneref *zref,
> +				   const nodemask_t *nodes)
>   {
>   #ifdef CONFIG_NUMA
>   	return node_isset(zonelist_node_idx(zref), *nodes);
> @@ -55,7 +56,7 @@ static inline int zref_in_nodemask(struc
>   /* Returns the next zone at or below highest_zoneidx in a zonelist */
>   struct zoneref *__next_zones_zonelist(struct zoneref *z,
>   					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes)
> +					const nodemask_t *nodes)
>   {
>   	/*
>   	 * Find the next suitable zone to use for the allocation.
> --- a/mm/page_alloc.c~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/mm/page_alloc.c
> @@ -3979,7 +3979,7 @@ try_this_zone:
>   	return NULL;
>   }
>   
> -static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
> +static void warn_alloc_show_mem(gfp_t gfp_mask, const nodemask_t *nodemask)
>   {
>   	unsigned int filter = SHOW_MEM_FILTER_NODES;
>   
> @@ -3999,7 +3999,7 @@ static void warn_alloc_show_mem(gfp_t gf
>   	mem_cgroup_show_protected_memory(NULL);
>   }
>   
> -void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
> +void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...)
>   {
>   	struct va_format vaf;
>   	va_list args;
> @@ -4695,7 +4695,7 @@ check_retry_cpuset(int cpuset_mems_cooki
>   	return false;
>   }
>   
> -static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
> +static void check_alloc_stall_warn(gfp_t gfp_mask, const nodemask_t *nodemask,
>   				unsigned int order, unsigned long alloc_start_time)
>   {
>   	static DEFINE_SPINLOCK(alloc_stall_lock);
> --- a/mm/show_mem.c~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/mm/show_mem.c
> @@ -116,7 +116,8 @@ void si_meminfo_node(struct sysinfo *val
>    * Determine whether the node should be displayed or not, depending on whether
>    * SHOW_MEM_FILTER_NODES was passed to show_free_areas().
>    */
> -static bool show_mem_node_skip(unsigned int flags, int nid, nodemask_t *nodemask)
> +static bool show_mem_node_skip(unsigned int flags, int nid,
> +			       const nodemask_t *nodemask)
>   {
>   	if (!(flags & SHOW_MEM_FILTER_NODES))
>   		return false;
> @@ -177,7 +178,8 @@ static bool node_has_managed_zones(pg_da
>    * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
>    *   cpuset.
>    */
> -static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> +static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
> +			    int max_zone_idx)
>   {
>   	unsigned long free_pcp = 0;
>   	int cpu, nid;
> @@ -402,7 +404,8 @@ static void show_free_areas(unsigned int
>   	show_swap_cache_info();
>   }
>   
> -void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> +void __show_mem(unsigned int filter, const nodemask_t *nodemask,
> +		int max_zone_idx)
>   {
>   	unsigned long total = 0, reserved = 0, highmem = 0;
>   	struct zone *zone;
> --- a/mm/vmscan.c~mm-constify-oom_control-scan_control-and-alloc_context-nodemask
> +++ a/mm/vmscan.c
> @@ -79,7 +79,7 @@ struct scan_control {
>   	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
>   	 * are scanned.
>   	 */
> -	nodemask_t	*nodemask;
> +	const nodemask_t *nodemask;
>   
>   	/*
>   	 * The memory cgroup that hit its limit and as a result is the
> @@ -6594,7 +6594,7 @@ static bool allow_direct_reclaim(pg_data
>    * happens, the page allocator should not consider triggering the OOM killer.
>    */
>   static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
> -					nodemask_t *nodemask)
> +				    const nodemask_t *nodemask)
>   {
>   	struct zoneref *z;
>   	struct zone *zone;
> @@ -6674,7 +6674,7 @@ out:
>   }
>   
>   unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> -				gfp_t gfp_mask, nodemask_t *nodemask)
> +				gfp_t gfp_mask, const nodemask_t *nodemask)
>   {
>   	unsigned long nr_reclaimed;
>   	struct scan_control sc = {
> _
>
> Patches currently in -mm which might be from gourry@gourry.net are
>
> mm-constify-oom_control-scan_control-and-alloc_context-nodemask.patch
>
Acked-by: Waiman Long <longman@redhat.com>


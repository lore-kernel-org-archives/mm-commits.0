Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072C2264FBD
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 02:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780021156; cv=none; b=dp7SsWWJIaTs42vvxJkzM6RAdRj5GltwO2pgxoFFDPy46zhHIwGvGdPy/2AaPtKUwMGuwboQWHA/Mh3+i+EEpHZUyehIBQlrCcX4Gti5QcbHWJfaFNnNoJfQRLByrCTUoj//NAfy9RuCSiN0mdaY73uW/RT+bZNoiOj5JeFMemU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780021156; c=relaxed/simple;
	bh=5ZVTgs603uCLqSJTP8B0gbf+RGmIc+Qy7pmYX8dj/VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSUjHWgE8B1aaDPItl2k/YipsRp/WE/liwzaicVUlwfGAvGCFX0io46rBxnME9CU8KGNidKG/iyscD+j23XZXDT4r/zMx89ZKBgtRoDVtSa71jurdSdEzzCxFCEFNbjFX6PE5+z3RdJkTXunAkjVH3MKXzmTwxu8CIqOB34QIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oYouX2JY; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oYouX2JY"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c82471904fcso5388536a12.2
        for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 19:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780021153; x=1780625953; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pzBFPmaqR8/S+R6Sx9iC337HkM9qwhh6v83m9u0ywYI=;
        b=oYouX2JYRYk3IpT6GZqc1Ap9mFq/eZ3SkI7Gtksq3bKmdLKK1e5O5hH+R3TmVz7mff
         DcgBuhHCU4KyOUW/BHLv/qnwS05TmAajhNR/jZHAS0ZBMRja28gMKzNkdWwmcQHlPdhR
         k4S7PDstYrVKvJj0Fat7oFMi14JmyJ3ZYyBKGGiiz63E+LrFQVuJazTxAe7XFN1WLurx
         l5HWKwmwBJ64kg9llXhaI8z92P30Y6AFOBaFR7VtobH6gxhb937piWUwMiMhv1o+u+D3
         I/l/DG4KEa09zxMDJAM1egUr/D7EPSBi8d1A+0LhfDdreN6BsgRpQbnELG1nhZ1dvWQj
         yutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780021153; x=1780625953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzBFPmaqR8/S+R6Sx9iC337HkM9qwhh6v83m9u0ywYI=;
        b=Yl8JzTXtIFEOXXb7WCjGy3ZCenL5zhTMGruQawHjf9banr3sf03D+SolcL0lP4CdeB
         6kc8gSvMjNftWzSeGkPcNIKfn2LD3R70+tsDtUDfH3u2W1blD+uN27Svh9/Rgyw0Av7A
         zfMEwlqqC9JvaE7HLt1axKJFPmxCo6nqHQLCL8rrFE5vAHP08DtJNs8ZxwF5aeXowIgA
         HT/GJfCQlc/zcdiK0lsg8/6rNWNEfEdSKWeQ864CBcEvF1MRnQOu1MyDgm+lHepFtXI9
         YG9Z0zRUUHDEPvmAdqQMf/yGRwLgh/ibnt7IPXSXXofIl+4EVKqhzaAAVhbCt4Siaf4q
         wuNg==
X-Forwarded-Encrypted: i=1; AFNElJ/7jcMW9lcsA7W9gSpocVFpWVCTEAw9JlLqxJhpJEJvjazfxijGqhiZkpAaME81pKtPtOgAau28hR2r@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6CQHVmbMFOqAsjKwq49e5Fk62MokU8h9xJML1nUV1GqvGxz/5
	cXsb9BsJYZZ5gRAymQf01O/iQN+lVofmhRK8JzYgktMCeaDpyV7xpzEa
X-Gm-Gg: Acq92OEHUaFK0fZGFeEczTuo7Y0Sh4jHpS98RUGkViwGrBy0h+E3iLQAbni4pBwZnku
	8gdlukbi3ao+rSImpTNX9MerNGuMUS7S/AunxuyzoarOuXvWqbtr30B9FmnKxyYdNwX8JnRB3Ze
	qjF0to/LoShrEzVYAqytsWYNuTQMMewEqmDuPQDjzt7RvKKRn4pynbx1MSDU/fk8EiqxOKNRHJY
	yGR7pI2UxYutpCmxaZxwsEI5ZkTJkibdm3G8VD2x1Sxbwx5dw4o5j3EoZAipRphBDHTb5+the8/
	C01tr6QjTOrzBr6h/oHPqAMHcC6FMC8nS19tItq34uB0GH6InjsyygbHAf2wSDEcpXa9Qk9D0XS
	axzyA+LM8IGA91/x+hM3vlDvo0I9vKGmHYi2dBhiOYBlcH3J+ix/8BXTX1PqjkOcO2aq2ct+WSB
	OKjXghc2B9v6vmUsf78k7CCYZIkqW8oijemCONSMJMyIsYdg6WncqPBARFWk7o7AITofiGdMKse
	0LNYVk=
X-Received: by 2002:a05:6a21:6f07:b0:3a0:c2b4:d976 with SMTP id adf61e73a8af0-3b412384a64mr799579637.44.1780021153265;
        Thu, 28 May 2026 19:19:13 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85772ba4adsm147136a12.23.2026.05.28.19.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 19:19:12 -0700 (PDT)
Date: Fri, 29 May 2026 10:19:07 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Kairui Song <kasong@tencent.com>, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [akpm-mm:mm-unstable 199/420] mm/memcontrol-v1.c:651:24: error:
 call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <ahj2pRAit5WPzyQ2@KASONG-MC4>
References: <202605281711.bSeZlErK-lkp@intel.com>
 <20260528144502.dd586e865b677051ac7c776b@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528144502.dd586e865b677051ac7c776b@linux-foundation.org>

On Thu, May 28, 2026 at 02:45:02PM +0800, Andrew Morton wrote:
> On Thu, 28 May 2026 17:58:34 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   8a74e22643189e0ae339afc91110ddb4cab1941b
> > commit: 93680c2b51fa1f84fe50800b71140dbd283372b8 [199/420] mm/memcg, swap: store cgroup id in cluster table directly
> > config: arm-randconfig-004-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/config)
> > compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> > rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605281711.bSeZlErK-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> mm/memcontrol-v1.c:651:24: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
> >          |                               ^
> >    mm/memcontrol-v1.c:721:31: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >      721 |         id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
> >          |                                      ^
> >    2 errors generated.
> 
> OK, CONFIG_SWAP=n.

I though we have already fixed this, and this is trigger by the bot
just because its not a squashed commit, so building while iterating
the commit will still fail? Or maybe I have some misunderstanding
here..

https://lore.kernel.org/linux-mm/20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org/

> 
> We could hack in a stub for swp_cluster_offset(), but why are we
> compiling __memcg1_swapout() at all when CONFIG_SWAP=n?  Ditto
> memcg1_swapin().
> 
> How does the below look?
> 
> Really this should be done as a preparatory thing, but we'll survive.
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: memcgv1: don't compile swap functions when CONFIG_SWAP=n
> Date: Thu May 28 02:35:22 PM PDT 2026
> 
> Stub these out to save some dead code and to fix a build error with the
> upcoming "mm/memcg, swap: store cgroup id in cluster table directly".
> 
> Link: https://lore.kernel.org/202605281711.bSeZlErK-lkp@intel.com
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/memcontrol.h |   15 ++++++++++-----
>  mm/memcontrol-v1.c         |    2 ++
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> --- a/include/linux/memcontrol.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> +++ a/include/linux/memcontrol.h
> @@ -1900,9 +1900,6 @@ static inline void mem_cgroup_exit_user_
>  	current->in_user_fault = 0;
>  }
>  
> -void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
> -void memcg1_swapin(struct folio *folio);
> -
>  #else /* CONFIG_MEMCG_V1 */
>  static inline
>  unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
> @@ -1930,6 +1927,15 @@ static inline void mem_cgroup_exit_user_
>  {
>  }
>  
> +#endif /* CONFIG_MEMCG_V1 */
> +
> +#if defined(CONFIG_MEMCG_V1) && defined(CONFIG_SWAP)
> +
> +void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
> +void memcg1_swapin(struct folio *folio);
> +
> +#else
> +
>  static inline void __memcg1_swapout(struct folio *folio,
>  		struct swap_cluster_info *ci)
>  {
> @@ -1938,7 +1944,6 @@ static inline void __memcg1_swapout(stru
>  static inline void memcg1_swapin(struct folio *folio)
>  {
>  }
> -
> -#endif /* CONFIG_MEMCG_V1 */
> +#endif
>  
>  #endif /* _LINUX_MEMCONTROL_H */
> --- a/mm/memcontrol-v1.c~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> +++ a/mm/memcontrol-v1.c
> @@ -604,6 +604,7 @@ void memcg1_commit_charge(struct folio *
>  	local_irq_restore(flags);
>  }
>  
> +#ifdef CONFIG_SWAP
>  /**
>   * __memcg1_swapout - transfer a memsw charge to swap
>   * @folio: folio whose memsw charge to transfer
> @@ -723,6 +724,7 @@ void memcg1_swapin(struct folio *folio)
>  	swap_cluster_unlock(ci);
>  	mem_cgroup_uncharge_swap(id, nr_pages);
>  }
> +#endif
>  
>  void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
>  			   unsigned long nr_memory, int nid)
> _
> 

Thanks again, looks good to me, the simple is simple and it looks the
same thing I posted previously:
https://lore.kernel.org/linux-mm/ag0mdxBWcrZ8hxPP@KASONG-MC4/

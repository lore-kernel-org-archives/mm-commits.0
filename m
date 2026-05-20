Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F882367B97
	for <mm-commits@vger.kernel.org>; Wed, 20 May 2026 06:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779258229; cv=none; b=h374xcYbps5GRya4f1LJXzsoTysPvX+0xia8x+4I7j6qqq1Z+rb4btJoTuiRFhlJoKD4la/6iLWwxVXHTDx7kNZ9wvqBIX9v4QAYBS7iWjUcuI3M8nOIhW3b+7Lvb7mYsbIyLSjs0i8MfRhzef22Tw0I95IfhL2OaSAARZwyMa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779258229; c=relaxed/simple;
	bh=4eh7OI4YeUKaNoJbnkWoq3HktROaoLSIjldeZv3g3d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHRjgLAHvAZtRkkgzKWiXkWFBhkueEFobhFwo9O2+tSBdfyb6iWSYglH42/2U6unENVnQB/7aH1fTEm6mM74KOtDOf07F/OPjF4UUYX1GVwSlQfudGGUhUw36f4vWCEMrKn6mBqgAxQ2ldz8+vp+aLUWMiMfzHYuk28IHnILzJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WGZHpB9U; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WGZHpB9U"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bcd3ac3307so25013565ad.0
        for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 23:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779258227; x=1779863027; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1suTFoH1EtOKjY9tGXkwvOUanGUsdAx5moIqDv9CmZQ=;
        b=WGZHpB9ULMEM14hUHHVLBl5ttE8PtH8p9z+aIOgCyALWYfU73rAIsjBjlF7DtcTLrT
         AIIsdkhy03KWER2xg/seCmrA8V4AtPMfjvaHP5/5UL2HSKHY4tKus/kLfvIfgb5pwLFE
         0iOgXQkYghj2+XbHrPCsay5xjAFRltcGKbuJVSPopsBJBjG2Zyn3LOfZzLb+hbHgejzI
         gOVUpmb8uj9zMltFF3+oviAXai0wCPqU+wS1zbpGRI9hzYKyXcmU1moZ/0hve6nPK0FC
         KeFThdIxbClzUi9SOaUlMFL8k8/e1DkkCtHsOAAFz7I488xafx6DxmqjhlKiLmVYC2e2
         mi1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779258227; x=1779863027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1suTFoH1EtOKjY9tGXkwvOUanGUsdAx5moIqDv9CmZQ=;
        b=hmRfeN6r6MXFYZyS3BhlAqE/+fUhXzWm+zWh8MtmPJ6uik0igS5YMC7k3BsxzjhS34
         gG/Qpaxrngptdr0rEXrlDumQ9+ER7iqBRVessGArIJnzU2zj3MwcYEgilZ7WEthQn1VV
         JcYRZfmu5WkS9ipEZsnmvZrI0GIvo2C1tX1OrI8KdrafpN3V6eVfKuNruwsQQAbmlL8m
         lC8rH5Iut6zqKrDCdlmbTYkaEQMYJ28yuK1gV2+6TYi5I8eR3YzzPqLnblzImIsSG3Q4
         o2X5Q1/OnRNjAZxE7d9Y84qpatGbdNEhRL7lhXjUgxF9dgTWLNo2gsWJ155oMNHKZHI7
         M8RA==
X-Forwarded-Encrypted: i=1; AFNElJ+rLy9K+nWeXiTPqHR0T3yfAI7weiSug5MsMrOHwG76V6+HQ/c/xqkVH32nC1jFZbOz3l2+lTWZo2PT@vger.kernel.org
X-Gm-Message-State: AOJu0YzpSlejoV8Bxj2bccSsjAabhdgqtGmxtLCyYkzU5xyfv8W/xOGw
	PNNpHmn8yftVaFQmwJ58Sm2GSq/zr71i9Upo4aG2ZBOXzuyMnU8DE15zYSznvibkeiF2/Q==
X-Gm-Gg: Acq92OGAoFJJlBXdI6PduAInz6LRQvi4/LKz0ANDau9XNe1JC8lUqGokarRtdkuwp9w
	zba5+8FYvZ1TdMPbDJ3DQ+l/Suin39tKv+8Vzzi4+s+LvMKwhIlnjvOiegXNv0e5UPE81JW3TOk
	QAzp8nXcRfRphixlX49JOAe3pYo7qEkT6JeyECl3xTsr/DbjY29Kyb28tZmK5CnxHrKDdG3NFZB
	ozjGM0PBPuoiChfMtFwjUjM7O0M3lraNO6ZueL+Bfha9HXWPcn1n1mSwE4A6fqUASLIAYV6Tlsx
	RyvDA3nMxlv4vhhtPRUCJsJ9k/zUkTaUZBbTX0fQMZkF6NcsOM+8x6uwFo4mZo6joLtA61Kd0yJ
	TeynCpavqGCKSoMha5MNc5gmRMXZ+ep90mUHVe7Aa99PzfktVri5Y3E1fKSZq2yIvvdIUU+5V9g
	4nCFQ5WNIPbSJxXyC15BAdCE0nRtNjIQgEJCh7GX61SwNzzc+0Wie40c8bgRwb+34y/+1d
X-Received: by 2002:a17:903:37ce:b0:2bd:a403:1d82 with SMTP id d9443c01a7336-2bda4031ef2mr184057385ad.21.1779258226945;
        Tue, 19 May 2026 23:23:46 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fb35sm204241485ad.12.2026.05.19.23.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 23:23:46 -0700 (PDT)
Date: Wed, 20 May 2026 14:23:41 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Kairui Song <kasong@tencent.com>, 
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 323/362] mm/memcontrol-v1.c:651:31: error:
 implicit declaration of function 'swp_cluster_offset'
Message-ID: <ag0mdxBWcrZ8hxPP@KASONG-MC4>
References: <202605200624.e9eMvkBW-lkp@intel.com>
 <20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org>

On Tue, May 19, 2026 at 03:26:20PM +0800, Andrew Morton wrote:
> On Wed, 20 May 2026 06:16:25 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   ac33089a65a951edf4365b1ff7fbe5b5e8062d06
> > commit: dc1675a14ba774891fdf5212b7bedc7f50661862 [323/362] mm/memcg, swap: store cgroup id in cluster table directly
> > config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/config)
> > compiler: sh4-linux-gcc (GCC) 15.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605200624.e9eMvkBW-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    mm/memcontrol-v1.c: In function '__memcg1_swapout':
> > >> mm/memcontrol-v1.c:651:31: error: implicit declaration of function 'swp_cluster_offset' [-Wimplicit-function-declaration]
> >      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
> >          |                               ^~~~~~~~~~~~~~~~~~
> 
> Thanks.  I added the below to fix the build, but I've no reason to
> believe that it's correct.
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> Date: Tue May 19 03:23:38 PM PDT 2026
> 
> "fix" CONFIG_SWAP=n build
> 
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Youngjun Park <youngjun.park@lge.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/swap.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/mm/swap.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
> +++ a/mm/swap.h
> @@ -482,5 +482,11 @@ static inline int swap_zeromap_batch(swp
>  {
>  	return 0;
>  }
> +
> +static inline unsigned int swp_cluster_offset(swp_entry_t entry)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_SWAP */
>  #endif /* _MM_SWAP_H */
> _
> 

Thanks for the fix, this is not wrong at the moment, memcg1's swap code
is dead code with !CONFIG_SWAP so filling anything there is fine.

I didn't notice that memcg1 won't filter out the swap code when
!CONFIG_SWAP. So following patch should be better:

Just eliminate the dead code. It should be put before this series,
there will be a minor conflict in memcontrol.h as a few declarations
are moved by this, but should be easy to solve. I can send a rebased
version of this series if the conflict is too trouble some to solve,
or we can clean this up later and just keep this dummy swp_cluster_offset
for now.

From 55dd3196e47f3d148edb01f2a37057e6af4bcdaf Mon Sep 17 00:00:00 2001
From: Kairui Song <kasong@tencent.com>
Date: Wed, 20 May 2026 11:14:13 +0800
Subject: [PATCH] mm/memcg: v1: guard swap helpers under CONFIG_SWAP

These helpers are essentially dead weight when CONFIG_SWAP is disabled,
so just guard them with the right ifdef, we will have a smaller vmlinux:

./scripts/bloat-o-meter mm/memcontrol-v1.o.old mm/memcontrol-v1.o
add/remove: 0/3 grow/shrink: 0/0 up/down: 0/-473 (-473)
Function                                     old     new   delta
__UNIQUE_ID_addressable___SCK__preempt_schedule_53       8       -      -8
memcg1_swapin                                 12       -     -12
memcg1_swapout                               453       -    -453
Total: Before=17932, After=17459, chg -2.64%

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 11 ++++++-----
 mm/memcontrol-v1.c         |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b..1e02f0afecb6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1899,9 +1899,6 @@ static inline void mem_cgroup_exit_user_fault(void)
 	current->in_user_fault = 0;
 }
 
-void memcg1_swapout(struct folio *folio, swp_entry_t entry);
-void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
-
 #else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -1928,7 +1925,12 @@ static inline void mem_cgroup_enter_user_fault(void)
 static inline void mem_cgroup_exit_user_fault(void)
 {
 }
+#endif /* CONFIG_MEMCG_V1 */
 
+#if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG_V1)
+void memcg1_swapout(struct folio *folio, swp_entry_t entry);
+void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages);
+#else
 static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 {
 }
@@ -1936,7 +1938,6 @@ static inline void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 static inline void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 {
 }
-
-#endif /* CONFIG_MEMCG_V1 */
+#endif
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe71..8fb02dc5b259 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -603,6 +603,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_SWAP
 /**
  * memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
@@ -704,6 +705,7 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 		mem_cgroup_uncharge_swap(entry, nr_pages);
 	}
 }
+#endif /* CONFIG_SWAP */
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid)
-- 
2.54.0

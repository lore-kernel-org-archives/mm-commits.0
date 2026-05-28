Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3827D35DA65;
	Thu, 28 May 2026 21:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780004705; cv=none; b=rjAVr9Mb/oQAHEeya6RPUQQwWugy8LwG5U8ccT94M6JWpni/l4Qc7bUPeT73t3ADUezqrPODSAZ+h/bL/xZhxexYdxTCZCpNDfntUJkgMgWOn8E/6N8prBKW/mFY5wMJxq+ncmNjSGfI+OFKX6w7pEHmxbBlA1Cz6KxhUFASupg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780004705; c=relaxed/simple;
	bh=sjnecVX5nIOcMHRYythtH58Mqtr54+a+OfryVaoyfhg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Mu27URXyDsdtuG9jFkxgicEb1vghTotMHnONGgrytGvpJw4OPc9fDHJ645yKjSARGQm78Ao0Q8EpW/RNEyP1x7mp5sXpKnPR4YNVuIh6ON1bJoJeKee+QOn94oQC+i25YnCO+HW1HM42P7IybHSsFkK9dW0ffPZTAtfqbf5/YGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1D3p3fU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1D3p3fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637F41F000E9;
	Thu, 28 May 2026 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780004703;
	bh=T/hmRzBBegpzhry5lne7It+TrGap2MWq6h+hhKaTIuQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t1D3p3fUYTz13Y/1X2Ddt/Owx9g7PCHJ4UibSTPCgBR0VYK4aY0aurH9R8E/7Gm99
	 uihO9PJS+JxjM6JU6p5zWhT3gQV1IXXryri9yqX2hll0U5ycz70bv91yHejTzNNtWH
	 4tDnwBx/KFPDMuI0DX4ny6N9IJ8tW6yQ3lmvaxi4=
Date: Thu, 28 May 2026 14:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Kairui Song <kasong@tencent.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [akpm-mm:mm-unstable 199/420] mm/memcontrol-v1.c:651:24: error:
 call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not
 support implicit function declarations
Message-Id: <20260528144502.dd586e865b677051ac7c776b@linux-foundation.org>
In-Reply-To: <202605281711.bSeZlErK-lkp@intel.com>
References: <202605281711.bSeZlErK-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 May 2026 17:58:34 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   8a74e22643189e0ae339afc91110ddb4cab1941b
> commit: 93680c2b51fa1f84fe50800b71140dbd283372b8 [199/420] mm/memcg, swap: store cgroup id in cluster table directly
> config: arm-randconfig-004-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605281711.bSeZlErK-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> mm/memcontrol-v1.c:651:24: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
>          |                               ^
>    mm/memcontrol-v1.c:721:31: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      721 |         id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
>          |                                      ^
>    2 errors generated.

OK, CONFIG_SWAP=n.

We could hack in a stub for swp_cluster_offset(), but why are we
compiling __memcg1_swapout() at all when CONFIG_SWAP=n?  Ditto
memcg1_swapin().

How does the below look?

Really this should be done as a preparatory thing, but we'll survive.



From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcgv1: don't compile swap functions when CONFIG_SWAP=n
Date: Thu May 28 02:35:22 PM PDT 2026

Stub these out to save some dead code and to fix a build error with the
upcoming "mm/memcg, swap: store cgroup id in cluster table directly".

Link: https://lore.kernel.org/202605281711.bSeZlErK-lkp@intel.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++++++++-----
 mm/memcontrol-v1.c         |    2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
+++ a/include/linux/memcontrol.h
@@ -1900,9 +1900,6 @@ static inline void mem_cgroup_exit_user_
 	current->in_user_fault = 0;
 }
 
-void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
-void memcg1_swapin(struct folio *folio);
-
 #else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -1930,6 +1927,15 @@ static inline void mem_cgroup_exit_user_
 {
 }
 
+#endif /* CONFIG_MEMCG_V1 */
+
+#if defined(CONFIG_MEMCG_V1) && defined(CONFIG_SWAP)
+
+void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
+void memcg1_swapin(struct folio *folio);
+
+#else
+
 static inline void __memcg1_swapout(struct folio *folio,
 		struct swap_cluster_info *ci)
 {
@@ -1938,7 +1944,6 @@ static inline void __memcg1_swapout(stru
 static inline void memcg1_swapin(struct folio *folio)
 {
 }
-
-#endif /* CONFIG_MEMCG_V1 */
+#endif
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol-v1.c~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
+++ a/mm/memcontrol-v1.c
@@ -604,6 +604,7 @@ void memcg1_commit_charge(struct folio *
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_SWAP
 /**
  * __memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
@@ -723,6 +724,7 @@ void memcg1_swapin(struct folio *folio)
 	swap_cluster_unlock(ci);
 	mem_cgroup_uncharge_swap(id, nr_pages);
 }
+#endif
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid)
_


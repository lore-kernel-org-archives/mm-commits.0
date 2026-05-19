Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D813ED13B;
	Tue, 19 May 2026 22:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779229584; cv=none; b=oaAXLHKDNEu4MAzMjEP3fEgJi+A5CT3o3G6yyPxUH6LHLDvFFrH211fgIl/4iiufApvmdwVCVxh3vRy6RscYPO2ljhvDXNk0wyamKIhKwB9V4y/3DoiiKSZqiq3d+d+nLfUIu6//Erc9fkBzkrcviQ8rl1Qxa6MHqCYIE/54b3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779229584; c=relaxed/simple;
	bh=/KqNsjIc3WbXa6UNJ9mIdkZpAwpfDQRK+xNy6ss09Ec=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RgAQ55OhiMNta9CL5v5j0yK4isIy1dmAdaXx8LsvPjBXrqkRNRlR+NK3VsiszFesYetVzUBRg4joAPS83mgvSMrP+JA/kWVjIL+XW5h/BsyCRIw8+hRXGAZfgYs2A9XtXOwKNyh/5WqdvobDaj6B4F5lRvfBVyHDbAjONsYGMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzvwMdv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzvwMdv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F671F00893;
	Tue, 19 May 2026 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779229581;
	bh=Hk/txucGLQIwsHh8NH2anDLZuGTDy7f0hjWCFl8qpjQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZzvwMdv2qcDdj7qN8WXbj7Vgu/V3Kn8NhOwDqn7uSLIFDOATwv0s0SzGIG0Fd1zFm
	 4AR56iEgcNaCFu/u8nc3Czeh+99JK/yAR8QIVP9FM9nx6vv9FEWq7n4LY4z9FCI4U+
	 bLGSuDn0wC7EwVNm11kE2RjuJKRweLIr/tBHPDJ8=
Date: Tue, 19 May 2026 15:26:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Kairui Song <kasong@tencent.com>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 323/362] mm/memcontrol-v1.c:651:31: error:
 implicit declaration of function 'swp_cluster_offset'
Message-Id: <20260519152620.b7b5fd2d68d635ec8d34ad2c@linux-foundation.org>
In-Reply-To: <202605200624.e9eMvkBW-lkp@intel.com>
References: <202605200624.e9eMvkBW-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 May 2026 06:16:25 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   ac33089a65a951edf4365b1ff7fbe5b5e8062d06
> commit: dc1675a14ba774891fdf5212b7bedc7f50661862 [323/362] mm/memcg, swap: store cgroup id in cluster table directly
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200624.e9eMvkBW-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605200624.e9eMvkBW-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mm/memcontrol-v1.c: In function '__memcg1_swapout':
> >> mm/memcontrol-v1.c:651:31: error: implicit declaration of function 'swp_cluster_offset' [-Wimplicit-function-declaration]
>      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
>          |                               ^~~~~~~~~~~~~~~~~~

Thanks.  I added the below to fix the build, but I've no reason to
believe that it's correct.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
Date: Tue May 19 03:23:38 PM PDT 2026

"fix" CONFIG_SWAP=n build

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swap.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
+++ a/mm/swap.h
@@ -482,5 +482,11 @@ static inline int swap_zeromap_batch(swp
 {
 	return 0;
 }
+
+static inline unsigned int swp_cluster_offset(swp_entry_t entry)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
_


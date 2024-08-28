Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C4215748F
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 09:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724837285; cv=none; b=R1se8/JHOs0xAgNDyR8nxeiXrqIEdLdU8ajQ/Tr07nxTdjukwogUteyNMVBJM/5P7tFpDUHaZhTmGvMqMYBbs7CDXPzHGcEApYVfjK9KwzDIOepXf4eEfgIgKXspGps2IFUWvSyX1VBqVxGEyRkiAccjGFOg0fEu7qkNy7rBYZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724837285; c=relaxed/simple;
	bh=dPhza5OLQunApuh0m/TJjqI80wdFQxNPJl/h1GD06DE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bt+GVOTqddaiFJe58xzteFgsBR2Rh1iet7tDExQkM/ksvQdw7KSi6/lmU1WvXY3udot2d4APoWiWOhzYNwE5WT5FEjyqgKSbBwisQB1e/2i1+vWT+N3g+rCwESCRRXSS2OTTMXXJ83P2F8jySE55iNuj0X/kR0XdLPjNgmnd8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mkoos3Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mkoos3Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3334AC984F2;
	Wed, 28 Aug 2024 09:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724837285;
	bh=dPhza5OLQunApuh0m/TJjqI80wdFQxNPJl/h1GD06DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mkoos3Kr0aHdAe2eBuTWAUQvowiKMfw2XjrRO/rWniLc25lvBaY2JJXr1e7g3SMV/
	 On2ld4ihmoXqPmllETtFzI3wK2ZDwEdHYbl+jzSNOCVn4ommiRZ3JC4i7rzDbQeMJV
	 /bjNJGzhXfoInBVulf20SdNnE/qd0CaaU+unTVl1D0dI3QGkXnigGYjd7IZyGW6cAQ
	 ao2Gd49SAvzkHCmPKtSBDQfXrmknzydi3JrbFZwvwTrVg9Hvlos9wH9CI+4B+bfzwM
	 Wk73cJZxhAbt+ZrB5/k29ARFZbGt9M92kbZ44FiAOE6UWh6DLp1+0nA6IiA0Co63o8
	 Ft1+F86A99ISA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	ziy@nvidia.com,
	ying.huang@intel.com,
	willy@infradead.org,
	wangkefeng.wang@huawei.com,
	shy828301@gmail.com,
	ryan.roberts@arm.com,
	p.raghav@samsung.com,
	ioworker0@gmail.com,
	hughd@google.com,
	david@redhat.com,
	da.gomez@samsung.com,
	chrisl@kernel.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com
Subject: Re: + mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch added to mm-unstable branch
Date: Wed, 28 Aug 2024 02:28:01 -0700
Message-Id: <20240828092801.154587-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240828021322.626BDC32786@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 27 Aug 2024 19:13:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: mm: shmem: fix the gfp flag for large folio allocation
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
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
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> Subject: mm: shmem: fix the gfp flag for large folio allocation
> Date: Tue, 27 Aug 2024 11:06:34 +0800
> 
> In shmem_replace_folio(), it may be necessary to allocate a large folio,
> so we should update the gfp flags to ensure it is suitable for allocating
> the large folio.
> 
> Link: https://lkml.kernel.org/r/5b1e9c5a-7f61-4d97-a8d7-41767ca04c77@linux.alibaba.com
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Daniel Gomez <da.gomez@samsung.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Pankaj Raghav <p.raghav@samsung.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/shmem.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> --- a/mm/shmem.c~mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix
> +++ a/mm/shmem.c
> @@ -155,7 +155,7 @@ static unsigned long shmem_default_max_i
>  
>  static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>  			struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
> -			struct mm_struct *fault_mm, vm_fault_t *fault_type);
> +			struct vm_area_struct *vma, vm_fault_t *fault_type);
>  
>  static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
>  {
> @@ -1883,7 +1883,8 @@ static bool shmem_should_replace_folio(s
>  }
>  
>  static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
> -				struct shmem_inode_info *info, pgoff_t index)
> +				struct shmem_inode_info *info, pgoff_t index,
> +				struct vm_area_struct *vma)
>  {
>  	struct folio *new, *old = *foliop;
>  	swp_entry_t entry = old->swap;
> @@ -1898,6 +1899,12 @@ static int shmem_replace_folio(struct fo
>  	 * limit chance of success by further cpuset and node constraints.
>  	 */
>  	gfp &= ~GFP_CONSTRAINT_MASK;
> +	if (nr_pages > 1) {
> +		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
> +
> +		gfp = limit_gfp_mask(huge_gfp, gfp);
> +	}
> +

I just found the above change makes kernel build without
CONFIG_TRANSPARENT_HUGEPAGE fails like below.

    ERROR:root:/usr/bin/ld: mm/shmem.o: in function `shmem_swapin_folio':
    shmem.c:(.text+0x12d9): undefined reference to `vma_thp_gfp_mask'
    collect2: error: ld returned 1 exit status

Specifically, I reproduce the problem with kunit[1].

Maybe the above if statement need to take care of the case, e.g., wrap with
#ifdef CONFIG_TRANSPARENT_HUGEPAGE?

[1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/kunit.sh


Thanks,
SJ

[...]

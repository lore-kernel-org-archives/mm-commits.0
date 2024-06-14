Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1633C146010
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 04:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718340895; cv=none; b=Jm4ioQoN6OX77B71s6Ml8ujhuotb9yG0kaZBXe6qfNjiQXfgt4Am7QyUXRvoz2/3ywYDADiLqfLRbhOhoX/v3aElPzaFaALpFOaugsUAuMmIL7ifShBs0s9oLrDB2NIs0DA8/e3WwwS0KAVPGotjxu+UabkIamHr98YCqXsjVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718340895; c=relaxed/simple;
	bh=+YODvDR5GALswpHOi5oC+0KviXoiHiSu7jBbKjVmjwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NWT/1Im9UQshnIVx1eXfvhS97TGASswjlwn5ZLIG36MxikRP/EGdfpyTi1JO6oPa2CpyJrBZd9k1E3a425O9nPNGsedb37J/mfWUU09S40E69uH8h9g6nywov5HK5eq395GtKjJnu7KLRgtVgmsFjOxb+TWSeKue1A/DVKmtlvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=m7FK4G3w; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="m7FK4G3w"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718340884; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Wi8g+RYrD3JIFaCl9fMy9AF4F/aHCqZIeUhf5e1PjbI=;
	b=m7FK4G3wFjZ3E0bDgE3lEsab9tOZXtP7txouP+Vn5Qyhf6s0U/4k+UJWviWZHUyEEyeK6zEQgxNPYnKHEBHmJ9MhXCxaBVqg//Ydj5E0C5AmxnajOfpmfnPSqMGDe4Le1dZoaV966zcrlNh3O9rc7ZWEzqCmQLw0jxxPl31vaCY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0W8Q.ob2_1718340881;
Received: from 30.97.56.56(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0W8Q.ob2_1718340881)
          by smtp.aliyun-inc.com;
          Fri, 14 Jun 2024 12:54:42 +0800
Message-ID: <e1f5767a-2c9b-4e37-afe6-1de26fe54e41@linux.alibaba.com>
Date: Fri, 14 Jun 2024 12:54:41 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ziy@nvidia.com, ying.huang@intel.com, wangkefeng.wang@huawei.com,
 v-songbaohua@oppo.com, shy828301@gmail.com, ryan.roberts@arm.com,
 p.raghav@samsung.com, ioworker0@gmail.com, hughd@google.com,
 david@redhat.com, da.gomez@samsung.com
References: <20240613204637.17E68C2BBFC@smtp.kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20240613204637.17E68C2BBFC@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/6/14 04:46, Andrew Morton wrote:
> The patch titled
>       Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
> 
> This patch will later appear in the mm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix
> Date: Thu, 13 Jun 2024 21:03:36 +0800
> 
> avoid going beyond the PMD pagetable size
> 
> Link: https://lkml.kernel.org/r/b0e6a8b1-a32c-459e-ae67-fde5d28773e6@linux.alibaba.com
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reported-by: syzbot+d6e5c328862b5ae6cbfe@syzkaller.appspotmail.com
> Fixes: 1c05047ad016 ("mm: memory: extend finish_fault() to support
> Cc: Barry Song <v-songbaohua@oppo.com>
> Cc: Daniel Gomez <da.gomez@samsung.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Pankaj Raghav <p.raghav@samsung.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/memory.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> --- a/mm/memory.c~mm-memory-extend-finish_fault-to-support-large-folio-fix
> +++ a/mm/memory.c
> @@ -4875,13 +4875,17 @@ vm_fault_t finish_fault(struct vm_fault
>   		pgoff_t idx = folio_page_idx(folio, page);
>   		/* The page offset of vmf->address within the VMA. */
>   		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
> +		/* The index of the entry in the pagetable for fault page. */
> +		pgoff_t pte_off = pte_index(vmf->address);
>   
>   		/*
>   		 * Fallback to per-page fault in case the folio size in page
> -		 * cache beyond the VMA limits.
> +		 * cache beyond the VMA limits and PMD pagetable limits.
>   		 */
>   		if (unlikely(vma_off < idx ||
> -			     vma_off + (nr_pages - idx) > vma_pages(vma))) {
> +			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
> +			    pte_off < idx ||
> +			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE - 1)) {

We should use 'PTRS_PER_PTE' instead of 'PTRS_PER_PTE - 1'. Sorry for my 
math fault (I wrote the code too late last night, wasn't thinking 
clearly:( ).

Sorry Andrew, could you help to squash this change? Thanks.

diff --git a/mm/memory.c b/mm/memory.c
index b7137d9c99a9..e6521dd82281 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4888,7 +4888,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
                 if (unlikely(vma_off < idx ||
                             vma_off + (nr_pages - idx) > vma_pages(vma) ||
                             pte_off < idx ||
-                           pte_off + (nr_pages - idx)  > PTRS_PER_PTE - 
1)) {
+                           pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
                         nr_pages = 1;
                 } else {
                         /* Now we can set mappings for the whole large 
folio. */

>   			nr_pages = 1;
>   		} else {
>   			/* Now we can set mappings for the whole large folio. */
> _
> 
> Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are
> 
> mm-memory-extend-finish_fault-to-support-large-folio.patch
> mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
> mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
> mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
> mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
> mm-shmem-add-mthp-support-for-anonymous-shmem.patch
> mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
> mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

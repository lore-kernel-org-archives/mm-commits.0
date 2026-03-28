Received: from out199-9.us.a.mail.aliyun.com (out199-9.us.a.mail.aliyun.com [47.90.199.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D3B481B1;
	Sat, 28 Mar 2026 02:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774663356; cv=none; b=ctQ8ut25Jj8QPqC3Au5oU/Ac+zxfXjRBxGzya1JOYOZnKkFKxG2W6LxtzURyeGcTTCX0G8O6X45d9njiO133TUR4+kOZOO135jtkVlgQDc9xzzQENaUoWHrQVCUnizlaz1mM0IEXNjixIjxW/XAyIsbFnD9ZsoXdpwwo3Hs6yt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774663356; c=relaxed/simple;
	bh=FcTIzy/rNZJXKKfwRMx31XSDed1iJHmzpOIN/fJ6K54=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sS5yo5usnfFzU0KGTkvVbd+oMcTgAdLj1R6lT0Uz00HOgL0Z5PxO98n+yXRJpP+cpecX7fQc4bN4mMOA8yD6IjuTAQSw6g7lO3+EE2dhPpfqMZ/+znfYKvP+3o9/jdp7eoSz1nHSSB2e+a5tdP3+GACg3fwoa04uLLQ2OpVnNKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SXaBl9oU; arc=none smtp.client-ip=47.90.199.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SXaBl9oU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774663333; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0KSxdwc2k70FW8/uwWZ5ZY0mxQqqfz3JxILfNWNlNb8=;
	b=SXaBl9oUX0hEyv7ED5LJUy87TKcUR1kROwackgj2DbMPUyhJv4fHy35mhoiimjpaN4aHga5EBk4PyTy3ixIfUOLXgKJ32hRPGp9lILXqlhAYcUofVZlKJRRuoacZcBliaiTLrrYIfjkeIA5dc7PIUN1ZMnESNVW+wvHVfxMBcUc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.pbLva_1774663331;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.pbLva_1774663331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 28 Mar 2026 10:02:12 +0800
Message-ID: <011665ea-ebde-4c5e-9eb9-b9adffff056f@linux.alibaba.com>
Date: Sat, 28 Mar 2026 10:02:09 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-hotfixes-stable]
 mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 xiangzao@linux.alibaba.com, willy@infradead.org, stable@vger.kernel.org,
 p.raghav@samsung.com, mcgrof@kernel.org, ljs@kernel.org, kas@kernel.org,
 hare@suse.de, djwong@kernel.org, dhowells@redhat.com, dchinner@redhat.com,
 david@kernel.org, da.gomez@samsung.com, brauner@kernel.org
References: <20260328003911.5D84BC19423@smtp.kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260328003911.5D84BC19423@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

On 3/28/26 8:39 AM, Andrew Morton wrote:
> The quilt patch titled
>       Subject: mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()
> has been removed from the -mm tree.  Its filename was
>       mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> Subject: mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()
> Date: Tue, 17 Mar 2026 17:29:55 +0800
> 
> On arm64 server, we found folio that get from migration entry isn't locked
> in softleaf_to_folio().  This issue triggers when mTHP splitting and
> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
> in softleaf_to_folio().  The race is as follows:
> 
> 	CPU0                                             CPU1
> 
> deferred_split_scan()                              zap_nonpresent_ptes()
>    lock folio
>    split_folio()
>      unmap_folio()
>        change ptes to migration entries
>      __split_folio_to_order()                         softleaf_to_folio()
>        set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>        smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>        prep_compound_page() for tail pages
> 
> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> are visible before the tail page becomes non-compound.  smp_wmb() should
> be paired with smp_rmb() in softleaf_to_folio(), which is missed.  As a
> result, if zap_nonpresent_ptes() accesses migration entry that stores tail
> pfn, softleaf_to_folio() may see the updated compound_head of tail page
> before page->flags.
> 
> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
> in softleaf_to_folio() and softleaf_to_page().

What happened to this fix patch? The commit message doesn't belong to my 
original patch.

Please see my original patch: 
https://lkml.kernel.org/r/1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang@linux.alibaba.com

> 
> Link: https://lkml.kernel.org/r/1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang@linux.alibaba.com
> Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Daniel Gomez <da.gomez@samsung.com>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Cc: Luis Chamberalin <mcgrof@kernel.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Pankaj Raghav <p.raghav@samsung.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/filemap.c |   11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- a/mm/filemap.c~mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages
> +++ a/mm/filemap.c
> @@ -3883,14 +3883,19 @@ vm_fault_t filemap_map_pages(struct vm_f
>   	unsigned int nr_pages = 0, folio_type;
>   	unsigned short mmap_miss = 0, mmap_miss_saved;
>   
> +	/*
> +	 * Recalculate end_pgoff based on file_end before calling
> +	 * next_uptodate_folio() to avoid races with concurrent
> +	 * truncation.
> +	 */
> +	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
> +	end_pgoff = min(end_pgoff, file_end);
> +
>   	rcu_read_lock();
>   	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
>   	if (!folio)
>   		goto out;
>   
> -	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
> -	end_pgoff = min(end_pgoff, file_end);
> -
>   	/*
>   	 * Do not allow to map with PMD across i_size to preserve
>   	 * SIGBUS semantics.
> _
> 
> Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are
> 
> mm-use-inline-helper-functions-instead-of-ugly-macros.patch
> mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch
> mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch
> mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch
> mm-support-batched-checking-of-the-young-flag-for-mglru.patch
> arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch
> mm-change-to-return-bool-for-ptep_test_and_clear_young.patch
> mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes.patch
> mm-change-to-return-bool-for-pmdp_test_and_clear_young.patch
> mm-change-to-return-bool-for-pmdp_clear_flush_young.patch
> mm-change-to-return-bool-for-pudp_test_and_clear_young.patch
> mm-change-to-return-bool-for-the-mmu-notifiers-young-flag-check.patch
> mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch


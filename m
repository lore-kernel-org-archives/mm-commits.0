Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FD57F484
	for <mm-commits@vger.kernel.org>; Sat, 17 Aug 2024 08:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723883479; cv=none; b=Iogh0Rmz4KE0ZxAiOKbNuNV+1b4GVhxIJaj7dfY5H9QYeham4Lb9ibaePcCCGjVXQZomT3wIJEhwwHoW5+TqCyweaqpormsSzEqLFWfJah8IZpPeQkidPQBcLGoEu1yEUHgk1ACkof3h8OE62ySbGf1Mk6ghFbXCZlt8imklxyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723883479; c=relaxed/simple;
	bh=Ddr7sbovltvnLDDTwkyM+aAHqeUp6v4BDck3llscpio=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sLTMsl+lN2zbO6/ltr/3Bgn+gwgQt+4XDTnpd2OlTNYOaEVaWy+b/rb7jzMGMj5at/OCrtNWkExaQcZGV+k/LF2VI01MLC91xhOxH0E1azZGiSIkFWg+F+mS8w/xWdCd7IvCQFuHGu6viQ/Bt+/WtTR7SKoW9VrFeqQFx8yFyos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WmBlZ0vh7z1j6Rl;
	Sat, 17 Aug 2024 16:26:18 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id ABC2D180042;
	Sat, 17 Aug 2024 16:31:13 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Aug 2024 16:31:13 +0800
Message-ID: <9bfdc0e4-4a82-4019-9264-00517e826096@huawei.com>
Date: Sat, 17 Aug 2024 16:31:12 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch added to
 mm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<osalvador@suse.de>, <nao.horiguchi@gmail.com>, <linmiaohe@huawei.com>,
	<david@redhat.com>
References: <20240816214256.1E93CC32782@smtp.kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20240816214256.1E93CC32782@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100008.china.huawei.com (7.185.36.138)

Hi Andrew, please drop this series, patch1 has build issue(isolate_hugetlb)
when rebase, and patch2 fix it, I will resend new patches.

On 2024/8/17 5:42, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm: memory_hotplug: remove head variable in do_migrate_range()
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
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
> From: Kefeng Wang <wangkefeng.wang@huawei.com>
> Subject: mm: memory_hotplug: remove head variable in do_migrate_range()
> Date: Fri, 16 Aug 2024 17:04:31 +0800
> 
> Patch series "mm: memory_hotplug: improve do_migrate_range()", v2.
> 
> Unify hwpoisoned page handling and isolation of HugeTLB/LRU/non-LRU
> movable page, also convert to use folios in do_migrate_range().
> 
> 
> This patch (of 2):
> 
> Directly use a folio for HugeTLB and THP when calculate the next pfn, then
> remove unused head variable.
> 
> Link: https://lkml.kernel.org/r/20240816090435.888946-1-wangkefeng.wang@huawei.com
> Link: https://lkml.kernel.org/r/20240816090435.888946-2-wangkefeng.wang@huawei.com
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/memory_hotplug.c |   22 ++++++++++++++--------
>   1 file changed, 14 insertions(+), 8 deletions(-)
> 
> --- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-head-variable-in-do_migrate_range
> +++ a/mm/memory_hotplug.c
> @@ -1773,7 +1773,7 @@ found:
>   static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
>   {
>   	unsigned long pfn;
> -	struct page *page, *head;
> +	struct page *page;
>   	LIST_HEAD(source);
>   	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
>   				      DEFAULT_RATELIMIT_BURST);
> @@ -1786,14 +1786,20 @@ static void do_migrate_range(unsigned lo
>   			continue;
>   		page = pfn_to_page(pfn);
>   		folio = page_folio(page);
> -		head = &folio->page;
>   
> -		if (PageHuge(page)) {
> -			pfn = page_to_pfn(head) + compound_nr(head) - 1;
> -			isolate_hugetlb(folio, &source);
> -			continue;
> -		} else if (PageTransHuge(page))
> -			pfn = page_to_pfn(head) + thp_nr_pages(page) - 1;
> +		/*
> +		 * The folio hold no reference or lock, it might be changed
> +		 * concurrently(eg, split), folio_nr_pages() may read garbage,
> +		 * but out loop could handle that as it revisits the split
> +		 * folio later.
> +		 */
> +		if (folio_test_large(folio)) {
> +			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
> +			if (folio_test_hugetlb(folio)) {
> +				isolate_hugetlb(folio);
> +				continue;
> +			}
> +		}
>   
>   		/*
>   		 * HWPoison pages have elevated reference counts so the migration would
> _
> 
> Patches currently in -mm which might be from wangkefeng.wang@huawei.com are
> 
> mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch
> mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch
> mm-memory-failure-add-unmap_posioned_folio.patch
> mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch
> mm-migrate-add-isolate_folio_to_list.patch
> mm-memory_hotplug-unify-huge-lru-non-lru-movable-folio-isolation.patch
> 

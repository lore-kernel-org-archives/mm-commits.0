Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6E4207E1C
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 06:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742192951; cv=none; b=aEslH5SBDbczq/tB3Vupu9E+kE7krjsu8VI5yf9ExB+CIqSmbqRn3r8b6v57jfmuEG8jum86PnJNwOZpO9oRR6OGu38aZSNCvljCrlJZKz0gZ86Zcg1HzLNTUI5rMCHsk9oFe3Memw87n2xUEIflHsBnJtIJZj3djIbG6FH7T/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742192951; c=relaxed/simple;
	bh=gFr3rbhA1YMw9bCjLUqsR3vuVWLStP3HAP/lPuUUzdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EN6SfxsXyXYeV/7KJDZbdyg+toTa7+yXla/0PPFYgoyv0mddZPLllOLGlaMKHbmy4zRDuBD6FKHuRdT0wM7tqTPoIqlgTxA8odAF2kRBXkwBGRnh58EVKFcWJ0Oz88gKA4ctG3SlhJ0AAYpy+qlQ6xlR7sx1pdL+JH7+q5Wt3Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZGQ1K5Yh7z1g2Hc;
	Mon, 17 Mar 2025 14:24:37 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 5257E18001B;
	Mon, 17 Mar 2025 14:29:05 +0800 (CST)
Received: from [10.174.179.13] (10.174.179.13) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 17 Mar 2025 14:29:04 +0800
Message-ID: <9f0e1e9d-2c91-6204-4907-f5c2c5bb2e93@huawei.com>
Date: Mon, 17 Mar 2025 14:29:03 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [merged mm-stable]
 mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch removed
 from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
	<osalvador@suse.de>, <muchun.song@linux.dev>, <mel@csn.ul.ie>,
	<lee.schermerhorn@hp.com>, <david@redhat.com>, <andi@firstfloor.org>
References: <20250317051437.4085FC4CEEC@smtp.kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20250317051437.4085FC4CEEC@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemo200002.china.huawei.com (7.202.195.209)


在 2025/3/17 13:14, Andrew Morton 写道:
> The quilt patch titled
>       Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
> has been removed from the -mm tree.  Its filename was
>       mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Hi, Andrew

As I explained in https://lore.kernel.org/all/c2c3d8b5-4b99-220e-20e0-e4a9dd8f5ecf@huawei.com/,
This patch fails to deal with free surplus huge pages, and will introduce another issue.

So please drop this patch from mm tree.

Thanks.

> ------------------------------------------------------
> From: Jinjiang Tu <tujinjiang@huawei.com>
> Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
> Date: Tue, 25 Feb 2025 22:19:33 +0800
>
> In set_max_huge_pages(), min_count should mean the acquired persistent
> huge pages, but it contains surplus huge pages.  It will lead to failing
> to free free huge pages for a node.
>
> Steps to reproduce:
> 1) create 5 huge pages in Node 0
> 2) run a program to use all the huge pages
> 3) create 5 huge pages in Node 1
> 4) echo 0 > nr_hugepages for Node 1 to free the huge pages
>
> The result:
>          Node 0    Node 1
> Total     5         5
> Free      0         5
> Surp      5         5
>
> With this patch, step 4) destroys the 5 huge pages in Node 1
>
> The result with this patch:
>          Node 0    Node 1
> Total     5         0
> Free      0         0
> Surp      5         0
>
> Link: https://lkml.kernel.org/r/20250225141933.3852667-1-tujinjiang@huawei.com
> Fixes: 9a30523066cd ("hugetlb: add per node hstate attributes")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   mm/hugetlb.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/mm/hugetlb.c~mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages
> +++ a/mm/hugetlb.c
> @@ -3937,7 +3937,7 @@ static int set_max_huge_pages(struct hst
>   	 * and won't grow the pool anywhere else. Not until one of the
>   	 * sysctls are changed, or the surplus pages go out of use.
>   	 */
> -	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
> +	min_count = h->resv_huge_pages + persistent_huge_pages(h) - h->free_huge_pages;
>   	min_count = max(count, min_count);
>   	try_to_free_low(h, min_count, nodes_allowed);
>   
> _
>
> Patches currently in -mm which might be from tujinjiang@huawei.com are
>
> mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch
>

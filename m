Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA093D393
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 07:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706598080; cv=none; b=nccW8ubxGKW1k3OCMkUzVJn8RsfGFTPdsOvEeO5HX0kIcAle5MHzSqooryTcvTzDqRalQZyOPPZZGX1+Qgu2IJvpGgRhK5/+REBdyJqzYSVbUjGHlukqPelUnCtzvwX85YC70Ab3+xb+9LRhtBFgX7fWgLrGW/J+pm1oJN8mtmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706598080; c=relaxed/simple;
	bh=qI0VklqydPOxekpSIKSJ9U6o/1vapwyXK9Z14rngDaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y7bkWYtArDtqcQPd4xTIQtJ5mja3spX3yxopvuV4Bg3TfwrIyTfGzpg5CXpdq7H+v4ZLK4MlPkxKQ3i/VLvaLeZYXuZasAbyEJc9zpRq2j0kwgpSqDxvJE67vEzY3joidiuS+dht9CoyQDlJmRR6S3uy/SmgRCoSx89mC4m6yJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=C/5uhi/q; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="C/5uhi/q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706598068; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RR7NNbnOU0LLBfw1eK3vKf4VsZqIARArj67GFgtkZE4=;
	b=C/5uhi/qtAm+Qut3pS3zvv1oO3GXsTUBJUMa48KFqsKv6V1Bt50qgN5YR+kbx5XZV1z6FLgNi/x8SxJEXSNZ01rnVzm0GMTZQf6NWB24BonBXmzTKNzUPzYr12tWKumNCqDnmLg6hM0lncah2oj6RUQcq+0jP0vGvZ7bFJ2qr/g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W.fH3TN_1706598067;
Received: from 30.97.56.47(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0W.fH3TN_1706598067)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 15:01:08 +0800
Message-ID: <e4d47608-7f7f-4156-9fbb-52ffb3029f4d@linux.alibaba.com>
Date: Tue, 30 Jan 2024 15:01:30 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
 added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 vbabka@suse.cz, mgorman@techsingularity.net
References: <20240130063057.A1891C433C7@smtp.kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20240130063057.A1891C433C7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/30/2024 2:30 PM, Andrew Morton wrote:
> The patch titled
>       Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
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
> Subject: mm: compaction: update the cc->nr_migratepages when allocating or freeing the freepages
> Date: Mon, 22 Jan 2024 21:01:54 +0800
> 
> Currently we will use 'cc->nr_freepages >= cc->nr_migratepages' comparison
> to ensure that enough freepages are isolated in isolate_freepages(), however
> it just decreases the cc->nr_freepages without updating cc->nr_migratepages
> in compaction_alloc(), which will waste more CPU cycles and cause too many
> freepages to be isolated.
> 
> So we should also update the cc->nr_migratepages when allocating or
> freeing the freepages to avoid isolating excess freepages.  And I can see
> fewer free pages are scanned and isolated when running thpcompact on my
> Arm64 server:
> 
>                                         k6.7         k6.7_patched
> Ops Compaction pages isolated      120692036.00   118160797.00
> Ops Compaction migrate scanned     131210329.00   154093268.00
> Ops Compaction free scanned       1090587971.00  1080632536.00
> Ops Compact scan efficiency               12.03          14.26
> 
> Moreover, I did not see an obvious latency improvements, this is likely
> because isolating freepages is not the bottleneck in the thpcompact test
> case.
> 
>                                k6.7                  k6.7_patched
> Amean     fault-both-1      1089.76 (   0.00%)     1080.16 *   0.88%*
> Amean     fault-both-3      1616.48 (   0.00%)     1636.65 *  -1.25%*
> Amean     fault-both-5      2266.66 (   0.00%)     2219.20 *   2.09%*
> Amean     fault-both-7      2909.84 (   0.00%)     2801.90 *   3.71%*
> Amean     fault-both-12     4861.26 (   0.00%)     4733.25 *   2.63%*
> Amean     fault-both-18     7351.11 (   0.00%)     6950.51 *   5.45%*
> Amean     fault-both-24     9059.30 (   0.00%)     9159.99 *  -1.11%*
> Amean     fault-both-30    10685.68 (   0.00%)    11399.02 *  -6.68%*
> 
> Link: https://lkml.kernel.org/r/0773058df022fa701b78f9a6dfe3c501a1a77351.1705928395.git.baolin.wang@linux.alibaba.com
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew,

Thanks for queuing this patch, but this patch should be updated as below 
after the "Enable >0 order folio memory compaction" series:

diff --git a/mm/compaction.c b/mm/compaction.c
index fa9993c8a389..af3738102838 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1881,6 +1881,7 @@ static struct folio *compaction_alloc(struct folio 
*src, unsigned long data)
         if (order)
                 prep_compound_page(&dst->page, order);
         cc->nr_freepages -= 1 << order;
+       cc->nr_migratepages -= 1 << order;
         return page_rmappable_folio(&dst->page);
  }

@@ -1903,6 +1904,7 @@ static void compaction_free(struct folio *dst, 
unsigned long data)
         list_add(&dst->lru, &cc->freepages[order].pages);
         cc->freepages[order].nr_pages++;
         cc->nr_freepages += 1 << order;
+       cc->nr_migratepages += 1 << order;
  }


>   mm/compaction.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> --- a/mm/compaction.c~mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages
> +++ a/mm/compaction.c
> @@ -1876,6 +1876,7 @@ again:
>   
>   	dst = list_first_entry(&cc->freepages[order].pages, struct folio, lru);
>   	cc->freepages[order].nr_pages--;
> +	cc->nr_migratepages--;
>   	list_del(&dst->lru);
>   done:
>   	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
> @@ -1904,6 +1905,7 @@ static void compaction_free(struct folio
>   	list_add(&dst->lru, &cc->freepages[order].pages);
>   	cc->freepages[order].nr_pages++;
>   	cc->nr_freepages += 1 << order;
> +	cc->nr_migratepages++;
>   }
>   
>   /* possible outcome of isolate_migratepages */
> _
> 
> Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are
> 
> mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch
> mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch

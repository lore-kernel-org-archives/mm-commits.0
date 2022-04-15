Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFA2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 14:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354225AbiDOODs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Apr 2022 10:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353501AbiDOODs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2022 10:03:48 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CE5BF30A
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 07:01:18 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VA7VgG0_1650031273;
Received: from 192.168.1.5(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0VA7VgG0_1650031273)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Apr 2022 22:01:15 +0800
Subject: Re: + mm-proc-remove-redundant-page-validation-of-pte_page.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shy828301@gmail.com, sashal@kernel.org,
        linmiaohe@huawei.com, kch@nvidia.com, adobriyan@gmail.com
References: <20220316211126.09A72C340E9@smtp.kernel.org>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <98d85ec3-330b-0853-9a9c-64e908e50320@linux.alibaba.com>
Date:   Fri, 15 Apr 2022 22:01:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220316211126.09A72C340E9@smtp.kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Could you share the reason why the patch is removed? thanks

ÔÚ 2022/3/17 ÉÏÎç5:11, Andrew Morton Ð´µÀ:
> The patch titled
>       Subject: fs/proc/task_mmu.c: remove redundant page validation of pte_page
> has been added to the -mm tree.  Its filename is
>       mm-proc-remove-redundant-page-validation-of-pte_page.patch
>
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-proc-remove-redundant-page-validation-of-pte_page.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-remove-redundant-page-validation-of-pte_page.patch
>
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Xianting Tian <xianting.tian@linux.alibaba.com>
> Subject: fs/proc/task_mmu.c: remove redundant page validation of pte_page
>
> pte_page() always returns a valid page, so remove the redundant page
> validation, as we did in many other places.
>
> Link: https://lkml.kernel.org/r/20220316025947.328276-1-xianting.tian@linux.alibaba.com
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   fs/proc/task_mmu.c |    2 --
>   1 file changed, 2 deletions(-)
>
> --- a/fs/proc/task_mmu.c~mm-proc-remove-redundant-page-validation-of-pte_page
> +++ a/fs/proc/task_mmu.c
> @@ -1873,8 +1873,6 @@ static int gather_hugetlb_stats(pte_t *p
>   		return 0;
>   
>   	page = pte_page(huge_pte);
> -	if (!page)
> -		return 0;
>   
>   	md = walk->private;
>   	gather_stats(page, md, pte_dirty(huge_pte), 1);
> _
>
> Patches currently in -mm which might be from xianting.tian@linux.alibaba.com are
>
> mm-proc-remove-redundant-page-validation-of-pte_page.patch

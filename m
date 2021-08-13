Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F14C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 16:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8760A6103A
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 16:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhHMQrg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 12:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235453AbhHMQre (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 12:47:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934716103A;
        Fri, 13 Aug 2021 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628873227;
        bh=z4U9afhxy89hLHW7meKEqKMvdbCqK7cNlTr4jnHuRT0=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=o/E6YETyeUhPwpP+qrp/msuOHucHETvO/ngrxmCcx3DAc41+s+xYHsVWUfr7I5OAh
         oua4BCH2LEvMAmtj87nyWhHLZ4FMDcyF/siELNqW9B+js7+B8xHryc/MhKTKo8AlMX
         hMb1qb3p1pH12Q9PlPc5r9sKcbHjryuM6dz3LsJIhypsXcXvUK3zHgK1u8Ucg11Bq7
         ydAqwrBZPsiexm6KfUvIvkv/0KFToaM+SegwM0cYmboMr6YIS6qjncoPGKJ5GLNxsM
         v/Jr5eGO2thKKn8a7wIuE9zGiTMc05ml2UP/QZztjjCi6visQDI3JgcLT2gfoMBFXX
         6ZR5Ak3c1NEhg==
Subject: Re: +
 mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch
 added to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        mike.kravetz@oracle.com, feng.tang@intel.com
References: <20210811011832.fuoJM%akpm@linux-foundation.org>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <86ee6411-56e8-0e79-e292-0e935636b116@kernel.org>
Date:   Fri, 13 Aug 2021 09:47:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210811011832.fuoJM%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew,

On 8/10/2021 6:18 PM, akpm@linux-foundation.org wrote:
> The patch titled
>       Subject: mm/hugetlb: Initialize page to NULL in alloc_buddy_huge_page_with_mpol()
> has been added to the -mm tree.  Its filename is
>       mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch
> 
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch
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
> From: Nathan Chancellor <nathan@kernel.org>
> Subject: mm/hugetlb: Initialize page to NULL in alloc_buddy_huge_page_with_mpol()
> 
> Clang warns:
> 
> mm/hugetlb.c:2162:6: warning: variable 'page' is used uninitialized
> whenever 'if' condition is false [-Wsometimes-uninitialized]
>          if (mpol_is_preferred_many(mpol)) {
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/hugetlb.c:2172:7: note: uninitialized use occurs here
>          if (!page)
>               ^~~~
> mm/hugetlb.c:2162:2: note: remove the 'if' if its condition is always
> true
>          if (mpol_is_preferred_many(mpol)) {
>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/hugetlb.c:2155:19: note: initialize the variable 'page' to silence
> this warning
>          struct page *page;
>                           ^
>                            = NULL
> 1 warning generated.
> 
> Initialize page to NULL like in dequeue_huge_page_vma() so that page is
> not used uninitialized.
> 
> Link: https://lkml.kernel.org/r/20210810200632.3812797-1-nathan@kernel.org
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/hugetlb.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/hugetlb.c~mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol
> +++ a/mm/hugetlb.c
> @@ -2088,7 +2088,7 @@ static
>   struct page *alloc_buddy_huge_page_with_mpol(struct hstate *h,
>   		struct vm_area_struct *vma, unsigned long addr)
>   {
> -	struct page *page;
> +	struct page *page = NULL;
>   	struct mempolicy *mpol;
>   	gfp_t gfp_mask = htlb_alloc_mask(h);
>   	int nid;
> _
> 
> Patches currently in -mm which might be from nathan@kernel.org are
> 
> mm-hugetlb-initialize-page-to-null-in-alloc_buddy_huge_page_with_mpol.patch
> 

Sorry for not making it clearer with a fixes tag but I did not intend 
for this to be a standalone patch but rather a fixup patch for 
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch, 
which fails to initialize page in alloc_buddy_huge_page_with_mpol(). I 
thought that replying inline to the thread would be enough.

Cheers,
Nathan

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C032C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 01:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DFF560F4B
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 01:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhHIBw5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 8 Aug 2021 21:52:57 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13249 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhHIBw5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 8 Aug 2021 21:52:57 -0400
Received: from dggeme703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GjfGZ4g9Bz1CTpM;
        Mon,  9 Aug 2021 09:52:22 +0800 (CST)
Received: from [10.174.179.25] (10.174.179.25) by
 dggeme703-chm.china.huawei.com (10.1.199.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 9 Aug 2021 09:52:34 +0800
Subject: Re: +
 mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
 added to -mm tree
To:     <akpm@linux-foundation.org>
References: <20210807184607.cyXFb%akpm@linux-foundation.org>
From:   Miaohe Lin <linmiaohe@huawei.com>
CC:     <mm-commits@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        <imbrenda@linux.ibm.com>
Message-ID: <55ebba29-a0da-234e-406c-3fa60c44d6c0@huawei.com>
Date:   Mon, 9 Aug 2021 09:52:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210807184607.cyXFb%akpm@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.25]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme703-chm.china.huawei.com (10.1.199.99)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2021/8/8 2:46, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix
> has been added to the -mm tree.  Its filename is
>      mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix
> 
> fix return value
> 
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/gup.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/mm/gup.c~mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix
> +++ a/mm/gup.c
> @@ -2240,6 +2240,7 @@ static int __gup_device_huge(unsigned lo
>  {
>  	int nr_start = *nr;
>  	struct dev_pagemap *pgmap = NULL;
> +	int ret = 1;
>  
>  	do {
>  		struct page *page = pfn_to_page(pfn);
> @@ -2247,12 +2248,14 @@ static int __gup_device_huge(unsigned lo
>  		pgmap = get_dev_pagemap(pfn, pgmap);
>  		if (unlikely(!pgmap)) {
>  			undo_dev_pagemap(nr, nr_start, flags, pages);
> +			ret = 0;
>  			break;
>  		}
>  		SetPageReferenced(page);
>  		pages[*nr] = page;
>  		if (unlikely(!try_grab_page(page, flags))) {
>  			undo_dev_pagemap(nr, nr_start, flags, pages);
> +			ret = 0;
>  			break;
>  		}
>  		(*nr)++;
> @@ -2260,7 +2263,7 @@ static int __gup_device_huge(unsigned lo
>  	} while (addr += PAGE_SIZE, addr != end);
>  
>  	put_dev_pagemap(pgmap);
> -	return 1;
> +	return ret;
>  }
>  

Looks good to me. Many thanks for this improvement. :)

>  static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> _
> 


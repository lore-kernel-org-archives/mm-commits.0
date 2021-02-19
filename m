Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D0CC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 01:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0E2F64E44
	for <mm-commits@archiver.kernel.org>; Fri, 19 Feb 2021 01:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBSBPt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Feb 2021 20:15:49 -0500
Received: from foss.arm.com ([217.140.110.172]:57548 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhBSBPs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Feb 2021 20:15:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 748061FB;
        Thu, 18 Feb 2021 17:15:02 -0800 (PST)
Received: from [192.168.0.130] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B3523F694;
        Thu, 18 Feb 2021 17:14:55 -0800 (PST)
Subject: Re: +
 mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
 added to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        will@kernel.org, teawaterz@linux.alibaba.com,
        richard.weiyang@linux.alibaba.com, pankaj.gupta.linux@gmail.com,
        pankaj.gupta@cloud.ionos.com, osalvador@suse.de, mst@redhat.com,
        mhocko@kernel.org, mark.rutland@arm.com, lkp@intel.com,
        Jonathan.Cameron@huawei.com, jasowang@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        dan.carpenter@oracle.com, catalin.marinas@arm.com, ardb@kernel.org
References: <20210218222836.52mtf%akpm@linux-foundation.org>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <c936f202-5ba8-2ef3-81e0-479f94f14cdf@arm.com>
Date:   Fri, 19 Feb 2021 06:45:25 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210218222836.52mtf%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 2/19/21 3:58 AM, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix
> 
> make pagemap_range() return -EINVAL when mhp_range_allowed() fails
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: teawater <teawaterz@linux.alibaba.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memremap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/mm/memremap.c~mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix
> +++ a/mm/memremap.c
> @@ -266,8 +266,10 @@ static int pagemap_range(struct dev_page
>  	if (error)
>  		goto err_pfn_remap;
>  
> -	if (!mhp_range_allowed(range->start, range_len(range), !is_private))
> +	if (!mhp_range_allowed(range->start, range_len(range), !is_private)) {
> +		error = -EINVAL;
>  		goto err_pfn_remap;
> +	}
>  
>  	mem_hotplug_begin();

Hello Andrew,

I some how missed the original error report about this on the list. But this
looks good. Would you fold this back to the first patch in the series while
merging OR should I resend the series with this fix ?

- Anshuman

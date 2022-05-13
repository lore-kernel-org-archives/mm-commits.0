Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D48C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 01:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353427AbiEMBRX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 21:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244317AbiEMBRW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 21:17:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850D6396
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5s0abBhbZRc2FyEzQbw9yF+J6sEB/oSaBiEtkwFEN7s=; b=deESmIQyTw4aslTxgmOtipcw57
        BiYzTyLKuAIvXpuuTHuetfGEVo/GJ3hyRelWDFYekLN00m7n4K1t/q54JtFr4lg1Kw0cbiW1eCFU6
        SQnLj68zNjHz8WOssCX3llAoeKwRtEZIxTFhTRF2JK8kvyROKepDbIP+zpilVl7F22o/iTszz0G05
        amMy8q4jJPtGsAoZBhLlq/3hkDekCjREyVAe91C6S8B0K0NpZtuC231vSguSrl2F9FZbGiXiF1gz+
        If3eT8P7+9arghHi4+Osw0yfxtu1K+RdnZp9FuLUifLax/Wt0vHbmOK05Swx9IpOh7+VffXpQPf5M
        tFDcfM9g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1npJva-006vDY-Pk; Fri, 13 May 2022 01:17:10 +0000
Date:   Fri, 13 May 2022 02:17:10 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rf@opensource.cirrus.com, pmladek@suse.com, jvgediya@linux.ibm.com,
        Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        andy.shevchenko@gmail.com, adobriyan@gmail.com
Subject: Re: + mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch
 added to mm-unstable branch
Message-ID: <Yn2xlvFZelucTEVD@casper.infradead.org>
References: <20220513010543.707FEC34113@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513010543.707FEC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 12, 2022 at 06:05:42PM -0700, Andrew Morton wrote:
>  {
> -	if (kstrtobool(buf, &numa_demotion_enabled))
> -		return -EINVAL;
> +	ssize_t ret;
> +
> +	ret = kstrtobool(buf, &numa_demotion_enabled);
> +		return ret;

Umm ... missing if?

>  	return count;
>  }
> --- a/mm/swap_state.c~mm-convert-sysfs-input-to-bool-using-kstrtobool-fix
> +++ a/mm/swap_state.c
> @@ -874,8 +874,11 @@ static ssize_t vma_ra_enabled_store(stru
>  				      struct kobj_attribute *attr,
>  				      const char *buf, size_t count)
>  {
> -	if (kstrtobool(buf, &enable_vma_readahead))
> -		return -EINVAL;
> +	ssize_t ret;
> +
> +	ret = kstrtobool(buf, &enable_vma_readahead);
> +	if (ret)
> +		return ret;
>  
>  	return count;
>  }
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> assoc_array-fix-bug_on-during-garbage-collect-fix.patch
> mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
> mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
> lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
> mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch
> mm-start-tracking-vmas-with-maple-tree-fix.patch
> damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
> mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
> mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
> linux-next-rejects.patch
> linux-next-git-rejects.patch
> mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
> 

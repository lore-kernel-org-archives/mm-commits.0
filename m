Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B3AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 19:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347389AbiFCT4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 15:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiFCT4C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 15:56:02 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1FB41306
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 12:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=dJk8hZOiYQpmru0hniNc+F7VHbUWEkkLeGV/E6OUwNM=; b=lmMalIZpXSe54wmb7E+3Jkb5j1
        z6uvhT09+0CDCDeAyQCDu/YRKTalbztMRE3tkgP3WE5Nl7yaY4g+V5/VaXEl3K3DXUVUhjWyazm9C
        gk5V5GrHCR4rQU6g9trt+uK15TVjHShVQeRGSkZ84IM6tqyyTIuvyTALeJh5TMLMRZTOCd7Y79uUr
        vZJ7+q1dhYnPa5TGuErUmBJAql0akIFDKMjm6fMAVrlnRKqiE0h2EDdXar/BGZ0VKrDsVBUJethzT
        +Y7tkDV/k+SSgH613OtRdrj2rAzXCbckr61Lsx/WMzkRNzB3U0xSu7mrr3ekLIL+BCMgSHlu3HdaE
        hsq0401g==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nxDOe-004Vh1-Qe; Fri, 03 Jun 2022 19:55:49 +0000
Message-ID: <e7b0b464-0b3c-b37e-2bbe-7380722dea9a@infradead.org>
Date:   Fri, 3 Jun 2022 12:55:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: +
 mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch
 added to mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, lkp@intel.com, naoya.horiguchi@nec.com
References: <20220603164907.B72A2C385B8@smtp.kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220603164907.B72A2C385B8@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 6/3/22 09:49, Andrew Morton wrote:
> The patch titled
>      Subject: mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Subject: mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
> Date: Fri, 3 Jun 2022 02:10:43 +0000
> 
> build fix
> 
> __get_huge_page_for_hwpoison() is not needed when CONFIG_HUGETLB_PAGE is
> n, so extending "#ifdef CONFIG_HUGETLB_PAG" to cover
> __get_huge_page_for_hwpoison() would be a simple resolution.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> 
>  mm/memory-failure.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/memory-failure.c~mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
> +++ a/mm/memory-failure.c
> @@ -1496,6 +1496,7 @@ static int try_to_split_thp_page(struct
>  	return 0;
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
>  /*
>   * Called from hugetlb code with hugetlb_lock held.
>   *
> @@ -1544,7 +1545,6 @@ out:
>  	return ret;
>  }
>  
> -#ifdef CONFIG_HUGETLB_PAGE
>  /*
>   * Taking refcount of hugetlb pages needs extra care about race conditions
>   * with basic operations like hugepage allocation/free/demotion.
> _
> 
> Patches currently in -mm which might be from naoya.horiguchi@nec.com are
> 
> mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page.patch
> mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch
> mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
> mm-hwpoison-make-__page_handle_poison-returns-int.patch
> mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
> mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch
> 

-- 
~Randy

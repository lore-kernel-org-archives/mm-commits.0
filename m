Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70828C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Mar 2022 13:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348772AbiCONvx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348820AbiCONvx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2022 09:51:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2885253701
        for <mm-commits@vger.kernel.org>; Tue, 15 Mar 2022 06:50:41 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHvn22M76zcbJ5;
        Tue, 15 Mar 2022 21:45:42 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 21:50:39 +0800
Subject: Re: +
 mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch added
 to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <tony.luck@intel.com>,
        <shy828301@gmail.com>, <naoya.horiguchi@nec.com>,
        <mike.kravetz@oracle.com>, <bp@alien8.de>
References: <20220314234733.DEA57C340E9@smtp.kernel.org>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ceeeda1f-fa10-0bd1-ae08-f5de72fa45fe@huawei.com>
Date:   Tue, 15 Mar 2022 21:50:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220314234733.DEA57C340E9@smtp.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022/3/15 7:47, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm-memory-failurec-fix-race-with-changing-page-compound-again-fix
> has been added to the -mm tree.  Its filename is
>      mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
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
> Subject: mm-memory-failurec-fix-race-with-changing-page-compound-again-fix
> 
> s@/**@/*@, per Naoya Horiguchi
> 
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memory-failure.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/memory-failure.c~mm-memory-failurec-fix-race-with-changing-page-compound-again-fix
> +++ a/mm/memory-failure.c
> @@ -1534,7 +1534,7 @@ static int memory_failure_hugetlb(unsign
>  
>  	lock_page(head);
>  
> -	/**
> +	/*
>  	 * The page could have changed compound pages due to race window.
>  	 * If this happens just bail out.
>  	 */

Many thanks for doing this. :)

> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
> remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
> mm.patch
> documentation-vm-page_ownerrst-update-the-documentation-fix.patch
> mm-list_lru-replace-linear-array-with-xarray-fix.patch
> mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
> mm-memory-failurec-fix-race-with-changing-page-compound-again-fix.patch
> mm-export-pageheadhuge-fix.patch
> userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
> mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
> mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
> mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
> proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
> linux-typesh-remove-unnecessary-__bitwise__-fix.patch
> taskstats-remove-unneeded-dead-assignment-fix.patch
> linux-next-rejects.patch
> linux-next-git-rejects.patch
> mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
> kasan-improve-vmalloc-tests-fix-3-fix.patch
> mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
> mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
> mutex-subsystem-synchro-test-module-fix.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> 
> .
> 


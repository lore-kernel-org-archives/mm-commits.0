Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAE1C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 20 Sep 2022 01:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiITBhp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 21:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiITBho (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 21:37:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB2749B6D
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 18:37:43 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MWkZP2zdzzMmx8;
        Tue, 20 Sep 2022 09:33:01 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 09:37:41 +0800
Subject: Re: + mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
 added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <sfr@canb.auug.org.au>
References: <20220919202559.4CA0FC433C1@smtp.kernel.org>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <3f220c79-aa66-d520-d48b-9b66a0db693c@huawei.com>
Date:   Tue, 20 Sep 2022 09:37:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220919202559.4CA0FC433C1@smtp.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022/9/20 4:25, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
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
> From: Miaohe Lin <linmiaohe@huawei.com>
> Subject: mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
> Date: Mon, 19 Sep 2022 17:30:51 +0800
> 
> fix htmldocs
> 
> Link: https://lkml.kernel.org/r/1bc55727-9b66-0e9e-c306-f10c4716ea89@huawei.com
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Many thanks for doing this, Andrew. :)

Thanks,
Miaohe Lin


> ---
> 
> 
> --- a/Documentation/core-api/mm-api.rst~mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix
> +++ a/Documentation/core-api/mm-api.rst
> @@ -19,9 +19,6 @@ User Space Memory Access
>  Memory Allocation Controls
>  ==========================
>  
> -.. kernel-doc:: include/linux/gfp.h
> -   :internal:
> -
>  .. kernel-doc:: include/linux/gfp_types.h
>     :doc: Page mobility and placement hints
>  
> _
> 
> Patches currently in -mm which might be from linmiaohe@huawei.com are
> 
> mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
> mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
> mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
> mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
> mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
> mm-hwpoison-cleanup-some-obsolete-comments.patch
> writeback-remove-unused-macro-dirty_full_scope.patch
> mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
> mm-page_alloc-make-zone_pcp_update-static.patch
> mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
> mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
> mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
> mm-page_alloc-fix-freeing-static-percpu-memory.patch
> mm-remove-obsolete-pgdat_is_empty.patch
> mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
> mm-page_alloc-use-local-variable-zone_idx-directly.patch
> mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
> mm-page_alloc-make-boot_nodestats-static.patch
> mm-page_alloc-use-helper-macro-sz_1km.patch
> mm-page_alloc-init-local-variable-buddy_pfn.patch
> mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
> mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
> mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
> mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch
> 
> .
> 


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CB9C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 06:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiBXGX6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Feb 2022 01:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiBXGX6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Feb 2022 01:23:58 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0BB269AB4
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 22:23:28 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K42qV2QkCz9t5n;
        Thu, 24 Feb 2022 14:21:42 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 14:23:26 +0800
Subject: Re: +
 mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <naoya.horiguchi@nec.com>
References: <20220224035930.C6092C340E9@smtp.kernel.org>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <529df045-15f2-46fe-e58f-a5f92ebefefb@huawei.com>
Date:   Thu, 24 Feb 2022 14:23:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220224035930.C6092C340E9@smtp.kernel.org>
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

On 2022/2/24 11:59, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix
> has been added to the -mm tree.  Its filename is
>      mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
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
> Subject: mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix
> 
> export is_free_buddy_page() to modules
> 
> ERROR: modpost: "is_free_buddy_page" [mm/hwpoison-inject.ko] undefined!
> 

This is my overlook. Many thanks for doing this, Andrew. :)

> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/page_alloc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/mm/page_alloc.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix
> +++ a/mm/page_alloc.c
> @@ -9520,6 +9520,7 @@ bool is_free_buddy_page(struct page *pag
>  
>  	return order < MAX_ORDER;
>  }
> +EXPORT_SYMBOL(is_free_buddy_page);
>  
>  #ifdef CONFIG_MEMORY_FAILURE
>  /*
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm.patch
> kasan-improve-vmalloc-tests-fix-3-fix.patch
> documentation-vm-page_ownerrst-update-the-documentation-fix.patch
> x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
> mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
> mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
> mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
> proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
> linux-next-rejects.patch
> drivers-gpu-drm-dp-drm_dpc-fix-build.patch
> mutex-subsystem-synchro-test-module-fix.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
> mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
> 
> .
> 


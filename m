Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0C9EB64DD
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 00:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjGMAuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 20:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjGMAuT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 20:50:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF201FFF
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 17:50:14 -0700 (PDT)
Received: from dggpemm500001.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R1bXZ6yVqzNm5S;
        Thu, 13 Jul 2023 08:46:54 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 13 Jul 2023 08:50:11 +0800
Message-ID: <33e257b0-3b2b-0e58-b4c4-f82a76f34265@huawei.com>
Date:   Thu, 13 Jul 2023 08:50:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: + selinux-use-vma_is_stack-and-vma_is_heap-fix.patch added to
 mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <stephen.smalley.work@gmail.com>,
        <paul@paul-moore.com>, <eparis@parisplace.org>
References: <20230712205336.678A7C433C7@smtp.kernel.org>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20230712205336.678A7C433C7@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 2023/7/13 4:53, Andrew Morton wrote:
> 
> The patch titled
>       Subject: selinux-use-vma_is_stack-and-vma_is_heap-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>       selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: selinux-use-vma_is_stack-and-vma_is_heap-fix
> Date: Wed Jul 12 01:42:33 PM PDT 2023
> 
> fix build
> 
> security/selinux/hooks.c: In function 'selinux_file_mprotect':
> security/selinux/hooks.c:3768:42: error: suggest parentheses around '&&' within '||' [-Werror=parentheses]
>   3768 |                 } else if (!vma->vm_file && vma_is_stack(vma) ||
>        |                            ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
> security/selinux/hooks.c:3769:59: error: expected statement before ')' token
>   3769 |                             vma_is_stack_for_current(vma))) {
>        |                                                           ^
> security/selinux/hooks.c:3768:24: error: this 'if' clause does not guard... [-Werror=misleading-indentation]
>   3768 |                 } else if (!vma->vm_file && vma_is_stack(vma) ||
>        |                        ^~
> security/selinux/hooks.c:3769:61: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
>   3769 |                             vma_is_stack_for_current(vma))) {
>        |                                                             ^
> security/selinux/hooks.c:3772:19: error: expected '}' before 'else'
>   3772 |                 } else if (vma->vm_file && vma->anon_vma) {
>        |                   ^~~~
> security/selinux/hooks.c:3780:25: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
>   3780 |                         rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
>        |                         ^~
>        |                         rq
> security/selinux/hooks.c:3780:25: note: each undeclared identifier is reported only once for each function it appears in
> security/selinux/hooks.c: At top level:
> security/selinux/hooks.c:3786:9: error: expected identifier or '(' before 'return'
>   3786 |         return file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
>        |         ^~~~~~
> security/selinux/hooks.c:3787:1: error: expected identifier or '(' before '}' token
>   3787 | }
>        | ^
> security/selinux/hooks.c: In function 'selinux_file_mprotect':
> security/selinux/hooks.c:3784:9: error: control reaches end of non-void function [-Werror=return-type]
>   3784 |         }
>        |         ^
> 
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Sorry for the typo, my arm64 built without CONFIG_SECURITY_SELINUX
and missing this, thanks Andrew.

> 
>   security/selinux/hooks.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/security/selinux/hooks.c~selinux-use-vma_is_stack-and-vma_is_heap-fix
> +++ a/security/selinux/hooks.c
> @@ -3765,8 +3765,9 @@ static int selinux_file_mprotect(struct
>   		if (vma_is_heap(vma)) {
>   			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
>   					  PROCESS__EXECHEAP, NULL);
> -		} else if (!vma->vm_file && vma_is_stack(vma) ||
> -			    vma_is_stack_for_current(vma))) {
> +		} else if (!vma->vm_file &&
> +			  	(vma_is_stack(vma) ||
> +				 vma_is_stack_for_current(vma))) {
>   			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
>   					  PROCESS__EXECSTACK, NULL);
>   		} else if (vma->vm_file && vma->anon_vma) {
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
> swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
> fs-buffer-clean-up-block_commit_write-fix.patch
> mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
> mm-make-pte_marker_swapin_error-more-general-fix.patch
> selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
> signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
> 

Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A131C77B61
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 01:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDNBEF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Apr 2023 21:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNBEE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2023 21:04:04 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2EB30C4
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 18:04:03 -0700 (PDT)
Received: from dggpemm500001.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PyJ5h0YS0znbGJ;
        Fri, 14 Apr 2023 09:00:24 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 09:04:00 +0800
Message-ID: <6396d25b-3e51-d8b3-993e-67d5b1c6eca7@huawei.com>
Date:   Fri, 14 Apr 2023 09:04:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: +
 mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes.patch
 added to mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>
References: <20230413220604.145C4C433D2@smtp.kernel.org>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20230413220604.145C4C433D2@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 2023/4/14 6:06, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes.patch
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
> Subject: mm-hwpoison-coredump-support-recovery-from-dump_user_range-checkpatch-fixes
> Date: Thu Apr 13 03:05:23 PM PDT 2023
> 
> WARNING: 'an user' may be misspelled - perhaps 'a user'?
> #33:
> address may not always an user address, so introduce a new copy_mc flag in
>                         ^^^^^^^
> 
> WARNING: please, no spaces at the start of a line
> #133: FILE: lib/iov_iter.c:637:
> +       if (iov_iter_is_copy_mc(i))$
> 
> WARNING: suspect code indent for conditional statements (7, 15)
> #133: FILE: lib/iov_iter.c:637:
> +       if (iov_iter_is_copy_mc(i))
> +               return (void *)copy_mc_to_kernel(to, from, size);
> 
> ERROR: code indent should use tabs where possible
> #134: FILE: lib/iov_iter.c:638:
> +               return (void *)copy_mc_to_kernel(to, from, size);$
> 
> WARNING: please, no spaces at the start of a line
> #134: FILE: lib/iov_iter.c:638:
> +               return (void *)copy_mc_to_kernel(to, from, size);$
> 
> total: 1 errors, 4 warnings, 118 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>        mechanically convert to the typical style using --fix or --fix-inplace.
> 
> NOTE: Whitespace errors detected.
>        You may wish to use scripts/cleanpatch or scripts/cleanfile
> 
> ./patches/mm-hwpoison-coredump-support-recovery-from-dump_user_range.patch has style problems, please review.
> 
> NOTE: If any of the errors are false positives, please report
>        them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> Please run checkpatch prior to sending patches
> 

Hi Andrew, thanks for your fixes, I should do it, sorry, and I realized
the help iov_iter_clear_copy_mc() is not needed, at least for coredump
memcpy recovery, because the iov_iter is a local variable, after 
__kernel_write_iter(), no one use it, I will wait a moment to see if any 
other comments and resend a new patch with dropping clear helper and fix 
above issue.

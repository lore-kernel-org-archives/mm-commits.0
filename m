Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D08EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Oct 2021 01:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F17E61261
	for <mm-commits@archiver.kernel.org>; Fri,  8 Oct 2021 01:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhJHBZt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 21:25:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13707 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJHBZs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2021 21:25:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HQVmF3QJyzWlM6;
        Fri,  8 Oct 2021 09:22:21 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Fri, 8 Oct 2021 09:23:51 +0800
Received: from [10.174.177.210] (10.174.177.210) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 8 Oct 2021 09:23:51 +0800
Message-ID: <a031b77d-ac70-030a-2a93-da8b30b3bc61@huawei.com>
Date:   Fri, 8 Oct 2021 09:23:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: + ramfs-fix-mount-source-show-for-ramfs.patch added to -mm tree
To:     <akpm@linux-foundation.org>, <mm-commits@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>
References: <20210924204434.4IOy6Z6z9%akpm@linux-foundation.org>
From:   yangerkun <yangerkun@huawei.com>
In-Reply-To: <20210924204434.4IOy6Z6z9%akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.210]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema766-chm.china.huawei.com (10.1.198.208)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Gently ping for this patch...

在 2021/9/25 4:44, akpm@linux-foundation.org 写道:
> 
> The patch titled
>       Subject: ramfs: fix mount source show for ramfs
> has been added to the -mm tree.  Its filename is
>       ramfs-fix-mount-source-show-for-ramfs.patch
> 
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/ramfs-fix-mount-source-show-for-ramfs.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/ramfs-fix-mount-source-show-for-ramfs.patch
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
> From: yangerkun <yangerkun@huawei.com>
> Subject: ramfs: fix mount source show for ramfs
> 
> ramfs_parse_param does not parse key "source", and will convert -ENOPARAM
> to 0.  This will skip vfs_parse_fs_param_source in vfs_parse_fs_param,
> which lead always "none" mount source for ramfs.  Fix it by parse "source"
> in ramfs_parse_param like cgroup1_parse_param has do.
> 
> Link: https://lkml.kernel.org/r/20210924091756.1906118-1-yangerkun@huawei.com
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   fs/ramfs/inode.c |   11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> --- a/fs/ramfs/inode.c~ramfs-fix-mount-source-show-for-ramfs
> +++ a/fs/ramfs/inode.c
> @@ -203,17 +203,20 @@ static int ramfs_parse_param(struct fs_c
>   	int opt;
>   
>   	opt = fs_parse(fc, ramfs_fs_parameters, param, &result);
> -	if (opt < 0) {
> +	if (opt == -ENOPARAM) {
> +		opt = vfs_parse_fs_param_source(fc, param);
> +		if (opt != -ENOPARAM)
> +			return opt;
>   		/*
>   		 * We might like to report bad mount options here;
>   		 * but traditionally ramfs has ignored all mount options,
>   		 * and as it is used as a !CONFIG_SHMEM simple substitute
>   		 * for tmpfs, better continue to ignore other mount options.
>   		 */
> -		if (opt == -ENOPARAM)
> -			opt = 0;
> -		return opt;
> +		return 0;
>   	}
> +	if (opt < 0)
> +		return opt;
>   
>   	switch (opt) {
>   	case Opt_mode:
> _
> 
> Patches currently in -mm which might be from yangerkun@huawei.com are
> 
> ramfs-fix-mount-source-show-for-ramfs.patch
> 
> .
> 

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC967C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 13:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C92C66121F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 13:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhIONWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 09:22:35 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44168 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbhIONWe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Sep 2021 09:22:34 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:47694)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mQUqf-007zJo-8q; Wed, 15 Sep 2021 07:21:13 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:46890 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mQUqb-003ljh-9P; Wed, 15 Sep 2021 07:21:11 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     akpm@linux-foundation.org
Cc:     axboe@kernel.dk, krisman@collabora.com, legion@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        ran.xiaokai@zte.com.cn
References: <20210915035327.38DUnaS_8%akpm@linux-foundation.org>
Date:   Wed, 15 Sep 2021 08:20:44 -0500
In-Reply-To: <20210915035327.38DUnaS_8%akpm@linux-foundation.org> (akpm's
        message of "Tue, 14 Sep 2021 20:53:27 -0700")
Message-ID: <8735q6c6vn.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mQUqb-003ljh-9P;;;mid=<8735q6c6vn.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18fi+Jodgwu6yIl8ibEinZet3h+mnMqZOQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: + unshare-use-swap-to-make-code-cleaner.patch added to -mm tree
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

akpm@linux-foundation.org writes:

> The patch titled
>      Subject: kernel/fork.c: unshare(): use swap() to make code cleaner
> has been added to the -mm tree.  Its filename is
>      unshare-use-swap-to-make-code-cleaner.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/unshare-use-swap-to-make-code-cleaner.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/unshare-use-swap-to-make-code-cleaner.patch
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

Why is the swap macro spelled in lower case?

Given that there is no way to write swap as a function I would think we
would want to write SWAP instead of swap to make it clear swap is a
macro.

Eric


> ------------------------------------------------------
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Subject: kernel/fork.c: unshare(): use swap() to make code cleaner
>
> Use swap() instead of reimplementing it.
>
> Link: https://lkml.kernel.org/r/20210909022046.8151-1-ran.xiaokai@zte.com.cn
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Alexey Gladkov <legion@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/fork.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> --- a/kernel/fork.c~unshare-use-swap-to-make-code-cleaner
> +++ a/kernel/fork.c
> @@ -3078,7 +3078,7 @@ int unshare_fd(unsigned long unshare_fla
>  int ksys_unshare(unsigned long unshare_flags)
>  {
>  	struct fs_struct *fs, *new_fs = NULL;
> -	struct files_struct *fd, *new_fd = NULL;
> +	struct files_struct *new_fd = NULL;
>  	struct cred *new_cred = NULL;
>  	struct nsproxy *new_nsproxy = NULL;
>  	int do_sysvsem = 0;
> @@ -3165,11 +3165,8 @@ int ksys_unshare(unsigned long unshare_f
>  			spin_unlock(&fs->lock);
>  		}
>  
> -		if (new_fd) {
> -			fd = current->files;
> -			current->files = new_fd;
> -			new_fd = fd;
> -		}
> +		if (new_fd)
> +			swap(current->files, new_fd);
>  
>  		task_unlock(current);
>  
> _
>
> Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are
>
> unshare-use-swap-to-make-code-cleaner.patch

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DFFC636C9
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 12:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398DE60C3E
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 12:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhGUMLL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 08:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhGUMLL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jul 2021 08:11:11 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04980C061574
        for <mm-commits@vger.kernel.org>; Wed, 21 Jul 2021 05:51:48 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m2so2092554wrq.2
        for <mm-commits@vger.kernel.org>; Wed, 21 Jul 2021 05:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eoW21vw4opajfE8sI9Wz2+CRvdZDIPU5XTtukbLmHfw=;
        b=EmsozAw5kxpwB95h3oFkY2GECZVPjLmhF7ETf7denY0iNkSxTk2wMzDL8DHl/1nanl
         TiNohRQkPVAs+xu3wSSUfK8f+qiJLNtnG3Qzn8VIRFqZ0iQjaFtB1dovslmSVduSOYDr
         NxZHDwXESHnZEkNvaraT1Q8ixCqu4nHxwvqGXsHF99E6Qstn1bo/qrsHCEuvnTJNZOLs
         9dMSay1z7nQ7TRPEsQw2tqtUfsJJLmjepQTMTJgneGG9qc6hTZdXXQ/GC9rLXI1RR/Js
         myH0gGYZcyBnVA2BfAFy7+UfKaB6AUx42SKHbJpHqCWtx5Ck5oQe1acp4n7UUobpSeo1
         hQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eoW21vw4opajfE8sI9Wz2+CRvdZDIPU5XTtukbLmHfw=;
        b=ThXdaFaTZ49Vfj/l033+WQjr/yoc95IYxbYhbORce/oCSrDODwJqJ+1vpQeLgCerjq
         h30mboMxC5DUX0IiKgwiRZsphwxUBzbNX/vW+oG9sZtlL+YGfBb0TNppSSJTlPKrrORt
         nCnNLYOpFYLjWIntckftA/TGtUZDD7Vj0X1BAV+R7dBmJLgn2InDOGRUeOQwLmMlBv38
         2y+nkkb/zm8w0lhTcHJsmbaJIq9GB7nX381qipNZvZR5czIrwOjtxcyjwL6fXz92CA8J
         xDujdkIb7iyFbRmiIyTiuJ0NQNym2uw0ML/yxIKnMP/A5dtfMxAIEmwHnvSrEjWgkIp6
         cvpw==
X-Gm-Message-State: AOAM5320gJuTuoOP7uHbaNN311bLIQlChQ4Iu7XyUwBERX/Eu2pfJMt+
        dClf1hW0tG8UTckPznvqkKk=
X-Google-Smtp-Source: ABdhPJyRzTEbV88K5IvD/ONCHlFfryTq59OucobVpKVXtkqUNxr/6R3zt3oEn9Z1nlvqqgfQj98PXw==
X-Received: by 2002:a5d:4748:: with SMTP id o8mr35686510wrs.202.1626871906459;
        Wed, 21 Jul 2021 05:51:46 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id o7sm19433087wrs.52.2021.07.21.05.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 05:51:45 -0700 (PDT)
Subject: Re: + mm-mremap-fix-memory-account-on-do_munmap-failure.patch added
 to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        weiyongjun1@huawei.com, wangkefeng.wang@huawei.com,
        chenwandun@huawei.com
References: <20210720232820.Yy_P-%akpm@linux-foundation.org>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <55a82401-7d06-f69b-16de-7933f8ac3006@gmail.com>
Date:   Wed, 21 Jul 2021 13:51:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720232820.Yy_P-%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 7/21/21 12:28 AM, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: mm/mremap: fix memory account on do_munmap() failure
> has been added to the -mm tree.  Its filename is
>      mm-mremap-fix-memory-account-on-do_munmap-failure.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-fix-memory-account-on-do_munmap-failure.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-fix-memory-account-on-do_munmap-failure.patch
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
> From: Chen Wandun <chenwandun@huawei.com>
> Subject: mm/mremap: fix memory account on do_munmap() failure
> 
> mremap will account the delta between new_len and old_len in
> vma_to_resize, and then call move_vma when expanding an existing memory
> mapping.  In function move_vma, there are two scenarios when calling
> do_munmap:
> 
> 1. move_page_tables from old_addr to new_addr success
> 2. move_page_tables from old_addr to new_addr fail
> 
> In first scenario, it should account old_len if do_munmap fail, because
> the delta has already been accounted.
> 
> In second scenario, new_addr/new_len will assign to old_addr/old_len if
> move_page_table fail, so do_munmap is try to unmap new_addr actually, if
> do_munmap fail, it should account the new_len, because error code will be
> return from move_vma, and delta will be unaccounted.  What'more, because
> of new_len == old_len, so account old_len also is OK.
> 
> In summary, account old_len will be correct if do_munmap fail.
> 
> Link: https://lkml.kernel.org/r/20210717101942.120607-1-chenwandun@huawei.com
> Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Nice catch!

> ---
> 
>  mm/mremap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/mremap.c~mm-mremap-fix-memory-account-on-do_munmap-failure
> +++ a/mm/mremap.c
> @@ -686,7 +686,7 @@ static unsigned long move_vma(struct vm_
>  	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
>  		/* OOM: unable to split vma, just get accounts right */
>  		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
> -			vm_acct_memory(new_len >> PAGE_SHIFT);
> +			vm_acct_memory(old_len >> PAGE_SHIFT);
>  		excess = 0;
>  	}
>  

But now as you noticed the accounting in  vma_to_resize(), I can't help
but see that accounting for MREMAP_DONTUNMAP seems to have been broken
from the beginning. Either we should also hack around this way:

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -605,7 +605,12 @@ static unsigned long move_vma(struct vm_area_struct
*vma,
 		return err;

 	if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT)) {
-		if (security_vm_enough_memory_mm(mm, new_len >> PAGE_SHIFT))
+		/*
+		 * new_len >= old_len, VMA shrinking is not in this path.
+		 * (new_len - old_len) is already charged in vma_to_resize()
+		 * So, charge old_len instead of new_len.
+		 */
+		if (security_vm_enough_memory_mm(mm, old_len >> PAGE_SHIFT))
 			return -ENOMEM;
 	}

@@ -614,7 +619,7 @@ static unsigned long move_vma(struct vm_area_struct
*vma,
 			   &need_rmap_locks);
 	if (!new_vma) {
 		if (unlikely(flags & MREMAP_DONTUNMAP && vm_flags & VM_ACCOUNT))
-			vm_unacct_memory(new_len >> PAGE_SHIFT);
+			vm_unacct_memory(old_len >> PAGE_SHIFT);
 		return -ENOMEM;
 	}

--->8---

But I hate what's going on here.
That's disgusting, let's not account/unaccount memory for
vma_to_resize(), I've sent an alternative patch:
https://lore.kernel.org/lkml/20210721124949.517217-1-dima@arista.com/


Thanks,
           Dmitry

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA4FC433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 02:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C16461426
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 02:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEICcK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 22:32:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229616AbhEICcK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 May 2021 22:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620527467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBco5bn2qhmEeT1pjWfRIfC4CY3dVbd63+xi9aPQ3JI=;
        b=FVR2+skNta1ORxSXP5zsux9z7slS5oJpNoAPR+ReMBqyKz2Okl3wnLHn+cW6+CKquoeR8J
        PaLCjcvMn005qD9kEF9iC2IwMmZWTOe9oqhOQoPuzaRjjxne8bM2Y4aTpq9QMDCfctueOI
        XZB5fBl4UV6IXJhrUaTPiPqbOP0Cm5Y=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-z3yLNsdLPAWsNtFyZFvyAQ-1; Sat, 08 May 2021 22:30:59 -0400
X-MC-Unique: z3yLNsdLPAWsNtFyZFvyAQ-1
Received: by mail-qv1-f70.google.com with SMTP id t9-20020a0cde090000b02901c4c7ae0cceso9713083qvk.7
        for <mm-commits@vger.kernel.org>; Sat, 08 May 2021 19:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BBco5bn2qhmEeT1pjWfRIfC4CY3dVbd63+xi9aPQ3JI=;
        b=LuOLinurVrna2EFo79ZxTC7fCIxaR+0CS7xV1nSJqARBDh7i7DaWQbXL5Z+B1SpIAz
         +UeuEA1ii+hH5wXH4SjRwfBHA32YPXr5IZcxDFfIQc3qlzCpF9vOXYnXQwvKaQM/KGEY
         2+6Fh2UKRaAiBJ7Czg4mhuAJwqzU06C/jstu2Cb33JPX/chno5qwKD3zUy0ofuYQmdv1
         i5qTNz7//PcwAvAeGKYKdhFoZ7ha+tSczBfHOT5cAsueeoozqc61V/VhD6Tp/Qb8rawL
         jsdBkZPTijlJJ6Ubyn4koaLiOVEaKnn7yEqK6gjotsQ+UOcfKHkwBFIqChIWgbTsonbd
         Thww==
X-Gm-Message-State: AOAM533R5mrtQ1SPUv8AOEhm+syNOgcOeDr3OC38BaBflkzQYkxVC7yk
        uotZ9eCoE65/45p01VNutf+08dhIAeEEHUcSZwFxD/yoxbK8qm9vJ7QpIoWf2eyTLGyjPcIrlYe
        pwK5ejQvKbXz+vGHjyqDdcQ==
X-Received: by 2002:a37:8246:: with SMTP id e67mr16991584qkd.410.1620527459028;
        Sat, 08 May 2021 19:30:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+2mUMYHRNx5mDQk/TxH31xKykmZRVFJ1985Fhj7wGzXxgLywA9xCNiPi7qPhFrUJ6j6oQQQ==
X-Received: by 2002:a37:8246:: with SMTP id e67mr16991569qkd.410.1620527458824;
        Sat, 08 May 2021 19:30:58 -0700 (PDT)
Received: from llong.remote.csb ([2601:191:8500:76c0::cdbc])
        by smtp.gmail.com with ESMTPSA id z187sm1798221qkb.129.2021.05.08.19.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 19:30:58 -0700 (PDT)
From:   Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Subject: Re: +
 mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
 added to -mm tree
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        chris@chrisdown.name, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        msys.mizuma@gmail.com, penberg@kernel.org,
        richard.weiyang@gmail.com, rientjes@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
References: <20210509004741.kIbOoDt_Z%akpm@linux-foundation.org>
Message-ID: <3738644c-3400-3960-3183-a019f57a8f11@redhat.com>
Date:   Sat, 8 May 2021 22:30:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210509004741.kIbOoDt_Z%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 5/8/21 8:47 PM, akpm@linux-foundation.org wrote:
> The patch titled
>       Subject: mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes
> has been added to the -mm tree.  Its filename is
>       mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
>
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes
>
> WARNING: else is not generally useful after a break or return
> #138: FILE: mm/memcontrol.c:2121:
> +		return &stock->task_obj;
> +	} else {
>
> total: 0 errors, 1 warnings, 193 lines checked
>
> NOTE: For some of the reported defects, checkpatch may be able to
>        mechanically convert to the typical style using --fix or --fix-inplace.
>
> ./patches/mm-memcg-optimize-user-context-object-stock-access.patch has style problems, please review.
>
> NOTE: If any of the errors are false positives, please report
>        them to the maintainer, see CHECKPATCH in MAINTAINERS.
>
> Please run checkpatch prior to sending patches
>
> Cc: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   mm/memcontrol.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- a/mm/memcontrol.c~mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes
> +++ a/mm/memcontrol.c
> @@ -2118,11 +2118,11 @@ static inline struct obj_stock *get_obj_
>   		preempt_disable();
>   		stock = this_cpu_ptr(&memcg_stock);
>   		return &stock->task_obj;
> -	} else {
> -		local_irq_save(*pflags);
> -		stock = this_cpu_ptr(&memcg_stock);
> -		return &stock->irq_obj;
>   	}
> +
> +	local_irq_save(*pflags);
> +	stock = this_cpu_ptr(&memcg_stock);
> +	return &stock->irq_obj;
>   }
>   
>   static inline void put_obj_stock(unsigned long flags)
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> mm.patch
> mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
> mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
> linux-next-git-rejects.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
>
Sorry, I forgot to run a final scripts/checkpatch.pl before sending it 
out. Please merge it with the previous patch.

Acked-by: Waiman Long <longman@redhat.com

Thanks,
Longman


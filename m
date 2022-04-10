Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66652C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Apr 2022 16:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbiDJQld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Apr 2022 12:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiDJQlb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Apr 2022 12:41:31 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FDD4B1DE
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 09:39:20 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 3so1471744qkj.5
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XPhaOPkM5+iL/tmr4udTx9ZAR8AFdK9PiRtzoMvRN8M=;
        b=Y1IqZNsh5SymQyFDumS5HXobjVzte7wpEFh3YkFEiAwxhxLnluoWbdORfmrJ4MhV/T
         UWC7IBYALdQPCeA7RLC/VYVgmvt8gSIY2K/J8cI6ehMsoyHvZCOVFbhiLdaG5th0JTDT
         mUEf8yIGd29vb0/+jjCvdtrmvmoEj6mu1t5QrzwJwtDry9V/kAItGg1I3nDkcDmTAS/F
         /yFm62kZN65rBzqhuMKEUmHx+WP5p80oW+B8NrrFZ3Fvu+YF5y6U32vNexwm+1bTVG0j
         MGtsr9gNAnxodCb5lWkgod7sIk10l1vxtxK9Q9Ipv7yqrZPcoeZOq9iILbwThJ0e8+AQ
         7tbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XPhaOPkM5+iL/tmr4udTx9ZAR8AFdK9PiRtzoMvRN8M=;
        b=Z7vjHq774+1PhQLzBfBD+pwHyx6Nj3sAKOwMlPKO8TIvO4cLO4bKpBAouqlD8DcUyj
         YwQHkuNdMz4qGKXyfDwPxKIGRoZ3Gt/XA/oa0zg51TtKT0iK3LPHkY23FOiLSqDUzX+Z
         Sdn0yM8hx+RGycF53vQpXNszQN1TcGB+YbCfBXsl0dWsrNxs1HFTVyjLvWWErp+RpAhM
         ZAiNlWO/4v7uVZwMFLEPqSiGGMQ0ViUyYWSBsqSV4eUQLT2Hn/5BqOcjaPgjvjoy5j3v
         pwnZlcBRrQAFtNfOJKsD/BNLbhxMW4fA4ajCfV/qLV+rFIZp8t2aLTaZ7eyXz1aOAwxc
         bD5Q==
X-Gm-Message-State: AOAM532+wwHg+RPCXvs5HteIqP6TE7XqTVu9/fp0PC6fz1JhnWyR7rOm
        eARPEckjH91UFZmbu25DOdA=
X-Google-Smtp-Source: ABdhPJwF60eipR98OXG4VbibuaCbBP0pDZmfsFKgpOQXjDtTsvWAaQ4DM+O/eB1mdEQdiimfvRbAow==
X-Received: by 2002:a05:620a:4694:b0:67e:ca07:4d46 with SMTP id bq20-20020a05620a469400b0067eca074d46mr18967580qkb.624.1649608759412;
        Sun, 10 Apr 2022 09:39:19 -0700 (PDT)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id o3-20020a05622a008300b002e06a103476sm23569645qtw.55.2022.04.10.09.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 09:39:19 -0700 (PDT)
Date:   Sun, 10 Apr 2022 09:39:16 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        urezki@gmail.com, npiggin@gmail.com, dingtianhong@huawei.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        aklimov@redhat.com
Subject: Re: [to-be-updated] vmap-dont-allow-invalid-pages.patch removed from
 -mm tree
Message-ID: <YlMINMJ1lhj9lkK4@yury-laptop>
References: <20220321211611.C59E9C340E8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321211611.C59E9C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Mar 21, 2022 at 02:16:11PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/vmalloc.c: vmap(): don't allow invalid pages
> has been removed from the -mm tree.  Its filename was
>      vmap-dont-allow-invalid-pages.patch
> 
> This patch was dropped because an updated version will be merged

Hi Andrew,

Can you please clarify what updated version did you mean? Are you
waiting for a v3 from me with extended patch comment, or something
else?

Thanks,
Yury
 
> ------------------------------------------------------
> From: Yury Norov <yury.norov@gmail.com>
> Subject: mm/vmalloc.c: vmap(): don't allow invalid pages
> 
> vmap() takes struct page *pages as one of arguments, and user may provide
> an invalid pointer which would lead to data abort at address translation
> later.
> 
> Currently, kernel checks the pages against NULL.  In my case, however, the
> address was not NULL, and was big enough so that the hardware generated
> Address Size Abort on arm64.
> 
> Interestingly, this abort happens even if copy_from_kernel_nofault() is
> used, which is quite inconvenient for debugging purposes.
> 
> This patch adds a pfn_valid() check into vmap() path, so that invalid
> mapping will not be created.
> 
> Link: https://lkml.kernel.org/r/20220119012109.551931-1-yury.norov@gmail.com
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Ding Tianhong <dingtianhong@huawei.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Alexey Klimov <aklimov@redhat.com>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/vmalloc.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/mm/vmalloc.c~vmap-dont-allow-invalid-pages
> +++ a/mm/vmalloc.c
> @@ -478,6 +478,8 @@ static int vmap_pages_pte_range(pmd_t *p
>  			return -EBUSY;
>  		if (WARN_ON(!page))
>  			return -ENOMEM;
> +		if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> +			return -EINVAL;
>  		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
>  		(*nr)++;
>  	} while (pte++, addr += PAGE_SIZE, addr != end);
> _
> 
> Patches currently in -mm which might be from yury.norov@gmail.com are
> 

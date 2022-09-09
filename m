Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42739ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 14:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIIOMH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 10:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIIOMG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 10:12:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B0B5A3F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 07:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662732722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NRIJ8rbXfFrqV3jD21o8m4MwjT+JrZDONs2r6OiAQ+c=;
        b=aJMwCTm8545NDj8k6bHSczOLdvPPw+ilOX/BS8tFHWluur58jssGZr1U3mZ4kObTcIlnNt
        TBj7tsPE+KAo+UJo1NYr7MjIqOFljqM7Mj+aoVUwd7ZwZ7Jgu/rHX31+QwDb4pWVyiDp9m
        +IXyBkNGhaBhsMNwZnymDiQ22ipzuSk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-281-nQ7KCUZGPe2yoepfykzQOw-1; Fri, 09 Sep 2022 10:12:01 -0400
X-MC-Unique: nQ7KCUZGPe2yoepfykzQOw-1
Received: by mail-qk1-f199.google.com with SMTP id de43-20020a05620a372b00b006bc3aa1908dso1538021qkb.15
        for <mm-commits@vger.kernel.org>; Fri, 09 Sep 2022 07:12:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=NRIJ8rbXfFrqV3jD21o8m4MwjT+JrZDONs2r6OiAQ+c=;
        b=n1zk9Ca5/Q0Q9OqWKQZ5tPxUMVA+bFbChfpKD3mRXr9zDUwzrncQHjmWwrduidYFy1
         GeW5s4J1RJrBEf0kxkR24yLpNBLnbgHtWxTz28nHC4ZwTKY8pT4jZ5lprTp21FM371HJ
         87CddcWESfS3a7qV2b7GIccPGY8jfWWPrzV2trn2teVfsjo9JS5zWp1FVYOXcPLPJBfo
         XnC+c1S6hM/SII4XFHZ6XTnWE+9jBcMT8lVu/iCW0pSguWx0f1XALbRQH3WLpOKhYDWX
         AD+yLEvH+nQB0VftUsbwc46Ioythg2S71NtZRE6Dh4Usc3WFSMB5CJYydpUOSdltUSlN
         UQqw==
X-Gm-Message-State: ACgBeo0L98CkYcVdfqcsUB1ADrzxUNBZENaJObI157+rXSYuHrrKdF2z
        PBjdIQrh7FqC+fgMagBOBQQOVOeu7N1ICVSsIR+yPhI9Q6diRGPGiMBhOi0RCDJARxvCzt8Tpe7
        8KnPjUaWRlu35MHrFt0G5xA==
X-Received: by 2002:a05:620a:198e:b0:6bb:7651:fc7 with SMTP id bm14-20020a05620a198e00b006bb76510fc7mr9898997qkb.376.1662732721142;
        Fri, 09 Sep 2022 07:12:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5LLLyDEyy0Z6OfT9a7056s3IEMqWPxl51obJ5ygo1j6XbkgUnpPcxn8r+VyWp/UMciCeNZbg==
X-Received: by 2002:a05:620a:198e:b0:6bb:7651:fc7 with SMTP id bm14-20020a05620a198e00b006bb76510fc7mr9898979qkb.376.1662732720893;
        Fri, 09 Sep 2022 07:12:00 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id f5-20020a05622a1a0500b003445bb107basm477362qtb.75.2022.09.09.07.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:12:00 -0700 (PDT)
Date:   Fri, 9 Sep 2022 10:11:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        david@redhat.com, apopple@nvidia.com, chenwandun@huawei.com
Subject: Re: +
 mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch added to
 mm-unstable branch
Message-ID: <YxtJr0kyV1v6kx3N@xz-m1.local>
References: <20220907233412.27BC6C433D6@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220907233412.27BC6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 07, 2022 at 04:34:11PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: avoid unnecessary page table walk for __get_user_pages
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch
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
> From: Chen Wandun <chenwandun@huawei.com>
> Subject: mm: avoid unnecessary page table walk for __get_user_pages
> Date: Tue, 6 Sep 2022 10:44:01 +0800
> 
> There is no need to walk page tables and find pages if faultin_page)_
> succeeds and __get_user_pages)_ doesn't care about populating the pages[]
> array.  So directly go on to handle the next page.
> 
> Link: https://lkml.kernel.org/r/20220906024401.133336-1-chenwandun@huawei.com
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/gup.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/mm/gup.c~mm-avoid-unnecessary-page-table-walk-for-__get_user_pages
> +++ a/mm/gup.c
> @@ -1175,7 +1175,10 @@ retry:
>  					   PTR_ERR(page) == -EMLINK, locked);
>  			switch (ret) {
>  			case 0:
> -				goto retry;
> +				if (pages)
> +					goto retry;
> +				else
> +					goto next_page;
>  			case -EBUSY:
>  			case -EAGAIN:
>  				ret = 0;

Will this mess up the refcounts already?  afaict follow_page_mask() is the
only place to grab the pages, and GUP should need to take refcounts on
pages even without pages** being passed in.

Meanwhile I'd think there will be cases that require multiple entrances of
continuous follow_page_mask() + faultin_page() sequences, that even the
previous round of faultin_page() returned success but follow_page_mask()
may still want one more round of faulting for some reason to finally grab
the correct page.

> _
> 
> Patches currently in -mm which might be from chenwandun@huawei.com are
> 
> mm-avoid-unnecessary-page-table-walk-for-__get_user_pages.patch
> 

-- 
Peter Xu


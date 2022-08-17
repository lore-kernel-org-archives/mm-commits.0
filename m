Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA47C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 21:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbiHQVUb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 17:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiHQVU2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 17:20:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A65FA5720
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 14:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660771226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pjEqKGiHz62sHaQ+yj+9fZeNPDNp3TuLnKhdZXX2z2s=;
        b=ULYMAnAh+ZMbnHlFA7YgT6uVBQhJAsNKHE5230kxuVD2Xx+IVFQrzjs8EHBGqkSaRg+jPb
        nmhQBYcwCqcivp0rp/81WTOCLW61v73K/WUOj4Wdvb9OCkDBhq2d1zUE1cZRSeIuD4MBgo
        YBNRODe3IyF1EZyq70mBAyIWJup02Yc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-511-Ej4Q8Kh6PXu7EzV9qT4_qQ-1; Wed, 17 Aug 2022 17:20:25 -0400
X-MC-Unique: Ej4Q8Kh6PXu7EzV9qT4_qQ-1
Received: by mail-io1-f69.google.com with SMTP id y10-20020a5d914a000000b00688fa7b2252so1315856ioq.0
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 14:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=pjEqKGiHz62sHaQ+yj+9fZeNPDNp3TuLnKhdZXX2z2s=;
        b=Yuu7qBNMnRVMVbuiBiCsihU2CudbtV+ikoXjzAx+1UBfsiB1b/9lwiI34kWspOp3Aw
         Kt/bCS7cd/1EOfIPYwiuXaYpLRJjGjMwCc1v+KwCP/2+IKmwecDrI+7KT53udb+wJBFX
         NOgU1E2qQLrIGw1VcFmmz+5prH07nnExzNez6iuj0ZNp7CiaWuEgIJ2bFBPSqJw7DKi0
         Di7kRoYGLxV1fRrWoNJtwyzaD20o7BG/NDN/HCt6WZqfcAgBX43SrUUSkxthb9GPSTMf
         xNz3Oj0jGBpELnttLVy6KCsVmk+4/gK/Vi1/MUUNyfKtRcWz9pSbX1UIanxPgwuGizFH
         B4rQ==
X-Gm-Message-State: ACgBeo322LWwXfAPtiEiZRI5JWJGwlr5fevkVA1um4mBVt7uFI7uYpJv
        YNYvjTj7DO2iSp0a3sSDPtLI9Ib26hUT4+O1smm2URh0MiBmmCoGMQzI2UOldHsHmQp2L5C+xM5
        JHfyi97VwQqVR/7q9jnk35w==
X-Received: by 2002:a05:6e02:1ca5:b0:2df:3283:b4a8 with SMTP id x5-20020a056e021ca500b002df3283b4a8mr18649ill.131.1660771224611;
        Wed, 17 Aug 2022 14:20:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4JEV2VMAN4UToltJRVEkpLTGHwtb6r9BTMYmE908JEJ+EW40/c9xUdUf4sNR+RR0XZV/y20A==
X-Received: by 2002:a05:6e02:1ca5:b0:2df:3283:b4a8 with SMTP id x5-20020a056e021ca500b002df3283b4a8mr18642ill.131.1660771224392;
        Wed, 17 Aug 2022 14:20:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p17-20020a056638217100b00343455007f7sm5894134jak.110.2022.08.17.14.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 14:20:23 -0700 (PDT)
Date:   Wed, 17 Aug 2022 15:20:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, hch@lst.de,
        felix.kuehling@amd.com, david@redhat.com, apopple@nvidia.com,
        alex.sierra@amd.com
Subject: Re: [merged mm-hotfixes-stable]
 mm-re-allow-pinning-of-zero-pfns-again.patch removed from -mm tree
Message-ID: <20220817152021.6b519be7.alex.williamson@redhat.com>
In-Reply-To: <20220817205701.3A3BFC433C1@smtp.kernel.org>
References: <20220817205701.3A3BFC433C1@smtp.kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 17 Aug 2022 13:57:00 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The quilt patch titled
>      Subject: mm: re-allow pinning of zero pfns (again)
> has been removed from the -mm tree.  Its filename was
>      mm-re-allow-pinning-of-zero-pfns-again.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Alex Williamson <alex.williamson@redhat.com>
> Subject: mm: re-allow pinning of zero pfns (again)
> Date: Wed, 10 Aug 2022 10:53:59 -0600
> 
> The below referenced commit makes the same error as 1c563432588d ("mm: fix
> is_pinnable_page against a cma page"), re-interpreting the logic to
> exclude pinning of the zero page, which breaks device assignment with
> vfio.
> 
> To avoid further subtle mistakes, split the logic into discrete tests.
> 
> Link: https://lkml.kernel.org/r/166015037385.760108.16881097713975517242.stgit@omen
> Link: https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen
> Fixes: f25cbb7a95a2 ("mm: add zone device coherent type memory support")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Cc: Alex Sierra <alex.sierra@amd.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/mm.h |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- a/include/linux/mm.h~mm-re-allow-pinning-of-zero-pfns-again
> +++ a/include/linux/mm.h
> @@ -1544,9 +1544,8 @@ static inline bool is_longterm_pinnable_
>  	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
>  		return false;
>  #endif
> -	return !(is_device_coherent_page(page) ||
> -		 is_zone_movable_page(page) ||
> -		 is_zero_pfn(page_to_pfn(page)));
> +	return !(is_device_coherent_page(page) || is_zone_movable_page(page)) ||
> +	       is_zero_pfn(page_to_pfn(page));
>  }
>  #else
>  static inline bool is_longterm_pinnable_page(struct page *page)

Something is off here, this is the v1 patch with the v2 commit log,
including link to the v2 posting.  Thanks,

Alex


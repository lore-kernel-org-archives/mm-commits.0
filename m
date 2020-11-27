Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29091C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 27 Nov 2020 10:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3099206F4
	for <mm-commits@archiver.kernel.org>; Fri, 27 Nov 2020 10:19:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTAmXr5q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgK0KTt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 05:19:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbgK0KTt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 05:19:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606472388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ggpE9uJFpRcBtD+unnOgH6GdeCYlB2fEDPd7p4kCLEc=;
        b=OTAmXr5qZbsv5uD1vDYTOMXfQYBh5NXITJ796GKzQL+0XGunL3IG0XlMTIM4YxN/jvspYX
        nFU8kHy3+xKUMTqumgbTFKGJGGfyl0WF2SaI8x0GfEM+94yZfpxMIkz6X8VlSW9iE1/QrK
        PVACHa9U6Xi+yt3voED7Dw143ziNuDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-9iM2g366Oqux3IrOGWwCKg-1; Fri, 27 Nov 2020 05:19:43 -0500
X-MC-Unique: 9iM2g366Oqux3IrOGWwCKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22A07805BFF;
        Fri, 27 Nov 2020 10:19:42 +0000 (UTC)
Received: from [10.36.114.118] (ovpn-114-118.ams2.redhat.com [10.36.114.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FFC11002393;
        Fri, 27 Nov 2020 10:19:38 +0000 (UTC)
Subject: Re: +
 mm-page_alloc-clear-pages-in-alloc_contig_pages-with-init_on_alloc=1-or-__gfp_zero.patch
 added to -mm tree
To:     akpm@linux-foundation.org, glider@google.com,
        keescook@chromium.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        rppt@linux.ibm.com, vbabka@suse.cz
References: <20201110200824.RD0MTQu_Y%akpm@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <6a90b115-5d83-1681-f26d-818fe2d79b75@redhat.com>
Date:   Fri, 27 Nov 2020 11:19:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201110200824.RD0MTQu_Y%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.11.20 21:08, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/page_alloc: clear pages in alloc_contig_pages() with init_on_alloc=1 or __GFP_ZERO
> has been added to the -mm tree.  Its filename is
>      mm-page_alloc-clear-pages-in-alloc_contig_pages-with-init_on_alloc=1-or-__gfp_zero.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-clear-pages-in-alloc_contig_pages-with-init_on_alloc%3D1-or-__gfp_zero.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-clear-pages-in-alloc_contig_pages-with-init_on_alloc%3D1-or-__gfp_zero.patch
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
> From: David Hildenbrand <david@redhat.com>
> Subject: mm/page_alloc: clear pages in alloc_contig_pages() with init_on_alloc=1 or __GFP_ZERO
> 
> commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and
> init_on_free=1 boot options") resulted with init_on_alloc=1 in all pages
> leaving the buddy via alloc_pages() and friends to be
> initialized/cleared/zeroed on allocation.
> 
> However, the same logic is currently not applied to alloc_contig_pages():
> allocated pages leaving the buddy aren't cleared with init_on_alloc=1 and
> init_on_free=0.  Let's also properly clear pages on that allocation path
> and add support for __GFP_ZERO.
> 
> With this change, we will see double clearing of pages in some cases.  One
> example are gigantic pages (either allocated via CMA, or allocated
> dynamically via alloc_contig_pages()) - which is the right thing to do
> (and to be optimized outside of the buddy in the callers) as discussed in
> https://lkml.kernel.org/r/20201019182853.7467-1-gpiccoli@canonical.com
> 
> This change implies that with init_on_alloc=1
> - All CMA allocations will be cleared
> - Gigantic pages allocated via alloc_contig_pages() will be cleared
> - virtio-mem memory to be unplugged will be cleared. While this is
>   suboptimal, it's similar to memory balloon drivers handling, where
>   all pages to be inflated will get cleared as well.
> 
> Link: https://lkml.kernel.org/r/20201110193240.25401-1-david@redhat.com
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

@Andrew, can you unqueue this one now that we have

https://lkml.kernel.org/r/20201120180452.19071-1-david@redhat.com

?

Thanks!

-- 
Thanks,

David / dhildenb


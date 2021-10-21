Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA75C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 10:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF8D60F5D
	for <mm-commits@archiver.kernel.org>; Thu, 21 Oct 2021 10:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJUKVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 06:21:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46942 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhJUKVF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Oct 2021 06:21:05 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 75F8C21989;
        Thu, 21 Oct 2021 10:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634811528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=410wT5AJuYqAs8Uw1rkydBmwx+KFJzd3aEKNKEQw0t4=;
        b=DrpB/dYdVqr7Sy4RkKSwLHVPF3fLESUGUdglqjAsmAy6bp8FxqM16e2mUAgusET5d7aYAF
        y91I9TMn0KxhtaEMhai50vCuZsjhkzgDaW507ZbfkjHw6P00va9NYT6/JndjpsCLqXXL6c
        9y3TqOugYD/MBA2TMfsqEuc6iPPMgVA=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3A5E2A3B83;
        Thu, 21 Oct 2021 10:18:48 +0000 (UTC)
Date:   Thu, 21 Oct 2021 12:18:45 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     david@fromorbit.com, hch@infradead.org, idryomov@gmail.com,
        jlayton@kernel.org, mm-commits@vger.kernel.org, neilb@suse.de,
        urezki@gmail.com
Subject: Re: + mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch
 added to -mm tree
Message-ID: <YXE+hcodJ7zxeYA7@dhcp22.suse.cz>
References: <20211020223613.z_R-mXCPH%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020223613.z_R-mXCPH%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed 20-10-21 15:36:13, Andrew Morton wrote:
> From: Michal Hocko <mhocko@suse.com>
> Subject: mm/vmalloc: be more explicit about supported gfp flags
> 
> The core of the vmalloc allocator __vmalloc_area_node doesn't say anything
> about gfp mask argument.  Not all gfp flags are supported though.  Be more
> explicit about constraints.
> 
> Link: https://lkml.kernel.org/r/20211020082545.4830-1-mhocko@kernel.org
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I haven't see other patches from the series to be applied to your tree
and without them this is not really correct.

> ---
> 
>  mm/vmalloc.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> --- a/mm/vmalloc.c~mm-vmalloc-be-more-explicit-about-supported-gfp-flags
> +++ a/mm/vmalloc.c
> @@ -2990,8 +2990,16 @@ fail:
>   * @caller:		  caller's return address
>   *
>   * Allocate enough pages to cover @size from the page level
> - * allocator with @gfp_mask flags.  Map them into contiguous
> - * kernel virtual space, using a pagetable protection of @prot.
> + * allocator with @gfp_mask flags. Please note that the full set of gfp
> + * flags are not supported. GFP_KERNEL would be a preferred allocation mode
> + * but GFP_NOFS and GFP_NOIO are supported as well. Zone modifiers are not
> + * supported. From the reclaim modifiers__GFP_DIRECT_RECLAIM is required (aka
> + * GFP_NOWAIT is not supported) and only __GFP_NOFAIL is supported (aka
> + * __GFP_NORETRY and __GFP_RETRY_MAYFAIL are not supported).
> + * __GFP_NOWARN can be used to suppress error messages about failures.
> + * 
> + * Map them into contiguous kernel virtual space, using a pagetable
> + * protection of @prot.
>   *
>   * Return: the address of the area or %NULL on failure
>   */
> _
> 
> Patches currently in -mm which might be from mhocko@suse.com are
> 
> mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

-- 
Michal Hocko
SUSE Labs

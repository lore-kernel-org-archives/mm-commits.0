Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F7EC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 09:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D857E61265
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 09:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbhKHJ1s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 04:27:48 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60914 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbhKHJ1r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2021 04:27:47 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 42F621FD71;
        Mon,  8 Nov 2021 09:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636363502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SHWH2jFNs/MKAnHqbJ/fucH8U/PBAzjvELvO1YIaGf0=;
        b=ZE01o+8hjs7CEidEKgBp682WRKWL6X9+Afe7D9WUcRrwT4iNqj9E1Ia16gpzqu0NziE365
        A2nUn74kwG2/E82w1QwFkuHRhRTo7h54NwVAe48rHCdTMmQJqgNcbTBBiHrHXSdhRrYYG/
        FZV6iJh1/gHN62+gkpGdhYmXRpaopv0=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0E8EEA3B81;
        Mon,  8 Nov 2021 09:25:02 +0000 (UTC)
Date:   Mon, 8 Nov 2021 10:25:01 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     akpm@linux-foundation.org, david@fromorbit.com, hch@infradead.org,
        idryomov@gmail.com, jlayton@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject: Re: [patch 099/262] mm/vmalloc: be more explicit about supported gfp
 flags
Message-ID: <YYjs7UT15WIF23DJ@dhcp22.suse.cz>
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105203950.AJ1Cnteeh%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105203950.AJ1Cnteeh%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri 05-11-21 13:39:50, Andrew Morton wrote:
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

As already pointed out
http://lkml.kernel.org/r/YXE+hcodJ7zxeYA7@dhcp22.suse.cz this patch
cannot be applied without other patches from the same series.

> ---
> 
>  mm/vmalloc.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> --- a/mm/vmalloc.c~mm-vmalloc-be-more-explicit-about-supported-gfp-flags
> +++ a/mm/vmalloc.c
> @@ -2983,8 +2983,16 @@ fail:
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

-- 
Michal Hocko
SUSE Labs

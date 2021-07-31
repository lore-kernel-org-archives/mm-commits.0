Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BFFC4338F
	for <mm-commits@archiver.kernel.org>; Sat, 31 Jul 2021 22:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8567160F9D
	for <mm-commits@archiver.kernel.org>; Sat, 31 Jul 2021 22:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhGaWST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Jul 2021 18:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhGaWST (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Jul 2021 18:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0EB60EBC;
        Sat, 31 Jul 2021 22:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627769892;
        bh=Pud8xtGP3Uc9/7WKiVauc4aaKsBW/kEwyrH3U5Z8Lf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LBhDrqUtUAHAn9AZXyT5FY/XjnSTQ+w4uuEhA/MeWasr2MIMtEu754qQJta0kU24l
         NGQuK+ok20YVwA35soSdRCgQ3YSHcZKH7E7+5mwUNl2JIo133vlb2ZT7hvPAiC3GT+
         1VAH6xR40vi0wKE0VVt/NiU+pu0AlS+AaghK+fjS79jNnoelilYrINxO2aF1Glh54q
         FnrhNu5OYLoyO4JqI7wyUgP4mdG9n/ZP3iQuA3VcmWBgT6JyWtBdFDZa0uMd749Gd+
         XwEh+hiDi5FQVVVKzDTwF6JJLx1pjfYf2B+EL98AHXzOYkstZoG6MVuWJh5zZFFZay
         H3U+OWPjaWmRg==
Date:   Sat, 31 Jul 2021 15:18:06 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject: Re: [patch 6/7] slub: fix unreclaimable slab stat for bulk free
Message-ID: <YQXMHnWRsmfzKK00@archlinux-ax161>
References: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
 <20210729215350.SZC9InNuL%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729215350.SZC9InNuL%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 29, 2021 at 02:53:50PM -0700, Andrew Morton wrote:
> From: Shakeel Butt <shakeelb@google.com>
> Subject: slub: fix unreclaimable slab stat for bulk free
> 
> SLUB uses page allocator for higher order allocations and update
> unreclaimable slab stat for such allocations.  At the moment, the bulk
> free for SLUB does not share code with normal free code path for these
> type of allocations and have missed the stat update.  So, fix the stat
> update by common code.  The user visible impact of the bug is the
> potential of inconsistent unreclaimable slab stat visible through meminfo
> and vmstat.
> 
> Link: https://lkml.kernel.org/r/20210728155354.3440560-1-shakeelb@google.com
> Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/slub.c |   22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> --- a/mm/slub.c~slub-fix-unreclaimable-slab-stat-for-bulk-free
> +++ a/mm/slub.c
> @@ -3236,6 +3236,16 @@ struct detached_freelist {
>  	struct kmem_cache *s;
>  };
>  
> +static inline void free_nonslab_page(struct page *page)
> +{
> +	unsigned int order = compound_order(page);
> +
> +	VM_BUG_ON_PAGE(!PageCompound(page), page);
> +	kfree_hook(page_address(page));
> +	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
> +	__free_pages(page, order);
> +}
> +
>  /*
>   * This function progressively scans the array with free objects (with
>   * a limited look ahead) and extract objects belonging to the same
> @@ -3272,9 +3282,7 @@ int build_detached_freelist(struct kmem_
>  	if (!s) {
>  		/* Handle kalloc'ed objects */
>  		if (unlikely(!PageSlab(page))) {
> -			BUG_ON(!PageCompound(page));
> -			kfree_hook(object);
> -			__free_pages(page, compound_order(page));
> +			free_nonslab_page(page);
>  			p[size] = NULL; /* mark object processed */
>  			return size;
>  		}
> @@ -4250,13 +4258,7 @@ void kfree(const void *x)
>  
>  	page = virt_to_head_page(x);
>  	if (unlikely(!PageSlab(page))) {
> -		unsigned int order = compound_order(page);
> -
> -		BUG_ON(!PageCompound(page));
> -		kfree_hook(object);
> -		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
> -				      -(PAGE_SIZE << order));
> -		__free_pages(page, order);
> +		free_nonslab_page(page);
>  		return;
>  	}
>  	slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
> _

This patch, now in mainline as commit f227f0faf63b ("slub: fix
unreclaimable slab stat for bulk free") causes the KASAN KUnit test
kmalloc_pagealloc_invalid_free to no longer fail:

[    0.000000] Linux version 5.14.0-rc3-00066-gf227f0faf63b (nathan@archlinux-ax161) (x86_64-linux-gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.37) #1 SMP Sat Jul 31 15:08:11 MST 2021
...
[    5.717678]     # kmalloc_pagealloc_invalid_free: EXPECTATION FAILED at lib/test_kasan.c:203
[    5.717678]     KASAN failure expected in "kfree(ptr + 1)", but none occurred
[    5.718909]     not ok 6 - kmalloc_pagealloc_invalid_free
...
[    9.481520] not ok 1 - kasan

The previous commit is fine:

[    0.000000] Linux version 5.14.0-rc3-00065-gb5916c025432 (nathan@archlinux-ax161) (x86_64-linux-gcc (GCC) 11.2.0, GNU ld (GNU Binutils) 2.37) #1 SMP Sat Jul 31 15:05:09 MST 2021
...
[    9.347598] ok 1 - kasan

I am by no means a KASAN or mm/ expert, I noticed this when trying to
test KASAN with clang for ClangBuiltLinux's CI, so it does not appear to
be compiler dependent. It is reproducible for me in QEMU with
x86_64_defconfig + CONFIG_KASAN=y + CONFIG_KUNIT=y +
CONFIG_KASAN_KUNIT_TEST=y.

Please let me know if there is any other information I can provide or
testing I can do.

Cheers,
Nathan

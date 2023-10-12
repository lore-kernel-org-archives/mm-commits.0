Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF98CDB47E
	for <mm-commits@archiver.kernel.org>; Thu, 12 Oct 2023 09:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbjJLJP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Oct 2023 05:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjJLJO5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Oct 2023 05:14:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD776E3
        for <mm-commits@vger.kernel.org>; Thu, 12 Oct 2023 02:14:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D62C433C7;
        Thu, 12 Oct 2023 09:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697102045;
        bh=9+YvGrIiyo9uZS4MwKJPyXHD9Tyk1HV/OmyWnOl7LtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6cl1bRq2EYZXIjhc41K04edQ+QLulQ946ZyTc0dHGDtyTHzX9qD9xAa0U/xN2mMq
         fDFSdCICF/1dTld37ikz00JAYLYTcLgE76AKMh0yjF31pP5vwILESeOutSZwTxfm9K
         BsAHmj4Mcqs0bwLtq/QHTFs+s4Npd4QFly2sRI/fbrJvgj5Mgi6SqhuNYXIlt+eUD5
         5Z2RgKHBDCr55IcnFLVoM96i0BD8UnfKyJT4QHZ2XQEHqjKkiFP/3CunFBL5XyjEcL
         tG4773rriCGfR14peUxjr8bAAkhWHwOw3r5dQbyomux2PeNwO+WZHSJczHDvonPaje
         sdkRNkLvJGKZg==
Date:   Thu, 12 Oct 2023 12:13:05 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        zhiguangni01@gmail.com
Subject: Re: + numa-improve-the-efficiency-of-calculating-pages-loss.patch
 added to mm-unstable branch
Message-ID: <20231012091305.GP3303@kernel.org>
References: <20231010005309.79E1CC433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010005309.79E1CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Oct 09, 2023 at 05:52:59PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: NUMA: improve the efficiency of calculating pages loss

We don't calculate the lost pages here, but pages with no NUMA node
assigned. How about

NUMA: optimize detection of memory with no node id assigned by firmware

> has been added to the -mm mm-unstable branch.  Its filename is
>      numa-improve-the-efficiency-of-calculating-pages-loss.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/numa-improve-the-efficiency-of-calculating-pages-loss.patch
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
> From: Liam Ni <zhiguangni01@gmail.com>
> Subject: NUMA: improve the efficiency of calculating pages loss
> Date: Mon, 11 Sep 2023 21:38:52 +0800
> 
> Optimize the way of calculating missing pages.

Essentially we check how much memory has no node in the data supplied by
firmware. The page count is just a mean to check this and the changelog
should reflect that.

Maybe something like

Sanity check that makes sure the nodes cover all memory loops over
numa_meminfo to count the pages that have node id assigned by the firmware,
then loops again over memblock.memory to find the total amount of memory
and in the end checks that the difference between the total memory and
memory that covered by nodes is less than some threshold. Worse, the loop
over numa_meminfo calls __absent_pages_in_range() that also partially
traverses memblock.memory.

It's much simpler and more efficient to have a single traversal of
memblock.memory that verifies that amount of memory not covered by nodes is
less than a threshold. 

Introduce memblock_validate_numa_coverage() that does exactly that and use
it instead of numa_meminfo_cover_memory().
 
> In the previous implementation, We calculate missing pages as follows:
> 
> 1.  calculate numaram by traverse all the numa_meminfo's and for each
>    of them traverse all the regions in memblock.memory to prepare for
>    counting missing pages.
> 
> 2. Traverse all the regions in memblock.memory again to get e820ram.
> 
> 3. the missing page is (e820ram - numaram )
> 
> But it's enough to count memory in `memblock.memory' that doesn't have the
> node assigned.
> 
> Link: https://lkml.kernel.org/r/20230911133852.2545-1-zhiguangni01@gmail.com
> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/mm/numa.c       |   33 +--------------------------------

arch/loongarch/kernel/numa.c copied the same check from x86, it should be
updated as well.

>  include/linux/memblock.h |    1 +
>  mm/memblock.c            |   21 +++++++++++++++++++++
>  3 files changed, 23 insertions(+), 32 deletions(-)
> 
> --- a/arch/x86/mm/numa.c~numa-improve-the-efficiency-of-calculating-pages-loss
> +++ a/arch/x86/mm/numa.c
> @@ -448,37 +448,6 @@ int __node_distance(int from, int to)
>  EXPORT_SYMBOL(__node_distance);
>  
>  /*
> - * Sanity check to catch more bad NUMA configurations (they are amazingly
> - * common).  Make sure the nodes cover all memory.
> - */
> -static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
> -{
> -	u64 numaram, e820ram;
> -	int i;
> -
> -	numaram = 0;
> -	for (i = 0; i < mi->nr_blks; i++) {
> -		u64 s = mi->blk[i].start >> PAGE_SHIFT;
> -		u64 e = mi->blk[i].end >> PAGE_SHIFT;
> -		numaram += e - s;
> -		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
> -		if ((s64)numaram < 0)
> -			numaram = 0;
> -	}
> -
> -	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
> -
> -	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
> -	if ((s64)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
> -		printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %LuMB e820 RAM. Not used.\n",
> -		       (numaram << PAGE_SHIFT) >> 20,
> -		       (e820ram << PAGE_SHIFT) >> 20);
> -		return false;
> -	}
> -	return true;
> -}
> -
> -/*
>   * Mark all currently memblock-reserved physical memory (which covers the
>   * kernel's own memory ranges) as hot-unswappable.
>   */
> @@ -583,7 +552,7 @@ static int __init numa_register_memblks(
>  			return -EINVAL;
>  		}
>  	}
> -	if (!numa_meminfo_cover_memory(mi))
> +	if (!memblock_validate_numa_coverage(SZ_1M))
>  		return -EINVAL;
>  
>  	/* Finally register nodes. */
> --- a/include/linux/memblock.h~numa-improve-the-efficiency-of-calculating-pages-loss
> +++ a/include/linux/memblock.h
> @@ -123,6 +123,7 @@ int memblock_physmem_add(phys_addr_t bas
>  void memblock_trim_memory(phys_addr_t align);
>  bool memblock_overlaps_region(struct memblock_type *type,
>  			      phys_addr_t base, phys_addr_t size);
> +bool memblock_validate_numa_coverage(const u64 limit);
>  int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
>  int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
>  int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
> --- a/mm/memblock.c~numa-improve-the-efficiency-of-calculating-pages-loss
> +++ a/mm/memblock.c
> @@ -734,6 +734,27 @@ int __init_memblock memblock_add(phys_ad
>  	return memblock_add_range(&memblock.memory, base, size, MAX_NUMNODES, 0);
>  }
>  

Please add kernel-doc description.

> +bool __init_memblock memblock_validate_numa_coverage(const u64 limit)

I think threshold is better name than limit here.

> +{
> +	unsigned long lose_pg = 0;

The pages we count are not lost, they just don't have node id assigned.
I'm inclined to use plain nr_pages rather that try to invent descriptive
but yet short name here.

> +	unsigned long start_pfn, end_pfn;
> +	int nid, i;
> +
> +	/* calculate lose page */
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> +		if (nid == NUMA_NO_NODE)
> +			lose_pg += end_pfn - start_pfn;
> +	}
> +
> +	if (lose_pg >= limit) {

The caller defines the limit in bytes, and here you compare it with pages.

> +		pr_err("NUMA: We lost %ld pages.\n", lose_pg);

I believe a better message would be:

		mem_size_mb = memblock_phys_mem_size() >> 20;
		pr_err("NUMA: no nodes coverage for %luMB of %luMB RAM\n",
		       (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);


> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +
>  /**
>   * memblock_isolate_range - isolate given range into disjoint memblocks
>   * @type: memblock type to isolate range for
> _
> 
> Patches currently in -mm which might be from zhiguangni01@gmail.com are
> 
> numa-improve-the-efficiency-of-calculating-pages-loss.patch
> 

-- 
Sincerely yours,
Mike.

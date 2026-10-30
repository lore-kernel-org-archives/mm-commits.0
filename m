Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793357893;
	b=zxajkywhXPCdEIPbENbp2qVwZBAPZu4Y86bqx+hbRBCR6stm5LFT38uedv1kkLkL28MY
	 kihe0nHb1ccqfPGrNpXlGAd1ZIRUU2TwED98OvM3ghHz7xqUHeXHid/UwE7oM/ZeIcULS
	 veSWncPaJNQu0b65Yv69NAM7qjv5Lzr6zmn+aOMxvPp3+n5LQsgWBgzDeucuIQC4N8AzK
	 7y0w/UBmvk8PJv6R6BfmnH6e32yI1MPeFwGELZQ3GOQw6/M3iWCMRvM6vKJ+IQejPxJdA
	 kH32gqgJeYAJjRCrXayvHnMTAsrtseefLQ8ucBg73hwwfLIC6qhdaWYaPUyKO05dmCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793357893;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5qbrTEO0RLig1uB14VHQHuOPY/Hx1HAGPaN/VA0Yl58=;
	b=WEBe924FK30eNkSlwAD4vh6opnDhxULivU7+q+eoGhvzb6Xzq2DryYRL6jsAejjXqqvd
	 q7mGBGOgfXyVCEDMsXPwKPdVjio8sjw3XAzfwe6o557LC4zU6h5HUawSzgNpkWtF7WkiI
	 8fpvUG/IDznw5scdYJ1fGlIcBSennke4TomlBkKCJiFoGyIGTdg1qArThkw5eGjyErkZu
	 fLbe7NLR0NFo7DyK/5NyD0lq9x9TFHi8LC3QuUChh5fJ06XMInmMzpK/7GCqwRxtMXf7q
	 FQY1Vxx5ABOm4BM1fF38d9Gu8IU+k3liYN3SPtNRx9C90lgkzZzvinNFq3Btk/JRCVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KV6Yeyju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BAB606B961
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 10:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KV6Yeyju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CBA1F00A17;
	Fri, 30 Oct 2026 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793357892;
	bh=5qbrTEO0RLig1uB14VHQHuOPY/Hx1HAGPaN/VA0Yl58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KV6YeyjuCNhbTgIAunpQpgO+RusEHmLbUEHa0g/yikIVNDDf5Idmqw5urr20cuqWd
	 BPTRMny2xLu6TXD77llsPYprAP7tDo2UIKxEE1urbrWZNpjC5WAdq2csd0mDj/UQoH
	 l0H6Z9QMu8+738Rlboul6bTuPUwRQO/9EnK3MVfaWHZqC4gKBtrLYLl1ExMFEKbtYx
	 Z2MYQmnSG8OTeJ8PI0bU9loDQoo4vDJVtyJyj3I3xqkgN6YVLZ/+g1IZHkAb5fYHeZ
	 wfnuEmLLUxsQKPCQjW9b9X6+rLnvkl1OU5fy7GW9m23ctPRd3AsHTZzmQi09HRR7xh
	 nuN8j/sMgXSXw==
Date: Fri, 30 Oct 2026 10:58:08 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, urezki@gmail.com, baoquan.he@linux.dev, 
	nickolai@csail.mit.edu
Subject: Re: +
 mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
 added to mm-unstable branch
Message-ID: <auR3EGwXrn8-3gcC@gremlin>
References: <20261018001257.B247E1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018001257.B247E1F000C4@smtp.kernel.org>

Hi Andrew,

Please drop this until a respin is sent.

On Sat, Oct 17, 2026 at 05:12:57PM -0700, Andrew Morton wrote:
>
> The patch titled
>      Subject: mm/vmalloc: read vm_map_ram block regions from the requested offset
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

Little unsure what mm-unstable is for during the merge window (I thought we
were leaving that alone now?) btw?

Anyway, this patch has had negative feedback from the vmalloc maintainer
[0], so should not be taken in this form, please - Ulad is vmalloc
maintainer so has final say over what lands there.

Sashiko also found an off-by-one error that you highlighted yourself [1].

I assume this isn't heading for any fixes branch?

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/atSM69faDNgmLNVJ@milan/
[1]:https://lore.kernel.org/all/20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org/

>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>
> ------------------------------------------------------
> From: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Subject: mm/vmalloc: read vm_map_ram block regions from the requested offset
> Date: Sat, 17 Oct 2026 19:13:25 -0400
>
> Reading a vm_map_ram() mapping through /proc/kcore returns the wrong
> memory for every page except the first page of the first used region in
> its vmap block.  read_kcore_iter() calls vread_iter() one page at a time,
> so a root user reading a live system with drgn, crash or gdb gets that
> first page in place of every later page of the mapping, and in place of
> the zeroes of the unused pages after it.  This affects every vm_map_ram()
> mapping that fits in a vmap block (up to BITS_PER_LONG pages): erofs and
> f2fs decompression buffers, videobuf2 vmalloc/dma-sg buffers, udmabuf
> vmaps, fuse readdir pages.  Kernels since v6.3 are affected.
>
> vmap_ram_vread_iter() walks the used regions of the block and, for each
> region, zero-fills up to its start and then copies from start +
> offset_in_page(addr).  A read starting in a later page of a region
> therefore copies the region's first page, and a read starting past the end
> of a region still copies from that region.
>
> Skip regions that end at or before addr, and copy from addr itself, i.e.
> use addr - start as the offset into the region.  The region is re - rs
> pages long, not re - rs + 1: for_each_set_bitrange() returns [rs, re) with
> re the first clear bit.  The extra page is one whose used_map bit is
> clear, and vb_free() clears the bits before it unmaps the pages, so a read
> racing with vm_unmap_ram() copied the page being freed instead of
> zero-filling it.
>
> Tested on x86_64 by queueing a 29-page V4L2_MEMORY_USERPTR buffer on a
> vivid capture device, which videobuf2-vmalloc maps with vm_map_ram(), page
> i starting with "userptr page i", and reading every page of its vmap block
> through /proc/kcore.  Before, all 1024 pages of the block read as page 0.
> After, pages 0..28 read back in order and the rest of the block carries no
> tag.  With a second buffer in the same block and a 100-page buffer outside
> the block path, reads at unaligned offsets, across page and region
> boundaries, into and within the unused part of the block, and of the whole
> block return the true contents.  With an msleep() inserted between the
> bitmap_clear() and the vunmap_range_noflush() of vb_free(), a read of a
> one-page buffer being unmapped between two mapped ones returns zeroes.
>
> Link: https://lore.kernel.org/20261017231325.796986-1-nickolai@csail.mit.edu
> Fixes: 06c8994626d1 ("mm/vmalloc.c: allow vread() to read out vm_map_ram areas")
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: LLM
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> ---
>
>  mm/vmalloc.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> --- a/mm/vmalloc.c~mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset
> +++ a/mm/vmalloc.c
> @@ -4649,7 +4649,7 @@ static size_t vmap_ram_vread_iter(struct
>  	struct xarray *xa;
>  	unsigned long offset;
>  	unsigned int rs, re;
> -	size_t remains, n;
> +	size_t remains, n, size;
>
>  	/*
>  	 * If it's area created by vm_map_ram() interface directly, but
> @@ -4683,6 +4683,10 @@ static size_t vmap_ram_vread_iter(struct
>  			goto finished;
>
>  		start = vmap_block_vaddr(vb->va->va_start, rs);
> +		size = (re - rs) << PAGE_SHIFT;
> +
> +		if (addr >= start + size)
> +			continue;
>
>  		if (addr < start) {
>  			size_t to_zero = min_t(size_t, start - addr, remains);
> @@ -4696,8 +4700,8 @@ static size_t vmap_ram_vread_iter(struct
>  		}
>
>  		/*it could start reading from the middle of used region*/
> -		offset = offset_in_page(addr);
> -		n = ((re - rs + 1) << PAGE_SHIFT) - offset;
> +		offset = addr - start;
> +		n = size - offset;
>  		if (n > remains)
>  			n = remains;
>
> _
>
> Patches currently in -mm which might be from nickolai@csail.mit.edu are
>
> mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch
> mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch
> resource-report-a-devm_request_resource-conflict-under-the-lock.patch
> mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
> mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch
>

--
Cheers, Lorenzo

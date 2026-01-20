Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C85444CF37;
	Tue, 20 Jan 2026 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768922649; cv=none; b=oeEzh14nTVH2RNtCM0/Nr0E06N7PIieCZXzoUIRipboZ1zQiTdcsIerrmFY4LUC6CyYyb3xKZI/0tBv0iVQm/9d6lSQqCVVkPFcEd8nwczFbvXOhs23Y69hlWd1eB2W27lI+iP9YDTXeKIhPYhnsoOFA5kXHF31yE5JULYxZJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768922649; c=relaxed/simple;
	bh=9jRhlOcB/BCAcsGAE6E2GxTLrKYlRd8V5vOhZYZPVfA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uOu0Ivw2O3Rh2Ad29rc4fDDA69Rs/7TQRf0uxCDzm/07OKUagaunEUlByBvbysNv1VAvGYbOWllIli2YjATtxkaNqmdr1DsvTTRjOir88DK7DqEVPBWi5ReMOi21QTYppCOZ5TLn/lKNOv2qGat2DQlbRy4TCZRD9rR+nWcxOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ew1eoVWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ew1eoVWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F36C16AAE;
	Tue, 20 Jan 2026 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768922649;
	bh=9jRhlOcB/BCAcsGAE6E2GxTLrKYlRd8V5vOhZYZPVfA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ew1eoVWJ54oFj/fHJHf3R4ddG73yX/O+h1arlczZW/Y0qoDGHJK4xUDuDseOZn96J
	 O5PSCx0qh6qm9XCIobNNDkFAlJc/IuZTCWhqVaZRjdtaId2V13S6DyE1EXJAnRbegv
	 WSUCtHwY44USLA63eUbZcWN9+LHTjl+RVrtukk9y22GwIzUfR4J/ajXbDBIBq+JdbI
	 mMHTgSg8nxbG0i7ru/nn/6qRH3QtOiSsUKHvu5PPQJXtC0jXMtz89tvdqxFpKhxadT
	 lJhpskuWvRXZ1+jYaBe6qVVAGb8B6rGWrRhLtTdxic8wTFK3/nNUJ03J2fJTOcdbaI
	 YoD49CQ1I1Q4A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, surenb@google.com, stable@vger.kernel.org,
 rppt@kernel.org, pratyush@kernel.org, pasha.tatashin@soleen.com,
 graf@amazon.com, ran.xiaokai@zte.com.cn
Subject: Re: [merged mm-hotfixes-stable]
 kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch
 removed from -mm tree
In-Reply-To: <20260119203054.70AE8C116C6@smtp.kernel.org> (Andrew Morton's
	message of "Mon, 19 Jan 2026 12:30:53 -0800")
References: <20260119203054.70AE8C116C6@smtp.kernel.org>
Date: Tue, 20 Jan 2026 15:24:06 +0000
Message-ID: <2vxzqzrke295.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Andrew,

On Mon, Jan 19 2026, Andrew Morton wrote:

> The quilt patch titled
>      Subject: kho: init alloc tags when restoring pages from reserved memory
> has been removed from the -mm tree.  Its filename was
>      kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch
>
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

This patch isn't quite complete. See [0]. It doesn't do anything wrong,
it just doesn't fix the problem for every case.

I suggested a re-roll of this patch based on top of my cleanup patches
[1], since I think with those the end result is a bit nicer.

I suppose we have 3 options:

1. Take this patch in hotfixes and leave kho_restore_pages() path
   unfixed. The fix the rest next merge window.

2. Do a new version of this patch fixing kho_restore_pages() with the
   current code, and then re-roll the clean up series to fix conflicts
   for next merge window.

3. Pull in the cleanups in hotfixes too, and then do a new revision of
   this patch on top.

I don't think the end result of option 2 is too horrible, so I think
that is probably the best option, but do let me know what you'd prefer.

[0] https://lore.kernel.org/linux-mm/2vxzpl7chw8d.fsf@kernel.org/
[1] https://lore.kernel.org/linux-mm/20260116112217.915803-1-pratyush@kernel.org/T/#u

>
> ------------------------------------------------------
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Subject: kho: init alloc tags when restoring pages from reserved memory
> Date: Fri, 9 Jan 2026 10:42:51 +0000
>
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator.  When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and below warning message:
>
> alloc_tag was not set
> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
> RIP: 0010:___free_pages+0xb8/0x260
>  kho_restore_vmalloc+0x187/0x2e0
>  kho_test_init+0x3c4/0xa30
>  do_one_initcall+0x62/0x2b0
>  kernel_init_freeable+0x25b/0x480
>  kernel_init+0x1a/0x1c0
>  ret_from_fork+0x2d1/0x360
>
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.
>
> Link: https://lkml.kernel.org/r/20260113033403.161869-1-ranxiaokai627@163.com
> Link: https://lkml.kernel.org/r/20260109104251.157767-1-ranxiaokai627@163.com
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/liveupdate/kexec_handover.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/kernel/liveupdate/kexec_handover.c~kho-init-alloc-tags-when-restoring-pages-from-reserved-memory
> +++ a/kernel/liveupdate/kexec_handover.c
> @@ -255,6 +255,7 @@ static struct page *kho_restore_page(phy
>  	if (is_folio && info.order)
>  		prep_compound_page(page, info.order);
>  
> +	clear_page_tag_ref(page);
>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
>  }
> _
>
> Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are
>
> alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch
>

-- 
Regards,
Pratyush Yadav

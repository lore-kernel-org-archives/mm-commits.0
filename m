Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC082F0673
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 20:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766520333; cv=none; b=VX0YLNsirSCViugGpjdSniXmchktlePZPlIAYFh+hQX9YIDB2FWwzm6NCrGMgpbsFPRmyiW6GVtdCQzBydbIG5GWjLULt+PAJk7Eyd9Y+t7F4XGnX0xqRxhp7Nr08f4gm7tiwUj3AMNL4AnIucOKUhy1D6SqggsHaLKSTEOp/lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766520333; c=relaxed/simple;
	bh=3G7jakdZOOF2xB2QOuk54PIqYiTfYXTvMwmuh/Xm2jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQqhGTMbBVOM0AlVBf+KEk2jdGK/bj+So3LiHlQObXaf9dR444d1rzmpQ4EtgxmgvQxw5rzwUYwUtmnFLiBhCV2kuYS6MZYslpZie5N4+z/m8mY85Fb8zKwzp/FB8nHmZh8bPUq2igolvDnKQu5srWTc+BOjZoznsetss9Pt4FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGzCnHv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGzCnHv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B4FC113D0;
	Tue, 23 Dec 2025 20:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766520333;
	bh=3G7jakdZOOF2xB2QOuk54PIqYiTfYXTvMwmuh/Xm2jE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AGzCnHv9JJZ3kXcfuL6Af82wH+Oe2uwDEF0dzzjCujSIVXHeMZPZwYUL1dNI8xR3s
	 P9LdIQkHbKKS7d1A6QW8B7RryXj9AfZwtBrHUkLIPMnzVsXs93pyTaiS9TCxpJPpuy
	 14BgOmiB5ke/0VI/uTpXW4cRqAwR5lvGvIUbEarzbHo/JfBFsPb3LtepBnlNyXUHBo
	 29/V7BGT3srb2CRMIbFffKu1tNOkFM2iWT2boLADuyHsQmQm7KHMrWGPDLLmeddHQK
	 GFu5y8e+sY2O/zb9sYCmAO5hqOgE5gQa/w02i/YkWQ+aM03qh2T2Cf8vLbVrn/Kgx7
	 t1MoF6nbOv7zg==
Date: Tue, 23 Dec 2025 22:05:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	jgg@nvidia.com, baolu.lu@linux.intel.com, yuan1.liu@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: + mm-fix-huge-page-table-not-free-after-memory-unplug.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aUr2B5RXmnWQab0a@kernel.org>
References: <20251223011522.BA78DC4CEF1@smtp.kernel.org>
 <8f111584-51ab-4df2-a7f4-966ec400139d@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f111584-51ab-4df2-a7f4-966ec400139d@kernel.org>

On Tue, Dec 23, 2025 at 09:27:52AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/23/25 02:15, Andrew Morton wrote:
>
> > From: Yuan Liu <yuan1.liu@intel.com>
> > Subject: mm: fix huge page table not free after memory unplug
> > Date: Sun, 21 Dec 2025 23:11:17 -0500
> > 
> > Newly plugged memory is marked as prot_sethuge via phys_pmd_init without
> > setting PG_head.  During memory unplug, free_hugepage_table frees the page
> > table as 2M, but pagetable_free handles it as 4K.
> > 
> > Link: https://lkml.kernel.org/r/20251222041117.44865-1-yuan1.liu@intel.com
> > Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> > Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Baolu Lu <baolu.lu@linux.intel.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >   arch/x86/mm/init_64.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/arch/x86/mm/init_64.c~mm-fix-huge-page-table-not-free-after-memory-unplug
> > +++ a/arch/x86/mm/init_64.c
> > @@ -1028,7 +1028,7 @@ static void __meminit free_pagetable(str
> >   		free_reserved_pages(page, nr_pages);
> >   #endif
> >   	} else {
> > -		pagetable_free(page_ptdesc(page));
> > +		__free_pages(page, order);
> 
> Hm, but this way we are skipping deconstructors, no?
> 
> In particular, clearing the kernel flag (ptdesc_clear_kernel()) and not
> handling ASYNC_KERNEL_PGTABLE_FREE correctly.

And it seems to be x86 material at any rate.

-- 
Sincerely yours,
Mike.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4421A76BB
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 15:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773674495; cv=none; b=CPtCL1Vc7R+cN+eTr1hggRAzH2Pg2EWfwcfN4/Bu1KYNu26jj2HFMnhLxVAK6Swtyuw7me3L/EEIPQADVJbo7XeeTXq+8CqO+wlwTnPIHxfNRnsZarqdFkWlhVhwzHsAqTPcewPklh9EzEU1Nj2Lj+AXjRXm5iYeSMeKV2tyCP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773674495; c=relaxed/simple;
	bh=w+QRkiGyfrbTZAbEPQ9GyhcbCXM9OHdwfUrtlxgj/No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tieQ2ztrD4yTlPn91KjhhfpFtKqlt2ekAsWg52zNNL5oBiRPAscPz3CTfkL4b5ka+L8LnDuN4cBuwT0rneK9Vknx+rkXomMoUy36Kcc+IEvbYBpXr43MRepAjQoFnurmDFI2+S+mNNpnX1LjsswPHERidLwwCaESAWC7gOtI0G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSuttUtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSuttUtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9958BC19421;
	Mon, 16 Mar 2026 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773674495;
	bh=w+QRkiGyfrbTZAbEPQ9GyhcbCXM9OHdwfUrtlxgj/No=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hSuttUtTf+idUBbjY5JbHdqra9C1YCqiqq+zIDeXcUIaa4TP79w/biEfrebvXed2R
	 qpS0M+eitiU3RFMpVTmh362sS/ofiyy78z7tX2GKk4E33LYZWt3rfDL4q72MaebIff
	 SPOuKkpqdN1FFvifwhwodZxct+IApcYuRCurg/ppIrLhjw4g3SWIa7B2fe42vqp34+
	 kLVj+IyzZXalhJBda/Gl56xM4JCiZJPGLjOvA4pSY4dHjQZ1eK7xV4xy3Ot3reXq0x
	 DdsLFB824FWQiRh4ghnAcrWRfkn9xmKCDanBF6jax8mbGH/bw+vKeFzIqDbuyGnv9n
	 vVubJwqjI2K3A==
Date: Mon, 16 Mar 2026 15:21:32 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org
Subject: Re: + mm-add-mmap_action_simple_ioremap-fix.patch added to mm-new
 branch
Message-ID: <9896c52a-3b10-4769-9b07-3e1adaa4b68e@lucifer.local>
References: <20260314232107.C989EC116C6@smtp.kernel.org>
 <cbaec2e4-9d53-417d-bfec-6a0a40e86553@infradead.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbaec2e4-9d53-417d-bfec-6a0a40e86553@infradead.org>

On Sun, Mar 15, 2026 at 03:28:21PM -0700, Randy Dunlap wrote:
>
>
> On 3/14/26 4:21 PM, Andrew Morton wrote:
> > The patch titled
> >      Subject: mm-add-mmap_action_simple_ioremap-fix
> > has been added to the -mm mm-new branch.  Its filename is
> >      mm-add-mmap_action_simple_ioremap-fix.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_simple_ioremap-fix.patch
> >
> > This patch will later appear in the mm-new branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Note, mm-new is a provisional staging ground for work-in-progress
> > patches, and acceptance into mm-new is a notification for others take
> > notice and to finish up reviews.  Please do not hesitate to respond to
> > review feedback and post updated versions to replace or incrementally
> > fixup patches in mm-new.
> >
> > The mm-new branch of mm.git is not included in linux-next
> >
> > If a few days of testing in mm-new is successful, the patch will me moved
> > into mm.git's mm-unstable branch, which is included in linux-next
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next via various
> > branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there most days
> >
> > ------------------------------------------------------
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: mm-add-mmap_action_simple_ioremap-fix
> > Date: Sat Mar 14 04:19:36 PM PDT 2026
> >
> > randyfy mmap_prepare.rst
> >
> > Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
>
> That change LGTM.
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Tested-by: Randy Dunlap <rdunlap@infradead.org>
>
>
> Not related to this patch, but at line 98 of
> mmap_prepare.rst I now see a reference to
> struct vma_area_desc. I think that should be
> struct vm_area_desc. (?)
>

Ack will fold fix into respin!

> For some reason 'git grep vma_area_desc' does not even
> find one occurrence of that string for me, while
> good ole 'grep -rs vma_area_desc' does find it.
>
> >
> >  Documentation/filesystems/mmap_prepare.rst |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/Documentation/filesystems/mmap_prepare.rst~mm-add-mmap_action_simple_ioremap-fix
> > +++ a/Documentation/filesystems/mmap_prepare.rst
> > @@ -127,7 +127,7 @@ pointer. These are:
> >  * mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remaps
> >    the entire mapping from ``start_pfn`` onward.
> >
> > -* `mmap_action_simple_ioremap()` - Sets up an I/O remap from a specified
> > +* mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
> >    physical address and over a specified length.
> >
> >  **NOTE:** The ``action`` field should never normally be manipulated directly,
> > _
> >
> > Patches currently in -mm which might be from akpm@linux-foundation.org are
> >
> > maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
> > maple_tree-add-cp_is_new_root-helper-fix-fix.patch
> > mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
> > mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
> > mm-rename-zone-lock-to-zone-_lock-fix.patch
> > mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
> > mm-various-small-mmap_prepare-cleanups-fix.patch
> > mm-add-mmap_action_simple_ioremap-fix.patch
> > mm-add-mmap_action_map_kernel_pages-fix.patch
> > kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
> > decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
> >
>
> --
> ~Randy

Cheers, Lorenzo

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5274962E
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 09:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724837221; cv=none; b=Dypsh7N4Qs45MKgK5s35OBTICLDw7A9k4ufP8he2ThFVQOsRQom1mBEFyRZrUNpV1i1akDkYyGrPeJC1VmPfD8c+K4uwFylDt5EKlhzLED9t4aRF0CdXf6sl9b8neofrzl957uhaciX9qzD7BNixCLVtYFPky47FRy89dviqTtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724837221; c=relaxed/simple;
	bh=NNWZnt+yPr1QZhgPuKgcAK/LsCB4D/lTUy8oBbwikJ4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=h44oeyCW3FYIsiyOSByHkpuMqdxTw4mbQon0+IRMng+70jMcoLuQofco3OtQB/hmlVQ1pZ1ZdJESJwn4uNpNorUkxEJqtJTdTpUOTm97XHI2Rg5c0SITA4GvlwRsNJXgy2i0mBxY8xPq+YmJ2lbO/ST+PPyYZDORxTVFT3DkMBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i9b6FoZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9b6FoZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24007C90DF5;
	Wed, 28 Aug 2024 09:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724837221;
	bh=NNWZnt+yPr1QZhgPuKgcAK/LsCB4D/lTUy8oBbwikJ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i9b6FoZPbOfIV5HiGYJuyCAiaFMphTlHSvRJOeBEXGaFn35WDE+AIYzJRk4i3hN6S
	 R5CvXkNdB94cOSEbSxxRkyIgaFEsIbOWKvxOdEVPTbBkgt0+d1iWhQXlSJhSsDMMld
	 xnqdLFfc0FsteEYF4oaX7LRRgyMuwaculwlara5w=
Date: Wed, 28 Aug 2024 02:27:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: mm-commits@vger.kernel.org, sj@kernel.org, Liam Howlett
 <liam.howlett@oracle.com>
Subject: Re: + mm-remove-duplicated-include-in-vma_internalh-fix.patch added
 to mm-unstable branch
Message-Id: <20240828022700.4770704b60227a4acd2a7648@linux-foundation.org>
In-Reply-To: <d898ce04-3231-441e-98eb-ceacbef930f6@lucifer.local>
References: <20240828025612.79FCAC4AF11@smtp.kernel.org>
	<d898ce04-3231-441e-98eb-ceacbef930f6@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Aug 2024 09:33:15 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > +#ifdef CONFIG_MMU
> >  /*
> >   * These three helpers classifies VMAs for virtual memory accounting.
> >   */
> > @@ -255,6 +256,7 @@ static inline bool is_data_mapping(vm_fl
> >  {
> >  	return (flags & (VM_WRITE | VM_SHARED | VM_STACK)) == VM_WRITE;
> >  }
> > +#endif
> >
> 
> Something's gone horribly wrong here! This ifdef is not meant to be here
> but rather around init_vma_munmap() as shown in fix patch in [0].
> 
> I'm not sure how the patch got mangled like this.
> 
> Could we replace this bogus patch with the correct one? Thanks!
> 
> 
> [0]: https://lore.kernel.org/all/7d0ea994-f750-49c5-b392-ae7117369cf3@lucifer.local/

afaict this is a fix against "mm/vma: expand mmap_region() munmap
call", so applying it against "mm: remove duplicated include in
vma_internal.h" made everything go pear-shaped.


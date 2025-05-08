Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D1B26AA91
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713800; cv=none; b=flxO4HwVReRPMSChHHDVDTd7CU7EHcKLbUysRG26p9ORyJ4j9NSamfj27C1fQvPLE21lOT9T1p1zKhnMtDVJykd9x05HyTl/jUmduW72EYnwTySLhw7TaE3ITILskqHhZN3SAYqSUbkOSGRt3q8HSm292IVnyPyM3Hz/OnEs8PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713800; c=relaxed/simple;
	bh=d1+xl51O3qfwEUoz+9OMm+aOmaBTylsDC7k+AgEroXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+76V2aTKv20aZEKnmVzYsfKfCncIre2OEDuUV2y7EUXovzEhqT7dM6WCLiUZUIQmgKvIcuH5KqQLFQhpjAI0Ia0YmR62VtAKQ6dKiUm8s5RVNJk7A3/Fz6/bTZWtv/fzoW4w6zjNCsbZRmfT2flNAKY1Hv4bZ4B2wSb+a3qNdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xko/mZZw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xko/mZZw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746713797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=um4v5Ggv8KZt/cYvJ2mkWIvMuM3e/8BwCZI+HcsnOdY=;
	b=Xko/mZZwikH0XCRCyBNVsOlS8DuBqoY40hi3brvZTOBGfclGVXc9Ueu9EkFc/AXiyWv18D
	JUTH5HceCINE7jDmZ+ujQtIPAVS5eWA4AXDdfoE6VWWjEAybIHhcWPXCttVAYjuvXAlYwA
	Nkxa8J++qqfGqsV0xaxDtgj+9EvulVQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-uE3o0-SYMQOvijUjhToVig-1; Thu, 08 May 2025 10:16:35 -0400
X-MC-Unique: uE3o0-SYMQOvijUjhToVig-1
X-Mimecast-MFC-AGG-ID: uE3o0-SYMQOvijUjhToVig_1746713795
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c95e424b62so359546985a.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 07:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713795; x=1747318595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=um4v5Ggv8KZt/cYvJ2mkWIvMuM3e/8BwCZI+HcsnOdY=;
        b=WH/S2/wh0H1lpmVcws6yy2Q4ig/R63BtNZljM0Ji7AU32oqiZqwHAydvxgGZnzCKpe
         nrN6SU9/DvDZgRAputBD+hx4UoBL3mC6cmzD9K5QSHleV07h0BQsf/okP0QNygP68fLt
         HwEStZmzfiiu/NcQdwZ79YsK8jcBwJgp3xlMIfECryRF0KHB4jYmvFOQoq+NvEvI3VE/
         in28yqnY/d/yMfVIgYI2rtpA57RjqvN0vl7Yoj9wwzzeivkk20dfLPZcZxkxx4XQgMHN
         Mw6cKLTs36N9qmMo5+UofXQywbNGYXmr+Agzz7Z+6DJrrEQFvLANeWBAxqgEBm0YPMmd
         YnRA==
X-Gm-Message-State: AOJu0YwgiEyAQznqgYoYt2RfrneWQivMsR/x1PdStyITcqYVtBzx/WkS
	xi+FvrZWnPWoxN2moY8kreQ7VFVdFSuOTZtbzRtddBFYsBxBJ27mb50RmmR+7cC2WvRBNC4l761
	KinfNwRPIlxo2x8h6IDinbIJogGx+CbRl5pf4jE3XPpCAbVqJ25ar7ck0te8=
X-Gm-Gg: ASbGnctSZp6C5WJvPh+G23Qt8V4bqkBQg+IkjnWkFZwnhmnUZo9OlZ+oL+SMt0iRW7m
	oYViT5fqEVDs1Q0g6Y9/uq/nAnWh1QWmSsdLsKbNUvwHmkcHT/TwNb1Kh90gc/IYzAd1qVKJ5Pk
	MYQkUo5c8hDFN/xOM5UVppCFyvzm4AmnxFhP+/vn0VbkNH9BjG9G41+0aK2xkLtUT5EUeLibVzZ
	ow2wAIZQiroBU5/pLm5EI/1HElki+ojwqwMGOhDzHnBCrE4mvkUGA+yhVs0FDUbFsm4ig+qBcgQ
	7Zc=
X-Received: by 2002:ad4:5aa4:0:b0:6ed:e3d:a1b1 with SMTP id 6a1803df08f44-6f54bb3db98mr51261416d6.10.1746713795171;
        Thu, 08 May 2025 07:16:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBbB6SXtIs9IGyLTDsPYPblWUpU2sTLPDg6KB7WYfALPXH0MRo3CiJP9o6t98+MdjjLLCBNQ==
X-Received: by 2002:ad4:5aa4:0:b0:6ed:e3d:a1b1 with SMTP id 6a1803df08f44-6f54bb3db98mr51260926d6.10.1746713794677;
        Thu, 08 May 2025 07:16:34 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e39e099dsm305326d6.22.2025.05.08.07.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 07:16:34 -0700 (PDT)
Date: Thu, 8 May 2025 10:16:31 -0400
From: Peter Xu <peterx@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
	jhubbard@nvidia.com, jgg@ziepe.ca, david@redhat.com,
	c.briere@samsung.com, artem.k@samsung.com,
	p.antoniou@partner.samsung.com, David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aBy8v7gi3tsQ5-iy@x1.local>
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250507215555.81672C4CEE2@smtp.kernel.org>

Hi, Pantelis,

[Cc David Howells]

On Wed, May 07, 2025 at 02:55:54PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: Fix zero copy I/O on __get_user_pages allocated pages
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
> Subject: Fix zero copy I/O on __get_user_pages allocated pages
> Date: Wed, 7 May 2025 10:41:05 -0500
> 
> Recent updates to net filesystems enabled zero copy operations, which
> require getting a user space page pinned.
> 
> This does not work for pages that were allocated via __get_user_pages and
> then mapped to user-space via remap_pfn_rage.
> 
> remap_pfn_range_internal() will turn on VM_IO | VM_PFNMAP vma bits. 
> VM_PFNMAP in particular mark the pages as not having struct_page
> associated with them, which is not the case for __get_user_pages()
> 
> This in turn makes any attempt to lock a page fail, and breaking I/O from
> that address range.
> 
> This patch address it by special casing pages in those VMAs and not
> calling vm_normal_page() for them.
> 
> Link: https://lkml.kernel.org/r/20250507154105.763088-2-p.antoniou@partner.samsung.com
> Signed-off-by: Pantelis Antoniou <p.antoniou@partner.samsung.com>
> Cc: Artem Krupotkin <artem.k@samsung.com>
> Cc: Charles Briere <c.briere@samsung.com>
> Cc: Wade Farnsworth <wade.farnsworth@siemens.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/gup.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> --- a/mm/gup.c~fix-zero-copy-i-o-on-__get_user_pages-allocated-pages
> +++ a/mm/gup.c
> @@ -833,6 +833,20 @@ static inline bool can_follow_write_pte(
>  	return !userfaultfd_pte_wp(vma, pte);
>  }
>  
> +static struct page *gup_normal_page(struct vm_area_struct *vma,
> +		unsigned long address, pte_t pte)
> +{
> +	unsigned long pfn;
> +
> +	if (vma->vm_flags & (VM_MIXEDMAP | VM_PFNMAP)) {
> +		pfn = pte_pfn(pte);
> +		if (!pfn_valid(pfn) || is_zero_pfn(pfn) || pfn > highest_memmap_pfn)
> +			return NULL;
> +		return pfn_to_page(pfn);
> +	}
> +	return vm_normal_page(vma, address, pte);
> +}
> +
>  static struct page *follow_page_pte(struct vm_area_struct *vma,
>  		unsigned long address, pmd_t *pmd, unsigned int flags,
>  		struct dev_pagemap **pgmap)
> @@ -858,7 +872,9 @@ static struct page *follow_page_pte(stru
>  	if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags))
>  		goto no_page;
>  
> -	page = vm_normal_page(vma, address, pte);
> +	page = gup_normal_page(vma, address, pte);
> +	if (page && (vma->vm_flags & (VM_MIXEDMAP | VM_PFNMAP)))
> +		(void)follow_pfn_pte(vma, address, ptep, flags);
>  
>  	/*
>  	 * We only care about anon pages in can_follow_write_pte() and don't
> @@ -1130,7 +1146,7 @@ static int get_gate_page(struct mm_struc
>  	*vma = get_gate_vma(mm);
>  	if (!page)
>  		goto out;
> -	*page = vm_normal_page(*vma, address, entry);
> +	*page = gup_normal_page(*vma, address, entry);

Is this really needed?  IIUC the iter code would only use in either UBUF or
IOVEC ones.

>  	if (!*page) {
>  		if ((gup_flags & FOLL_DUMP) || !is_zero_pfn(pte_pfn(entry)))
>  			goto unmap;
> @@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
>  	int foreign = (gup_flags & FOLL_REMOTE);
>  	bool vma_anon = vma_is_anonymous(vma);
>  
> -	if (vm_flags & (VM_IO | VM_PFNMAP))
> -		return -EFAULT;

Is there's any justification that this won't break some existing GUP users
that may rely on properly failing at pfnmaps?

IIUC netfs isn't the first one that wants to GUP on top of pfnmaps, KVM
does it for years and so far it was processed in a standalone path:

hva_to_pfn:
	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
		r = hva_to_pfn_remapped(vma, kfp, &pfn);

That started with supporting real pfnmaps (with no page struct), but pfnmap
with page structs can also happen afaict, and kvm processes that too by
checking page==NULL ultimately, e.g. in kvm_release_faultin_page().

The other thing is above only processed pte level of pfnmap, and just to
mention pmd/pud may need attention too because we're gradually supporting
huge mappings even for pfns.  I didn't check whether it's possible as of
now, though.  Maybe it's not an immediate concern.

In general, I'm uncertain about whether this is the right way to go so
far. To me it might be less intrusive if we follow what kvm does for now,
or maybe we also at least want to enrich the justification part in the
commit log.

>  
>  	if ((gup_flags & FOLL_ANON) && !vma_anon)
>  		return -EFAULT;
> _
> 
> Patches currently in -mm which might be from p.antoniou@partner.samsung.com are
> 
> fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
> 

-- 
Peter Xu


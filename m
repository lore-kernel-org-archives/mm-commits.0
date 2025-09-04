Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44432FD7CC
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 13:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756991172; cv=none; b=O6iXQnvzCV17LNevahNMwJqGVtdv78cqg7JXYF6Sta3ZDblllovn88AvpZiq4v6QXlax3oRwNt+GLjkAKdradHTCajtSsFswuR7JDNn5efZbWmOib3oSy7QVBv+6WPht7kSLETRo5DmkJPw02G7Y+zrRCT2ZmiD5jViO7qrmmkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756991172; c=relaxed/simple;
	bh=F/8R1k0FhA8hq+Px62TtIKI/64rXyDUvwFaOVrJ12So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFhx+yAL6UX/2pRmQpiKZbyIb1fPUaI/KnB8skWR+xa8xoZVXaHKavlOCRM5OKCuflN7PnK8JxOOqVs+q+S5IwFe5wl0W6NmHbvhvoJ4v2t9YtCy0hzgVnBi7vk7gIwa3g/8XugJa3VHySFpGo5cJDvgkCpoHxRwuO2eqwL7/og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gqdyRC7z; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gqdyRC7z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DTDlhdKoMN5i3uLxebjscQ4dAwnuZThHht7EolZVo2k=; b=gqdyRC7zn63sRubMJZsn+ibEEp
	B4wCKjyFYiXoqvHZkaO209sLdsJLsoatXD2Oij3JBVTws9u3iSMQAZo/4FTUmakiJbL3c6VFP2qEO
	thhESn7cJGnHcFle5OfiNmyE3FuE48Di/Ck52WOQRMwZUMsXQiM33FSbO1GZLsU8VskM1iumjjrzK
	UZ8HZPHIEQOci8WTISUHRvxPS1TfN/WWN0K2pKkJpsaVYXL13l6GfFgXdE1qP6fEm8s7u+y2ZQr5E
	6rFXhysiFPNfyeO4Tbnnkdg0UrgbGhpmdF3KPdbMFtNLPKIsxD6e9/yGNqwzd27+KfwXyoPE09Kvx
	1b2/yAMw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uu9fD-00000001Cw9-1vAt;
	Thu, 04 Sep 2025 13:06:07 +0000
Date: Thu, 4 Sep 2025 14:06:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rppt@kernel.org,
	lorenzo.stoakes@oracle.com, jcmvbkbc@gmail.com
Subject: Re: +
 mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
 added to mm-unstable branch
Message-ID: <aLmOv498CjpmpVqz@casper.infradead.org>
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
 <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
 <9d209746-5e22-4ae8-a38d-f4988b4f7183@suse.cz>
 <0967d9a8-2677-4fac-89fa-4c75dc533ecd@redhat.com>
 <d45f0608-3ca4-44ef-950b-07b0388db639@suse.cz>
 <83819219-c972-4e4f-b343-d2b3cbe5f4d2@redhat.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83819219-c972-4e4f-b343-d2b3cbe5f4d2@redhat.com>

On Thu, Sep 04, 2025 at 11:40:34AM +0200, David Hildenbrand wrote:
> A plain
> 
> 	#define folio_page(f, n) (&(f)->page + (n))	
> 
> Would also make the compiler respect the const'ness of f, because "->page"
> is not a pointer.
> 
> Now, of course that would change once ->page becomes a pointer (memdescs
> ...)

Right, once folio is a separate data structure from page, the constness
of one does not naturally follow the other.  I'm not actually planning
on having a page pointer in folio but rather pfn.  It's my feeling that
we want the pfn of the folio more often than we want the page of the
folio (eg so we can put the pfn in the page table).  Sometimes we want
the kernel virtual address for the page (read() / write()) but we can't
store folio->addr because highmem.  And I think pfn -> addr is more
efficient than page -> addr.

ie I expect folio_page() to be implemented as:

struct page *folio_page(const struct folio *folio, unsigned long n)
{
	return pfn_to_page(folio->pfn + n);
}

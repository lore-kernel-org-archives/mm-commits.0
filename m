Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553A315E8B
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758485137; cv=none; b=BXrsBNjV2dYg2HgeRENIsYl3LADttC5pEQZkJHYacJ+kyRpKVJbHXv78EMj1zxZNEjqxXVnvYuX1fjc6RXzBuo/A0eH1JFEWev0INs9zgYeoWnmaMa15iFv41rhJiyG+g1SrrS+6cbGpjm4BpuvmjpNtQwloU1TQPUD6gXSclGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758485137; c=relaxed/simple;
	bh=5FWdme54FmpHeHFvcg1BPp27B7oAOs268ZA/ysAUw+k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=q2tYnA0GNShGMUbHLWagQ5Yetnz7Sb6N07USHCvJT4tVL0LE3e985lynU756qeKHv6la7azv23FW6/PH2ZZ3TzSLR4BCF+0dHGso3bTSJt11jGrtDLucxa6dRmE2CQbvY0l11sIAZ83XsZE/ewEXDvDoCEXTF4+vZJCWPdeQ/Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YYYLdaSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYYLdaSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB7C4CEE7;
	Sun, 21 Sep 2025 20:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758485136;
	bh=5FWdme54FmpHeHFvcg1BPp27B7oAOs268ZA/ysAUw+k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YYYLdaSgOXv7xF/uVaAdxqe/XwZIaKbSscPvtrTywsjcjkI/ldts3HHnaG9659TVd
	 VMCCfgaf0drRaobdSY21Mqon/Fqo/RQvohvtjA/n2DtbA+st8DlXfPZDwrLDe9VwJR
	 /1baL2LtQjG+0YDDWFsPh19fqQYx2dRoj9sjkxk8=
Date: Sun, 21 Sep 2025 13:05:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, sfr@canb.auug.org.au,
 rppt@kernel.org, lorenzo.stoakes@oracle.com, jcmvbkbc@gmail.com
Subject: Re: +
 mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
 added to mm-unstable branch
Message-Id: <20250921130536.c31bfc3b40a12aad8ad79c0b@linux-foundation.org>
In-Reply-To: <3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
References: <20250904025957.EC982C4CEE7@smtp.kernel.org>
	<3100ea45-ea18-498a-866c-a04c2f453db6@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Sep 2025 08:37:11 +0200 David Hildenbrand <david@redhat.com> wrote:

> > --- a/include/linux/page-flags.h~mm-constify-highmem-related-functions-for-improved-const-correctness-fix
> > +++ a/include/linux/page-flags.h
> > @@ -316,9 +316,9 @@ static __always_inline unsigned long _co
> >    * check that the page number lies within @folio; the caller is presumed
> >    * to have a reference to the page.
> >    */
> > -static inline struct page *folio_page(struct folio *folio, unsigned long n)
> > +static inline struct page *folio_page(const struct folio *folio, unsigned long n)
> >   {
> > -	return &folio->page + n;
> > +	return (struct page *)(&folio->page + n);
> >   }
> >   
> >   static __always_inline int PageTail(const struct page *page)
> > _
> > 
> 
> 
> I think we should do the following. And I'm wondering if we should squash that
> into the relevant nth_page patch instead:

Well I didn't merge anything new as a result of this patch and it's
time to get this series into mm-stable.  So I'll use my nasty hack for
now - could someone please prepare a followup to denastify it?


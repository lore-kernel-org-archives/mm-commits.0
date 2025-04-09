Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9A015855E
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 23:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744240740; cv=none; b=ASVLGn4Jng07u78u6lOTL27kqqdWTFIA4yZRayTCVPW2nLw8WA2IdjLqekpfx/tBYqZmi7aaCLch2w+5//Qfd/MseDFmaNY6N6MVixRwNklJ+MEA8qNNJxRNuOwIHWTygjpU7Sgte23GWryNAPfwcwUB1zKym8ULTqi+mKcMebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744240740; c=relaxed/simple;
	bh=iuDjoJoK9qNLd32r4c/Sxi7hqHWPnlw/KIwV6mWhCm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAcj8ulfKGUUDkupgOwmbIV0UTZ0ydM2zm2HNTf1CP23eakCkpghF5DAzrYneUAM1CM/CDV6+jtHLxZTgitvGmIgAxcFLeyOzW0snAMTvGbPYnUJuA4Tqj0xW7bfzG8eCCm5gmntBbxKCU6e1U8IFFllHO0HFJvc4LHTiiTbkmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vhzk8li5; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vhzk8li5"
Date: Wed, 9 Apr 2025 19:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744240725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6lnNhCARkmfZPIs4ZCP8cYdUTseSWihASprLxik5U8M=;
	b=vhzk8li5JnfJ4M7pKN1vQ5Vd9ceeh7sSnwuYgnuUo2JUALbiCQXbwLIAsyn3DsoaDn079C
	eeb9N04grTpaIyARLPeTuexg9yb6pspMQ679PB214NppcRhmgnbfnGApvL/CtyLhfPmG8D
	c+OuL0LTOwZRIN8W/XOxVMU3QDfJWnA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	stable@vger.kernel.org, janghyuck.kim@samsung.com, tjmercier@google.com
Subject: Re: +
 alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
 added to mm-hotfixes-unstable branch
Message-ID: <npfuocigbrn7wy25ssezqucz3kd5fjpmiqkeqzzmomz2r6wyrd@pmfig3afweud>
References: <20250409211241.70C37C4CEE2@smtp.kernel.org>
 <hzrrdhrvtabiz7g4bvj53lg64f7th5d7ravduisnaqmwmmqubr@f52xy2uq6222>
 <CAJuCfpGe3cY3yYGB03kTGJR-Dyh02w8spDDRkckjdP+qSKtdXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGe3cY3yYGB03kTGJR-Dyh02w8spDDRkckjdP+qSKtdXg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 09, 2025 at 03:31:57PM -0700, Suren Baghdasaryan wrote:
> On Wed, Apr 9, 2025 at 3:10 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Wed, Apr 09, 2025 at 02:12:40PM -0700, Andrew Morton wrote:
> > >
> > > The patch titled
> > >      Subject: alloc_tag: handle incomplete bulk allocations in vm_module_tags_populate
> > > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> > >      alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
> > >
> > > This patch will shortly appear at
> > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
> > >
> > > This patch will later appear in the mm-hotfixes-unstable branch at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > >
> > > Before you just go and hit "reply", please:
> > >    a) Consider who else should be cc'ed
> > >    b) Prefer to cc a suitable mailing list as well
> > >    c) Ideally: find the original patch on the mailing list and do a
> > >       reply-to-all to that, adding suitable additional cc's
> > >
> > > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > >
> > > The -mm tree is included into linux-next via the mm-everything
> > > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > and is updated there every 2-3 working days
> >
> > I don't think we want to rush this patch, given that it's not fixing an
> > actual crash.
> 
> It's not designed to fix a crash. The issue is that whenever tags
> require more than one page and CONFIG_PAGE_OWNER is enabled, memory
> allocation profiling gets disabled. I missed the fact that
> alloc_pages_bulk_node() can return less number of pages than requested
> and this patch fixes that.

That's my point; "allocation profiling gets silently disabled" is much
less severe than the crash we're chasing.

I just want to make sure we're not introducing new things while we're
chasing more severe bugs, although the patch does look simple enough.

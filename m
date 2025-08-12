Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E722D3EDA;
	Tue, 12 Aug 2025 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755033636; cv=none; b=VN0HJFYgecTjb7cysRCWBzT83MGfeJvCKA1kpBlGLatWYx0v7D8VoIlIQRx9TCFngyE7EG555ACum7HvXXLdDrSIX2zpaLANYi9dTRZ7paKdCMaahCdp4rgT0UCCjqr9VUlCK/Bh2x/HzF/ZcucC330dJZVIglsnbmtlg5cMwYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755033636; c=relaxed/simple;
	bh=fwnR9ohW4MHiX299hdJap167nKq/mWGWcAfGoXVzKEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e57OtHOt0anAsi0bgbKfj3o/I/Rj1xo4T6NA2ZzockRsmgMANbGj+XkJSJmJmZ1lgIlO837Hpf0rki8dW+vkz23BJTcx6eLAfduA0C6KjmLDweib9sU3knueE+Vv2+oWKuYn3Cbqpre5UdMekv7SMtLHN/V068a2UrBuFc/fnO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=yWeEXnyL; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="yWeEXnyL"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 4711A14C2D3;
	Tue, 12 Aug 2025 23:20:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1755033633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d3uuIMedvyP5Q01BQ+ATCFwzgprmBiLx4U3xOpj9u6M=;
	b=yWeEXnyL/a2utoDC09Ds54mQZWLlshzUcno4L2lzPcwoaGXoPEk6sKRzisMMfjgxhEeIsB
	KhD8kbvSSW7ZOunBOKkkDCtgEyriL6AW5bfeVkV3ZSl/P06/hQCw5yX5mGrs8GQ5keCS/g
	XBBD4FiyPnQpaTlg9tVXwqYURzNvdebAp4wHJJIh42IP31SEsP2f/2dH25FDAEY1llVZtQ
	G6cMam8vDmPjZtToPWV4xBtckUrmJA3O6utgfvJUk7MImL/t+typlBzZjh15udJTwsMLyG
	/Zs7e5sO9fbqne9j7iMOxPnbRxDuvnnaZ35N4kpRUPikSIBOrXinQCx5DTVtWA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 72b5c997;
	Tue, 12 Aug 2025 21:20:28 +0000 (UTC)
Date: Wed, 13 Aug 2025 06:20:13 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	viro@zeniv.linux.org.uk, stable@vger.kernel.org, ryan@lahfa.xyz,
	maximilian@mbosch.me, ct@flyingcircus.io, brauner@kernel.org,
	arnout@bzzt.net
Subject: Re: +
 iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch added to
 mm-hotfixes-unstable branch
Message-ID: <aJuwDfwoSUP_M_0D@codewreck.org>
References: <20250812010237.B52F8C4CEED@smtp.kernel.org>
 <650364.1754991487@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <650364.1754991487@warthog.procyon.org.uk>

David Howells wrote on Tue, Aug 12, 2025 at 10:38:07AM +0100:
> > @@ -168,6 +168,8 @@ size_t iterate_folioq(struct iov_iter *i
> >  			break;
> >  
> >  		fsize = folioq_folio_size(folioq, slot);
> > +		if (skip < fsize) {
> >  		base = kmap_local_folio(folio, skip);
> >  		part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
> >  		remain = step(base, progress, part, priv, priv2);
> > @@ -177,6 +179,7 @@ size_t iterate_folioq(struct iov_iter *i
> >  		progress += consumed;
> >  		skip += consumed;
> > +		}
> >  		if (skip >= fsize) {
> >  			skip = 0;
> >  			slot++;
> >  			if (slot == folioq_nr_slots(folioq) && folioq->next) {
> 
> With the stuff inside the braces suitably indented.  The compiler should be
> able to optimise away the extra comparison.

skip is modified in the first if so I don't see how the compiler could
optimize it.
I just checked and at least iov_iter.o is slightly bigger with a second if:

(a.o = goto, b.o = if)
06:17:52 asmadeus@thor 0 ~/code/linux/bb$ size a.o b.o
   text	  data	   bss	   dec	   hex	filename
  26923	  1104	     0	 28027	  6d7b	a.o
  27019	  1104	     0	 28123	  6ddb	b.o

but honestly I'm happy to focus on readability here -- if you think two
if are easier to read I'll be happy to send a v3

-- 
Dominique Martinet | Asmadeus

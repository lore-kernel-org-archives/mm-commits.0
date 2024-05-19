Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27CD2E3E4
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716141768; cv=none; b=escXIQjAUMVqToQt/M2JkE/dmMO6yL+XZ1q6w6Y5oEN1VYonwfn7lj9vkhw3DSuN4cD+E39mmaYZsJsXkSLyfEW8VmO8V5uSdrC2c2+EAv8ss49wbG77VvG7mQTWnlZXRfE/oFv2Vs29TfE6bH5Kr0CN04fTHNXjGN0h94SPKX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716141768; c=relaxed/simple;
	bh=kEhtOaLdgy5lPNGHbBfdDuHmO9QXnSuQyV86uRAAzR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQUweyboiaqbSRwBFg0/Cqpur3SCE8sxQDbXvJ9Dp+/KFWhVjoCPqAcXCzX0y1GOmm+/8Hz/txDxjU0rPT8JZQntMaDAxj3jjJyyOR1i7afU4xH8ODwm49NRTdLUmctsdY6FsE32W4wTUYMTGXmkLugbmsxwLWWqkO5MwQKab5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bSKda03q; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bSKda03q"
X-Envelope-To: torvalds@linuxfoundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716141764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QxWT6yFeaOauY+SRIXUcV0VmlDaq8Ucmr4A+eczzPDg=;
	b=bSKda03qak4LPyrSaarBvNgu2qR0QRx7q9MRbSwN1KXH34CJsWxmxrsM5RozDdhMWkehGl
	XHkq7D91uA9QZMvOdEmokZbyZg/noDv1jvmKlVvE4UWW5XQy5Y8OJ0IaTrJuGiSteBhTGP
	6g+X6WWkr9DcLPVc7pyPSJMYpViBMeE=
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mm-commits@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Sun, 19 May 2024 14:02:41 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
Message-ID: <5qcafqbnrox7r5m4kghgykahtp2pusmhwfxqzrmhgvavxxsdux@ao2tce7nppey>
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
 <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
 <CAHk-=whSiUg7dggHaBLULuF6_GB6NORLDByog0p=Qo+0ewmZSA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whSiUg7dggHaBLULuF6_GB6NORLDByog0p=Qo+0ewmZSA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, May 19, 2024 at 09:48:49AM -0700, Linus Torvalds wrote:
> On Sun, 19 May 2024 at 08:32, Linus Torvalds
> <torvalds@linuxfoundation.org> wrote:
> >
> > I'm going to take this pull and fix up the cases I find, but I'm not
> > happy with this kind of trivial C preprocessor misuse.
> 
> I did some other maco handling cleanup too and tried to regularize
> some of this all, and it seems to work for me. But somebody should
> double-check, and it's possible these patterns should all be
> regularized further with a few helper macros for the whole "add
> __GFP_ZERO to argument list" or similar.

I just double checked slab.h, gfp.h and percpu.h, and scanned through
the diff vs. 6.9 for include/linux/ - looks like you got everything.

I think we can slim down the API surface of slab.h some more too, we're
now exposing three different ways of saying "trace/track this allocation
here": _trace, _track_caller and _noprof vs. normal; I think after a
cycle we can see if the old variants are still needed or can be
consolidated somehow.

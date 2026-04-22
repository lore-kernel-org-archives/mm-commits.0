Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D920277C81;
	Wed, 22 Apr 2026 20:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776890333; cv=none; b=sOPQ9eVgcp0kfZWiYyriqHX6Y9sWqlp36G5qqIEhfMNxt3r06j3QeqRZdrsUo9d0QralQPkwhlzlbD0lnR/O0ALW/Tbx4HF/17is1j5HwXq6DfDa3uEQH5H/lZFBOPS7tsqMT15QO4IRSZ7qWTZu6y2UmeMBXuVB7Vn9LrxVdYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776890333; c=relaxed/simple;
	bh=ypjIFJoMGkV05wpDN6/610qk87sp/CSBB17c69vu04w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+5YyixdaFAXrNi2nibKIDRcSsc4x/k0GUBJQJNidJ06BRiNAT+3mmo95PA0nP30tWali2ZmpE0bOGblLX8gjGeEws3BSF9DGbkQoXCB9vuBTxxRMqgipLsV0ynbXCo7rH4NiU5GSBjOQMu+A6vN1yi6IlUxWmlkFYnP4rXS9b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJsdlNRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJsdlNRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4296CC19425;
	Wed, 22 Apr 2026 20:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776890333;
	bh=ypjIFJoMGkV05wpDN6/610qk87sp/CSBB17c69vu04w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fJsdlNRsGxjvffWG+b5UNCN7OGX4bUL8gzUCiGvAe1XbSiKiJP1n4ou95lZ3uTUMk
	 UO2rLBgcMzZFHTyFaVyP0RneV1h0tEQzSbBjI42EZnfCYynLJdZw6Pq/nhFzF38sRf
	 NRhjxOTvrJaHu4zZJXfejx3s81ZGvlw3OQt4UfpQ=
Date: Wed, 22 Apr 2026 16:38:52 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-ID: <20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
 <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
 <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>

On Thu, Apr 16, 2026 at 01:18:20AM -0700, Andrew Morton wrote:
> > The proper format would seem to be
> > 
> >     https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/
> > 
> > (or "lkml" instead of "all" if you want to be more specific).
> > 
> > Maybe something changed recently, or maybe your scripting for this is
> > just broken?
> > 
> 
> Something changed recently.  Maybe Konstantin knows.

It's a temporary blocking measure against aggressive crawlers. We'll restore
this functionality shortly.

> I've always used https://lkml.kernel.org/r/MSGID.  So at present there
> are many thousands of broken links in the kernel tree.

Well, the upside of this scheme is that they are only broken for clicking, but
they can all still be found using the MSGID. However, as I said, this will
soon be restored once we migrate the system serving lkml.kernel.org hits.

-K

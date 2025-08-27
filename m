Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C25C2192E3
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 03:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756266154; cv=none; b=cQ/Xk/Ftqsas1AXi3c7byTZxpkr0vGWjKJ6W43WRf4Be9y5K8GF1UuvXpmb9hLIcUErppAXyPLRxthfSPPP73hUkJxVLtPJ0DDrwItR2csge5iaRiv7kI6VVnYxRIkAeKgNFNvDx7inp7nrmHnjD0vCI53kr+5C7xIP6AndcQDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756266154; c=relaxed/simple;
	bh=LvUi31Op+QRQvMdc2WJMRS2Y4qjnjt/OZkX/V+T/sEk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=JZ5f8aheN2jtQtYkh7OKKgZFaoNkHbPQWf51kRuC0N4JGmUdLsIusVJ6srsm32ydsnZSIm35Kzathxgl5tC6A826syMHjTCpSqKDegVY5iHPJLFBS3uSXFKG4Jj0xdvkJx6fEQqw/Jk/Ad6QCHGv5TjqJi7LjBA9BU/rannae9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Qrcj3om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Qrcj3om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1C1C4CEF4;
	Wed, 27 Aug 2025 03:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756266154;
	bh=LvUi31Op+QRQvMdc2WJMRS2Y4qjnjt/OZkX/V+T/sEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2Qrcj3omN66cRrRdYsHO7Z7hFE+/QAI9e6IBh2R6+je6l+3SbQlfXFP/D2vRtGB5Y
	 8MYQG1G/zEps93pdqrVrkc61caAiShI1RVzTPBoeMH4/nSHD8Qqa+uLasG3O1wGaYl
	 TnyTV1j1zkugUm5KIdldLBGoyyt+xjyTagQwMvFg=
Date: Tue, 26 Aug 2025 20:42:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, graf@amazon.com,
 changyuanl@google.com, bhe@redhat.com, epetron@amazon.de
Subject: Re: + efi-support-booting-with-kexec-handover-kho.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20250826204233.997c07140f1ba550798720f9@linux-foundation.org>
In-Reply-To: <CAMj1kXETbG0YZdJSjaw4o-QLpCNVmtuGpeJL6bFqpb_sBiW1MQ@mail.gmail.com>
References: <20250821213034.0B05AC4CEEB@smtp.kernel.org>
	<CAMj1kXG8OhR4TE013TqhFjf__nWbiF17gjSJFEbODH9wKk1b3g@mail.gmail.com>
	<20250826163129.8324fd9a457f549a6bd63728@linux-foundation.org>
	<CAMj1kXETbG0YZdJSjaw4o-QLpCNVmtuGpeJL6bFqpb_sBiW1MQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 27 Aug 2025 04:38:38 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:

> On Wed, 27 Aug 2025 at 01:31, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 26 Aug 2025 14:55:59 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > > On Thu, 21 Aug 2025 at 23:30, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > >
> > > > The patch titled
> > > >      Subject: efi: support booting with kexec handover (KHO)
> > > > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> > > >      efi-support-booting-with-kexec-handover-kho.patch
> > > >
> > >
> > > Please drop this patch. Once we agree on the right approach, I will
> > > take this via the EFI tree. Thanks.
> >
> > This was part of a two-patch series.  You're saying we should split
> > that series apart?  That this patch has no interaction with [1/2]?
> 
> Please drop both if you think that is more appropriate.

Why, what happens then?  Will the kexec patch be merged via the efi tree?



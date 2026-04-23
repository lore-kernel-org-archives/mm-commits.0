Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F63537D2;
	Thu, 23 Apr 2026 12:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776946367; cv=none; b=EenbW1PBtgz1LHC6DiFcrrPvD+iyBGW+HQc6jIQj4i8c7TcgbBcOnIhCFHH9AcfJ+hIvdSyamwiVFxV1kcMIbAbbvz4d02PgkHnwuQa8yKrNuXrmUQGGkp4DFiWxjNMdw0nKU4Yvho6n9C9YvA7BK8UV4BpHd4PfHHOIQzk5UUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776946367; c=relaxed/simple;
	bh=r2asbMybGDVKY94ODHXpQXCuLqqLQpPqFVYp/o4uWKs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=PrUbNuyD4Sj622Y3hHDedW5yu6msk7L90moapiS4uzWuRmXl04y8bsCOC+2GFnunEnoXMcZfUumYlmemHI2nQUSC2JGqL5crQuAUbbzYPNeP0l6Nnn64O+hGVvs5nTbXp1HmRXx9DtUfUsCrHY+sRpAtc5ei0/X1rvhoM0jlDOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a1bIpr/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a1bIpr/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6364C2BCAF;
	Thu, 23 Apr 2026 12:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776946366;
	bh=r2asbMybGDVKY94ODHXpQXCuLqqLQpPqFVYp/o4uWKs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a1bIpr/Oen6eV+OGCwfZkaptIFNISLzMXthuMTOgLvUAF4LUfRj/k91KiWOGGT/LS
	 j0UXoF1AMnV6JTTk7RXRxn9wtL9v3a/poQo0LWs2/2jna897LweCTnFsm4s4WDGq+O
	 iT0rfOuBQlfeMRYbtH1DMAKp8+mYadD0IJcQ68d4=
Date: Thu, 23 Apr 2026 05:12:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-Id: <20260423051246.5de8968ca017eeb8f053fbff@linux-foundation.org>
In-Reply-To: <20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
	<CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
	<20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
	<20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Apr 2026 16:38:52 -0400 Konstantin Ryabitsev <konstantin@linuxfoundation.org> wrote:

> On Thu, Apr 16, 2026 at 01:18:20AM -0700, Andrew Morton wrote:
> > > The proper format would seem to be
> > > 
> > >     https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/
> > > 
> > > (or "lkml" instead of "all" if you want to be more specific).
> > > 
> > > Maybe something changed recently, or maybe your scripting for this is
> > > just broken?
> > > 
> > 
> > Something changed recently.  Maybe Konstantin knows.
> 
> It's a temporary blocking measure against aggressive crawlers. We'll restore
> this functionality shortly.
> 
> > I've always used https://lkml.kernel.org/r/MSGID.  So at present there
> > are many thousands of broken links in the kernel tree.
> 
> Well, the upside of this scheme is that they are only broken for clicking, but
> they can all still be found using the MSGID. However, as I said, this will
> soon be restored once we migrate the system serving lkml.kernel.org hits.

OK, thanks.

But what is the preferred, official URL?   Any preferences?

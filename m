Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F357D345725
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774545322; cv=none; b=AxRifeYEJtwHLRC66sW50pehjnrw06IJhe0CUjMxVLmbjTi8qxi0qMtzG5EUCm0NT9XR6Wmdp10RRYognuDMV9WOJp2umDwpibHnYpCYaISxG4DdM1hAbP88SIMvaXxIzHj0/OF+eayuunssb/KVjBW5bY/4cjFLRze5j0tD+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774545322; c=relaxed/simple;
	bh=LZ9sZYKgYBDZ10/hZU1n8UaBei0W1CapPVfwJ6RamsI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pJLn//91DzesRneBPTDIpsVGwFUrxGPIwg+gsFrDgwkMcI4KGpFuoN0J2XkH2+/XRa6ywCaTR26XnFIlHCY4A2ItfwMRSnL9qBKy4iSPLzBo0cibaVHO1FYfSiBNl7sxQ3e7a4/WjVkdqNRhihBJsBUfFm0UalCJF2di1DT6k+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ghjsb6Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ghjsb6Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74503C116C6;
	Thu, 26 Mar 2026 17:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774545321;
	bh=LZ9sZYKgYBDZ10/hZU1n8UaBei0W1CapPVfwJ6RamsI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ghjsb6MbVYwVDoJPo8rlS5cuJ5ONxz//3OSYOh7YS/4O09mwNkyNjfazoIDzSmGzg
	 ZPqV89aCOZcpoa0Bv5SFIooW74cVGmpwpDJfOlg8XBGIxpz9PfYdOYEx3Nj0EeEawZ
	 24OOsgNzzRiez5gfYMWEV2Z7D00RLrgnBjlxb9ag=
Date: Thu, 26 Mar 2026 10:15:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Block <bblock@linux.ibm.com>
Cc: Thomas Gleixner <tglx@kernel.org>, mm-commits@vger.kernel.org
Subject: Re: +
 debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
 added to mm-nonmm-unstable branch
Message-Id: <20260326101520.86c065368f171e70d4726418@linux-foundation.org>
In-Reply-To: <20260326094626.GC252856@p1gen4-pw042f0m>
References: <20260311174822.42D6DC4CEF7@smtp.kernel.org>
	<87qzp7et8k.ffs@tglx>
	<20260325115527.36034bfd3d91d6f258526c74@linux-foundation.org>
	<20260326094626.GC252856@p1gen4-pw042f0m>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 26 Mar 2026 10:46:26 +0100 Benjamin Block <bblock@linux.ibm.com> wrote:

> On Wed, Mar 25, 2026 at 11:55:27AM -0700, Andrew Morton wrote:
> > On Wed, 25 Mar 2026 18:03:55 +0100 Thomas Gleixner <tglx@kernel.org> wrote:
> > 
> > > Andrew!
> > > 
> > > On Wed, Mar 11 2026 at 10:48, Andrew Morton wrote:
> > > > The patch titled
> > > >      Subject: debugobjects: allow to configure the amount of pre-allocated objects
> > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > > >      debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
> > > 
> > > Can you please drop this. The underlying problem is not explained at
> > > all and the question I asked vs. deferred page init is not answered.
> > > 
> > 
> > Yep, no probs, I agree that this isn't the one.
> > 
> > Benjamin, please do pursue this - the issue is real and has been around
> > for a long time!
> 
> I'll get back to you both; I was out for a couple of days :)

Thanks.  It's been this way for a very long time, so there's no hurry
at all.  And we can backport any fix into -stable kernels if the issue
is determined to be serious enough.

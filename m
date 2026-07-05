Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA005376A17
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783275305; cv=none; b=qLEpxuVclcyldkYjcdVxLfgIas6I7mIM+kReAXnfY1YKxwYZfsdyaVSiQFtcoxlrMQyPKhZ7bEz8FNRdcCm2i/O9H73RyHLPICg1DdYs9+E6yoTTGdj2OIaSqv0gsFcL7xtE97+ssAfwmur2V8nu5DjznOONDgqzMAmrPDQwxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783275305; c=relaxed/simple;
	bh=oDrTK8OL9rO+xCA3AKwk/cIawfpXkxDzxSLaybCjJQE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=T6Mitd1AiQKiEDRd8iv5C6t6tfTk6puKvOwWCWRByVzNY02FS05ZzUpHUONjYhF1CfO6RFWbPU5km/AlmIEf5Yv6x5Qy4H+vbIMuTmJ3K5mNtkrlh5fvzE0AJM7rk69NN9iuSvX4cKsOVeL3frkAbt8dsYrZjyx422ET6SNgWCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXvMrTrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXvMrTrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F7C1F000E9;
	Sun,  5 Jul 2026 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783275303;
	bh=6tvbnOsiGejklFLE21y8e8YxT9cFCIL3X+MQvuwEFGk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IXvMrTrppBTe53/UD1N0Ke08d5yMQCWpvdsv+k+PE3IbATCtSHzkMJntGsYI4lEV/
	 A/7hCZcaiKdIQ241V9ae3Tf1mN8CdTK7sqa7FWtH/GEQNKCiwz0+pNHU3fv0lieq0H
	 qVYULTCX47csFescbNCmjm7mNYlC/PVfUOdF0p8w=
Date: Sun, 5 Jul 2026 11:15:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: mm-commits@vger.kernel.org, kent.overstreet@linux.dev,
 catalin.marinas@arm.com, bigeasy@linutronix.de, arnd@arndb.de,
 leitao@debian.org
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-Id: <20260705111502.665c33d496d5dc9e0187a577@linux-foundation.org>
In-Reply-To: <ako1sMPVu4dfQR4K@casper.infradead.org>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
	<ako1sMPVu4dfQR4K@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 5 Jul 2026 11:45:04 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Sat, Jul 04, 2026 at 07:12:40PM -0700, Andrew Morton wrote:
> > The patch titled
> >      Subject: radix-tree: fix kmemleak false positives on tree head reassignment
> > has been added to the -mm mm-new branch.  Its filename is
> >      radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
> 
> Umm.  I don't see this patch in my inbox anywhere else.  Is email broken
> again?

You weren't cc'ed on the original.  I added you.  lib/radix-tree.c has
no MAINTAINERS record!

> > This is the same race fixed for the XArray API in commit a1a029bcea59
> 
> This commit ID doesn't exist in any tree I have.
> 
> > ("XArray: fix kmemleak false positive in xas_shrink()").  The IDR uses the
> > radix tree API directly and hits it on both the grow and the shrink path,
> > so mark the new head as a transient leak in both.

https://patchew.org/linux/20250512191707.245153-1-jkangas@redhat.com/

Seems it was in mm.git for a while, I dropped it due to failures and
I don't think Jared took it further.

> > Add a matching kmemleak_transient_leak() stub to the radix tree test
> > harness so the userspace lib/radix-tree.c build keeps building.
> 
> Last time this was proposed, the suggestion was that kmemleak needed to
> be fixed.
> 
> https://lore.kernel.org/all/aCyI8T2sWlPLEYZ_@arm.com/

Great, thanks, I added a note, shall await developments.

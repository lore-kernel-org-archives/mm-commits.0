Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F186F19D089
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719259662; cv=none; b=itW8WU7H6bQ7iTQm4fR4N6pmB6Fw/ihZIYlXC1ZQWgQjbt6gemDo9oZKJDlFDyLvnkDFY1eUGgEUwxnEdbStWpQm9ke1G3AjuwWSI45/dnFIT92qrgHntQVpxHSljH6KLq+12RkUWW/b/xK0P81Q+zx+udAOajMv36qsc8VheTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719259662; c=relaxed/simple;
	bh=W68zs9ya5x9Xq9I+GCqZYiIwXsZE+NvtBIxpRZJoXfI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=alN19XDFbaYqa53SWkdM47Lvm4qWFkAfCu9MJ6D9xNOq8Ga/OHqFIwhuLYdm6U9pTOoxDFoBAN6/fJOW4K5udfYMZ6zkWGCdlGRL2EqLWEOVqWQDvSNbXD2BhCj0od4tpj0sQV26vH6B6V+x5u3VbIHRLB6LybfxVhNnPqyekSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kg2YPH5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kg2YPH5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496D3C2BBFC;
	Mon, 24 Jun 2024 20:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719259661;
	bh=W68zs9ya5x9Xq9I+GCqZYiIwXsZE+NvtBIxpRZJoXfI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Kg2YPH5qh+k1JZZAjmh3g4IaDLy6tabQ7XVcpkOSpEWYZ6+FoQcBbg6qOlORSSdBU
	 /2E2BR4oLgzjo5u0WaqGrSrzRozP3xaksS9k9wX8lE7ebWikJny2ZBs6upI9kpiOCf
	 2i3LekUkFMItf7RRsFdB6K7CE7FU7Q/FfNvbSgJw=
Date: Mon, 24 Jun 2024 13:07:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, mm-commits@vger.kernel.org,
 terrelln@fb.com
Subject: Re: + zram-move-from-crypto-api-to-custom-comp-backends-api.patch
 added to mm-unstable branch
Message-Id: <20240624130740.de6c0b0e01ec2430bb4a3ded@linux-foundation.org>
In-Reply-To: <20240624155132.GC3130923@google.com>
References: <20240522223141.2F4A4C2BBFC@smtp.kernel.org>
	<20240624033323.GA3130923@google.com>
	<ZnmRDl_mZOP2XxtO@google.com>
	<20240624155132.GC3130923@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Jun 2024 00:51:32 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> On (24/06/24 08:30), Minchan Kim wrote:
> > > > This patch will shortly appear at
> > > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-from-crypto-api-to-custom-comp-backends-api.patch
> > > 
> > > Hello Andrew,
> > > 
> > > May I please ask you to drop this entire series?  Apologies for
> > > inconvenience.
> > 
> > Hey Sergey,
> > 
> > I didn't catch up all yet but why do you want to drop it?
> 
> Hello Minchan,
> 
> I should have provided more context, sorry.
> 
> The reason being is that I want to rework the series.  For example,
> I don't really like the way I handle zstd C/D dicts and the whole
> ->init_config/->release_config for per-CPU compression contexts.
> We, quite likely, can move compression contexts out of per-CPU area
> entirely, and have a single context per alrogithm.  It's only workmem
> that cannot be shared and hence should stay in per-CPU.

I have dropped the series, thanks.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D486430E82C;
	Thu, 18 Jun 2026 20:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781815074; cv=none; b=L95R9LJ+rktXxKXbQXxCXVKzKZAcatahE9jDjIq5cpinuLJHByvB3HYGs/vL4gE4v2ukCANyeqdpOOMqE4BZ3AvoLrkBVCZuFJRLe+v3i/QppS7piJwkosHO9mxFZNz1lV+nlQj25y0o93L2VSUyu3wbSepoKVuKCkUjQ6Vw/ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781815074; c=relaxed/simple;
	bh=YPb6Xth53zRK5oKIAdV4JlkBZKVJguIGNSGSlgwr5zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQCf4RPF9ECXQOFxJOGSpYoNbWnOF7agUeZuzOkurdD/FhelxGoTtskdUI44Qb6O4kGpDcMuEsZpeUlsFEDsCAoJx2BAjG2K4SsXE/jQHbpS6v1VOWVcx1TWVvwRhffSbdQg5pOUMHStAnFeHaHTIn3+8wYqroj7xF520t+R994=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGBv+lCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGBv+lCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457081F000E9;
	Thu, 18 Jun 2026 20:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781815073;
	bh=FgYvUxkRhhZ1t4kqKiHc1yP0t1oilVAH8i82pg2Y2aE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lGBv+lCY1dyY/ASodCxpsI8G9aY/iPKrPt/+UjtiW3q7BTqSohgm9az2+ioAIo3Ar
	 FDz+3mldQkzcUB5v/Y1WNtw/VteSKN6EilfCGLakjt3kjnXaYW9EDlLthr93y67Iok
	 /6Byy9UBhkr7r7oVMjhx7h1z2zEKxcYLgTD6sOsI=
Date: Thu, 18 Jun 2026 16:37:52 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pr-tracker-bot@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
Message-ID: <20260618-generous-sceptical-jackdaw-3d32db@meerkat>
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
 <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
 <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>

On Thu, Jun 18, 2026 at 09:02:06AM -0700, Linus Torvalds wrote:
> This is very wrong. That merge (2f9f5887b427) is merging Jens'
> io_uring epoll cleanup. Not Andrew's MM tree, which I haven't gotten
> to yet.
> 
> I wonder why pr-tracker-bot got this wrong.
> 
> [ Goes off and looks ]
> 
> Oh. Andrew's pull request is confused. It says
> 
>    The following changes since commit e771677...
>      ...
>    for you to fetch changes up to e771677....
> 
> and note how the "since" commit and "up to" commits are the same (and
> is my iommufd merge). So then pr-tracker bot thinks it's merged when
> the "since" commit was merged.

Let me at least handle this situation -- it's clearly an oversight.

> That doesn't explain why pr-tracker-bot thinks it got merged in what
> was me merging Jens' tree, but whatever.

I'll look into this as well.

-K

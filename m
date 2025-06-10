Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C4823504C;
	Tue, 10 Jun 2025 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749575052; cv=none; b=R8cOHx8qgQWpoA/4F53N9PJhAeGek17NdsBuDU2AMNSwd4s2d+8IH15e+IPHwWifIKG30n0oAr5BnfzPzl0ohX+4YQJ/3KhIPruH3H0oENivsQ+cKTxp8Tz7f6lqLWks+F5KNj2VNc1nZCBZ3OWQ57RoCmMS3mYby6EdTSTi1Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749575052; c=relaxed/simple;
	bh=0hNtdD7pLrxAsMjKqBoKQsElU7iB5BJEcOrwJGziKds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qV3XnQIuU8Ps+29LVTKnA0NLxg5XVUg1JVdAnm65vb81vH6rnyEPiFF7Y579TfR7fhopg4D3fTyd+oFp5inMI1hbAlsv/QrDTpONnQlUwQhfOKMl4V7Hs2ZkYRrj2EZSfzVaqkzrs3NG1BXDSgHH+2VHB1osPm8MFiV0PXgWZMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDydrHOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDydrHOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE932C4CEED;
	Tue, 10 Jun 2025 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749575051;
	bh=0hNtdD7pLrxAsMjKqBoKQsElU7iB5BJEcOrwJGziKds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDydrHOsrDy5gPFA1bba7CuyrCTPBvTZ97fB/6ixk0ZNtBeOjpRZDXQiCvJ/kx1aP
	 QNRz49yRYvF0rO8QhVGNkTJQm4df8NLQOsJdeMNtTilYJeBEc7cNmajN6ULPatoj7L
	 CCYVBMAFnXjooXdrVX47n/i+UVuum8IHAyK6rZeUElareSKH0ChKQykKe/n8UmxtiT
	 ivBpq9eyNHcVPUUbxkyoMFSydxeU9V9pW6Rd8EfAPnmab35TgcSdePmpOX+oReWQYl
	 pcFLeOK9fti1p+WijObqiDko/pRGSQPoua7elDcvyesOmR/eHt0JxGpG5ciZClJezO
	 /wiXvTE6z7meQ==
From: SeongJae Park <sj@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	mm-commits@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
Date: Tue, 10 Jun 2025 10:04:08 -0700
Message-Id: <20250610170408.48855-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAMuHMdXyJhaFUbKX2Hhoa2y4hVK+0NhvL4hNL_8RnVOxaCkq=g@mail.gmail.com>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Geert,

On Tue, 10 Jun 2025 18:41:43 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Hi Andrew,
> 
> On Tue, 10 Jun 2025 at 17:54, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 10 Jun 2025 11:05:40 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Mon, 2 Jun 2025 at 17:55, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > - The 2 patch series "mm/damon: build-enable essential DAMON components
> > > >   by default" from SeongJae Park reworks DAMON Kconfig to make it easier
> > > >   to enable CONFIG_DAMON.
> > >
> > > ... or, make it harder to disable it?
> > >
> > > Given no single defconfig file in v6.15 enables CONFIG_DAMON, I find
> > > it hard to believe defaulting DAMON to "y" is the right thing to do...
> > > (Yes, I have read the rationale in commit 28615e6eed152f2f
> > > ("mm/damon/Kconfig: enable CONFIG_DAMON by default")).

I'm not clearly seeing what is your concern.  Could I ask you more
elaborations?  I'm not that familiar with distros' config setup process and
defconfigs, so this might be just a silly question, but please bear in mind
with me.  I'd like to clearly understand this to avoid making similar problems
later.

> >
> > So what do you recommend?  Editing all the defconfigs seems a bit lame.
> 
> Just revert the commit?
> Distros are (usually) not using defconfig files anyway.

Reverting the commit is not a big problem for me.  But, it would be nice if I
could better understand and agree your concerns, and learn how I could do
better next time.


Thanks,
SJ

[...]

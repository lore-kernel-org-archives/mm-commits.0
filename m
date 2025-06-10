Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2367E23AE95;
	Tue, 10 Jun 2025 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749570858; cv=none; b=BZKYEWXgdOq1pQPjxBZHcpQlsJYtVixe02I340c1siaKAOVzWSITVjzGdxwOo8oGqChiXIxH6QuPvAB4qSglNjN+LL1jeLVawC3/UEna8XvnchgUZsac902UIB1Qrr+piS8uivCwx+gdkGzNGQ2tkVksRRbFuDCdRFxApkru/3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749570858; c=relaxed/simple;
	bh=mGv6u+/Jd7Nu4gqNxhBr16DRVCVkBdZUmm9+9kWgTbk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=U24IpkbjA5MtlyKBvn10v/F9Yh6Z389n84E7G/y52ffQQuKtchCCFlH3S6xR9/S7c5A2Rw7cTG1MbtTjGqMbbRXuC2/Pj0I2uXryUgfyFWulNA/RTqbQpJ3+1dSNWnvG0qIVhwRapzON0UQLIHHV1tkFRswIij23ew2fdEMazhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwDCcvjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwDCcvjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C55C4CEED;
	Tue, 10 Jun 2025 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749570857;
	bh=mGv6u+/Jd7Nu4gqNxhBr16DRVCVkBdZUmm9+9kWgTbk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iwDCcvjMQXn+rysuJcbEtdKIjRogg/J+PlbKbR3ZkJtCBkID+Zrjdf7BDRO5BgVO3
	 p5HCzAySXm+k/0QuMrJ0yxt3XCeG/9D+x8vOlVjFxI/+k80SWdnicqETVeSOI3Y+p0
	 ipJtlOHzDtbLhxr05B8FddwkgPgDMbqrIZHifNAc=
Date: Tue, 10 Jun 2025 08:54:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: SeongJae Park <sj@kernel.org>, Honggyu Kim <honggyu.kim@sk.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
Message-Id: <20250610085416.062b4bc386dde2ea475369f5@linux-foundation.org>
In-Reply-To: <CAMuHMdU1NdNjx3f1V9j2FACWwC5faPKCXChtW6Z=i2JyXquFuA@mail.gmail.com>
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
	<CAMuHMdU1NdNjx3f1V9j2FACWwC5faPKCXChtW6Z=i2JyXquFuA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Jun 2025 11:05:40 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Hi Andrew et al,
> 
> On Mon, 2 Jun 2025 at 17:55, Andrew Morton <akpm@linux-foundation.org> wrote:
> > - The 2 patch series "mm/damon: build-enable essential DAMON components
> >   by default" from SeongJae Park reworks DAMON Kconfig to make it easier
> >   to enable CONFIG_DAMON.
> 
> ... or, make it harder to disable it?
> 
> Given no single defconfig file in v6.15 enables CONFIG_DAMON, I find
> it hard to believe defaulting DAMON to "y" is the right thing to do...
> (Yes, I have read the rationale in commit 28615e6eed152f2f
> ("mm/damon/Kconfig: enable CONFIG_DAMON by default")).
> 

So what do you recommend?  Editing all the defconfigs seems a bit lame.

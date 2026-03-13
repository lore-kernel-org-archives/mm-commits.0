Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A904361678;
	Fri, 13 Mar 2026 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417174; cv=none; b=P19q6jV3vZBtqpBSWE+3pFC+7XbqJSLKCNFsrCX1/uTodm/9QHL/4a9UZtSCQG6k0IRccAEVR7z0a6EB+MO+GQ0I9JPvWSBQCPwdudzKgMiIsscHMOPuORTjRhmer8w+98xIMoDxyOiF15FSw8Ba31KtXIsk6APwNvPo4RJ09MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417174; c=relaxed/simple;
	bh=DPuIYlzk/ACFLyS3hqF2TtwKQ0tYQcpwlY1FrssBKuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ja2WcBGnu0Yp5dBlh/JV3zNw+tzo3LhgIGeXPgCmpVeula6oZxmTrpGQhpqJ6k0VKlmu7JNwc1LCA6a7/jfABCaKu6Mv9QDweYf0aj8JL6ACeWt7PBDv0pQYlhWj8Sl+QatYUGOEoEQINKuSMOoDoZQWx+l/WSUuqWSbcbZx9Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDA9cI+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDA9cI+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEA9C19421;
	Fri, 13 Mar 2026 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773417173;
	bh=DPuIYlzk/ACFLyS3hqF2TtwKQ0tYQcpwlY1FrssBKuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDA9cI+FVqffKXyQ9fB6OqLKrIiTrgbewkFePz70IS4isCeeWWnw2aXu48ragF5eY
	 qTtvJDcLgMoV8d55RoyXltLDHe8LaggJw7Prc2s67KYwpzGa//YiuqflcoBuF8lITX
	 NtQfihTfjZJbr/RKo2y4+nruMjphPFWaXJxiwIHxqn3FIEPhcJ9bDgOhI6laU4TMnI
	 mhA8jrHpP1ZWaFatgPYIjJGKYlSghs40slR8zBHMCg59oecVR7lH5YW/V4p07YN7kX
	 e2QtJNmLAdcUXb0T7TAhLm5B2X4eFNFiSD5vr0XWs7oTkTtBcq/NkKbf4jWmuO0p/P
	 J4l6GXtUhdb9Q==
Date: Fri, 13 Mar 2026 08:52:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Josh Law <hlcj1234567@gmail.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Vlastimil Babka <vbabka@suse.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>,
	mm-commits@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: add Josh Law as reviewer for library code
Message-ID: <20260313155253.GD1742010@frogsfrogsfrogs>
References: <20260307221931.2848601-1-objecting@objecting.org>
 <3cd25de5-3737-49f4-aa8b-eaaee471af50@lucifer.local>
 <ee644e1b-5759-477f-8aec-35c91a5a938e@suse.com>
 <20260307222154.2848660-1-objecting@objecting.org>
 <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com>
 <20260313-anvisiert-gemeckert-352414e3d58d@brauner>
 <20260313-halskette-annahme-94e782eb4ae4@brauner>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260313-halskette-annahme-94e782eb4ae4@brauner>

On Fri, Mar 13, 2026 at 04:33:49PM +0100, Christian Brauner wrote:
> On Fri, Mar 13, 2026 at 04:00:38PM +0100, Christian Brauner wrote:
> > On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
> > > Add myself as a designated reviewer for the library code to help review
> > > incoming patches and improvements.
> > > 
> > > Signed-off-by: Josh Law <objecting@objecting.org>
> > > ---
> > >  MAINTAINERS | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 96e97d25e1c2..8fd03ab9c657 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -14613,6 +14613,7 @@ F:	tools/testing/nvdimm/
> > >  
> > >  LIBRARY CODE
> > >  M:	Andrew Morton <akpm@linux-foundation.org>
> > > +R:	Josh Law <objecting@objecting.org>
> > >  L:	linux-kernel@vger.kernel.org
> > >  S:	Supported
> > >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > > -- 
> > > 2.43.0
> > > 
> > 
> > On Fri, Mar 13, 2026 at 10:17:53AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
> > > > Add myself as a designated reviewer for the library code to help review
> > > > incoming patches and improvements.
> > > >
> > > > Signed-off-by: Josh Law <objecting@objecting.org>
> > > 
> > > Sorry but NAK, I appreciate your enthusiasm but this is literally _all_
> > > library code, and you don't have a long track history in the kernel.
> > > 
> > > Also in [0], [1], etc. you aren't demonstrating a great deal of maturity,
> > > so I don't think it's appropriate for you to be added at this time.
> > > 
> > > I really don't think a 'catch all' category should be getting arbitrary
> > > extra reviewers in any case.
> > > 
> > > Please take some time to contribute to the kernel, establish yourself, and
> > > then look to reviewership for a specific category.
> > > 
> > > Thanks, Lorenzo
> > > 
> > > > ---
> > > >  MAINTAINERS | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 96e97d25e1c2..8fd03ab9c657 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -14613,6 +14613,7 @@ F:	tools/testing/nvdimm/
> > > >
> > > >  LIBRARY CODE
> > > >  M:	Andrew Morton <akpm@linux-foundation.org>
> > > > +R:	Josh Law <objecting@objecting.org>
> > > >  L:	linux-kernel@vger.kernel.org
> > > >  S:	Supported
> > > >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > > > --
> > > > 2.43.0
> > > >
> > > >
> > > 
> > > [0]:https://lore.kernel.org/all/c41dbb9d-b8a5-4b5f-9f71-3fe1bed210b6@gmail.com/
> > > [1]:https://lore.kernel.org/linux-mm/40767ecf-7e25-48f5-a604-c43b835b6b66@gmail.com/
> > 
> > On Fri, Mar 13, 2026 at 11:49:03AM +0100, Vlastimil Babka wrote:
> > > On 3/13/26 11:17, Lorenzo Stoakes (Oracle) wrote:
> > > > On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
> > > >> Add myself as a designated reviewer for the library code to help review
> > > >> incoming patches and improvements.
> > > >>
> > > >> Signed-off-by: Josh Law <objecting@objecting.org>
> > > > 
> > > > Sorry but NAK, I appreciate your enthusiasm but this is literally _all_
> > > > library code, and you don't have a long track history in the kernel.
> > > 
> > > Agreed, just a week after first appearance on lists is really quite too soon.
> > > 
> > > Yes, getting Cc'd thanks to R: entry is one thing, but that can be achieved
> > > with lei as well. The other aspect of R: is giving weigh in replies to
> > > (potentially new) contributors and that's why it's not given out rather that
> > > quickly.
> > > 
> > > > Also in [0], [1], etc. you aren't demonstrating a great deal of maturity,
> > > > so I don't think it's appropriate for you to be added at this time.
> > > > 
> > > > I really don't think a 'catch all' category should be getting arbitrary
> > > > extra reviewers in any case.
> > > 
> > > Agreed. Many of the files under lib/ are listed in other sections with their
> > > own maintainers. They were not cc'd on this MAINTAINERS update and yet it
> > > would affect all patches to their files too, so they could at least have a
> > > say. It's unfortunate that it's how this catch-all works. Maybe X: entries
> > > could be used by the specific maintainers in the catch-all section, although
> > > it's somewhat tedious.
> > 
> > Agreed. I'm sorry but there is no meaningful track record that would
> > justify this addition. lib/ encompasses locking.c, iov_iter.c,
> > rhashtable.c and a ton of other stuff that is consumed by literally the
> > whole kernel from core to drivers. If this was something innocous I
> > wouldn't care but there's a lot of really gnarly but important stuff in
> > there.
> > 
> > And yes, all of the externally maintained files should be dropped from
> > the generic lib/ catch-all ideally.
> 
> Ok, so let's look at this for a minute:
> 
> - first patch Feb 28 under pseudonym "techyguyperplexable", switched to "Josh Law" only when Andrew required a real name
>   in https://lore.kernel.org/all/20260228114939.de7d44de38d907a9b6632480@linux-foundation.org
> - 142+ emails in ~2 weeks — 37 patches in a single day (Mar 1)
> - All trivial/cosmetic — SPDX headers, comment grammar, spacing, const qualifiers. Zero bug fixes, zero new functionality
> - Carpet-bombed multiple subsystems — lib/, arm64/, staging/, input/, etc.
> - within 1 week of first-ever patch, submitted MAINTAINERS: add Josh Law as reviewer for library code covering all of lib/ (locking.c, iov_iter.c, rhashtable.c, etc.)
> - Email identity mismatch — From: hlcj1234567@gmail.com, Signed-off-by: objecting@objecting.org
> - Formatting problems — top-posting, line length violations, patches not applying cleanly
> 
> So I mean, one week to Reviewer. Even if we're being very generous here,
> we need to do a lot more due diligence going forward. We can't just hand
> out core components like this and risking our reputation and security
> posture.

/me sees "Lmao you and your test cases" in [1] and responds with "LMAO
NAK".  If you're not serious about helping everyone to test your changes
to library code such that you respond that dismissively to longtime
maintainers, you shouldn't be working on operating system kernels.

--D

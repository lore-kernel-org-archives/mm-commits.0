Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570A521770B;
	Fri, 13 Mar 2026 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773414058; cv=none; b=clST9d4Mqmcr59k0YZs71CKi2Q2fx1j7oKivcvZmYaew3SC3yI3RmUNJ7WdcUxBiJkzutSDLvy6uvoEHKPXZiJC3JmeVBEI3Au03Vnu3Gzo9mm+HGBPdq9crHg2pbphNTVH0LX2eg3DecMON5PoMVOU3yLN9g6gsa4ujzEy6Znk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773414058; c=relaxed/simple;
	bh=c6LBU7XJk1IiaPu8DZnHkyMvzaSk2SyumHxHJ9AXqDc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=QDjOUZpAMEZowk3EJad1nJc5U43cX5Fe6u5Yzu6HedlQfv9uwpVSnCE9woiHYJAcgfxH+rKXbzy3NvKds/YbtLWB8OevOSZeoMzezeVOz5MbY1mnoMMS1hU/W59m0SCk14Pg9USH4pgprA9PD3PNIoTOnOyxlpAd4GPt9h4Q3VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQP4QY7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQP4QY7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09655C19421;
	Fri, 13 Mar 2026 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773414057;
	bh=c6LBU7XJk1IiaPu8DZnHkyMvzaSk2SyumHxHJ9AXqDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=gQP4QY7jrRaQZI/TPm8j+LG6X6CjmJDC1LSul8Kfv1G4NRf7b4Noz7XmHRE4KYR68
	 8Y+QMGfCXeoQnAGygWkYgEVuku9VnnMaGiV7cqbfospN1uxpXkdbXak4JhcShry7iD
	 aR2x/I4iKXuyYPKsrQkNrvYMloEjfydHM6JFHpcKBl/wJtM4LsEdHkkdaNhSzp4Rtj
	 kkjyIsTfCv2BrUs6IWuLlM4OQQiqpFWqMUWFOu2xeTDofZCdtXR4/s9kAkgl3+lR2S
	 STl8QylAB3CoLh++D8n2FdmoZr5K7sXeIb41MAf2oBWuYm8qhrN0hM3GMx/venLW5T
	 HyAlsOJS3m5rA==
Date: Fri, 13 Mar 2026 16:00:38 +0100
From: Christian Brauner <brauner@kernel.org>
To: Josh Law <hlcj1234567@gmail.com>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Vlastimil Babka <vbabka@suse.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>, mm-commits@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Josh Law as reviewer for library code
Message-ID: <20260313-anvisiert-gemeckert-352414e3d58d@brauner>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260307221931.2848601-1-objecting@objecting.org>
 <3cd25de5-3737-49f4-aa8b-eaaee471af50@lucifer.local>
 <ee644e1b-5759-477f-8aec-35c91a5a938e@suse.com>
 <20260307222154.2848660-1-objecting@objecting.org>
 <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com>

On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
> Add myself as a designated reviewer for the library code to help review
> incoming patches and improvements.
> 
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 96e97d25e1c2..8fd03ab9c657 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14613,6 +14613,7 @@ F:	tools/testing/nvdimm/
>  
>  LIBRARY CODE
>  M:	Andrew Morton <akpm@linux-foundation.org>
> +R:	Josh Law <objecting@objecting.org>
>  L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> -- 
> 2.43.0
> 

On Fri, Mar 13, 2026 at 10:17:53AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
> > Add myself as a designated reviewer for the library code to help review
> > incoming patches and improvements.
> >
> > Signed-off-by: Josh Law <objecting@objecting.org>
> 
> Sorry but NAK, I appreciate your enthusiasm but this is literally _all_
> library code, and you don't have a long track history in the kernel.
> 
> Also in [0], [1], etc. you aren't demonstrating a great deal of maturity,
> so I don't think it's appropriate for you to be added at this time.
> 
> I really don't think a 'catch all' category should be getting arbitrary
> extra reviewers in any case.
> 
> Please take some time to contribute to the kernel, establish yourself, and
> then look to reviewership for a specific category.
> 
> Thanks, Lorenzo
> 
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 96e97d25e1c2..8fd03ab9c657 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -14613,6 +14613,7 @@ F:	tools/testing/nvdimm/
> >
> >  LIBRARY CODE
> >  M:	Andrew Morton <akpm@linux-foundation.org>
> > +R:	Josh Law <objecting@objecting.org>
> >  L:	linux-kernel@vger.kernel.org
> >  S:	Supported
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > --
> > 2.43.0
> >
> >
> 
> [0]:https://lore.kernel.org/all/c41dbb9d-b8a5-4b5f-9f71-3fe1bed210b6@gmail.com/
> [1]:https://lore.kernel.org/linux-mm/40767ecf-7e25-48f5-a604-c43b835b6b66@gmail.com/

On Fri, Mar 13, 2026 at 11:49:03AM +0100, Vlastimil Babka wrote:
> On 3/13/26 11:17, Lorenzo Stoakes (Oracle) wrote:
> > On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
> >> Add myself as a designated reviewer for the library code to help review
> >> incoming patches and improvements.
> >>
> >> Signed-off-by: Josh Law <objecting@objecting.org>
> > 
> > Sorry but NAK, I appreciate your enthusiasm but this is literally _all_
> > library code, and you don't have a long track history in the kernel.
> 
> Agreed, just a week after first appearance on lists is really quite too soon.
> 
> Yes, getting Cc'd thanks to R: entry is one thing, but that can be achieved
> with lei as well. The other aspect of R: is giving weigh in replies to
> (potentially new) contributors and that's why it's not given out rather that
> quickly.
> 
> > Also in [0], [1], etc. you aren't demonstrating a great deal of maturity,
> > so I don't think it's appropriate for you to be added at this time.
> > 
> > I really don't think a 'catch all' category should be getting arbitrary
> > extra reviewers in any case.
> 
> Agreed. Many of the files under lib/ are listed in other sections with their
> own maintainers. They were not cc'd on this MAINTAINERS update and yet it
> would affect all patches to their files too, so they could at least have a
> say. It's unfortunate that it's how this catch-all works. Maybe X: entries
> could be used by the specific maintainers in the catch-all section, although
> it's somewhat tedious.

Agreed. I'm sorry but there is no meaningful track record that would
justify this addition. lib/ encompasses locking.c, iov_iter.c,
rhashtable.c and a ton of other stuff that is consumed by literally the
whole kernel from core to drivers. If this was something innocous I
wouldn't care but there's a lot of really gnarly but important stuff in
there.

And yes, all of the externally maintained files should be dropped from
the generic lib/ catch-all ideally.

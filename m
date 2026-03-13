Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A6335838F;
	Fri, 13 Mar 2026 15:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773416912; cv=none; b=QuDVLIBtIFwlw69fBZyfk1URQnQIDhgaM+0yzSGg88Qf0klCtfCDe9w24k6wQwlPgyyWC9vdeXx7khKUP6+rR+NW7PBGoE2L+oNBIwPopoMGsEoA8WO86i+6Y0UmDQNBNPaA3l2OJV51T0QVbv+zptCIOsJJdCL270ZvEJhGA4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773416912; c=relaxed/simple;
	bh=xCtooFBlYayR6p/jvyKQJ9Wmo2RiUb+PyTS+owxN9Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZB6JO4GUqrvZCmx4QgOtRJToPZEWDp5lx126GOZpWu61VQX03YuCyibhxKfv8T7UbxsY3V4A0Gsba5sxsJQ5kGJh72TZ2ZSfIyr3VxuuhJXKMI/l3DAak94vAI45fX5HHgxgU/DP9wjvbPeYNASQS7zxUMg3UCqz89MRR/00SoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlSFysvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlSFysvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608E1C19421;
	Fri, 13 Mar 2026 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773416912;
	bh=xCtooFBlYayR6p/jvyKQJ9Wmo2RiUb+PyTS+owxN9Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KlSFysvowjbt+r+Rl0xVh/PRT2zSo04GQjTGfwHSTq6um3RSn1Iv/kZDub/qoJXCd
	 Xp9v0Iwh3rer1GPgv42grDcV43YMJ/zZPRc+G5Hx7qmfJJczvf+rsB9ILLv8oNG4Oc
	 L7ezsxzUMiONbaRQyiZLAhX5lX4pgkoYvRRvJnME86QoUg7WLtOrF5uW8jIRUXQmBX
	 sIFagOmfDVT4X0Z5j0XRVe89ui7AMg7FEpM1F97y8tBKpM/TLVeSdq16nlJNvTgCe9
	 m040lMyU3tfQibFMk5f5Fd5CMeZ0Rgjl1WqPr4hvBSy5ha0KEQo0S85yiXrMqws889
	 u5I0iR8QJiKig==
Date: Fri, 13 Mar 2026 15:48:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Josh Law <hlcj1234567@gmail.com>, Vlastimil Babka <vbabka@suse.com>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>, 
	mm-commits@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add Josh Law as reviewer for library code
Message-ID: <01a6bbcc-1442-48c7-be5b-14f07fe655c9@lucifer.local>
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

+cc David for mention

On Fri, Mar 13, 2026 at 04:33:49PM +0100, Christian Brauner wrote:
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

Thanks! Agree absolutely that we need to be careful about this. Jia Tan should
be instructive.

Josh - there's nothing personal here to be clear, this is a question of
procedure and caution.

More broadly I think we should avoid assigning new people to catch-all
categories anyway unless they are well established enough to be involved with
_everything_ the catch-all covers.

For instance adding people to the mm/* other than perhaps... David ;) would be
crazy.

Also - Andrew - I think for cases where you are the only maintainer but it
impacts others, you should seek acks proportional to the scope the MAINTAINERS
entry spans - in this case that'd be a _lot_ of people - but that only
underlines that we shouldn't be updating such entries anyway.

In fact - can we just do away with catch-all's and just make sure MAINTAINERS
entries are established for everything?

I have ground to stand on for this as I personally did it for mm, although we do
still have a catch-all (not sure if necessary any more?)

In the case of lib/ a quick fix could be to figure out which files are not
covered by other MAINTAINERS entries and adding them all to what is currently
the catch-all?

Cheers, Lorenzo

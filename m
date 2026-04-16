Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5EC37C0FE;
	Thu, 16 Apr 2026 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776327508; cv=none; b=eQh6ZgOdfHDsb7FSZ4JmW8ZJSl05vOUaZQftWhb48V8PheI/LlwRZPjlgYSh0nCZ37XD4fWyaRCN3YHaCpCl2vgz6ZaTUC61pkMxAFSPZDQ1q8bsU/f36LFxOMnABtWpPMwsmyZxswe6+Kr6YU/hN7z2Mwi75qABlIH42efmjYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776327508; c=relaxed/simple;
	bh=vzK7Ux6f7SdteP95AP1eGRKFQyII4TRioIjRMsY61og=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=AwF2HLrzh/JnyXL2wxb6iweQWoGbFj4OMWBa0bEkfrqnSr0yDKnP5qPfMemfDQf1nFZ79487ZK5DxfMoD6cALMqPSoc/8qfZx9kFFaSlQUmAF1PKF8HpB+ZigBIdZRbKgI8EfXgb78Yz4crGwJaQXCd92NX00uoy60miYNiuCwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=izFIxPGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="izFIxPGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30D3C2BCAF;
	Thu, 16 Apr 2026 08:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776327507;
	bh=vzK7Ux6f7SdteP95AP1eGRKFQyII4TRioIjRMsY61og=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=izFIxPGhNLGqsJFGqQ2h8cfN+svaNWqqz/B1V7eX86ZhIG/MOass6mtkKeVFNcrAJ
	 oH4SkP9cNEhTv39Splp2bB4xtbfH1/GDL5u8tsIkoOyfmB/jUFnt5mXAC7wvPbYW9F
	 FDmbR9hYTXNII0TEe7IjF4NZaVGdQn+Vozu9QTV8=
Date: Thu, 16 Apr 2026 01:18:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-Id: <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
In-Reply-To: <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
	<CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Apr 2026 13:20:23 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 13 Apr 2026 at 21:50, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > include/net/netmem.h, vs net tree:
> >         https://lkml.kernel.org/r/aaGiDINfnUexT9Px@sirena.org.uk
> 
> None of your links work for me, all resulting in "403 Forbidden"
> 
> The proper format would seem to be
> 
>     https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/
> 
> (or "lkml" instead of "all" if you want to be more specific).
> 
> Maybe something changed recently, or maybe your scripting for this is
> just broken?
> 

Something changed recently.  Maybe Konstantin knows.

Is https://lore.kernel.org/all/MSGID/ indeed the official recipe?

I've always used https://lkml.kernel.org/r/MSGID.  So at present there
are many thousands of broken links in the kernel tree.



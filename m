Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57B214A8B
	for <mm-commits@vger.kernel.org>; Mon, 22 Jul 2024 03:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721619346; cv=none; b=uAqehmTFr8ocQFZcGtnxzTNv70g5Y9yjFL5Qzbw7I0Z0jamSlJICMyoci3OgXbMS0XtOTcnnLGczp5HVW9YsFziI4nXGwXeTjZy6n0gih3denvDOkVHjT2L5VeSDTyHemwDA3JPpv/bO9lcHS6/huYv6ay779VHmgo5teN+Yjps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721619346; c=relaxed/simple;
	bh=uZXhBG7vPw3qKRLvnXKEMHdIZvmBexPeEcLyIN0VsCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPPQnDezfliPP53wlcFOD7bfiBn4LNWxPE+7J91/ozeznhWgbcfy3RX3+j77JdjycL9A33Mxq6zYKGFPJC0i/p3sznrmPg9C/uhdXIgOIOQOjGFwNeqfX2py2IIb1r9Q+cNc9OuiERAXqeYHr1NIWacvp3AE7EcPs/fXIjgiEWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sczzfqz6; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sczzfqz6"
X-Envelope-To: torvalds@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721619341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Sy+av2USCA7bHCocFVHgZnrLjuRaJ5Cq849zVPzaEQ=;
	b=Sczzfqz6h3UcJNZOdo2zSXXgDbEykWH4OtbHuskGupNpdb/EgvoIMr2D9JwhZYfJVz5TSV
	TZnzVW1txfyoD8+01Ta0uvhlwcBJRQrmiaD1pV8OApwxAv75iJuBLzbrDlJD4GMErjNRqo
	DLFMiiJ/jMGqRLT8eIKDs6IEdo68xCg=
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: mm-commits@vger.kernel.org
Date: Sun, 21 Jul 2024 23:35:38 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: [GIT PULL] non-MM updates for 6.11-rc1
Message-ID: <yebpkzq53mcpzf3366jxksf7w6npa5bpsiqinom74ivzutofke@m7os33wmq3fx>
References: <20240721151013.b9b331ce79f5f60c54c69636@linux-foundation.org>
 <CAHk-=whqXizOqcpcrqvRJ88Twi4+o=G1Y=5qsLBs5R-8uHjs+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whqXizOqcpcrqvRJ88Twi4+o=G1Y=5qsLBs5R-8uHjs+Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jul 21, 2024 at 06:12:37PM GMT, Linus Torvalds wrote:
> On Sun, 21 Jul 2024 at 15:10, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > - In the series "treewide: Refactor heap related implementation",
> >   Kuan-Wei Chiu has significantly reworked the min_heap library code and
> >   has taught bcachefs to use the new more generic implementation.
> 
> Bah. I think the users should probably have been converted in their
> own trees, instead of having this thing that caused a somewhat nasty
> conflict.
> 
> I think I sorted it out correctly, but I'm not seeing why the bcachefs
> conversion was done outside the bcachefs tree.

Ergh, this turned out awkward. I originally planning on sending you that
series, but Andrew picked it up - and splitting the bcachefs patches out
from the rest of the series would made it awkward to keep track of, but
perhaps that was justified here.

I think this must have been missed in -next as well because the clock.c
changes came late (there was a bug that was uncovered by some out of
tree code, and I'm still sitting on that patch but the bug was worth
fixing).

> Kent, mind checking that I didn't do something horribly horribly bad?

Looks good, and nothing's immediately exploding when I test it, kasan
included, so I think we're good.

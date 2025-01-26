Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853B91362;
	Sun, 26 Jan 2025 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737867618; cv=none; b=bzwa/tN9ScoeWmN0vCkKr8sLcjyVnnrL+MCYrjPaXq3hsgfwAc9Tv+G2bimUtBYznXplr6p7kW5CsGTSkaURSbsAUd6BuiOsfORo+h/6m6OiaXvXx3/9inhWxOSQdM5oSx5THsUW0aCXvqdRYPWmqwtMMKUN1kG+izc6qcEKgsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737867618; c=relaxed/simple;
	bh=U2PUaDs5TSr1YUIt9JN3FKcA1FZkXyuoi7tE2ven3i4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Msh8x/8K+x/9uSGIFm5nhYR6Gq7XgZ+3n1Y6H/mI7SN3uaxhADq6HgHo1Quva7pOoFu6VxB4vTETcepm1gP/QX9+iaWVmGc0cO6TwFqg5nCttbTsZfC9aLCQQJbxHhqY7/clezDcPr7fV+we5NeuJ8Cn+7O7pxYjz/zOJAegHy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PG9Fi9nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PG9Fi9nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A360BC4CED3;
	Sun, 26 Jan 2025 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737867617;
	bh=U2PUaDs5TSr1YUIt9JN3FKcA1FZkXyuoi7tE2ven3i4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PG9Fi9nnomvKUYHBZxBPCVigRFGPPv1UK+IHUoIZsAyRUgkfdoti2ObKHhnp1GiWy
	 XKhX9mzIwqevEz0wx8XmV2KgSI4HFniqDgcD6bLPOvm2YoyYokmy3mJtGXipKjy1hr
	 ImE/puTN750GuHyDhozUAegLJAmLOAF9yY17HaXE=
Date: Sat, 25 Jan 2025 21:00:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, Stephen Rothwell
 <sfr@canb.auug.org.au>, Dan Carpenter <dan.carpenter@linaro.org>, Anders
 Roxell <anders.roxell@linaro.org>, Naresh Kamboju
 <naresh.kamboju@linaro.org>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
Message-Id: <20250125210016.815b4260ad539b1e66298d98@linux-foundation.org>
In-Reply-To: <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
	<CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Jan 2025 14:09:16 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 24 Jan 2025 at 16:22, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Linus, please merge the MM updates for the 6.14 development cycle,
> 
> This does not build at all for me.
> 
> I get
> 
>     ./arch/x86/include/asm/current.h:49:9: error: call to undeclared
> function '__typeof_unqual__'; ISO C99 and later do not support
> implicit function declarations [-Wimplicit-function-declaration]
> 
> when running the Rust 'bindgen', and what seems to be going on is that
> my version of *gcc* does support __typeof_unqual__, so I end up with
> 
>     CONFIG_CC_HAS_TYPEOF_UNQUAL=y
> 
> in my kernel config, but I think that 'bindgen' that generates the
> Rust bindings is based on LLVM, and clearly does not understand
> __typeof_unqual__.
> 
> I have bindgen 0.69.5 (plain F40 install), in case somebody wants to test.
> 
> Apparently few people test linux-next with Rust enabled, and the
> reports that I find on lkml were ignored.
>
> I do see reports of this failure on lkml from mid-December, so it's
> not like I'm the first person ever to see this.
> 

Well dang, nobody told me, and I assume Stephen didn't find out.

Guys, if tree owners are carrying bad patches, please do give them a
heads-up!

> Anyway, pulled and then unpulled again.

OK, I've dropped Uroz's series "Enable strict percpu address space
checks", shall resend the pull request soon.

And I shall continue to scratch my head over
Documentation/rust/quick-start.rst.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C251F1507
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744382879; cv=none; b=M0Yjquqal3uBngS/H3dxCfy8h91cHYn1AtGuihwxgSUBrS7IOCnSPyOkcaTcDtDhx+ahNU89vGufPIT96Kt8CBjMVHXDTQz6OLqCjerVacNlxwwUhWyPrzIUJr7d9irdxSZrxEVt1/iwYQoOI4tZfeGJAAHRoggNm88HMig8sd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744382879; c=relaxed/simple;
	bh=ZMDTP6ki1UaVjLe1P7ie8JhARD72w6Gxq4H+CXcqXwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIap2ACD5YHrEJoZHglijR/X5x9pHeR3hsUUCdsrIX273pJgbQq3qduGR+McVSQ8xZIMlcSIuu4RB3pF6zbRPlb7nLM1HUf7X9VZnpwLCgNyXHas38/dZxt967BnxZPlgV3xZrh/mWsB+twCzHa6nkBN4fhnwwkqb36iJxvKiHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlfH7Xn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlfH7Xn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E17C4CEE7;
	Fri, 11 Apr 2025 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744382879;
	bh=ZMDTP6ki1UaVjLe1P7ie8JhARD72w6Gxq4H+CXcqXwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WlfH7Xn+B1wU3siJMMyZ1Km4Z8r3Y3o6G+757NrlHbOP8LOfqZxYpez3wZ43wD/9f
	 XSGjayLqrrxYAAgu61Sk4raJnXnyf70BJxXVvUX4TsYYAfGkqx0xwBRZub0Kjl9hWi
	 BXdg4c0yXZxVkCWK09hdmCGbpFJE8o9OWWO1cU6zZN1NUycqaonYmK3D5Hov6edimD
	 x3yVWWw0+b+aOKzVkEpNXIgNAa8lKfHGHonPXpVPklBKSKTi4aNcPU/3uE0tLPDNMt
	 lqHjBqUVnDwtctQwEuyF+9jWu2guJwnq+qkk73Apxuhe8pWFBBly85SiHm/IMEzVBA
	 JpnJHEQSBBceA==
Date: Fri, 11 Apr 2025 07:47:54 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, ldv@strace.io, charlie@rivosinc.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr
Subject: Re: + syscallh-add-syscall_set_arguments-fix.patch added to mm-new
 branch
Message-ID: <20250411144754.GA4082891@ax162>
References: <20250411014303.CF55AC4CEDD@smtp.kernel.org>
 <20250411024726.GA2717907@ax162>
 <20250410210634.dc781eab270bb994fc4a5de3@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410210634.dc781eab270bb994fc4a5de3@linux-foundation.org>

On Thu, Apr 10, 2025 at 09:06:34PM -0700, Andrew Morton wrote:
> On Thu, 10 Apr 2025 19:47:26 -0700 Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > Hi Andrew,
> > 
> > On Thu, Apr 10, 2025 at 06:43:03PM -0700, Andrew Morton wrote:
> > > 
> > > The patch titled
> > >      Subject: riscv: avoid fortify warning in syscall_get_arguments()
> > > has been added to the -mm mm-new branch.  Its filename is
> > >      syscallh-add-syscall_set_arguments-fix.patch
> > ...
> > > ------------------------------------------------------
> > > From: Nathan Chancellor <nathan@kernel.org>
> > > Subject: riscv: avoid fortify warning in syscall_get_arguments()
> > 
> > I do not think I made myself clear enough in my request when reading it
> > back, so I do apologize for that. I need the diff at the end of [1]
> > applied to syscallh-add-syscall_set_arguments.patch, not [2], which is a
> > standalone patch for the existing syscall_get_arguments() that should go
> > via the RISC-V tree because it is an existing issue (or at least be kept
> > in standalone patch form).
> > 
> > [1]: https://lore.kernel.org/20250408213131.GA2872426@ax162/
> 
> This fixed syscall_set_arguments()_ only.
> 
> > [2]: https://lore.kernel.org/20250409-riscv-avoid-fortify-warning-syscall_get_arguments-v1-1-7853436d4755@kernel.org/
> 
> Whereas https://lkml.kernel.org/r/20250409003803.GA2876360@ax162 fixed
> syscall_get_arguments() also.

Yes, I merely meant for that to be a demonstration of what resolves both
fortify warnings.

> I queued both fixes as separate patches.  And I reverted your mail
> client's conversion of tabs to spaces and I added signoffs and all the
> usual whatever.
> 
> Please check mm-new once I get it pushed out.

The fix for syscall_set_arguments() looks properly done in mm-unstable
but I do not understand why the fix for syscall_get_arguments() is
marked as another fix to be squashed into the patch that adds
syscall_set_arguments()? It is an issue that is present in Linus's tree
currently, not one that appears after Dmitry's patch. Just drop the
patch that fixes syscall_get_arguments(), it is my understanding that
the RISC-V folks will handle it (or if you are adamant about carrying
it, keep it as a standalone patch, not one to be squashed). I just need
syscall_set_arguments() fixed by you because you are carrying the patch
that adds it per the plan at
https://lore.kernel.org/20250409155207.GA1506425@ax162/

Cheers,
Nathan

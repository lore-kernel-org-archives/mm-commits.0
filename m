Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE14EC2
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744344396; cv=none; b=T/kbK4XrqmRxtKgu+vXG1+KHthXuAXAzGfqvWwKH4kDHTabwScSM9201WsJs/ppNmcio7aHRg6OUNI5JfAdCNJ9mo4m4pqlM1G0BoiIWJ7NiFlHooUjWptQTMOHPxingrI0MoNf+vEoKurZ+nRhWh7NPXhgK5UnJu2aqeyJrHGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744344396; c=relaxed/simple;
	bh=715GNo73uuEEV3hjkkOTF5OIxPyfFOMTMk4bH/sEzAs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ciUsHrAE1kt6kQEL39VlglV9rDqCYkVWeDBwdsQrNkzWPx3cmHbiBr3mOdSJWPPXaoYrOZFY8l2RIkE/HtGdBZR4r/C6zuEX0Qjrak7EyBOgKi4cC77CRNgUB2W9bovDNwNFyyHuzjJx0QJWuT1JJZmDXDUKtQKHJtIjc72jo4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pzfGpTNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pzfGpTNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D68C4CEE5;
	Fri, 11 Apr 2025 04:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744344395;
	bh=715GNo73uuEEV3hjkkOTF5OIxPyfFOMTMk4bH/sEzAs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pzfGpTNok5NFiEJzCdcHVG400h9J0GSPdKti9CVnyNm5LvNtmuJH9u7cAm0HbUEh7
	 XoWqtllpml9iTrL0yzPIqdFBsmNudRsUb9KVVMMA+lfN4TJEWrcM0OE71nEYEK6Vt5
	 VdHtBPmyLZwrYKo+1PbW1lvirAwkrE38izdvNvg4=
Date: Thu, 10 Apr 2025 21:06:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: mm-commits@vger.kernel.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, ldv@strace.io, charlie@rivosinc.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr
Subject: Re: + syscallh-add-syscall_set_arguments-fix.patch added to mm-new
 branch
Message-Id: <20250410210634.dc781eab270bb994fc4a5de3@linux-foundation.org>
In-Reply-To: <20250411024726.GA2717907@ax162>
References: <20250411014303.CF55AC4CEDD@smtp.kernel.org>
	<20250411024726.GA2717907@ax162>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Apr 2025 19:47:26 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> Hi Andrew,
> 
> On Thu, Apr 10, 2025 at 06:43:03PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: riscv: avoid fortify warning in syscall_get_arguments()
> > has been added to the -mm mm-new branch.  Its filename is
> >      syscallh-add-syscall_set_arguments-fix.patch
> ...
> > ------------------------------------------------------
> > From: Nathan Chancellor <nathan@kernel.org>
> > Subject: riscv: avoid fortify warning in syscall_get_arguments()
> 
> I do not think I made myself clear enough in my request when reading it
> back, so I do apologize for that. I need the diff at the end of [1]
> applied to syscallh-add-syscall_set_arguments.patch, not [2], which is a
> standalone patch for the existing syscall_get_arguments() that should go
> via the RISC-V tree because it is an existing issue (or at least be kept
> in standalone patch form).
> 
> [1]: https://lore.kernel.org/20250408213131.GA2872426@ax162/

This fixed syscall_set_arguments()_ only.

> [2]: https://lore.kernel.org/20250409-riscv-avoid-fortify-warning-syscall_get_arguments-v1-1-7853436d4755@kernel.org/

Whereas https://lkml.kernel.org/r/20250409003803.GA2876360@ax162 fixed
syscall_get_arguments() also.

I queued both fixes as separate patches.  And I reverted your mail
client's conversion of tabs to spaces and I added signoffs and all the
usual whatever.

Please check mm-new once I get it pushed out.

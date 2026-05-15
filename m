Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E63B37CD41
	for <mm-commits@vger.kernel.org>; Fri, 15 May 2026 21:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778878958; cv=none; b=kkupV+ttKhssAr1lDBzmzNWBUbnOHUVEJjgnWTF6uW5o3mbKBvu0Zhs7XglbDHUXQH8ZffWgoZSnruLQOAYCraiiQFhyGCToueLgbwY3m4nGweYCxXkRx7VF4vHwgWyB0198kN3p4+4Ebc+QQVyYtW3VVxCHlOX+RWKl0Y6SUQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778878958; c=relaxed/simple;
	bh=pvxQzuQgVrOKS0vOi2UI0OhrFrpAIIO6ya6xziQ9SUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSRaC3q055UMS+hNj9x6/P0kpVeIhw23SUY39e1L/1Wb6nM4mack3a93P9B4XYEksyS9gCE7YhYzPe+8A2xHl2lfNCOqWFbLD5fmamnTkTqvRn6PGNSQrLelE9aGZx0A14/icl8XqlSexPY+DLN4Qk/yF58SF4P8ZjEFWqCxbjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oInPyIfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oInPyIfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7960C2BCB0;
	Fri, 15 May 2026 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778878958;
	bh=pvxQzuQgVrOKS0vOi2UI0OhrFrpAIIO6ya6xziQ9SUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oInPyIfjpYOSe8Oa9mgoVpiWSuwkDiEH6JIjjzG61W7qzrN45HOU+uzL3+fimoTHl
	 tEFiONbSAfHGOyl0AlLZBX/kmo0KkcA0j4SEsMbI84r68Xg9W/WtqMS8kiCqy1txTY
	 Bp0XeSBRkVxBhddz7IlOv4pMPNOJdPa+/jQ5Xst6vvZfLkoF3U1kNB5XAQmkb7sa/j
	 QyKf97pXLqq09jjBgf+7d1Rmt0EC06M6Cud6DBPBrrPZRejuAQDFO4F93KT7RSmvM6
	 gF+lYgVmuxlc6hePp/bJGm7GzqCqfajW+hLb351AYTGUI78v3SLx433fcSfhyouN7A
	 B/VtNUb9YMJ4g==
Date: Fri, 15 May 2026 14:02:36 -0700
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, timmurray@google.com, surenb@google.com,
	mhocko@suse.com, hca@linux.ibm.com, david@kernel.org,
	brauner@kernel.org
Subject: Re: +
 mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch added to
 mm-new branch
Message-ID: <ageJ7IOUFPH6MW2D@google.com>
References: <20260512214249.53993C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260512214249.53993C2BCB0@smtp.kernel.org>

On Tue, May 12, 2026 at 02:42:48PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> has been added to the -mm mm-new branch.  Its filename is
>      mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> The mm-new branch of mm.git is not included in linux-next
> 
> If a few days of testing in mm-new is successful, the patch will me moved
> into mm.git's mm-unstable branch, which is included in linux-next
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Minchan Kim <minchan@kernel.org>
> Subject: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> Date: Mon, 11 May 2026 14:42:26 -0700

Andrew, can you drop this patch?

Following our discussion, I’ll rework the process_mrelease issue
by building on Jann's patch instead.

https://lore.kernel.org/linux-mm/ageHmE1QIzK4R3nO@google.com/

Thank you.

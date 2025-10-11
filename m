Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC8A283FD6;
	Sat, 11 Oct 2025 18:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760207884; cv=none; b=B/Vv04r0eqr6TGIiDOe7iFmVIhFrqLCeDVbBXrwErITWQZuLnU5nQ13Q0AiEAKwZV8UhlQ9BjlBVHjflbva9+75KKuDcrTr8cbNN3M7TY/L+HChfNrKlxux/DyQ8+mN9fLkwrjyosCv2FKkOZ3AHb+YjsL+ZMKElcjnuuKIJ+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760207884; c=relaxed/simple;
	bh=nRjeBVE7S7W06TYisUW9cjD4R1lazQGWNP3bOhZYVRM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZmOfefberBgGKUgHOFP0oEkJ/GpH5MTUCoGvulw6oHOLomYIyRo3qaiB0n08p0Fj0A7cKDG4yZoqCOpnoiCHN2m5OCSPNyM+CtWBtjy/5kCjTxudGLLIl4CvN5Wif6E8ygFFS/51BBnqZi2AM6vVNdHZCvFn1JSZxOsBMRtyz/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/KaeOHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/KaeOHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15F4C4CEF4;
	Sat, 11 Oct 2025 18:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760207883;
	bh=nRjeBVE7S7W06TYisUW9cjD4R1lazQGWNP3bOhZYVRM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A/KaeOHSyO8pGw0GJTXAgRTGeOPJ36PqqGzlUw0SrKtjaMETHbMCu+KeFizk+apVO
	 qcr1XNzfr0/3Z9+auob7JuCLB2i0q72UT1bfLn7Hz06qXg/yVuv6WJIBZq7e7eiHsH
	 7k1HW7I+D0as8OU1HQYbeazVqj17VSI+SX8hpTtCHiaALB3ZuZZtTjdOjdoBMslBSV
	 2DE6ahIdy1ZSvE3Y5NQuGC1pckZ2qFDeRO5B78+irSai96FEP09GHn/YLr0pj1O877
	 iriCzslOfyeS72lStUkGHKA+kRGhV6FfU46qLRxOMZWvbUVSnduiSin8wjBNvefSfR
	 tcnOiO9VFL9Ow==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD993809A18;
	Sat, 11 Oct 2025 18:37:51 +0000 (UTC)
Subject: Re: [GIT PULL] additional non-MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251010150844.1ac58a5f9b89aa1e7e260ace@linux-foundation.org>
References: <20251010150844.1ac58a5f9b89aa1e7e260ace@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251010150844.1ac58a5f9b89aa1e7e260ace@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-10-15-03
X-PR-Tracked-Commit-Id: 90eb9ae35727a662789c850efaf225ffe5511fae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ae13bd23102805383bf04f26e0b043f3d02c9b15
Message-Id: <176020787065.1422231.10057956075404154756.pr-tracker-bot@kernel.org>
Date: Sat, 11 Oct 2025 18:37:50 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Oct 2025 15:08:44 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-10-15-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ae13bd23102805383bf04f26e0b043f3d02c9b15

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

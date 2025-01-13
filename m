Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CA1190692;
	Mon, 13 Jan 2025 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736788955; cv=none; b=Rrubc0M6SCeTDVcmKx1WbMsOrrMQ+kpx87I0skGd8CZ0Ca8Zmm3HvCSmSr2KSYQ0ZmqvCALTxugyX6ZYpvZGjnZuqdr1iZI0bs2bcfp01ucno60dk/p5On374xPdra/As5xkj7RWNvDiriDhIeMaLscsSP6UxwDXclfPSGlaqzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736788955; c=relaxed/simple;
	bh=Dcq2FoWsjuri+Uc8tkiEkDlHTLk8U48gyhu5ZwM7G6s=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WsrMaR/8TRVd/H1xddSbhXufgwerLmjl41QNp28BFm5kibHgFU/Tlhw+AWc/+h7/4/B55Xk5nyfhgCi5Rjxs+CM8HGqbxkDAqt80Jiq3GtIwAAsf4xBRoheD5U4GzUaZhHGi0A+4OR5vMvVyeaVZq9AMuBm24g+ym/NUzrGjTco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WudAW04D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WudAW04D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EDBC4CED6;
	Mon, 13 Jan 2025 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736788955;
	bh=Dcq2FoWsjuri+Uc8tkiEkDlHTLk8U48gyhu5ZwM7G6s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WudAW04DcOyj008UTv+b2EWe/txhvd8wXW3IoieqGFwoIDdXzxkv+PHbAI0+ZoZMR
	 DIydOiYcsyQ2CqvtOw/3X3VjoYp2GwsNLCFsURK73cexdHnh+rICoVDOFW6RS3RaRW
	 72r9QTjjtbGSorryLxskNuF2JCUm0IkhE3qA/a+wLP0SsO6gMH4qxU233u3M8HFDvF
	 vO9yu03XAP2EkYtbn0FENECZ50AeVcTKbF0pGAb9sSPAIbe4d3Ip6KKftSWTzasK0s
	 Z1XVEYYTLarMFDoIQ1Qayx8t6AluKrGJntWINgw/pUHlK8SGwmbhWkXMrvOBqljZBr
	 Yw6Lr41ZiEawg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3454E380AA5F;
	Mon, 13 Jan 2025 17:22:59 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.13-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250113000543.862792e948c2646032a477e0@linux-foundation.org>
References: <20250113000543.862792e948c2646032a477e0@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250113000543.862792e948c2646032a477e0@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-13-00-03
X-PR-Tracked-Commit-Id: cbc5dde0a461240046e8a41c43d7c3b76d5db952
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c45323b7560ec87c37c729b703c86ee65f136d75
Message-Id: <173678897767.3571245.17075187021668820479.pr-tracker-bot@kernel.org>
Date: Mon, 13 Jan 2025 17:22:57 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 13 Jan 2025 00:05:43 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-13-00-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c45323b7560ec87c37c729b703c86ee65f136d75

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

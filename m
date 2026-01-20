Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A4941B34D;
	Tue, 20 Jan 2026 23:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768951411; cv=none; b=NIrZyCpImlfFLEKqy6iOlUjHb+fx2IFzNxbFArz5wRuZB9qI50bwr5pHiX3R1mw3MjxvSHGmbuPNqddKiDJ7KR4vjF8fvlCOOW8Rqz0FJnNmcJsK4qvWorpmL8nruHMFBEiAy1izwwO5HOFx4ZI7vJMzn8dxMwlK+y9SIuXaU/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768951411; c=relaxed/simple;
	bh=K82kHZD1KaEicFMbRUFOLT/B+Jfrfiem190d9DbwiGE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DWQz0pVd06qEsrNBcSXizIMZMLrxeM3eJrRa5D5pgIx1l8lZrYM/bN0ebylE3kZzCA9iY/IIjDhKycoNPnJDazKfAwzjJNH3A72ng/4+vk6srnPhEkneRs/Vppf4bMHPdxNlrI60De26UG5wJmhSUGryB3TKoR/aEcTkSBVReMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnjvvg4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnjvvg4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560ECC16AAE;
	Tue, 20 Jan 2026 23:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768951411;
	bh=K82kHZD1KaEicFMbRUFOLT/B+Jfrfiem190d9DbwiGE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hnjvvg4xpaH/4NscL42Oovch9uGb2f9afrwoXT03+uPmCWGyIkp98McVV+hZXM4Xg
	 3nlatJK7s8op1n2hN6H4zfxaNdpgyN4Yyyztt1AhWxBWMOnb1Xr/FLdXKyUzZO1YLz
	 xzuaDU7h0LiM/a1kXSekVdRF8QCCN5G7UtnMSPWwWn8iglim4tD31EDdHhHcBP0DZP
	 7sN1f9VyXw8a8kLpYDjT7MkUUnveVN7/ot6s99si00Ad2DH8ag6/wf+wSfc2ZAq8kl
	 NJNi0o2LaCdaf2cmW6BgUv/UAhgNx36VgjuNoD0NBJg0fo/9kj5Uddjzk7qdp/GzgR
	 QCD5A34WNTv/Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 11E6B380820D;
	Tue, 20 Jan 2026 23:23:30 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
References: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-20-13-09
X-PR-Tracked-Commit-Id: 16aca2c98a6fdf071e5a1a765a295995d7c7e346
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c25f2fb1f469deaed2df8db524d91f3321a0f816
Message-Id: <176895140853.649372.8779652225988361344.pr-tracker-bot@kernel.org>
Date: Tue, 20 Jan 2026 23:23:28 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 20 Jan 2026 13:11:26 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-20-13-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c25f2fb1f469deaed2df8db524d91f3321a0f816

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

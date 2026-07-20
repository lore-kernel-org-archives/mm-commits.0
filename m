Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECAF3B42CB;
	Mon, 20 Jul 2026 20:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578066; cv=none; b=V+4AG9OHYAqyzMRnEkftmEdnzwe0tJQcueQByQ9LZb5UX4Vb/JfD0CfA6On6KnEeVGMUUeMh58GOJroUDdYihEX2ZHS3zyzT7IGPx4rBStirnYRxnU7iV7QiQwtlXwl5Ml5kCHhpMrRcFNm8pLXrGgSnEOuqDpuuK6wf2TiBcYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578066; c=relaxed/simple;
	bh=Ak0yCSOGO7iwtf4w+qffo34CJOEwN0Dvj2ry+Dr5ITg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VJ+nZ7xPpTaRNDwVzMzTW/EpKXgua9Ve1Ir0Ese0S7eQISZblRbyJH+6fYDygOEZDKIFRy5/aultvzUOVmN3Sq+d2SWuCLTiDPg0EwXnuVrjQrrX3uEMiqUyY3Bd4V4HAB2R9vHp1W65Mg2EnsYiCWehrKdQ/N77TrLFzwvo92E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYUrosTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYUrosTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3A91F00A3A;
	Mon, 20 Jul 2026 20:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784578065;
	bh=FSDZOKDITuvHVEfYM0znzNCRh/yzDimb8GlW407ykSE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=LYUrosThPhvAlQWDHttVXf0ZgyjsQkE7NRNfHf0Fkty4T+rdxi1R4C1LvgIQvmTNb
	 mXtTCAsB9w6KNNZ9rS1q2cCm3+9zxE2wd6zc9mJxsL/jCnMMlR89uBeWNpZbck6wW7
	 mSHegldDqFxF6qbO9VQpOfo7RMTeHiHBHyNlLw3Hpr5B0Ac2Jd1e0xtsSsK1lUw1Gt
	 jOPMuOKhWq7oMrKKZOzz3tRxWoBBHZYS24mvBOijfnsGV1pj2NDmhA2DTfu1npd5BF
	 k0HA1vF8THJlFTrMifi4QCGvr2xg7F+SY+6t+eaklWlkiiRap3tW7Fhz6FFLBuqoDo
	 jwP6DwyZBo1yQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56BAE39244CA;
	Mon, 20 Jul 2026 20:07:16 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
References: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-20-11-37
X-PR-Tracked-Commit-Id: e57d6e9e20b551e4910d7a6331a81775c3ad6693
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b95f03f04d475aa6719d15a636ddf32222d55657
Message-Id: <178457803502.4145645.13085712170717969937.pr-tracker-bot@kernel.org>
Date: Mon, 20 Jul 2026 20:07:15 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 20 Jul 2026 11:39:47 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-20-11-37

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b95f03f04d475aa6719d15a636ddf32222d55657

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

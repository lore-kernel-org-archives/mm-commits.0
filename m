Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C341CAD23;
	Thu, 27 Jun 2024 01:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450270; cv=none; b=fV5XOA2fx3Ef9XH8gpCTPPto8Oi1vUJYrUS5j1bjCINMoT4MrjFAQ0OL/WWEfeIOCcHQBXXbksnn4E/LSEwtJDde9wvuqIf4m9pu8xYYBesykin6RgQHCcYL0byo7VLPw1iGk9jHicjNhxbAyOmtEuUfdGUsi077ElQtylFAImg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450270; c=relaxed/simple;
	bh=Mr33KWENc+kss1Bvi146WYV4VM2mHPO1fymo8GoonxQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=luHJx0Q9OI/RquvoMM0rLvfVEUENoVOy64J5tGE1tag3fnVuTC3jFMaSWIBvpx65w6KiDcNdByyAybwAnoODLSzaryfq2QF3w8zGxwrFoiZNa+d5MuCGugdB0zg6bQOhxIKqZ5VLySDkmbDZJ3RgQ+HcQ/5XcnDPsED51so44n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAeSSSJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAeSSSJY"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BB7AC116B1;
	Thu, 27 Jun 2024 01:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719450270;
	bh=Mr33KWENc+kss1Bvi146WYV4VM2mHPO1fymo8GoonxQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eAeSSSJYruejce9MvOgPaYb+9OpH+LXtBUxsncOQKCDUew2D8WlGJJq53+yO8tCFr
	 Vfm2e1HAGud1MhJgXhPa5I8n0xXL1Hhy86LOE28Hc7A6r15PC2Y0qK0aFtuOc9Bw8G
	 XzH4mNJl/4KZVom0PPm37D7uLcSiY3Wdm7RBjCkfMz0AuANvu0uiU9+Zvj/gRflhIO
	 k1ZoF89PSc/Gf8K2GMTiycZvC38BThzpztuB1zzvuYgcmjNWtq6C5upYT0EsCib7o0
	 DPe+NIJGB7CZYVPI7UTpxkWseR01jpotFVEoQxrFgZXSTPg4S8HlgKoJT533B+qL+/
	 hK0m8W1lmXJuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 649E9C43446;
	Thu, 27 Jun 2024 01:04:30 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.10-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240626173017.d4d69c597466bdd42da64da3@linux-foundation.org>
References: <20240626173017.d4d69c597466bdd42da64da3@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240626173017.d4d69c597466bdd42da64da3@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-26-17-28
X-PR-Tracked-Commit-Id: ab1ffc86cb5bec1c92387b9811d9036512f8f4eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: afcd48134c58d6af45fb3fdb648f1260b20f2326
Message-Id: <171945027039.13769.17437527375707006728.pr-tracker-bot@kernel.org>
Date: Thu, 27 Jun 2024 01:04:30 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 26 Jun 2024 17:30:17 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-26-17-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/afcd48134c58d6af45fb3fdb648f1260b20f2326

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

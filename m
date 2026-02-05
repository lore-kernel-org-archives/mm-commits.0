Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5264F30275F;
	Thu,  5 Feb 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313654; cv=none; b=D3SAGwv90LZkdb1nA5nTjanEd29CYnx0e/hbto8YOwteNiTis2Gcry93auLms0JpHZgARgSpJpKR40rJgvXo99ka4nvkAB7WA0ao7idj1QJK/j6wscWiiRu2uiVYUJtpup8CgxHRyC5uxp2liJMEB7DeoKyBG4zvs5MMp+n13L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313654; c=relaxed/simple;
	bh=5r1cNZ711fosLU2hxpv3v6DnKR9J2b5R52KaPdq0rVo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NhcfLH7kg1HJikUtIbbrgjWHpHH9AZSU4KJwNcq2A7xX0FUAn1HCX4FmDfHM9KSq1CA6PvgwrkRCtC8LUKdjpfBS9agwt8qC8VKI8Mh1ZwcfDQ2RgET+fafn5fpdiuminK+z5jJHGH/fPqpzaLve268+jH9SQ39UoehaeyB20uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4fUHG5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4fUHG5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A84C4CEF7;
	Thu,  5 Feb 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770313653;
	bh=5r1cNZ711fosLU2hxpv3v6DnKR9J2b5R52KaPdq0rVo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=q4fUHG5znFTlwjO0exqdqWYPybtLtceqqwji/A3KMZxuiEKE2hbX60kTvHm60cIPz
	 mQZelkJeXnuFkGjO7y1C1Uye7UJmXCpm1ZAo2qGMXWMT5+pT2XWUCNNM7Klnh5yf2e
	 8dKMmS3997S2a2MIyf8NRe/WKjXM2QPUehzY1Xl4njLzgiXSF6rPHp6FfC0MdjbJxf
	 qxqK9rP/i3mh23zLt2cO4KaXOtJxprLkrE7TWdVb30issxYhE8Kg2KWPy43ywAIj53
	 YFZ2lMfLTdQvsh5Zfa2upgfaPKokscRVLzI3LhDhU3YOSw7zrXDsXyQF6usE00DUAc
	 E3vjo2h4gq+qA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C26233808200;
	Thu,  5 Feb 2026 17:47:32 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
References: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-04-15-55
X-PR-Tracked-Commit-Id: 1a47837bfafed7e9ef93f5dfdea6d70869b0c3ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b20624608f350c5dadd74577629e90715d351e2c
Message-Id: <177031365139.509822.8597681757742011770.pr-tracker-bot@kernel.org>
Date: Thu, 05 Feb 2026 17:47:31 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 4 Feb 2026 15:58:38 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-04-15-55

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b20624608f350c5dadd74577629e90715d351e2c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

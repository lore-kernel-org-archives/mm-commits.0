Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303F92E7BAD;
	Tue, 11 Nov 2025 19:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762888262; cv=none; b=ESwojQhdDTzxczIZzYOves6DqAcKc7z4SaBoEr3VpzCg75F1oPTw5aTQV8/5Z/rpDzBesvvjAPSWiiBNDneypJy6QoAcMO3s3CFrDEPIH/DZSiVYnF/VJRpYN7WwoNilClvOa/duW6VqHY5LoLqoqHxQzrBrTC0uhn5BB1wCRKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762888262; c=relaxed/simple;
	bh=gAe4sPr7e7v3nBPzgMetHpFdrlCpKdnQw8fJdSJDi6M=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qVuP4BDoT2DQDXzM6ZyndCUGqlrt6jnwb1dIDfyyN+Msrp7o0LHR1HpLi33Y+MYSpZvH2FzmOC3NvURwhUCXDRvBMq0o5YpXfYYtbJhLS9YIUuzTYpDRGJgVgGZxbbVm0T5T9cXLYN7Nbq+yO/wLpQwGQ9T3+iwD83YCX+4aC8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cme46EXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cme46EXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92BC113D0;
	Tue, 11 Nov 2025 19:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762888261;
	bh=gAe4sPr7e7v3nBPzgMetHpFdrlCpKdnQw8fJdSJDi6M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Cme46EXdpW99bLE8zU9hrxWaBet1uQ0s6yfJ2bYpjT8O4qmNcEgo5p4aPjhj7XafW
	 wV/KivrEJk5Mr2FnEyKS+M8vBVgwfpNIkOzIQ8hY6KDDUwiDnfbhST9Uk5Y5S8A2fc
	 vwROQbG26dRpoZuFfTnykZAyA5ZDeKAOHhEUPdVF/Y7mPrSsTzkd/BQ6+MngDQBIWY
	 WItR99TfsQIY0DkoDu6mXz79kNd5vg2Yl3A++jCGwfq8pleF7nIb5gZppxhk/60UB/
	 sC+5SqFo9/HOK11I7Nd/Dx/LaHHlOCMh1Kh+poON528+9ojQL5yfvRX3LJi5EdUnZ+
	 WQTiRklc9+bNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3405F380CFEF;
	Tue, 11 Nov 2025 19:10:33 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.18-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
References: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-10-19-30
X-PR-Tracked-Commit-Id: b05addf6f0596edb1f82ab4059438c7ef2d2686d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 537d196186e0a0ce28e494ca1881885accc35a12
Message-Id: <176288823187.3549715.10391095070329025115.pr-tracker-bot@kernel.org>
Date: Tue, 11 Nov 2025 19:10:31 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 10 Nov 2025 19:32:47 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-10-19-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/537d196186e0a0ce28e494ca1881885accc35a12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

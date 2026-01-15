Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8C25F798;
	Thu, 15 Jan 2026 20:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768508000; cv=none; b=Gy7khv/G9E/fPvdIokgs9Xs7Uez8iHchY93Jl4OUDj2UzHH9nPc/gON3N0bIgeBzyXK0CrsGxjxDt/K8rVbgOXU9MSuiqVBcx0NGM3774xSHUJo2C3ptrziwLH5mqf1+YLVQjW3vIVrRSqWYilTXcOJsadtEmXw/WYkooHAZo68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768508000; c=relaxed/simple;
	bh=DyEw4wdK9i63jquzZL/QXi85unjtuB7rL3sRfLLuuhI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=doqgDPYuZAorZGO2lD1UvWTUXUKLRAPHGz3yYCVKpyhtogBwinF59JvgyqZnkdy9TCAvDuvp5J9TA9fAjHLPM5IVb6rguaGld6Kh47YPSaKXpKNxcFjDCfLYdODwnkgHVU7q80za8W0MVo8Iz1/NMnw1aVJ6CE1ReWEszRLyiRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3N/HOct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3N/HOct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21474C116D0;
	Thu, 15 Jan 2026 20:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768508000;
	bh=DyEw4wdK9i63jquzZL/QXi85unjtuB7rL3sRfLLuuhI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=m3N/HOctEwVHBtIRawEdgcshJHCWMqwlMAMj8EkHjnJXFivVoJsfDe5HYPYObE0t+
	 mYgO9TtzGevBv+ELLMs9N7fFzAvMRwjRkN0mWVT6FuVz4px5NO/uZ/LHPfwXnBiK2i
	 zgLJr4WJG0SFrHeeH3nusUr7uU1ZHi6wyRnLHPLh6aqRg8ze8d8oCKstPlOujqwIVC
	 EOIG1WzF4TfBqkKSyqbkuuMU7v/cVs0mveS2ePko6Ydj94oEKUaD+WzUeCUw3OY62i
	 p7lT6oaSKUOo8kWgcY0VtXs23cMVk9ypY17dNwtV9jtHHNbm1H62rJM8hBugJoGnfJ
	 BKNCxI40F/CXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78E19380A97F;
	Thu, 15 Jan 2026 20:09:53 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
References: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-15-08-03
X-PR-Tracked-Commit-Id: 3e8e590fd65d0572584ab7bba89a35e6d19931f1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13b2d15d991b3f0f4ebfffbed081dbff27ac1c9d
Message-Id: <176850779212.4151234.10322330701377620588.pr-tracker-bot@kernel.org>
Date: Thu, 15 Jan 2026 20:09:52 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 15 Jan 2026 08:06:45 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-15-08-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13b2d15d991b3f0f4ebfffbed081dbff27ac1c9d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

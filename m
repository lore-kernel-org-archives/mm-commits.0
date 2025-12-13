Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219A2279DC3;
	Sat, 13 Dec 2025 09:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765617071; cv=none; b=Vvqd5S5+9sxxD5WhI1t2xJQBH36/sMr44n+m0mtUDQcPRRIXrqhlDbUlJXThv4GP42RfQPGbQkUi2AuGG0CQW3xpj677j1drtKTLu7MyMD/uzPNlknyd6pURnIkyRk/vn4Tdz0mRbhHAKGo7qyNuj0929E7C1caJvqoWiMFR8d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765617071; c=relaxed/simple;
	bh=8kaMKdggW6PmADocHhcaePSRDkforroNc8Y7TLMr7NA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=g8AAw4kHPR9FmU8fQ7gQJlhOQrOUO/Tl8M0WnQtKG0Xmx/6wz4ZWnHyacdRt6shzcPQik2q1xxB4WuYCfCzZQVWcie7HMWm7zQnPqIqkP2acJoFPLLWYdm3wvv0Ys0GCwn48HO8QYX58hQxJ4roJT0jFNAYtHnQNNlGVXruRU9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaJ7NElI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaJ7NElI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F54C4CEF7;
	Sat, 13 Dec 2025 09:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765617071;
	bh=8kaMKdggW6PmADocHhcaePSRDkforroNc8Y7TLMr7NA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KaJ7NElIEjU9e14jICHyEsZK/BjSEGR+RMwpjFBagEH9ExqCYVKckcu7WkETVi++a
	 7JHE3uok5iIrFahxgD0QEn9He95KpT5YC6xPbADgTP7+qasIYbcyh5vcBqfxtMKO4d
	 avObKF3d2oWLKu+ZTa8sZXKciImOUrwGE7+FuFvgkusZFGBJ0ec7ImLW0m6ITlGU6Q
	 IgYLNCmQjqMujQOYeMqljM6DDzkVDyRSUT5bp3mnvj+s+EWULXqu+/T9qm1ZoScpAi
	 dpnoux4uPuR/sTxX7rpvPdW0aFMMbt1KNBHbQ46lsPrtsQt+OOLAseETxjJ9b2zmqD
	 V3mrI82cL36Bw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2A25380A956;
	Sat, 13 Dec 2025 09:08:04 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
References: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-11-11-39
X-PR-Tracked-Commit-Id: dafdba0964bd10913fbaa5537201cbbe05df5b9c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2516a87153183e1797021879121ca25c95f1ea3a
Message-Id: <176561688356.2460530.11124774899123193311.pr-tracker-bot@kernel.org>
Date: Sat, 13 Dec 2025 09:08:03 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 Dec 2025 13:11:27 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-11-11-39

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2516a87153183e1797021879121ca25c95f1ea3a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

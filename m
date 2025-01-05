Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0CE1CEAD3;
	Sun,  5 Jan 2025 20:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736107424; cv=none; b=YAIyFSHsHPbAl0rdlml09+bnShjKFGXslUBkGRP8+mJddVZ2pR0z+lQrepy3atRFgz8/Whls9c5RvtsK4my9nxO5mIPTGqWciv5z8vet7Q7FsmdP0rycL5WZ3gO+NUyuthyZEJ11odSHLLV5nXm6kWRmzN5h5hGlaROA8k+ZOo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736107424; c=relaxed/simple;
	bh=DvjUrdAoZuQFYVLLBnHlMKPtw6QTpYTAT5xvgQqfIDo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GynLaK/HbRTgbMejPhjtMO/26hp7yV42hUWo86CqMcDmimXJZdPYuOGkb9alAtBMEtbmoff7ey8eG6WQOqztpf6KHVrmP3Tjtlw5xOL7Mf24EOd+mudF+5c5aqs7Mw5IB7xUZA6c/727QCO2OsxWuj2syp3U0Ah4tW77bRNDej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lo2YQrYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lo2YQrYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B0CC4CED2;
	Sun,  5 Jan 2025 20:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736107423;
	bh=DvjUrdAoZuQFYVLLBnHlMKPtw6QTpYTAT5xvgQqfIDo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lo2YQrYd/Y8sbB7I7Wtm5EGeaVl6AnB8maXoKo9gMnBUC22btDn0JuR4kMamU+l7B
	 mbTA32naeUN23sLy48kJ+Ci9dgobH/ZZpjYkqN0LwFECN0njQ3YVnPg3c2sTjLKMVE
	 6udReSoytNWjdDgUKiZY7/Du7REnrDD1Gi+871ZKjHOazTv8zFAC86Wvi8AafLZNXN
	 piFXUwsU5RKyWrGXWQAZKNgxeGgDB8lLy/uhdzuau7csDHLycBtcDBDxHdxikFt4Ir
	 HFTfuagpYl54gIum4Tjxv+dQxIimo4Cw32FYsboJDoyiCLGBYYVLsBms29lS+9XY6s
	 F9VCpjHX41umA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB043380A976;
	Sun,  5 Jan 2025 20:04:05 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.13-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250104180511.ec607c34f312c8cc759cffc2@linux-foundation.org>
References: <20250104180511.ec607c34f312c8cc759cffc2@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250104180511.ec607c34f312c8cc759cffc2@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-04-18-02
X-PR-Tracked-Commit-Id: e7404921818d676da4d7143ce78659456b05e2af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5635d8bad221701188017a6087fbe25ab245c226
Message-Id: <173610744463.2663043.17944530150142155521.pr-tracker-bot@kernel.org>
Date: Sun, 05 Jan 2025 20:04:04 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 4 Jan 2025 18:05:11 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-04-18-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5635d8bad221701188017a6087fbe25ab245c226

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B9C2A1BA;
	Sun, 20 Apr 2025 05:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745126008; cv=none; b=C48vOnBynAmztWrfZDHCdR68wYzCuTrvBWUZdhK/zQigGewIFoqO07COzMxlSwtM4PqC7TMKVVRAN/YEFSvRdRNTvkvBjIbl/qsSTXBCDfUMid+gYSlqWJq3aaD8CMrLvUlAkbizuBCJzm44UFT/r4Ai0dzDt5lW8qbrxp7WZIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745126008; c=relaxed/simple;
	bh=4Foqdtv3u4RUFtFk5+yVVKgrwKl+Tx/aQGzR/Jk5Txg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DKydjc2LOjwxYIkaHBrN4PFccOV2GXZt6lo+FTfevLc6I6Te5dbzmPUiWimiBmE5PhPbd2mta5ATVJ3R0DCS9uZZGO8tsemBvBRGer//OzZ/EM2y+m7MNXfeXJPr5p29gYYHuly4j0mdYadSYQnqAM8BEZyXkhHJccVFDZgn4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qh/05cuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qh/05cuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B3DC4CEE2;
	Sun, 20 Apr 2025 05:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745126008;
	bh=4Foqdtv3u4RUFtFk5+yVVKgrwKl+Tx/aQGzR/Jk5Txg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Qh/05cuYu6V+OVewGNP+dmX9dHvLUlNr6BFZshQQZrrTcZt02S4La0k2ZElMts9sg
	 kuH/5rjiMc8NwViVTBv7IWWi8f8sr4bDiO3vyIDCxSVO95vZfn0XkmhYvsjRWOBsZ6
	 jy5EImFdBeGyace1a2lgR0PcOwsd45bIgpr2AGEGwje9CSNzRa4NXzQCCE9nxoyD+g
	 GXbymlw7iRDno/U2L6yUKU1xmwsjJzaXo7lRhcjCImj6gObetbtvSXXhmvRqUuNDAR
	 y7g7uWYn8CxCPLHn8qabndzGWqdPWNqXGIBFKKiQNxvH/er2z42NprEHqp6zy9Wq+u
	 dKC+D3phSyJWQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE2C038111D4;
	Sun, 20 Apr 2025 05:14:07 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.15-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250419212632.41bd67c6fa1459f817f0ea58@linux-foundation.org>
References: <20250419212632.41bd67c6fa1459f817f0ea58@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250419212632.41bd67c6fa1459f817f0ea58@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-19-21-24
X-PR-Tracked-Commit-Id: ea21641b6a79f9cdd64f8339983c71c89949dcb5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6fea5fabd3323cd27b2ab5143263f37ff29550cb
Message-Id: <174512604639.596822.11152284297731344427.pr-tracker-bot@kernel.org>
Date: Sun, 20 Apr 2025 05:14:06 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 19 Apr 2025 21:26:32 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-19-21-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6fea5fabd3323cd27b2ab5143263f37ff29550cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

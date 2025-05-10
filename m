Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B557E9;
	Sat, 10 May 2025 23:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746918313; cv=none; b=pSl3ljCLY59/6gy+um1AHwdF758ZXWJgjoXkLxg5jxP+UPPyjaqEvdF7kOT0i3Z7ATRCpUEIgd5/xq/eT9FMlaK8Whvuka8J5/HLGzPinDnKPXSiZ5UGini2GmzMGv3eB/APHlS5S32JVVEI2730hy3baQs9FvWLi3NQPuV1ahc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746918313; c=relaxed/simple;
	bh=ipywfN1D+tnC+T+izKhptB9WFmnt81Dg3yO1nqvzexo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bi6IdXqWuqrzJGBXL/n63MSlC1RB1egHxi2OnTV5dz9MuD3GWA//dg/XcHeSfw7fXLaqcAxZjSXnATSqWrubAraEmnEGWBMLznJIqV7sFdBniTJIcJGWPHwY3oPGFZeG2turKC90iigs1HFWx0tOzrPdL1MuUS+1UvNoJIgYydw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PozxbQgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PozxbQgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85745C4CEE2;
	Sat, 10 May 2025 23:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746918313;
	bh=ipywfN1D+tnC+T+izKhptB9WFmnt81Dg3yO1nqvzexo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PozxbQguAxn2L9GMAB3PK5o8gyRuBzcRNSkt2HavTTvkEJaN1C8VoeGEsmx1cZN7Q
	 J06bE6/66EYOu9fbxA1u4I5rIH4rIjTGsLpZlyhiW2vPl1kUtrs22Wjp68iO8gzF0M
	 3xma7XWGQOABAbvnYJZzZ/67SSZA78W2Oh0stH2InM4Bh4U/ESMEgPe+y+HMhf23Gn
	 gFe2jDA+mpVy2g4LebLyHGWMpVPCYdlUOqYN5Fh3oeFecIWBzvR/eq15mbfgc3eRCA
	 cCYPZ9y8TeHF1mL8dUJYMYf+H3YWFT8/JbcHexfV1xTI2B8iHGkitHr4mWSmT1hAFp
	 0Q0xzFf26vGiQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0153822D42;
	Sat, 10 May 2025 23:05:52 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.15-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250510142536.5e56d771875c6357574a3b89@linux-foundation.org>
References: <20250510142536.5e56d771875c6357574a3b89@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250510142536.5e56d771875c6357574a3b89@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-10-14-23
X-PR-Tracked-Commit-Id: 7b08b74f3d99f6b801250683c751d391128799ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ce9925823c7d6bb0e6eb951bf2db0e9e182582d
Message-Id: <174691835157.4052259.4385853872053674405.pr-tracker-bot@kernel.org>
Date: Sat, 10 May 2025 23:05:51 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 10 May 2025 14:25:36 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-10-14-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ce9925823c7d6bb0e6eb951bf2db0e9e182582d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

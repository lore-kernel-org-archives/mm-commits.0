Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C87047A60;
	Sun, 19 May 2024 21:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716153465; cv=none; b=C45nE2FaBesX/i/vBpklnhxW8pWQwlF0R2v4QxwMJ8vj4OyO3yV6pHnDk0kP9Jo+DHyHW+eskoqPJast4mMMsLGu4swH41uE9pddveRED8jLmoJK7Gr4CUSrVtrIfAQ7tOao3g/jXT46d4lGbVWgitegWGa8LJKmtNzb1ZfEvJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716153465; c=relaxed/simple;
	bh=punUDCVGVPYQF/kLRTsggXRte6yt4V1jpUPMKClsRvY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZLKz/j6K78OmcE8T4sfE586ChrqO8pZ4oR2iE1ZUJPADjSDc/BR3UpTE30PgjWZeIVyUojriId4lqiAsba4SGEG8lllIHlwK654lUVQmcKrfR24QWveS51YGpWGiuPmwew5QgleHnYZhORREbPcymp01AKgcraprq3oViv8YtaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PHeCoV4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHeCoV4u"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C936C32781;
	Sun, 19 May 2024 21:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716153465;
	bh=punUDCVGVPYQF/kLRTsggXRte6yt4V1jpUPMKClsRvY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PHeCoV4uWgaPKKFnUbdcisc+/YBi1nsVBkywDYpu4osTeWknRlNwkExTaqacHhvqt
	 DK1p5yjMegZwhCyuYjOfFDrVLjA1n7S31SwYHRZ5lWHdEFDQgIUc+cADdqwm+LUaqX
	 dOkuF91ZovzH3lm4EM5L4qoRsTHkfYzC8xuk9dC+pk33098/9KMRDimKYX9QGMLKBx
	 WzQQbLZiwGDPzR/MdNMPxkFvmKsqOnPOgUiQB1qeQZYMxgdHaaI63+XgTpZB4KCPc/
	 GmsrECP7EjAQNC/MBKlVX4muJWTkVNgkZDy1JKV4zSPnl7eM6HMbqEr7MSbrMPmbJr
	 iP4Rp6XcoEopA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 328E5C41620;
	Sun, 19 May 2024 21:17:45 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240519115735.acabb2269a1a91ee0ebdbca5@linux-foundation.org>
References: <20240519115735.acabb2269a1a91ee0ebdbca5@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20240519115735.acabb2269a1a91ee0ebdbca5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-05-19-11-56
X-PR-Tracked-Commit-Id: 5cbcb62dddf5346077feb82b7b0c9254222d3445
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eb6a9339efeb6f3d2b5c86fdf2382cdc293eca2c
Message-Id: <171615346519.27435.1588076438743306098.pr-tracker-bot@kernel.org>
Date: Sun, 19 May 2024 21:17:45 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 19 May 2024 11:57:35 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-05-19-11-56

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eb6a9339efeb6f3d2b5c86fdf2382cdc293eca2c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

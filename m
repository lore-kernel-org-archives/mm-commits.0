Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C907D1E4AB;
	Sun, 16 Nov 2025 21:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763330218; cv=none; b=JdSw4WhLkj+wD4ilFmmF0dHq9OwebEYUOgdta2J8EMU7+bb7ASN7IOrSqVR6Oku4nDQ4ssJ6drqAnn5+Gf/RkaebVNrCrlJ9PjfgqJnuu2YgCeaOvuJASIwMOKPGqaj1z1cIMxlCN1KRJFKSJCL+KYcIDOtdvli7sU5zw/NaNN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763330218; c=relaxed/simple;
	bh=PDkkOpiMJjesVYweoYCtun20J+ToVKvJguekRA83Gvs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cXPxanvR8cPNtLEEvb34Hh+yyrScm+ggJFHAQwtsGkeL3Oxd71qEL0+xWvM2dXaDOBOKchLM+Zn1JMvVvfXhj5lrhbXlbUsak/6IG4dHIE7HnqPfV/DEnGIGX0D6nqOEqBtDepGRQrGnzXbNVhJStfQRz4eIe0/JQCb7ufuLYiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imgMWj9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imgMWj9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB99C113D0;
	Sun, 16 Nov 2025 21:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763330218;
	bh=PDkkOpiMJjesVYweoYCtun20J+ToVKvJguekRA83Gvs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=imgMWj9jXwpT2fJ0dQygRWxglESWZLeezswF+2hohCPEoLXLakrM5eQEfsvDp0RZ4
	 ldBdLjFULi0ioNeePqjj3t5reie4soJ3QC83WOYZXJM10EG7wq5iW2m5Nh0k3TxnDk
	 UtMtkLxPt3PEscez1MqPBwQXpCbtwxSjmKXZ3uuSPS0Q11atglqqq3r3gWwivjpGwg
	 7zXE5SLCLOrQAYXYYV+niHaYLDoj5SmHtK9oNEb/ZkNBN1vnUe0YZ36K04pWPCGxXh
	 94Z7N+P8lqDNcvxNSw1uDysrcClEYRPK0qxoIgl2ccmTuxNSOuSxbaGj+7AWHh9wdw
	 ffeH97zWYNrRA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 340523A78B25;
	Sun, 16 Nov 2025 21:56:27 +0000 (UTC)
Subject: Re: [GIT PULL] more hotfixes for 6.18-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
References: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-16-10-40
X-PR-Tracked-Commit-Id: 1c2a936edd71e133f2806e68324ec81a4eb07588
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ba45f15049b4442c932ca2499aec739bb6bdbcf
Message-Id: <176333018574.2325379.9692418358427217808.pr-tracker-bot@kernel.org>
Date: Sun, 16 Nov 2025 21:56:25 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 16 Nov 2025 10:43:14 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-16-10-40

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ba45f15049b4442c932ca2499aec739bb6bdbcf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172B7522699;
	Tue, 29 Sep 2026 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690311; cv=none; b=Bwg/oINTkgXLq2zELmpW6QlRbUFheTVUZWm4iHWj+3z8X18+BgwStLFrf6JByw6Nh5TBnV1LK18vgw3/6oW5LmdBr6NOQgK34+i8hWp5r4U5kHdIz6x8I6GTC6sAKzeodDoqGJNbVEq98mYkcgdGF8QVbnUyMhr2IeBEnTTN/+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690311; c=relaxed/simple;
	bh=SOEvubbQMnOooXD/UcW88oGK5qu0rgnbA9Sct4nYulE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=X0oCZ89U5PY8i7MyR/7S2pHlgVbKHjqwKWhKLTHPeQP/NYljXzCKzRn9uWTaVfmq2v54pXZrkK+KP2aF0DasE3kS6QeqLwlv5GViZpRClwHQvIIcsW0vna0B9nRL32U/WgAvBtemqxLzMqDJVaRxqllW197xgnAI2zHC6NdwPf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgRYrjZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgRYrjZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3061F000FF;
	Tue, 29 Sep 2026 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790690309;
	bh=OtECl8+vYMPnXskEA5uxBLNSGll9C58y1Bq34FNO+eg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=SgRYrjZTvIw0+xwOcjvzqiB9d9fnVU2yeS703kX9dpf1qk3Ss0h9Fmj3K0+JEKFvv
	 sTPm8tV6joZij1oeq62s0zs8iVK701ZJJZAkFZ/aIBM9s3UtaPbfrGwHkK6/eMpJVO
	 1k9CZhwbre3jDVa/S26Dtbq7vcy9JXen4kF2u6y6QdmINPgMWTTxNaqUDhznMMnzcD
	 PMjbZ+Soxz4Z2wbVgjyqOLfEgnSheS6Yg43GdRDuMbuhRDY9EIJSlCbkSOT1Wkfawj
	 Ox2FH+VkdxCXS2ZuQCoIS4hMafq4pL4p1OOH/jt9oITWPMNfW5H9KmCfR7gSDwJC/Z
	 t6FQXGqHi6bow==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B47383926663;
	Tue, 29 Sep 2026 13:58:29 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.3-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
References: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-27-19-12
X-PR-Tracked-Commit-Id: 976d5e0ddac885b0219252f004f6c561c344df9d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f8319e3e9a44dd537d17f41565a8453c560a581
Message-Id: <179069030829.508778.12503709141210678561.pr-tracker-bot@kernel.org>
Date: Tue, 29 Sep 2026 13:58:28 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 28 Sep 2026 20:06:25 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-27-19-12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f8319e3e9a44dd537d17f41565a8453c560a581

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

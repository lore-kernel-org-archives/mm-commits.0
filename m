Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8727913C917;
	Fri, 10 May 2024 21:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715377154; cv=none; b=I0sYEuO4gqI1V8I7AeiF4S1pd+gK7eCLdwg0Yevy4CDsPPJtHwvOBWx2P+MQo+OHF+Jx4nGRnL/VxfqF3nFSjuivVJlF8hOUGxqGGSa/mfaanbNsySNIKI64zB3dhCHcwAbbKvis73MVm9hCfuDFOQpbUF3md62sVUZRtlUAfXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715377154; c=relaxed/simple;
	bh=eQbK4t7LZ4AmfufELJBTSU2juM59XYEa7CN1Mh1aJBU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZulKnIXFP2hQcZEXC7vkSAGA/VdCpZVEp1v5NbluiKGXB4KRrVCQxC+2d9CE8HZcdqGRvF2eSpQyJwo7gISZaUNev6d5pEU7YL4a6ePq/pFsFRwxwhT16V/XEk+07wAUdVBfG4AnZfCoFJXXCK7F80IMBq2TdG2anNJLnKyFWvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BeBK2XsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BeBK2XsV"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6898AC32782;
	Fri, 10 May 2024 21:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715377154;
	bh=eQbK4t7LZ4AmfufELJBTSU2juM59XYEa7CN1Mh1aJBU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BeBK2XsV4+dlGMgnzEqNxxpHpGxEsjSn9dwBUuQEf1SJyNEGsxRnRYvYy3t41TsNX
	 Ul0zgLooQZoKFF8FaXA9KyPcvyW/gPOxEVERuM4U5cyy4CWrbhYVw6fJoe6CCpfDYV
	 vSPa6MYSYL9wBNYVXw4dej59CEg9LG04cjNExkox9lmyj80KrYoS7dEg5pgzp20vNp
	 Lo2gKXQdek+v+YVHfHL2J5Y6Tb5ecMFQQhMZ0blDskFdTSOnuhhVwW9s4UL3y7HtBt
	 YcBCIxPQuatIkuWTdaL6e/4bjyliaxxHNXvhCD5or1nfu1JJbl1bFgoISnrXYKRORR
	 +YRL7ourBXooA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CA3FE7C112;
	Fri, 10 May 2024 21:39:14 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240510131743.cf12a22295edd6ae4c175d5b@linux-foundation.org>
References: <20240510131743.cf12a22295edd6ae4c175d5b@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240510131743.cf12a22295edd6ae4c175d5b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-05-10-13-14
X-PR-Tracked-Commit-Id: 672614a3ed24150f39752365c57a85fca1bd0017
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c22c3e0753807feee1391a22228b0d5e6ba39b74
Message-Id: <171537715436.8717.12103384516961795701.pr-tracker-bot@kernel.org>
Date: Fri, 10 May 2024 21:39:14 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 May 2024 13:17:43 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-05-10-13-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c22c3e0753807feee1391a22228b0d5e6ba39b74

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83052352C4F;
	Tue,  7 Apr 2026 19:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775590032; cv=none; b=F0Y8UyFxXoK/ZoWQpWfxAlCpnuQnNSy8sn7ohJcCS1k+4Psb+9n8W2cT6DWI6kfdtk+DBCTMmFhfGDvn5toe7OQJWZ1tMaNJFjitD/FDJOfeO0XqyxZXb90dCZdKpRmvBwALIQWW980YG6mVFn33QZMZOuKuytKz7rmWL0J2HbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775590032; c=relaxed/simple;
	bh=kWHAI7aObyXj6dvQDOMtmoAXbU5XnD34DfBNqB63Fuk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=J8yTRTy4xboYhSKtKRG9hrJ1t8b3eOF6vih9nxQFUzIwpCLxp2aE08APo9KIDyu1rD1IW1vrV4OxrUK0HO1iUf3oZTyynVc21xeFs4nISsMJqTMKVu3nY5OHlgMRyw5Ocr9uHsM21Yc1h/0hDH3vAR/mf/fC16PKjiyfs/tUhGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ji7895+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ji7895+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0A7C116C6;
	Tue,  7 Apr 2026 19:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775590032;
	bh=kWHAI7aObyXj6dvQDOMtmoAXbU5XnD34DfBNqB63Fuk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ji7895+QUsE+yknJwq04P/tYQ09vHzFAyMlfKY6P9ohknz3L2WPq12Qcw+TbbbZ+v
	 BaR3hN/4v52VEtnIWLmVOJ2Md90rNWymPkwA5qxemKcSuxw8ehTbL0oiZEw6qbTr5W
	 NPeHiWNiQcFvFKgtf4FnMQRMr0gMisW8ptTqxyeeKO3GIfF6NJWhHJ44+Hgr7L+u6Q
	 tcf2FI9ZseCSAuVxjAaa3VuHNizTbKZ2ZJkBVOVjV6yEJNvJ1SLiTLQtx5rCxUHhVl
	 KBrxS5ze/4MBMwD1Q4dCIsXParBa7IL+LuIziIeKsmrBuwXdriwo7aAOMvlldsPBIa
	 0y8UCRLEpvZhQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02E083809A33;
	Tue,  7 Apr 2026 19:26:51 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 7.0-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
References: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-06-15-27
X-PR-Tracked-Commit-Id: 7bc5da4842bed3252d26e742213741a4d0ac1b14
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66d64899eae85dc9b96c5433933787cdcd9b21e4
Message-Id: <177559000961.4123438.10274665543837779264.pr-tracker-bot@kernel.org>
Date: Tue, 07 Apr 2026 19:26:49 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 6 Apr 2026 20:40:05 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-06-15-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66d64899eae85dc9b96c5433933787cdcd9b21e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

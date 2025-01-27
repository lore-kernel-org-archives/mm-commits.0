Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D069F1FC100;
	Mon, 27 Jan 2025 03:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737949155; cv=none; b=Wm280S4eS21+tN6i7a/Q8rsC1SSri682ll9SGTYLCzq9+Ggeil9WoB4rQdMfmA9Jv+5bT1rLDCe5gRws8irSW+lyQCBq0/IsOOE+6xLRvpXepolOucS2/joB4+4fAtv6aKKg14LXZgbDZ8LFCJV67k6A8Lk8kKK4LPKxP8RBkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737949155; c=relaxed/simple;
	bh=RelyCisAubsmmDc64NRnDK5j7Hf28p2XoOXYK9N0Nn4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GNlt0ilbWI3UaAFqBYNNnGvo23FLcc4k2ZEjHBkCvdHD01ZPsvehnTVXAIWHtRgR/ebyEwK8Idt6Gt96OPSQei+yDXt5lIZ6FhZGQWlMxEDncCypeJPGUX34vDCXQAXWxEHt6RmnThUx3VpOO9uEFlWe0TGf+nKn/lMYJm3qpAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IS/gkFUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IS/gkFUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3E7C4CEE2;
	Mon, 27 Jan 2025 03:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737949155;
	bh=RelyCisAubsmmDc64NRnDK5j7Hf28p2XoOXYK9N0Nn4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IS/gkFUk95R60DSItAe5EsOLKibcOVllmX2VVAV3scA6N1F86dpxtrPV7LUSU/U4j
	 xU509A9dGB/W8sU/ObE9NMW9aWpmGxP4EYtcruU6fGy8kiYrafzXl+FKwjBFq1FACd
	 7TEivzvygRTGUt3UBGvxWU12LvnmQsOQDLSMMOmupDKK4BoQpA4NhHl8GAyRcuVESr
	 jFNJDB1kyOcc5E9RtvLoIQmyn9IzOavWDHBPZgQtKySiknbYmGLMDAIZs8YKPqLXb/
	 nzMPiiKs0+GGZqGjDvJFuPPbGlBvDneIQwKFcmvpnYWX7i4vu5DKsqh7N6pfdahkUr
	 0sAD32e+o+UTg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAC62380AA79;
	Mon, 27 Jan 2025 03:39:41 +0000 (UTC)
Subject: Re: [GIT PULL] MM udpates for 6.14-rc1, take 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250126150532.2b75f7ac330cdde40d13d788@linux-foundation.org>
References: <20250126150532.2b75f7ac330cdde40d13d788@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250126150532.2b75f7ac330cdde40d13d788@linux-foundation.org>
X-PR-Tracked-Remote: https://lkml.kernel.org/r/20241111135241.1640f547@canb.auug.org.au include/linux/mm.h
X-PR-Tracked-Commit-Id: d1366e74342e75555af2648a2964deb2d5c92200
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9c5968db9e625019a0ee5226c7eebef5519d366a
Message-Id: <173794918049.2962345.16153806964109303355.pr-tracker-bot@kernel.org>
Date: Mon, 27 Jan 2025 03:39:40 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 26 Jan 2025 15:05:32 -0800:

> https://lkml.kernel.org/r/20241111135241.1640f547@canb.auug.org.au include/linux/mm.h

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9c5968db9e625019a0ee5226c7eebef5519d366a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

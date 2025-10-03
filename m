Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6042D320E;
	Fri,  3 Oct 2025 02:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759457903; cv=none; b=taEkKn6X9u7W3wr2pFpTjgU/Wn1o6kuhy1t8bRFpJ2PhVkF1Jso/Gk/Y6P/LetcmKBY+g/31YjXRPPkBKV0jZhpmh8jwggNHktS29jziDiq1B5PY7gyTwfnIAG/yXFoCcRoXZPmjDlPGP8S0O/MMbXroG5uJFJodwSbg8dfku1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759457903; c=relaxed/simple;
	bh=Dc9/hZWk9fHRv7vY+ojxRQScjdcyQGHx3TOlkrD6eLc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EX1pBG9sQ4rAI0FTHEacFtTJfOpKMT9yo3oXT3ReLd67bRwxxRJkX8/PO/1via9Rcj6EVFj1ikVVUvBfnMUWMM621E+7tKGsqBxFHUv9UCPIFszS1SaquYgVltYiASmkJYK0UTancOeEJDj4mbDVE9tRwqyuLTjMadKjGv0WDzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOetLl5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOetLl5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4E4C4CEF5;
	Fri,  3 Oct 2025 02:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759457903;
	bh=Dc9/hZWk9fHRv7vY+ojxRQScjdcyQGHx3TOlkrD6eLc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YOetLl5fKaj7OEU72LUSqOE6CRDtzwNw0H4yD6enkY8XcmXZ2PT9W/5nDF4T1tqx2
	 uLYL6L4T9gFgNZDOQpA0XFmMuqfku2qeU5qXpQHxcsU03jncwiJCmWAnt1SIaKjyAJ
	 JVkJZj+lZztFYx6Oxbk2ij9zdxKBKKdedW1xtWOco5b4HnyfjNf/8Tai7pf6/y4kLa
	 HWcSyU7zOYZnvFnbCvubyqaIVIYiDD8JR26XZNGesTLM5WMwB+D77Su08CKVVD4Qly
	 8YuiSSfrTS46OW0aH7xzT1hRUW5hT37F0guzWHRon+LE+tV4TcwyR/OyNuwWrEy6Dh
	 85PwkR4xHgYtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3401139D0C1A;
	Fri,  3 Oct 2025 02:18:16 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251002153627.8890d5019e8e25a9df283e99@linux-foundation.org>
References: <20251002153627.8890d5019e8e25a9df283e99@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251002153627.8890d5019e8e25a9df283e99@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-02-15-29
X-PR-Tracked-Commit-Id: 9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e406d57be7bd2a4e73ea512c1ae36a40a44e499e
Message-Id: <175945789476.3590395.14349776223212846303.pr-tracker-bot@kernel.org>
Date: Fri, 03 Oct 2025 02:18:14 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 2 Oct 2025 15:36:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-02-15-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e406d57be7bd2a4e73ea512c1ae36a40a44e499e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

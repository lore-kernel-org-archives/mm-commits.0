Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611863C17;
	Mon, 27 Jan 2025 03:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737949153; cv=none; b=nTGXk+XCgktkM7rETCBxYvLCU278+NH06gmmoE0CDyzAQUyTZSaGLkhVosym0dA5HJPfRKqZy5LMtybImhDVWX7bRX3REGXbtkLwXqUg6C0C6JDGUwvvUvm1TgZQ52QOUPDR7487/ZCMLhSPTJ48Qzu6dLgUpBB9U3eVgknsTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737949153; c=relaxed/simple;
	bh=zlKGO4RBfVmh3oGYbiQSdAf5J5eLB3ztmaNSRYVRfiA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VXmm9N0o2S3Hm5EWGHz1Wi2VWWnCufhym+4qwnt6kwiOZiPxnarebv4kPslSt7gsekNhD0e8j4Gv/PMaKqaXeGLAHt5fXKRiVHEssACeJJq0BgEo1WrDLq1nEpwhwjiXhcTg1S4usItRU2vXcZzOybtWI/mLcnWpRgQKrPVNKzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEc58Dex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEc58Dex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474ABC4CED2;
	Mon, 27 Jan 2025 03:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737949153;
	bh=zlKGO4RBfVmh3oGYbiQSdAf5J5eLB3ztmaNSRYVRfiA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LEc58DexJ15jO3z361AV4glr0bNb2E40Kue/porPrYOhPPQytbDZRZ0X4aNDcWayY
	 +xfDWZVUoe+ZHNNEgbhsu4QcJmxHSpiFRQzbEkFRoqqqLOItX8OfZWuKQaHffvosx/
	 YCRNQ7sbc6rc8frRFB2Z/4HGqfxerxY+3H76HTGHu/HwWk+ILSVSBxMNduVC1RiABE
	 Fb/d141EYNl1FSbYDNd/1BTjLFCPGRTkE+UUQJuI3wxKM14KOAeivNVkOhge17Bhh4
	 lKJvzaSkJpjU32mpoVNQwLXtNrSb30JogQWjoQdyTCB2ukTRYb82xk73z2yybdOc/Y
	 1EmSv3aJu8VTw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0B0380AA79;
	Mon, 27 Jan 2025 03:39:39 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.14-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250124232623.62694054f4c1e92f0900bcba@linux-foundation.org>
References: <20250124232623.62694054f4c1e92f0900bcba@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250124232623.62694054f4c1e92f0900bcba@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-01-24-23-16
X-PR-Tracked-Commit-Id: beeba1eeec9c75d0a62335861ac175b9bdccfbd5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c159dfbdd4fc62fa08f6715d9d6c34d39cf40446
Message-Id: <173794917863.2962345.13857525082872304683.pr-tracker-bot@kernel.org>
Date: Mon, 27 Jan 2025 03:39:38 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 Jan 2025 23:26:23 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-01-24-23-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c159dfbdd4fc62fa08f6715d9d6c34d39cf40446

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

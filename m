Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F6230F54B;
	Sun, 19 Apr 2026 21:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776635676; cv=none; b=q5EsEG9O9Ttm7iO7d7w5DInoboG+u/o735rH2jj8VcxX0jyKXBAGFKAap9xpPvkx+sRihier+IyXx6hgvQgNwQJL52uSquykFMqH0jHGlvR7mfPzA7Sq6TYuvbb2AqWnaqORvGwPzuIMsNTnG/ySupDAyf5zid2EZ/ZPjzVLPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776635676; c=relaxed/simple;
	bh=xp8O3ZLidwKRYT26LD2n40Clhacjz4g/4YMmM1g5G9k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=r4nct5MMt9JpMGEva4a+8Jr8yyTsEbLQQYoOHp2NyO8Ikz2fVx2pIzHwB6dj+RDew8C729oO1uShQBcMtC2bEQTjHMdBcBaLMPtEauHbSJHz+N4GHUqBUy/1pMRtAhrAv0gQM2dhP/4JgUZg4JNAlpXqwCq0uD6UAAh9vvpSWWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEUvKiYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEUvKiYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B462C2BCB4;
	Sun, 19 Apr 2026 21:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776635676;
	bh=xp8O3ZLidwKRYT26LD2n40Clhacjz4g/4YMmM1g5G9k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oEUvKiYEmKbKaEulKKqkBTPmg6aHx2ksXrdPDuFReNGuUS56iu4mYKE0lvPOFwPa5
	 Ugi1OjgBhRZl1pUlOrfO88xV+CwZQWTIkOHE0tB7tB4f2h2IK6qAy/RyxQfLtysZty
	 yqxC772Eov56wzbAoEIVkDmBKRjOcHXVuQJSwk8lUtYwbIZJvIx2e2fXYEpeKc9weA
	 7+HkGO7K+Pm4r9sSS2sAp11MEhaDy5qx2NJ6xlYCPUnuXnuPXqd5f5OFELAbkGHpXA
	 GqjcSX/ZQaBpkrgW8+RTCFptlSweZnQ/SlOnt8bE6Swn4ddV6YphvpjPgNxBmxeRkD
	 iZadYCDDjkegA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9DD3380CEFC;
	Sun, 19 Apr 2026 21:54:02 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
References: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-19-00-14
X-PR-Tracked-Commit-Id: 95093e5cb4c5b50a5b1a4b79f2942b62744bd66a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c1f49dea2b8f335813d3b348fd39117fb8efb428
Message-Id: <177663564117.895827.10985364203298298867.pr-tracker-bot@kernel.org>
Date: Sun, 19 Apr 2026 21:54:01 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 19 Apr 2026 11:58:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-19-00-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c1f49dea2b8f335813d3b348fd39117fb8efb428

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

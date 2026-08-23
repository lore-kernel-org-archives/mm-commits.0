Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F527377A85;
	Sun, 23 Aug 2026 16:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787502673; cv=none; b=KOrERdFC+KP4ZJxtOG6bPrOvP5o8ZGMvtvBPy0ry7oHPp2ovFmzLAbo8oxPvHvsFOtqShJomrtsfswG8yXu/hpHha3dnMp14lAxsGwfek0jnPWY+3902NBw8BKRf5RAsd7JJD/eGMlo+yr022v4p+IdIwitbJzS3aWAcEbhaMSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787502673; c=relaxed/simple;
	bh=gKLcspl+lIIwSPU7+4qCl/gj1qQLGuJjlTJfUJ3JwQo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ekH1G8zAGqxWhuehRoEX//Xgab98yOhVVGVMKhOaCjjLet9PqhDv6qkCD283TONlQC4n8kQ/azsffyy/m38l7YmWJCRdX34ZcE1qSS7LitdYdzvaz/DJ1qUbeEWS1JtnfBJxnoEDDkHUP9rlJIObGSpjAjHd/U2xKT6rC7ZjZ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Whfp9XBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Whfp9XBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC5D1F0156C;
	Sun, 23 Aug 2026 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787502658;
	bh=zSckTnyIbH/NA5CO67d6i3mvcZ8WMAnIAcorZ5eX4AM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Whfp9XBUNTPzRmBYYYOkoBvC/oOhfgY0shRcyKHO27qTXsv0ZsB/y30MRfq70NqkO
	 uLnZQJzpret3nO1H46hNxRXOeEKe91bkghBrdbACti26mncfrT1fnWp+8+7q0DCmVa
	 uLzNbk03bjOy4xNhrlt/P5HLwbHQClCFdeuqVGOc9J/b8ZV+4s2WMJwIrcmTRWligA
	 URC24N14WBiKJUhvIPGDZjRCKqGGX8vdmnoghAUuTAzZRCCgvDJALP7hFNkW3aY11F
	 qErGYxZfYryEbyV582yCYsXIcFpTqO1gHykZGpAdPMVIB2NMl5Dru2w+vXz896hNV3
	 4PuITQONggajQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199DD380AA77;
	Sun, 23 Aug 2026 16:30:08 +0000 (UTC)
Subject: Re: [GIT PULL] Non-MM updates for 7.3.rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260822170728.415abdaf6589f2849d6de871@linux-foundation.org>
References: <20260822170728.415abdaf6589f2849d6de871@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260822170728.415abdaf6589f2849d6de871@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-08-22-16-57
X-PR-Tracked-Commit-Id: eef628bce8e18ce1eb8531c396bf55e36f86c62c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e5f92606156a6a823992294d214c285b49cd72e9
Message-Id: <178750260687.2078512.3571703151903804032.pr-tracker-bot@kernel.org>
Date: Sun, 23 Aug 2026 16:30:06 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Aug 2026 17:07:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-08-22-16-57

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e5f92606156a6a823992294d214c285b49cd72e9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

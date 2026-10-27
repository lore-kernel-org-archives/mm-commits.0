Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793140261;
	b=KrI0QAQJmsRGZtvl1V8C5JqyAabR1xcPoQ5rjf6B44/cl0xuGkEdnt9yMEakH2wXmNKc
	 uixH41Ip65u2nycsPkEywB5yUtr+LNyjQGr/JGW2ZYTD4J7ZmtlE6bhvYhO8JrNbb/A1p
	 Pq9Pbd3wRm0IKMKSpAwf2t785Zq33VcPsXFvadbttqSP8MXg8wXpPQUi2QtiveXmClkZJ
	 XRRGsTWZxsvjX/ThmoQ0YGtTtxbatQeHu4g3LaP3NRpzuaQf6VVge/UHZQDpmYRhgcfvU
	 OU7/NAyx1Nn1s2OasN9JOcB1rJHPUjfV1AVx3JXtKy7WQ15/QEPGs2eOhUz+kxma63Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793140261;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=j2aaTu/ejA+h6yETxrpfv6ILgHiEOxegmW4KZtHlbN8=;
	b=IRmF7BkSC8/xalfafOr+5q22dnPdxWKyAvRkc/qUKupyszYTwTCuU8phb32HghsRJOJp
	 AH5T8ZZWHfxtmf3cKuNXZypl8O661p30VbBG6EHmx0eYKCDPWELPC1xWjzUGEmRwSo85D
	 rTUS71teuoVJhqm0012aLuS4+a0X5ENJNG9JLIk8UyVDWqTCXdZM7vT+PnuUjzGgnxAZU
	 fsLdYxfWcOK0f+pOedYoH9OhkSperOlu4mNgL8pZZOVblLHuy/hM0En7Nqdfyazo/SUWF
	 0EQGhfmmSGV8utEIP8uICPG/d0wMBypqn8QHfkIGbgMZfL/6p4wcg1aH1bqO6IXFA7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="W31G7A/z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91D9606A324;
	Tue, 27 Oct 2026 22:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W31G7A/z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73C31F01825;
	Tue, 27 Oct 2026 22:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793140260;
	bh=j2aaTu/ejA+h6yETxrpfv6ILgHiEOxegmW4KZtHlbN8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=W31G7A/ze4tUfIqB3Kiq31CY7BH4DPbWKb77AiVJXJ/wMVQsqIhGOzMScObhWa8VS
	 M9AsbOs63a8DZYhmjTQbLAR+YzoFfNYM8UmbbRQ/iyX75PrP3Gj/dKsVXK+m7wrBwm
	 7ey7yFbZlO91ZZ9nYmotT33/RuXd0dEDZkfjjTh/i/jJBw0jIuv1jaNpyR6OfXz9n/
	 BZ+1VEQKDcU0Ejo1iMLjQQNn2zYdb/IJ38HEJXiTA1S/sBM6li2uT9/dfxAYEttuN/
	 VqdFqreYAyVvcrJASNK1ElYd1Rj/buvwhn19xH4eR8g2L1Sz2CLlVlJPu2vKIi5RUO
	 LMMPDDGNSrurA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9592D3AA940C;
	Tue, 27 Oct 2026 22:31:00 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261025202725.34c617497b6d9a2be352cf4f@linux-foundation.org>
References: <20261025202725.34c617497b6d9a2be352cf4f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261025202725.34c617497b6d9a2be352cf4f@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/as93Q-hDP5cW6gaj@sirena.org.uk Thanks.
X-PR-Tracked-Commit-Id: b6232ca8d194c60ee603586e42b5ea584d4b7be9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b
Message-Id: <179314025939.360848.2970216075715902545.pr-tracker-bot@kernel.org>
Date: Tue, 27 Oct 2026 22:30:59 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sun, 25 Oct 2026 20:27:25 -0700:

> https://lore.kernel.org/as93Q-hDP5cW6gaj@sirena.org.uk Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

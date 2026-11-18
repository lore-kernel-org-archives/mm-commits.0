Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024568;
	b=Ni1/v3axokOp4H3CqZvqDIi2OJcN4ifWRkYIrkwXxvUk0c/zwPyFLIpnxSZF315n3EHg
	 ThpaX3v65dVl3DHOtqjaWRhxpt0hAycVpXmZsDHiEo7kVA+jaYmGAeXegH/aI9GcAWY1n
	 KfKs/cYMhfJ5Aox0afVaBOdMT+Ddjx+VoTz8zRUUBLEq38QmiXN0fiVuQmNBTcWu5/YK7
	 SYmXloQKtq2q4zHo1XBCXQxClCWWySkfhkioYX4rgrJ94v6ZL0qwXJXbi7sAsCI9Ln74r
	 LK07RIS7gPtCfpOe7uCmnB1TYpjPljl8VaXN/OZNfBBZqMZIotGWTOq4Cy3lK3WPlZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024568;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=CzjLRcrwDq/hxGK1YyQYbZmktQm7XN5YdBQqLzEKlyo=;
	b=5t3YWNZB34U39P/OaS9UULQFxX+baUb39F3bzYaHLoRl0wqIahFFgqqSQL+Qd7aEFUvp
	 AqoJrsv6A06rnMToVVoxr3PGUPzOKKThma+pyo5djJmbGmiH8edn53VvBYFBQ3vbcLaHM
	 jUH4ceqj+BgCg1I8zmkJaDrHM8zSBwBncgLIbTxL8U7DOjUtlak6Fw8pCHqJxG5JBVIq7
	 Z9fLgINBIbIYSPCd+ai2uw3r76T1tJkhy7fdThdSv2jsAnUtnKQbmky8pJ18mIeMrg/Bu
	 p/FZgQboltonwqZt+ZNkd+V0Rgqca/gyu6z42f6vfRX3INCnKkgP4uFgKaCkGpGjLtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cU6ihKG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC84F606A330;
	Wed, 18 Nov 2026 17:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cU6ihKG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802891F000C4;
	Wed, 18 Nov 2026 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024568;
	bh=CzjLRcrwDq/hxGK1YyQYbZmktQm7XN5YdBQqLzEKlyo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cU6ihKG8YQqis+Yy2Bt6ZcRMlUPzhSuLcnPvjQvnN0nombex/BAcUssmZli+do6ok
	 Tp3chEC7FEoPOEnfgXM8Ok9puixKOv9EUzx6YmYO2+UOslrouIwMItMcxug7Ur/1oz
	 jfXg0Fyc/rFDtqRWPgK1XHmM8HDMZcsP/cir/Q8oR0X1KKLGYIx8OINf7CRPM7ZgwQ
	 bBqfwMh0UZfP2FkjFB5aXvS06vJLOsqljQr0vcs4ZpLTNmdVbpKJiAY+HcHtcS/YZb
	 zkr9yEI+VnHjEZIMIhOifFkatKYLseUxpZBop1RMIymSZmNFtTDHGdDkKNYXuSJTLi
	 ZC6h2VWhs4yog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 774E03808210;
	Wed, 18 Nov 2026 17:56:08 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
References: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-17-19-55
X-PR-Tracked-Commit-Id: a4e667346a8d91e629a2ca9affc70dc28978f4a1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d866d5bafc5e1417032255002e95f8ec3121754b
Message-Id: <179502456713.1929586.6548525722108404316.pr-tracker-bot@kernel.org>
Date: Wed, 18 Nov 2026 17:56:07 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Tue, 17 Nov 2026 19:59:35 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-17-19-55

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d866d5bafc5e1417032255002e95f8ec3121754b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6761879;
	Thu, 23 May 2024 02:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716430536; cv=none; b=SdrQYPyjIWbAU3Ef/ioSOTGGcF3s3vRh/fYh1B/H4lz6l2wBWDeyYcJOsgsomMNeqiYZmmy4DjBw8a+6g3lleFOdLmp/tqqVBA3ARRF3ziIJ+7HNy0LHcRInDe32iZVLLgjWKfiHE8FB7HQezSdmxgIjBlROh+/CPDBtRHR9zNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716430536; c=relaxed/simple;
	bh=qVQggCqRhbUcbFurc9+D/oAt708hE2ehLytBDP3BHWc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jnT1iOYt1ewWooIpVaFBA5Lm8fC5IRezF7vQUxWZ+rg4cvbzsFWLhDXjEJlTJ62+pGayeuY93DE2Opt0GQx6Wdk+WG9QUlJNRoJet7D0aCaK+g5CTwKON4ftlXAkjO8InBeOPx0uFovgNr0Fu2y6aXYsu9CeFtMKhfhg+ST3pAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Inlv9gKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Inlv9gKK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 799ABC2BBFC;
	Thu, 23 May 2024 02:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716430536;
	bh=qVQggCqRhbUcbFurc9+D/oAt708hE2ehLytBDP3BHWc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Inlv9gKKfmuWBMgUgJHUS3qQcwQrSUr+CjpKgxCKu8QnERGkt/9tbMLBFPvz23Hoq
	 KCxHh+u8tk3mDtqoNLRTXnglCva8G8H57+El8rTfsx+eRkl1emn7EpMi22AB9MQTkx
	 kSyGgFjlrnuB0PjsBifnIHAtW5DjQtzuVuwC70w7npmJlXa9P2q1IT6AAehJFusamd
	 3F64hZ2aB7l1Op1XU/42BTqgqci066u5quf7KG2bjweEMUrI8bf77oI8dbSlKko0fb
	 xodpAnYepP8W1q0Y7Bt/XpD/ubMqxHLyhmeM/q8V0Tlehcw9pDVud1Omeyi+4oRgCf
	 /8lyXidIuoxpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70F2DC4332E;
	Thu, 23 May 2024 02:15:36 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240522172431.d2aa8775d7a48999afbc29b4@linux-foundation.org>
References: <20240522172431.d2aa8775d7a48999afbc29b4@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240522172431.d2aa8775d7a48999afbc29b4@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-22-17-22
X-PR-Tracked-Commit-Id: 99b80ac45f7ec351c2d1c9fbfec702213dcae566
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5c6f4d68e2aca67e425b7227369ec9fde8adfb6d
Message-Id: <171643053645.23672.3041718607921419995.pr-tracker-bot@kernel.org>
Date: Thu, 23 May 2024 02:15:36 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 22 May 2024 17:24:31 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-22-17-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5c6f4d68e2aca67e425b7227369ec9fde8adfb6d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

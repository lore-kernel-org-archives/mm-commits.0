Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0117A25B1CB;
	Fri, 27 Feb 2026 01:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772157393; cv=none; b=p4ttLYtG3O3yRVeRUboKy4/5783NTOh0+ZqkzjMlc6eFc+yc9Upkrlo0JvmMliF76rni2IwrxjLpLTrEXQfCsppvzpxSz+UeDPULcpxu/dFTD/ONXfvcfQ51ZN146JNuSX9W46LtBc2R5hphG7Nm/0P1eQRQkeCJN8R5SnYKf7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772157393; c=relaxed/simple;
	bh=CeL0o7iDozDNHrlUHISLQBri+jPvgiHF2jv/vUiwOI0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=klxn0e1U5D82jYedXkQNFdK6J+18DWUAjM3AkT8CHh8nz8fkHkomVENe/OoA+3fogAuEkp1ID4RK4zGf7zRRpVGiNiWV3DLjqg7EneQfsf+jeUKKKuiPGlFeRlQpbG7Vt09qJqp95vasMI2/GoSL/n7u0gEsll+Dipg6V1gqQSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOwcbfPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOwcbfPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9486EC116C6;
	Fri, 27 Feb 2026 01:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772157392;
	bh=CeL0o7iDozDNHrlUHISLQBri+jPvgiHF2jv/vUiwOI0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jOwcbfPLMmfGhgKBn9tXEONS+8aPggiAFkMKwpdRnvywOBjMFPNNqN5yJu0hYeZtm
	 /aolv9y+KqwMzjGTmuLWvxymdqskRnMKmVp0JiQ7jtum04hp7qswBa8k2AFV/6sZ+G
	 hd1W2Nagsgd1bbkSuvQ3hYlZ34kc6Bs8gttkNScZVY2Qx6wX/hkahmLFUjUjel6spd
	 5uOxVrtcx1v48NHhPtb9qq1eM7myBgKiznNUXaJWkTHmb3wcIpFYvefUbQUWywdrix
	 VfA12tPcw+9VoJZg05j9WPMsuEjl8hFY976am8jwZPrASSQBTx10vsGg4c2ce93ngx
	 CG3Md51cpKcFg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F28393109B;
	Fri, 27 Feb 2026 01:56:38 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
References: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-26-14-14
X-PR-Tracked-Commit-Id: 410aed670cddac1de4f0c2865f30ec623fd20f78
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 69062f234a2837d2302a41c2ba125521630deea8
Message-Id: <177215739659.1937342.143122209456192930.pr-tracker-bot@kernel.org>
Date: Fri, 27 Feb 2026 01:56:36 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 26 Feb 2026 14:16:33 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-26-14-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/69062f234a2837d2302a41c2ba125521630deea8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

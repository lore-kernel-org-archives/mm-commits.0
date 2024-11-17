Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1991E8F54;
	Sun, 17 Nov 2024 00:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731802668; cv=none; b=X5Kn4CnnQYf93BCrUVinRadOB/lcn8uNSJV5cexm56Zy1QlNKKDIbl9QcmZBP8GYrY30JVSZopT6pSa6Ir3jZPPZLp/aPfx9ZihUdILaU3WqBXihkvNiPBQ631Cfh4Qr8zPpvf96RNV6VxVcYKzkeW8iJgUmp6YKwMkCcTrQrg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731802668; c=relaxed/simple;
	bh=jT6ArlNPdzGNPh5TZ5FBBCXBtb1aGUl8N/vV68ZSeN4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CuGoAv1Etz0rIS75gWy1uRAI518A0emSG8qqaRQo4xMEKHn4LcETJxGP6eIuQZc2CDhTIUrmfdUQN1bOczj+6rW2vkowEBNIl38YiEH6grAabigHrWqukDZrnaEc+Pfth37iBG8LFDoag2b2y79E3z/dKUb+bCe5gA7EY8YvzAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4zeuQ/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4zeuQ/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA65CC4CEC3;
	Sun, 17 Nov 2024 00:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731802668;
	bh=jT6ArlNPdzGNPh5TZ5FBBCXBtb1aGUl8N/vV68ZSeN4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Z4zeuQ/lG9BrIhp6PxUBB+K5lBh8scfEPrdQ88MiYjMPgAk6i2OWslSyN1uWcF8bS
	 Qec2y/pmByaBXyMinPiBMazDDXT2GiOS1wcDvNODvxYma72NUlyevKTx58ChLGp6ta
	 WQeDK+xhvCp45X23WWdI0o5vlsBLcv5wGVpIZKUAITWkSyJSocFARuZlcgr+WnsgKB
	 juYvHFZqRMxktnipvddfZy/psgy+GymdZb50h3W/MUFRpN7rihv3F80bV1fEvhmWNd
	 pV2hFti0JT6sD8UwOE6/cVJwnrdYoIUmtHFIHnL5JUnn+wyzruFtxjmRsxCsUPTjWx
	 XSxHzl5L3dycA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34AF03809A80;
	Sun, 17 Nov 2024 00:18:00 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241116153556.767f1aeed6ac628a09efe346@linux-foundation.org>
References: <20241116153556.767f1aeed6ac628a09efe346@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241116153556.767f1aeed6ac628a09efe346@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-16-15-33
X-PR-Tracked-Commit-Id: d1aa0c04294e29883d65eac6c2f72fe95cc7c049
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4a5df37964673effcd9f84041f7423206a5ae5f2
Message-Id: <173180267884.3024604.1394094466289581152.pr-tracker-bot@kernel.org>
Date: Sun, 17 Nov 2024 00:17:58 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 16 Nov 2024 15:35:56 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-16-15-33

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4a5df37964673effcd9f84041f7423206a5ae5f2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

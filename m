Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20113305E03;
	Fri, 22 Aug 2025 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755869783; cv=none; b=kf3aXm/OF3N8FXTQ+w1CCwseLD91kgFzUGi7dYxezfmmzkwLM48fvVKKWzu9Xe4qmD+OeNOxZRUmGVDjKxldYfa7150Stl6fVSR2DKHC+JyA8MQUfmD+2d7Q/gcxmiLH+bRtqje5zFxjML8DeV+vRy3XdE/MVAFaPGS5OXXKTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755869783; c=relaxed/simple;
	bh=95FgaTA08CZt7zqW4778eoQHgSzTh+tdD9TNspJq6Qg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=q2Q80DMa6+MCx9EQDN1wFBqjkIByoJ80o59fWE16PexxGEPMGyD+8PJUIDwB5i7wd8gmdcsykN/ID8QLjnstKzTlMu/2hVpLgdUiXav3hdJRUASroSlAjFcqYt5azYjSK2IICUbb5rcUlA0bsi058BCGcxoy7b0BZWrLC3QaT+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9d3VUI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9d3VUI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA06C4CEED;
	Fri, 22 Aug 2025 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755869783;
	bh=95FgaTA08CZt7zqW4778eoQHgSzTh+tdD9TNspJq6Qg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=B9d3VUI3tQn2THUGhPdrjiM35nVXrHZZVfVCIIqm6KlgqsjILxdCkiNVSfXDYzBiE
	 GCREfjNYC9NAGIhZA2bc0aa/2O+BW74wwo7wODHUmon9bmo9CffCV4NnYO1elSbfYg
	 t1315LZZYTWLS9SNlyo2fs4g4SvSQcGNZqNe4Jn7CQnTErKII5W0jxGZBUaQNrbK9S
	 OhoCrR6faHK2UboXwFu+8+Pb2PkAsdYITRs++sQVEfl9C4/7c+83GuqXhM56RgHbV1
	 FjO8N/eCOMtqcXOtOZMRQM70slcJzBx3veHB/MOupUhm7/Y8P2OmmMMB5INmylMS7N
	 X6zdj8SnPL8+g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34024383BF6A;
	Fri, 22 Aug 2025 13:36:33 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
References: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-21-18-17
X-PR-Tracked-Commit-Id: 772e5b4a5e8360743645b9a466842d16092c4f94
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6eba757ce90483b76da4e7eda962d8b8b8930f2c
Message-Id: <175586979170.1831455.3293661494826885715.pr-tracker-bot@kernel.org>
Date: Fri, 22 Aug 2025 13:36:31 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 21 Aug 2025 18:21:22 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-21-18-17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6eba757ce90483b76da4e7eda962d8b8b8930f2c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

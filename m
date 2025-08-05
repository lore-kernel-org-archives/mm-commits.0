Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8999274658;
	Tue,  5 Aug 2025 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754401223; cv=none; b=BqKFP7XEQTG3D0fipWvwahAstQoaZjT71kk0lM+/sMFgjG8OJo2DUzHSyrVe72JTsXeKECu49se9u7OlrCcFg171ulDQpSHKNizauiNh2aSTCDLCIJ3KRYRxi06yxlmaMhdVhGmk5QM+/eo7ZXXWnz3+w7NeHw+y/n2qGta06m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754401223; c=relaxed/simple;
	bh=bb3JgIx5onPUl2cZwI6V/I7YOYcFnp3aaOkl3S6nAnE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HPQ0MaaF8qB5nVmzFRYCSA1khXjqWEPPzaiDUtIQFDeeAuf83MKp2uIs24Ox+u1/+4R6chI+L2vYfPqS8CJvdwsqMeAWxPzJHcoc5+vur2+JE7omyjMFOAWFMpfvNRWkRZZmn4Q7QfHtYFyiZmIDaJPwLnhAWpZrrpKPvai4/Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AA3YcoFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AA3YcoFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386A9C4CEF0;
	Tue,  5 Aug 2025 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754401223;
	bh=bb3JgIx5onPUl2cZwI6V/I7YOYcFnp3aaOkl3S6nAnE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AA3YcoFFaEPVIICBB3GrrT6/hOw8t35kpBTvMwnXCDqnAOeIA4n3XBi1TQtdKqjjA
	 AztAAgwOWtYv0nqQUxs0ScO9NfrBytd+6xAOkGTWoouZaJvR2xVv/48tQzIForSr3H
	 a+TJsNXBtpXR/0mMSTLPTZnweprLg12hKbNE1sI+gPwouRlpIlKvsueDwrbXINOQh1
	 euoR3F0VmMszcVKtOXc90M6Cp4TPQe6grqPpJmiRjTnB0htoGhtwkAYu5QVRcm3Nh+
	 WRF/Lc/Ue3gLmF8/aPADZ9wpVZtij5/n44aSMTwI+E3LOhdGZQy6QDhA+JPuHMHUZn
	 xOmxDIABqEShw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 74879383BF56;
	Tue,  5 Aug 2025 13:40:38 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250804185852.038ce90aa6f9a177c492b675@linux-foundation.org>
References: <20250804185852.038ce90aa6f9a177c492b675@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250804185852.038ce90aa6f9a177c492b675@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-08-03-12-35
X-PR-Tracked-Commit-Id: a2152fef29020e740ba0276930f3a24440012505
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: da23ea194db94257123f1534d487f3cdc9b5626d
Message-Id: <175440123814.2024406.414993637909226297.pr-tracker-bot@kernel.org>
Date: Tue, 05 Aug 2025 13:40:38 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 4 Aug 2025 18:58:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-08-03-12-35

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/da23ea194db94257123f1534d487f3cdc9b5626d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

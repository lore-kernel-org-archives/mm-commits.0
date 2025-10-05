Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2DD1E412A;
	Sun,  5 Oct 2025 19:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759693529; cv=none; b=qhevijjB168DPlWQi3QeO2CxWxtKRQPGir2zaPYgEQ/6Eo0wn0A/Jy5A61qKqo2k4sjSfaYGvif1qvHmpd+nmwrARn223/DW8jwxXAnz0AmsX8kuJODdYWk8cPy4C8Ae1BWxCaVD1SEK3yU9DzpzVLDjONgFWbM/Qs9jR0/B/1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759693529; c=relaxed/simple;
	bh=XcUhwtF7uuagHrGC9EKXXgcoMysaKraEZFP2wxRcrOM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cVfHmrZvI8/VI8Xoxx+kdvWTzPncG/YtgaTrkJQ92bsLBDWvxSFiuxGImEn/kX6tFbRE8RVwTnuKFyMrzoMFB1vrZkDkSS4fDnIeuzWRR2Oxh+QITrlPYwQ4amF8zWi9KQaA7uA9gGmFXN3l2JbUdCqR8JkMAhvqBHgJlykg0wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zy7Df1Ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zy7Df1Ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439E4C4CEF4;
	Sun,  5 Oct 2025 19:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759693529;
	bh=XcUhwtF7uuagHrGC9EKXXgcoMysaKraEZFP2wxRcrOM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Zy7Df1Ex4hfhtHIPCZpyCQnScZcEHsWCYcPmPzbnrzvaAvKfTQUU0hwAGh9Sg/7ji
	 /9C168K23Xjc4QDuzie5AnwHrSEOU4IBHZZXUMFD3wv+nhczr9UijjNNTrojbzdaDj
	 rsgtUaMOo6yIP5GjbQteYF7k+LcwCzgNhq++LZDT9sJ3kUF59gta6ilRPQV6aZicuk
	 FI7qp0UsN44jJlySo03rIdT+JbJwmwZSYuuFvIxCkXCv/6l17INvV3TDBbLIn3ZXMV
	 PYJNWtLxm5gG2/IL5bh674VD6hKLAyNFKv17ImL1qc6XzbExi9f6K6Ltk1J4Efh+sF
	 BEmVdaH2nSDwQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE4A39D0C1A;
	Sun,  5 Oct 2025 19:45:20 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
References: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-03-16-49
X-PR-Tracked-Commit-Id: c14bdcc9f274620492aba7d920cc2641440cf1ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7a405dbb0f036f8d1713ab9e7df0cd3137987b07
Message-Id: <175969351912.726026.1611185390690071734.pr-tracker-bot@kernel.org>
Date: Sun, 05 Oct 2025 19:45:19 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 5 Oct 2025 11:15:38 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-03-16-49

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7a405dbb0f036f8d1713ab9e7df0cd3137987b07

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

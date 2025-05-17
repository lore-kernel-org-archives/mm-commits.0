Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A854B1E77;
	Sat, 17 May 2025 19:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747511868; cv=none; b=NN61O09KAKap3ONuGEo9Ma8v6OW4z0nFtWbsngXXKHhVNG+3eq1YcYpHvF9Y9qh1lso/I3fpk/LMUPgqL/4RIvcywkPtSb2vbz+/nQqLoM/inblCNeyWajFnEKw7cOFwbk+UtezKGYh8wFZkHBCZPqFu57qB+LSXFAsq4rYCK7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747511868; c=relaxed/simple;
	bh=8kHp1IxjHnxfcP7lo8NRmiJ+XZmlgO88ZF7J/C9aYro=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jSPwDjde0SNFZ9TzpSZb39ZrFPJr3x0S0lmKlNkiB5hQW37ASdNYqNC3YX3PmSTK9lAXsUoX7oLPN35LUYPFIXa/MSgZU4DIV4ue2gDTcCdVZgPqTx/ZtvqlxzfHSQMKrC8DkXxUdt3sKGK1yPPDPgiv2eBNInbSSm2mcqWntMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcikOcWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcikOcWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09ABC4CEE3;
	Sat, 17 May 2025 19:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747511867;
	bh=8kHp1IxjHnxfcP7lo8NRmiJ+XZmlgO88ZF7J/C9aYro=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YcikOcWA5lvElbphhw6jUowlPZrVKYTM9wnHlZEhZJpBq++/duBoMnfamsq4B2pet
	 Sxg+knaw81gsOWDrCY/tQ17mTZFXVzAs0snUg6PaQQGEGCq4umi6juU7UWSZc/gEp+
	 38IL28ovl91iAFOB0atvcuXETc9ptschqMSHyJZyhQKPsZc18yKMpai8sQaP5e8k7u
	 b1VUQVDJD4U26Xd2XsWnFE5DW1nX548QgjR4Q1PoeTPluF4YQPh6ix+Q4FJ/VpXFym
	 91BN80JHHW9NkzFO+o5r2siYEGcbRgt0U5PFA4HjEJD8QNR9TuwpyEpWgmvxNPjdoP
	 L/F5t69wwSnGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71194380DBE1;
	Sat, 17 May 2025 19:58:25 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.15-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250517094422.f299a4e333261dfea7beb43c@linux-foundation.org>
References: <20250517094422.f299a4e333261dfea7beb43c@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250517094422.f299a4e333261dfea7beb43c@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-17-09-41
X-PR-Tracked-Commit-Id: 75cb1cca2c880179a11c7dd9380b6f14e41a06a4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e72e784fb1138ad313e004ef598ff98b364c7329
Message-Id: <174751190406.138654.431314098615139104.pr-tracker-bot@kernel.org>
Date: Sat, 17 May 2025 19:58:24 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 17 May 2025 09:44:22 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-17-09-41

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e72e784fb1138ad313e004ef598ff98b364c7329

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

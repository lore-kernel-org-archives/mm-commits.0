Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E71C366;
	Thu, 17 Apr 2025 03:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744860254; cv=none; b=WhfMkANh5llGcwOwurn57PKESlF44fJw/AoFEJ/ZQhOdIqo4rVPneVe5SI13ssLT01S0L/oZ0rAgBQV4bXDoRiqwwXE1dAunUccMeeKzMXO9mIvu0/z/rZJavUhlKh1DuscSDeuwKmoA4q/s8AFT1m8Y0+aIuFkbAvejvbfoAjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744860254; c=relaxed/simple;
	bh=GPOe+CWRA1zhZube9ms+Gko5+JymZ4wWboZRkedHXOg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HfiZr31bNlM3KzlJpJobY/J3BpodDJCT8dDOVP6V3CKQpvxN4sTQY/B38rdNAw/Dh/hU323jSHXQJz/uzOk0seWwu+cLBqMOb2xy7f8XvNVLlRtmMp59WCkbwspcePa6n6G3BE3IIXz/FTGdIqtrnO6vjpMbx6KyG1OW25RDvjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fst9w30x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fst9w30x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E5AC4CEE7;
	Thu, 17 Apr 2025 03:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744860253;
	bh=GPOe+CWRA1zhZube9ms+Gko5+JymZ4wWboZRkedHXOg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fst9w30xYm9l2lmdtIYUxheXqPtlqag9n4Gkmw4skhrWW8ARiH+5SZqEGmhyZvWaF
	 X6i0Ita4pQPFMnI7D5klbhEtLBJssAtDvwBzlZ3ixL9P8bEQaMKTYisRvGwdLMzNvR
	 sWC71kx/L5uxDIoHR1MLG5byzc0f8r/PXKzTHSX/oUQ3kUlzwvboVFrtF8eC+CkSO0
	 GUaqKmeVZEHMq399cFK6AIP2bdzhOFab+1BvtS/D1e3neoWv0M12TnlkSVPzxAzfEM
	 q32Budak1x6Qzp2bU/0dneygO3RQ0nAXw/iX3U+fWCJoLB7SuzqUIYr9TYfTw6THEn
	 VuSANL097IH5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E0A3822D60;
	Thu, 17 Apr 2025 03:24:53 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.15-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250416200202.f5fe2bc61292d57a7a2346fd@linux-foundation.org>
References: <20250416200202.f5fe2bc61292d57a7a2346fd@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250416200202.f5fe2bc61292d57a7a2346fd@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-16-19-59
X-PR-Tracked-Commit-Id: a727a83ef22591d47e2d219cd8e01bd3616f4611
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cfb2e2c57aef75a414c0f18445c7441df5bc13be
Message-Id: <174486029162.3581141.6618445882592954834.pr-tracker-bot@kernel.org>
Date: Thu, 17 Apr 2025 03:24:51 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 16 Apr 2025 20:02:02 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-16-19-59

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cfb2e2c57aef75a414c0f18445c7441df5bc13be

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

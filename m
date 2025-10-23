Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27F529405;
	Thu, 23 Oct 2025 01:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761181794; cv=none; b=nZYUGpeE23J7g1TxjaTyJU/WNmTFcM6gyOdh9grDvLxiB+NfabnICpRuv5A9Cw5j3rZo/6IktR74kj8sbzxJjbGJZTSLI7TR1tps/jLXi/Pf+BUBfLMSYFFQcOzW9ZkPFyJ5+bvqBWZqyFCZCk1/tf2YIvW9qfxVaxFNXBir5lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761181794; c=relaxed/simple;
	bh=G0zO/gc9MN6KlY2clwE0hRQpkFOp+B6rix9cfRycwNw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Y+M3krpLLs5fpotOUn6zrBlLSbgki0IdU8mhri8u5XE83f0KFVo1bGmKuZKbvnB/Q1MCSWLCmxXFPXS0RJGIABlz8i7aTrHvc3rF+XOgNyQ2sC4/5MinopOHA8ZjFG0mCfkrv3iRqRxt7V3DFLmCU8Z5SCKWRNRUWEb4jev5JTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZEou8pA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZEou8pA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81531C4CEE7;
	Thu, 23 Oct 2025 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761181794;
	bh=G0zO/gc9MN6KlY2clwE0hRQpkFOp+B6rix9cfRycwNw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XZEou8pAzZph6RaP/px9DGaj9wzQQc7PRiwczqZxTJB/LCw8fpxiylSf4ejqXI4br
	 xiycTQOUNmMLB9zR/boxz8raYOnd9CbfSoWK4nuxknmjkxME7j5HrOSiNRejJJ8Ahk
	 CmU4dTDke+RL58d43bNFLo6mxbtlFzf4qHpQYjoF4JWcykYwRN2eF3+dudSCZ5DlEo
	 JCNwHqcoxMsTHMgB/CrSXQ0RIwRHRSwvlQkMuIb9dNA7VWRXYaDNp2eidYCGA8H2bt
	 5DGHDe5cMy+9dWObcwiFxLnqHpUT3DZFWJVwOGpjTIVHHIonRlASXJBaQ1cU2pJMRP
	 KgdfaPQ8yQswg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7134A3809A00;
	Thu, 23 Oct 2025 01:09:36 +0000 (UTC)
Subject: Re: [GIT PULL]  hotfixes for 6.18-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
References: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-22-12-43
X-PR-Tracked-Commit-Id: 9aa12167ef1149d9980713b120ddcb31cf17222d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f3ad9c6105f32d1755c0bd54a7f98c892f3ceb7
Message-Id: <176118177496.2361762.8429864278657439386.pr-tracker-bot@kernel.org>
Date: Thu, 23 Oct 2025 01:09:34 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 22 Oct 2025 12:45:48 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-22-12-43

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f3ad9c6105f32d1755c0bd54a7f98c892f3ceb7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

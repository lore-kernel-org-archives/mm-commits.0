Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F7338DC74;
	Tue, 22 Sep 2026 17:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790097114; cv=none; b=JE6ol3qinUO5+TjY7YEGw3Aidgfr79lPb5fNJQOEehG2xGmBi8+uqQ0IAbp/TS7t6dGRZK+mInZhyxAb/ZhpkuxEFRcOX0E//D4n23nH+9qdbzLVTdIUrbMT8URo3DVtOVGLvWGVMMmG1y3+N3DQaJRBfoSJonuULTFcs9KYr1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790097114; c=relaxed/simple;
	bh=corF7Fcnx7BcA3ptM4CR3gJRf8H5dq8za00+k0KzaRE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=atieOTbUD0xxSygalkcHeMTQJTBf/5TRizsG/ZVlGRvE+sSEVYZWKZPkV5vfj2Jybe1w2uOjM58RDDwRYOoEWJCQf8g8+qygiC2SoCKaat8ccx92mJquS0mWvL3+aM7qQTKGC6MEbXDBTI0cqfiipQPh6caNzk3NB14Tv03mUxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6E1qPB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6E1qPB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581911F000FF;
	Tue, 22 Sep 2026 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790097113;
	bh=t/k4e0hVfI9hDMz8Wm7fg+eHHKsPTG2TwJP/59CoEi4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=k6E1qPB4+vpZRBFXXk2nbd234TILU5Jc80JiM0QEFz1edo1+L33lYKuuArKZAWr4D
	 VyFlQqIRSar+aV6l6KKNfuafV9quBCdJ1DaHSx9xaWp+YO20mQdVsIozbVELgtQu22
	 Ykl9tQ00nVoqVt8U0QrAPg1PrN4HHv1hZiOuf4nfwHpbA+FXvWasuFIEdBbGlU+Hr1
	 4iPlVKM6E6hacGt81kRpbVjMLldCef5Sgm25619o5pVVLcDMEyf9QatuDT+LbgzUZC
	 IPwpm7Q5Ik3OMxG/u7DckHoerJdKkqaUuLMGxrnbqMFN1+6gmwtoDqI8bBfvEq4d62
	 ZVwaP0i92hdag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B2A3811A56;
	Tue, 22 Sep 2026 17:10:45 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.3-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
References: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-21-17-08
X-PR-Tracked-Commit-Id: 692dd08e03f4a5523650e055f033f846bee43a0c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a52a93358ac2bef65f15e0069cd410a2b59ae03b
Message-Id: <179009704407.4190423.13832222731277666906.pr-tracker-bot@kernel.org>
Date: Tue, 22 Sep 2026 17:10:44 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 21 Sep 2026 17:17:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-21-17-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a52a93358ac2bef65f15e0069cd410a2b59ae03b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
